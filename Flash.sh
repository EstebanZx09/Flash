#!/bin/bash

# Fungsi untuk memilih berkas ROM dengan prompt
select_rom() {
  read -p "Masukkan path folder ROM: " rom_file
}

# Fungsi untuk flashing ROM menggunakan Fastboot
flash_rom() {
  clear
  echo ""
  echo "==========================================================="
  
  # Mencari file skrip `.sh` yang sesuai dengan nama `rom_file`
  find ${rom_file}*.sh > ${rom_file}a.txt 2>&1

  # Mengecek apakah file yang ditemukan mengandung perintah `flash_`
  cat ${rom_file}a.txt | grep -e "flash_" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    # Menghapus ekstensi `.sh` dari file yang ditemukan
    sed -i 's/.sh//g' ${rom_file}a.txt 2>&1

    # Mengganti `fl` dengan `flash` dalam file daftar yang dibuat
    sed -i 's/fl/flash/g' ${rom_file}a.txt > /dev/null 2>&1

    # Menampilkan isi file hasil pencarian
    cat ${rom_file}a.txt
    echo "==========================================================="

    # Menghapus file sementara yang dibuat
    rm -r ${rom_file}a.txt > /dev/null 2>&1

    # Meminta pengguna untuk memasukkan perintah flash
    read -p "Ketik perintah flash di sini: " flash
    sleep 2
    clear

    echo "Masuk Mode Fastboot Kemudian Sambungkan"
    
    # Menjalankan skrip flash yang dipilih oleh pengguna
    bash $flash.sh
  else
    # Jika tidak ditemukan file yang sesuai, tampilkan pesan error
    rm -r ${rom_file}a.txt > /dev/null 2>&1
    echo "Folder ROM Tidak Ditemukan"
    echo "==========================================================="
    sleep 10
  fi
}

# Memilih ROM dan memulai flashing
select_rom
if [ -z "$rom_file" ]; then
  echo "Anda harus memasukkan path folder ROM."
else
  flash_rom
fi