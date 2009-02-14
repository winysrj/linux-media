Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:48136 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZBNJkh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 04:40:37 -0500
Message-ID: <49969186.8030009@gmail.com>
Date: Sat, 14 Feb 2009 13:40:22 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Carl Oscar Ejwertz <oscarmax3@gmail.com>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis Update was Re: Twinhan DTV Ter-CI (3030 Mantis)
 ???
References: <4984E294.6020401@gmail.com> <498B7945.4060200@gmail.com>	<498F0667.50000@gmail.com> <49947655.5040904@gmail.com> <49968351.50703@gmail.com>
In-Reply-To: <49968351.50703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carl Oscar Ejwertz wrote:
> Sad to say that I still get the same error after a fresh clone and compile. Is 
> there any info that I can supply that can help getting this card working?
> 

What's the error that you see ?

Did a quick test on the following cards:
VP-1041, VP-2033, VP-3030 The logs look as follows, do you see any
different ?

Regards,
Manu

found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (04:04.0),
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 22 (level, low) -> IRQ 22
    Mantis Rev 1 [1822:0031], irq: 22, latency: 32
    memory: 0x0, mmio: 0xf93aa000
mantis_stream_control (0): Set stream to HIF
mantis_i2c_init (0): Initializing I2C ..
mantis_i2c_init (0): Disabling I2C interrupt
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x50] <W>[ 08 ]
        mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 1c 42 c9 ]
    MAC Address=[00:08:ca:1c:42:c9]
mantis_dma_init (0): Mantis DMA init
mantis_alloc_buffers (0): DMA=0x325c0000 cpu=0xf25c0000 size=65536
mantis_alloc_buffers (0): RISC=0x32463000 cpu=0xf2463000 size=1000
mantis_calc_lines (0): Mantis RISC block bytes=[4096], line
bytes=[2048], line count=[32]
mantis_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (Mantis DVB adapter)
mantis_dvb_init (0): dvb_dmx_init
mantis_dvb_init (0): dvb_dmxdev_init
mantis_frontend_power (0): Power ON
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <1000>
mantis_frontend_soft_reset (0): Frontend RESET
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3000>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3000>
stb0899_write_regs [0xf1b6]: 02
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f1 b6 02 ]
stb0899_write_regs [0xf1c2]: 00
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f1 c2 00 ]
stb0899_write_regs [0xf1c3]: 00
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f1 c3 00 ]
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x68] <W>[ f0 00 ]
        mantis_i2c_read:  Address=[0x68] <R>[ 82 ]
_stb0899_read_reg: Reg=[0xf000], data=82
stb0899_get_dev_id: ID reg=[0x82]
stb0899_get_dev_id: Device ID=[8], Release=[2]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f3 fc 00 04 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f3 34 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 31 44 4d 44 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f3 34 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 31 44 4d 44 ]
_stb0899_read_s2reg Device=[0xf3fc], Base address=[0x00000400],
Offset=[0xf334], Data=[0x444d4431]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f3 fc 00 04 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f3 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ f3 3c ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
_stb0899_read_s2reg Device=[0xf3fc], Base address=[0x00000400],
Offset=[0xf33c], Data=[0x00000001]
stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ fa fc 00 08 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ fa 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 4c 00 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ fa 2c ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 31 43 45 46 ]
_stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800],
Offset=[0xfa2c], Data=[0x46454331]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ fa fc 00 08 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ fa 34 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x68] <W>[ fa 34 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
_stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800],
Offset=[0xfa34], Data=[0x00000001]
stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
stb0899_attach: Attaching STB0899
vp1041_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend @0x68
stb6100_attach: Attaching STB6100
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x08] <W>[ 40 ]
vp1041_frontend_init (0): Done!
DVB: registering frontend 0 (STB0899 Multistandard)...






found a VP-3030 PCI DVB-T device on (04:04.0),
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 22 (level, low) -> IRQ 22
    Mantis Rev 1 [1822:0024], irq: 22, latency: 32
    memory: 0x0, mmio: 0xf93a8000
mantis_stream_control (0): Set stream to HIF
mantis_i2c_init (0): Initializing I2C ..
mantis_i2c_init (0): Disabling I2C interrupt
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x50] <W>[ 08 ]
        mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 1a 4d de ]
    MAC Address=[00:08:ca:1a:4d:de]
mantis_dma_init (0): Mantis DMA init
mantis_alloc_buffers (0): DMA=0x33450000 cpu=0xf3450000 size=65536
mantis_alloc_buffers (0): RISC=0x334ad000 cpu=0xf34ad000 size=1000
mantis_calc_lines (0): Mantis RISC block bytes=[4096], line
bytes=[2048], line count=[32]
mantis_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (Mantis DVB adapter)
mantis_dvb_init (0): dvb_dmx_init
mantis_dvb_init (0): dvb_dmxdev_init
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <00>
mantis_frontend_power (0): Power ON
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3000>
vp3030_frontend_init (0): Probing for 10353 (DVB-T)
mantis_i2c_xfer (0): Messages:2
        Byte MODE:
        Byte <0> RXD=0x1f7f1480  [14]
tda665x_attach: Attaching TDA665x (ENV57H12D5 (ET-50DT)) tuner
vp3030_frontend_init (0): Done!
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...







found a VP-2033 PCI DVB-C device on (04:04.0),
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 22 (level, low) -> IRQ 22
    Mantis Rev 1 [1822:0008], irq: 22, latency: 32
    memory: 0x0, mmio: 0xf93aa000
mantis_stream_control (0): Set stream to HIF
mantis_i2c_init (0): Initializing I2C ..
mantis_i2c_init (0): Disabling I2C interrupt
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x50] <W>[ 08 I2CDONE: trials=0
I2CRACK: trials=0
]
        mantis_i2c_read:  Address=[0x50] <R>[ I2CDONE: trials=0
I2CRACK: trials=0
00 I2CDONE: trials=0
I2CRACK: trials=0
08 I2CDONE: trials=0
I2CRACK: trials=0
ca I2CDONE: trials=0
I2CRACK: trials=0
19 I2CDONE: trials=0
I2CRACK: trials=0
ea I2CDONE: trials=0
I2CRACK: trials=0
ee ]
    MAC Address=[00:08:ca:19:ea:ee]
mantis_dma_init (0): Mantis DMA init
mantis_alloc_buffers (0): DMA=0x2e580000 cpu=0xee580000 size=65536
mantis_alloc_buffers (0): RISC=0x3254b000 cpu=0xf254b000 size=1000
mantis_calc_lines (0): Mantis RISC block bytes=[4096], line
bytes=[2048], line count=[32]
mantis_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (Mantis DVB adapter)
mantis_dvb_init (0): dvb_dmx_init
mantis_dvb_init (0): dvb_dmxdev_init
mantis_frontend_power (0): Power ON
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <3001>
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <3001>
mantis_frontend_soft_reset (0): Frontend RESET
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <1001>
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <1001>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3001>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3001>
vp2033_frontend_init (0): Probing for CU1216 (DVB-C)
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x50] <W>[ ff I2CDONE: trials=0
I2CRACK: trials=0
]
        mantis_i2c_read:  Address=[0x50] <R>[ I2CDONE: trials=0
I2CRACK: trials=0
22 ]
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x0c] <W>[ 1a I2CDONE: trials=0
I2CRACK: trials=0
]
        mantis_i2c_read:  Address=[0x0c] <R>[ I2CDONE: trials=0
I2CRACK: trials=0
7c ]
TDA10021: i2c-addr = 0x0c, id = 0x7c
vp2033_frontend_init (0): found Philips CU1216 DVB-C frontend
(TDA10021) @ 0x0c
vp2033_frontend_init (0): Mantis DVB-C Philips CU1216 frontend
attach success
vp2033_frontend_init (0): Done!
DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
