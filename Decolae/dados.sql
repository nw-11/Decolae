-- =========================================================
-- DADOS DE TESTE (POVOAMENTO) - SISTEMA DECOLAE
-- =========================================================

USE decolae;

-- 1. Inserir Usuários (Com hashes de senha realistas em SHA-256)
INSERT INTO USUARIO (email, nome, senha_hash, tipo_usuario) VALUES 
('ana.souza@email.com', 'Ana Souza', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Cliente'),
('carlos.lima@email.com', 'Carlos Lima', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Cliente'),
('mariana.silva@decolae.com', 'Mariana Silva', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'Gerente'),
('roberto.santos@decolae.com', 'Roberto Santos', '4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a', 'Administrador');

-- 2. Inserir Passageiros (CPFs com 11 dígitos exatos)
INSERT INTO PASSAGEIRO (cpf, nome, data_nascimento) VALUES 
('11122233344', 'Ana Souza', '1995-04-12'),
('55566677788', 'Carlos Lima', '1988-09-25');

-- 3. Inserir Trajetos (Horários no formato HH:MM:SS)
INSERT INTO TRAJETO (local_embarque, local_chegada, horario_partida, horario_chegada) VALUES 
('São Paulo (GRU)', 'Rio de Janeiro (GIG)', '08:00:00', '09:10:00'),
('São Paulo (GRU)', 'Salvador (SSA)', '14:30:00', '17:15:00');

-- 4. Inserir Aeronaves (Identificação e assentos > 0)
INSERT INTO AERONAVE (identificacao, modelo, numero_assentos) VALUES 
('PR-AXA', 'Airbus A320', 180),
('PR-MZV', 'Boeing 737', 160);

-- 5. Inserir Tripulações (IDs automáticos)
INSERT INTO TRIPULACAO (id_tripulacao) VALUES 
(1), 
(2);

-- 6. Inserir Clientes (Status permitidos: Ativo, Suspenso ou Bloqueado)
INSERT INTO CLIENTE (cpf, email_usuario, telefone, data_de_cadastro, status_cliente) VALUES 
('11122233344', 'ana.souza@email.com', '11987654321', '2026-01-10', 'Ativo'),
('55566677788', 'carlos.lima@email.com', '11912345678', '2026-02-15', 'Ativo');

-- 7. Inserir Funcionários (Incluindo funcionários com e sem conta de usuário)
INSERT INTO FUNCIONARIO (cpf, nome, cargo, salario, email_usuario) VALUES 
('99988877766', 'Mariana Silva', 'Piloto Chefe', 12500.00, 'mariana.silva@decolae.com'),
('44433322211', 'Roberto Santos', 'Comissário de Bordo', 4500.00, 'roberto.santos@decolae.com'),
('22233344455', 'Juliana Almeida', 'Copiloto', 9800.00, NULL),    
('33344455566', 'Marcos Vinicius', 'Comissário de Bordo', 4600.00, NULL),
('77788899900', 'Beatriz Costa', 'Gerente de Solo', 6500.00, NULL); 

-- 8. Inserir Relações Tripulação-Funcionário (Funções permitidas: 'Piloto', 'Copiloto', 'Comissário')
INSERT INTO TRIPULACAO_FUNCIONARIO (id_tripulacao, cpf_funcionario, funcao_na_tripulacao) VALUES 
(1, '99988877766', 'Piloto'),
(1, '44433322211', 'Comissário'),
(1, '22233344455', 'Copiloto'),
(2, '33344455566', 'Comissário'),
(2, '22233344455', 'Piloto'); 

-- 9. Inserir Voos (Status permitidos: Programado, Concluído, Cancelado)
INSERT INTO VOO (codigo_trajeto, identificacao_aeronave, id_tripulacao, data_hora_partida, data_hora_chegada, status_voo, preco_base) VALUES 
(1, 'PR-AXA', 1, '2026-06-10 08:00:00', '2026-06-10 09:10:00', 'Programado', 450.00),
(2, 'PR-MZV', 1, '2026-06-12 14:30:00', '2026-06-12 17:15:00', 'Programado', 780.50);

-- 10. Inserir Compras (Pagamentos e status dentro das restrições)
INSERT INTO COMPRA (cpf_cliente, id_voo, data_hora_compra, forma_de_pagamento, status_compra) VALUES 
('11122233344', 1, '2026-05-01 10:30:00', 'Cartão', 'Paga'),
('55566677788', 2, '2026-05-02 15:45:00', 'Pix', 'Paga');

-- 11. Inserir Passagens (Vinculadas às compras e voos correspondentes)
INSERT INTO PASSAGEM (codigo_bilhete, codigo_compra, cpf_passageiro, numero_assento, preco) VALUES 
('BIL-9001', 1, '11122233344', 12, 450.00),
('BIL-9002', 2, '55566677788', 5, 780.50);
