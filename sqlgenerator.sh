#!/bin/bash

opc1=0
sql=""
echo "Deseja [1 - Criar  | 2 - Atualizar | 3 - Inserir | 4 - Deletar | 5 - Listar]"
read opc1

if [ "$opc1"  = 1 ]; then
    sql="CREATE "
elif [ "$opc1"  = 2 ]; then
    sql="UPDATE "
    echo "Nome da tabela:"
    read tabela_nome
    sql="$sql $tabela_nome SET "
    
    while true; do
        echo "Nome do campo a ser atualizado (ou digite 'fim' para encerrar):"
        read campo

        if [ "$campo" = "fim" ]; then
            break
        fi

        echo "Novo valor do campo:"
        read novo_valor

        sql="$sql $campo = '$novo_valor', "
    done

    sql=$(echo "$sql" | sed 's/, $//')

    echo "Condição WHERE (opcional, deixe em branco para atualizar todos os registros):"
    read condicao

    if [ -n "$condicao" ]; then
        sql="$sql WHERE $condicao;"
    else
        sql="$sql;"
    fi
elif [ "$opc1"  = 3 ]; then
        sql="INSERT INTO "
        echo "Nome da tabela:"
    read tabela_nome
    sql="$sql $tabela_nome ("
    
    while true; do
        echo "Nome do campo (ou digite 'fim' para encerrar):"
        read campo

        if [ "$campo" = "fim" ]; then
            break
        fi

        echo "Valor do campo:"
        read valor

        sql="$sql $campo, "
        valores="$valores '$valor', "
    done

    sql=$(echo "$sql" | sed 's/, $//')
    valores=$(echo "$valores" | sed 's/, $//')

    sql="$sql) VALUES ($valores);"
elif [ "$opc1"  = 4 ]; then
    
    sql="DELETE FROM "
    echo "Nome da tabela:"
    read tabela_nome
    sql="$sql $tabela_nome"

    echo "Condição WHERE (opcional, deixe em branco para excluir todos os registros):"
    read condicao

    if [ -n "$condicao" ]; then
        sql="$sql WHERE $condicao;"
    else
        sql="$sql;"
    fi

elif [ "$opc1"  = 5 ]; then
    
    sql="SELECT "
    echo "Colunas a serem selecionadas (selecione '*' para todas):"
    read colunas
    sql="$sql $colunas FROM "

    echo "Nome da tabela:"
    read tabela_nome
    sql="$sql $tabela_nome"

    echo "Condição WHERE (opcional, deixe em branco para selecionar todos os registros):"
    read condicao

    if [ -n "$condicao" ]; then
        sql="$sql WHERE $condicao;"
    else
        sql="$sql;"
    fi

else
    echo "Opção inválida"
fi

opc2=0
echo "Deseja [1 - Tabela  | 2 - Banco | 3 - Coluna | 4 - Linha | 5 - Tudo]"
read opc2

if [ "$opc2"  = 1 ]; then
    sql="$sql TABLE "
    echo "Nome da tabela:"
    read tabela_nome

    sql="$sql $tabela_nome (\n"

    primeiro_campo=true
    campos="" 

    while true; do
        echo "Nome do campo (ou digite 'fim' para encerrar):"
        read campo

        if [ "$campo" = "fim" ]; then
            break
        fi

        echo "Tipo de dados do campo:"
        read tipo_dados

        echo "Restrições do campo (opcional):"
        read restricoes

        if [ "$primeiro_campo" = true ]; then
            campos="$campos $campo $tipo_dados $restricoes"
            primeiro_campo=false
        else
            campos="$campos,\n$campo $tipo_dados $restricoes"
        fi
    done

    sql="$sql $campos\n);"

elif [ "$opc2" = 2 ]; then

    sql="$sql DATABASE"
    echo "Nome do banco de dados:"
    read database_nome
    sql="$sql $database_nome;"

elif [ "$opc2" = 3 ]; then
    sql="$sql COLUMN"
    echo "Nome da coluna:"
    read coluna_nome
    sql="$sql $coluna_nome;"

elif [ "$opc2" = 4 ]; then
    sql="$sql ROW"
    echo "Nome da tabela:"
    read tabela_nome
    sql="$sql FROM $tabela_nome"
    
    echo "Condição WHERE para selecionar a linha (opcional, deixe em branco para selecionar todas as linhas):"
    read condicao

    if [ -n "$condicao" ]; then
        sql="$sql WHERE $condicao;"
    else
        sql="$sql;"
    fi

elif [ "$opc2" = 5 ]; then
    sql="$sql * "
else
    echo "Opção inválida"
fi

clear
echo -e "SQL:\n\n$sql\n\n"
echo -e "$sql" | tr -d '\n' > script.sql