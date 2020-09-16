require 'csv'
require './Aluno.rb'

#função do menu principal
def menu_principal
    puts "--------Bem-vindo ao UFFMail--------"
    puts "Digite a sua opção:"
    puts "1 - Criar UFFMail"
    puts "0 - Sair"
    
    op = nil
    loop do
        op = gets.chomp.to_i
        if op < 0 or op > 1
            puts "Digite uma opção válida."
        end
    break if op == 0 or op == 1
    end

    case op
    when 1
        criar_uffmail
    end
end

#funcao que busca a matricula no arquivo csv e, caso encontrada, cria e retorna um objeto criado para o aluno
def busca_aluno(mat)
    db_aluno = CSV.parse(File.read("alunos.csv"), headers: true)
    a = nil #objeto aluno a ser retornado
    for i in 0..(db_aluno.length - 1)
        if db_aluno[i]["matricula"] == mat
            #cria o objeto aluno referente a matricula digitada
            a = Aluno.new(db_aluno[i]["nome"], db_aluno[i]["matricula"], db_aluno[i]["telefone"], 
            db_aluno[i]["email"], db_aluno[i]["uffmail"], db_aluno[i]["status"])
        end
    end
    return a
end

#funcao que adiciona o novo email criado no arquivo csv
def edit_uffmail(mat, uffmail)
    db_aluno = CSV.parse(File.read("alunos.csv"), headers: true)
    for i in 0..(db_aluno.length - 1)
        if db_aluno[i]["matricula"] == mat
            db_aluno[i]["uffmail"] = uffmail
        end
    end
    #como o parse tira o header do arquivo, foi necessario adicionar o header manualmente
    f_aluno = CSV.open("alunos.csv",'w')
    f_aluno << ["nome","matricula","telefone","email","uffmail","status"]
    f_aluno.close
    #adiciona todo o conteudo da table db_aluno no arquivo csv
    File.open("alunos.csv",'a'){ |f| f << db_aluno.map(&:to_csv).join }
end

#gera lista de uffmails a serem escolhidos pelo usuario
def gerar_lista_uffmail(nome)
    emails = Array.new
    emails.push(nome.split.first.downcase + '_' + nome.split.last.downcase + "@id.uff.br") #primeiro nome _ ultimo nome
    emails.push(nome.chars.first.downcase + nome.split.last.downcase + "@id.uff.br") #primeira letra do nome + ultimo nome
    emails.push(nome.split.at(1).downcase + "_" + nome.split.last.downcase + "@id.uff.br")
    emails.push(nome.split.first.downcase + nome.split.at(1).chars.first.downcase + nome.split.last.chars.first.downcase +  "@id.uff.br") #primeiro nome + primeira letra do segundo nome + primeira letra do ultimo nome
    emails.push(nome.split.first.chars.first.downcase + nome.split.at(1).downcase + nome.split.last.chars.first.downcase + "@id.uff.br") #primeira letra + segundo nome + primeira letra do ultimo sobrenome
    return emails
end

#define o uffmail do aluno
def criar_uffmail()

    puts "Digite a sua matricula:"
    mat = gets.chomp

    aluno = busca_aluno(mat)

    if aluno.nil? #matricula nao encontrada
        puts "Matrícula não encontrada"
    elsif aluno.status == "Inativo" #se a matricula esta inativa
        puts "Não é possível criar um UFFMail para essa matrícula: Matrícula inativa."
    elsif !aluno.uffmail.nil? #se ja possui email cadastrado
        puts "Não é possível criar um UFFMail para essa matrícula: Já possui um UFFMail cadastrado."
    else
        puts "--------#{aluno.nome.split.first}, por favor escolha uma das opções abaixo para o seu UFFMail: --------"
        lista_emails = gerar_lista_uffmail(aluno.nome)
        for i in 0..(lista_emails.length - 1)
            puts "#{i+1} - #{lista_emails[i]}"
        end
        op = nil
        loop do
            op = gets.chomp.to_i
            if op <= 0 or op > lista_emails.length
                puts "Digite uma opção válida.\n"
            end
        break if op > 0 and op <= lista_emails.length
        end
        aluno.uffmail = lista_emails[op-1]
        
        edit_uffmail(aluno.matricula, aluno.uffmail)

        puts "A criação do seu email (#{aluno.uffmail}) será feita nos próximos minutos."
        puts "Um SMS foi enviado para #{aluno.telefone} com a sua senha de acesso"

    end
    menu_principal
end