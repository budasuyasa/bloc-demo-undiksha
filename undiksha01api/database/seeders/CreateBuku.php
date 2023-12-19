<?php

namespace Database\Seeders;

use App\Models\Buku;
use Illuminate\Database\Seeder;

class CreateBuku extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        $dataBuku = [
            [
                'judul' => 'Belajar Javascript untuk Balita',
                'isbn' => '378912739127',
                'pengarang' => 'Eren Yeager',
                'tahun_terbit' => 2020,
            ],
            [
                'judul' => 'Laravel dengan Master Style Kutukan Gojo',
                'isbn' => '832913812',
                'pengarang' => 'Gojo',
                'tahun_terbit' => 2021,
            ],
            [
                'judul' => 'Tutorial Makeup Masa Kini ',
                'isbn' => '83213831298',
                'pengarang' => 'Freya Fern',
                'tahun_terbit' => 2022,
            ],
            [
                'judul' => 'Tutorial Menjadi Robot',
                'isbn' => '832139812912',
                'pengarang' => 'Optimus Prime',
                'tahun_terbit' => 2023,
            ],
        ];

        foreach ($dataBuku as $b) {
            Buku::create($b);
        }

    }
}
