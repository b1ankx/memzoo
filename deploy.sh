#!/bin/bash

# Считывание данных из config.yaml
title=$(yq eval '.site.title' config.yaml)
description=$(yq eval '.site.description' config.yaml)
contact_email=$(yq eval '.site.contact_info.email' config.yaml)
contact_phone=$(yq eval '.site.contact_info.phone' config.yaml)

# Считывание данных о животных из config.yaml
animals=$(yq eval '.animals' config.yaml)

# Считывание данных из config.json
seo_keywords=$(jq -r '.seo.keywords | join(", ")' config.json)
seo_description=$(jq -r '.seo.description' config.json)
seo_author=$(jq -r '.seo.author' config.json)

# Обновление index.html
sed -i "s/<title>.*<\/title>/<title>$title<\/title>/" index.html
sed -i "s/<meta name=\"description\" content=\".*\"/<meta name=\"description\" content=\"$seo_description\"/" index.html
sed -i "s/<meta name=\"keywords\" content=\".*\"/<meta name=\"keywords\" content=\"$seo_keywords\"/" index.html
sed -i "s/<meta name=\"author\" content=\".*\"/<meta name=\"author\" content=\"$seo_author\"/" index.html
sed -i "s/<h1>.*<\/h1>/<h1>$title<\/h1>/" index.html
sed -i "s/<p>Самый смешной зоопарк в мире!<\/p>/<p>$description<\/p>/" index.html
sed -i "s/<p>Контакты:.*<\/p>/<p>Контакты: $contact_email, Телефон: $contact_phone<\/p>/" index.html

# Обновление animals.html
animal_html=""
for ((i = 0; i < $(echo "$animals" | yq eval length -); i++)); do
    animal_name=$(echo "$animals" | yq eval ".[$i].name" -)
    animal_description=$(echo "$animals" | yq eval ".[$i].description" -)
    animal_html+="<section><h2>$animal_name</h2><p>$animal_description</p></section>"
done

sed -i "/<main>/,/<\/main>/c\<main>$animal_html<\/main>" animals.html

# Обновление contact.html
sed -i "s/<p>Электронная почта:.*<\/p>/<p>Электронная почта: $contact_email<\/p>/" contact.html
sed -i "s/<p>Телефон:.*<\/p>/<p>Телефон: $contact_phone<\/p>/" contact.html

# Коммит изменений и деплой на GitHub Pages
#git add .
#git commit -m "Автоматическое обновление сайта"
#git push origin main
