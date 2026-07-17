make_vhdl_prom jfs3_c7.bin blit_rom0.vhd
make_vhdl_prom jfs4_d7.bin blit_rom1.vhd
make_vhdl_prom jfs5_e7.bin blit_rom2.vhd

copy /b jfa_b9.bin + jfb_b10.bin + jfc_a10.bin prog_rom.bin
make_vhdl_prom prog_rom.bin prog_rom.vhd

make_vhdl_prom jfa_b9.bin prog_rom1.vhd
make_vhdl_prom jfb_b10.bin prog_rom2.vhd
make_vhdl_prom jfc_a10.bin prog_rom3.vhd

make_vhdl_prom jfc1_a4.bin bank0.vhd
make_vhdl_prom jfc2_a5.bin bank1.vhd
make_vhdl_prom jfc3_a6.bin bank2.vhd
make_vhdl_prom jfc4_a7.bin bank3.vhd
make_vhdl_prom jfc5_a8.bin bank4.vhd
make_vhdl_prom jfc6_a9.bin bank5.vhd

make_vhdl_prom jfs1_j3.bin snd_rom.vhd

make_vhdl_prom jfs2_p4.bin mcu_rom.vhd

pause


