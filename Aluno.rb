class Aluno
    attr_accessor :nome, :matricula, :telefone, :email, :uffmail, :status
    def initialize(nome, matricula, telefone, email, uffmail, status)
        @nome = nome
        @matricula = matricula
        @telefone = telefone
        @email = email
        @uffmail = uffmail
        @status = status
    end
end