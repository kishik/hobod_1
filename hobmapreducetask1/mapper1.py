import string
import sys


for line in sys.stdin:
    # Разделение строки на идентификатор статьи и текст статьи
    idx, text = line.split("\t", 1)
    
    # Очистка текста от знаков пунктуации и приведение к нижнему регистру
    text = text.translate(str.maketrans('', '', string.punctuation))

    # Поиск имён собственных
    for word in text.split():
        if len(word) >= 6 and len(word) <= 9:
            # Подсчёт вхождений
            if word[0].isupper() and word[1:].islower():
                print(f'{word.lower()} 1')
            else:
                print(f'{word.lower()} 0')
                