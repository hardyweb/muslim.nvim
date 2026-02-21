local M = {}

M.zones = {
    {
        group = "Johor",
        options = {
            { value = "JHR01", text = "JHR01 - Pulau Aur dan Pulau Pemanggil" },
            { value = "JHR02", text = "JHR02 - Johor Bahru, Kota Tinggi, Mersing, Kulai" },
            { value = "JHR03", text = "JHR03 - Kluang, Pontian" },
            { value = "JHR04", text = "JHR04 - Batu Pahat, Muar, Segamat, Gemas Johor, Tangkak" }
        }
    },
    {
        group = "Kedah",
        options = {
            { value = "KDH01", text = "KDH01 - Kota Setar, Kubang Pasu, Pokok Sena (Daerah Kecil)" },
            { value = "KDH02", text = "KDH02 - Kuala Muda, Yan, Pendang" },
            { value = "KDH03", text = "KDH03 - Padang Terap, Sik" },
            { value = "KDH04", text = "KDH04 - Baling" },
            { value = "KDH05", text = "KDH05 - Bandar Baharu, Kulim" },
            { value = "KDH06", text = "KDH06 - Langkawi" },
            { value = "KDH07", text = "KDH07 - Puncak Gunung Jerai" }
        }
    },
    {
        group = "Kelantan",
        options = {
            { value = "KTN01", text = "KTN01 - Bachok, Kota Bharu, Machang, Pasir Mas, Pasir Puteh, Tanah Merah, Tumpat, Kuala Krai, Mukim Chiku" },
            { value = "KTN02", text = "KTN02 - Gua Musang (Daerah Galas Dan Bertam), Jeli, Jajahan Kecil Lojing" }
        }
    },
    {
        group = "Melaka",
        options = {
            { value = "MLK01", text = "MLK01 - SELURUH NEGERI MELAKA" }
        }
    },
    {
        group = "Negeri Sembilan",
        options = {
            { value = "NGS01", text = "NGS01 - Tampin, Jempol" },
            { value = "NGS02", text = "NGS02 - Jelebu, Kuala Pilah, Rembau" },
            { value = "NGS03", text = "NGS03 - Port Dickson, Seremban" }
        }
    },
    {
        group = "Pahang",
        options = {
            { value = "PHG01", text = "PHG01 - Pulau Tioman" },
            { value = "PHG02", text = "PHG02 - Kuantan, Pekan, Rompin, Muadzam Shah" },
            { value = "PHG03", text = "PHG03 - Jerantut, Temerloh, Maran, Bera, Chenor, Jengka" },
            { value = "PHG04", text = "PHG04 - Bentong, Lipis, Raub" },
            { value = "PHG05", text = "PHG05 - Genting Sempah, Janda Baik, Bukit Tinggi" },
            { value = "PHG06", text = "PHG06 - Cameron Highlands, Genting Higlands, Bukit Fraser" }
        }
    },
    {
        group = "Perlis",
        options = {
            { value = "PLS01", text = "PLS01 - Kangar, Padang Besar, Arau" }
        }
    },
    {
        group = "Pulau Pinang",
        options = {
            { value = "PNG01", text = "PNG01 - Seluruh Negeri Pulau Pinang" }
        }
    },
    {
        group = "Perak",
        options = {
            { value = "PRK01", text = "PRK01 - Tapah, Slim River, Tanjung Malim" },
            { value = "PRK02", text = "PRK02 - Kuala Kangsar, Sg. Siput , Ipoh, Batu Gajah, Kampar" },
            { value = "PRK03", text = "PRK03 - Lenggong, Pengkalan Hulu, Grik" },
            { value = "PRK04", text = "PRK04 - Temengor, Belum" },
            { value = "PRK05", text = "PRK05 - Kg Gajah, Teluk Intan, Bagan Datuk, Seri Iskandar, Beruas, Parit, Lumut, Sitiawan, Pulau Pangkor" },
            { value = "PRK06", text = "PRK06 - Selama, Taiping, Bagan Serai, Parit Buntar" },
            { value = "PRK07", text = "PRK07 - Bukit Larut" }
        }
    },
    {
        group = "Sabah",
        options = {
            { value = "SBH01", text = "SBH01 - Bahagian Sandakan (Timur), Bukit Garam, Semawang, Temanggong, Tambisan, Bandar Sandakan, Sukau" },
            { value = "SBH02", text = "SBH02 - Beluran, Telupid, Pinangah, Terusan, Kuamut, Bahagian Sandakan (Barat)" },
            { value = "SBH03", text = "SBH03 - Lahad Datu, Silabukan, Kunak, Sahabat, Semporna, Tungku, Bahagian Tawau  (Timur)" },
            { value = "SBH04", text = "SBH04 - Bandar Tawau, Balong, Merotai, Kalabakan, Bahagian Tawau (Barat)" },
            { value = "SBH05", text = "SBH05 - Kudat, Kota Marudu, Pitas, Pulau Banggi, Bahagian Kudat" },
            { value = "SBH06", text = "SBH06 - Gunung Kinabalu" },
            { value = "SBH07", text = "SBH07 - Kota Kinabalu, Ranau, Kota Belud, Tuaran, Penampang, Papar, Putatan, Bahagian Pantai Barat" },
            { value = "SBH08", text = "SBH08 - Pensiangan, Keningau, Tambunan, Nabawan, Bahagian Pendalaman (Atas)" },
            { value = "SBH09", text = "SBH09 - Beaufort, Kuala Penyu, Sipitang, Tenom, Long Pasia, Membakut, Weston, Bahagian Pendalaman (Bawah)" }
        }
    },
    {
        group = "Selangor",
        options = {
            { value = "SGR01", text = "SGR01 - Gombak, Petaling, Sepang, Hulu Langat, Hulu Selangor, S.Alam" },
            { value = "SGR02", text = "SGR02 - Kuala Selangor, Sabak Bernam" },
            { value = "SGR03", text = "SGR03 - Klang, Kuala Langat" }
        }
    },
    {
        group = "Sarawak",
        options = {
            { value = "SWK01", text = "SWK01 - Limbang, Lawas, Sundar, Trusan" },
            { value = "SWK02", text = "SWK02 - Miri, Niah, Bekenu, Sibuti, Marudi" },
            { value = "SWK03", text = "SWK03 - Pandan, Belaga, Suai, Tatau, Sebauh, Bintulu" },
            { value = "SWK04", text = "SWK04 - Sibu, Mukah, Dalat, Song, Igan, Oya, Balingian, Kanowit, Kapit" },
            { value = "SWK05", text = "SWK05 - Sarikei, Matu, Julau, Rajang, Daro, Bintangor, Belawai" },
            { value = "SWK06", text = "SWK06 - Lubok Antu, Sri Aman, Roban, Debak, Kabong, Lingga, Engkelili, Betong, Spaoh, Pusa, Saratok" },
            { value = "SWK07", text = "SWK07 - Serian, Simunjan, Samarahan, Sebuyau, Meludam" },
            { value = "SWK08", text = "SWK08 - Kuching, Bau, Lundu, Sematan" },
            { value = "SWK09", text = "SWK09 - Zon Khas (Kampung Patarikan)" }
        }
    },
    {
        group = "Terengganu",
        options = {
            { value = "TRG01", text = "TRG01 - Kuala Terengganu, Marang, Kuala Nerus" },
            { value = "TRG02", text = "TRG02 - Besut, Setiu" },
            { value = "TRG03", text = "TRG03 - Hulu Terengganu" },
            { value = "TRG04", text = "TRG04 - Dungun, Kemaman" }
        }
    },
    {
        group = "Wilayah Persekutuan",
        options = {
            { value = "WLY01", text = "WLY01 - Kuala Lumpur, Putrajaya" },
            { value = "WLY02", text = "WLY02 - Labuan" }
        }
    }
}

M.api_url = "https://www.e-solat.gov.my/index.php?r=esolatApi/TakwimSolat"

M.get_zone_list = function()
    local result = {}
    for _, group in ipairs(M.zones) do
        for _, option in ipairs(group.options) do
            table.insert(result, option)
        end
    end
    return result
end

M.get_zone_text = function(zone_code)
    for _, group in ipairs(M.zones) do
        for _, option in ipairs(group.options) do
            if option.value == zone_code then
                return option.text
            end
        end
    end
    return nil
end

M.is_valid_zone = function(zone_code)
    return M.get_zone_text(zone_code) ~= nil
end

return M
