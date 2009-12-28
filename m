Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46504 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZL1T2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 14:28:43 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NPLGj-0008K2-3T
	for linux-media@vger.kernel.org; Mon, 28 Dec 2009 20:28:41 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 20:28:41 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 20:28:41 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Mon, 28 Dec 2009 20:28:16 +0100
Message-ID: <1262028495.3489.10.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
	 <1261578615.8948.4.camel@slash.doma> <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
	 <1261611901.8948.37.camel@slash.doma> <4B339A8F.8020201@freenet.de>
	 <1261673477.2119.1.camel@slash.doma>
	 <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On pon, 2009-12-28 at 02:23 +0400, Manu Abraham wrote:
> Can you please do a lspci -vn for the Mantis card you have ? Also try
> loading the mantis.ko module with verbose=5 module parameter, to get
> more debug information.

$ lspci -vn

03:07.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0002
	Flags: bus master, medium devsel, latency 32, IRQ 21
	Memory at fdcff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis


$ modprobe -v mantis  verbose=5

insmod /lib/modules/2.6.33-rc1/kernel/drivers/media/dvb/mantis/mantis_core.ko 
insmod /lib/modules/2.6.33-rc1/kernel/drivers/media/dvb/mantis/mantis.ko
verbose=5

$ dmesg

[ 2371.762511] Mantis 0000:03:07.0: PCI INT A disabled
[ 2462.703393] Mantis 0000:03:07.0: PCI INT A -> GSI 21 (level, low) ->
IRQ 21
[ 2462.704761] DVB: registering new adapter (Mantis DVB adapter)
[ 2463.563234] DVB: registering adapter 0 frontend 0 (Philips TDA10023
DVB-C)...
[ 2522.842548] Mantis 0000:03:07.0: PCI INT A disabled
[ 2534.495759] found a VP-2040 PCI DVB-C device on (03:07.0),
[ 2534.495771] Mantis 0000:03:07.0: PCI INT A -> GSI 21 (level, low) ->
IRQ 21
[ 2534.495796]     Mantis Rev 1 [1ae4:0002], irq: 21, latency: 32
[ 2534.495799]     memory: 0x0, mmio: 0xffffc900128cc000
[ 2534.495818] mantis_stream_control (0): Set stream to HIF
[ 2534.495841] mantis_i2c_init (0): Initializing I2C ..
[ 2534.495845] mantis_i2c_init (0): Disabling I2C interrupt
[ 2534.495849] mantis_i2c_xfer (0): Messages:2
[ 2534.495852]         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
[ 2534.496243]         mantis_i2c_read:  Address=[0x50] <R>[ 00 08 c9 d0
02 09 ]
[ 2534.497049]     MAC Address=[00:08:c9:d0:02:09]
[ 2534.497051] mantis_dma_init (0): Mantis DMA init
[ 2534.497071] mantis_alloc_buffers (0): DMA=0x3d670000
cpu=0xffff88003d670000 size=65536
[ 2534.497073] mantis_alloc_buffers (0): RISC=0x3b731000
cpu=0xffff88003b731000 size=1000
[ 2534.497076] mantis_calc_lines (0): Mantis RISC block bytes=[4096],
line bytes=[2048], line count=[32]
[ 2534.497077] mantis_dvb_init (0): dvb_register_adapter
[ 2534.497079] DVB: registering new adapter (Mantis DVB adapter)
[ 2534.497081] mantis_dvb_init (0): dvb_dmx_init
[ 2534.497166] mantis_dvb_init (0): dvb_dmxdev_init
[ 2534.497269] mantis_frontend_power (0): Power ON
[ 2534.497271] gpio_set_bits (0): Set Bit <12> to <1>
[ 2534.497274] gpio_set_bits (0): GPIO Value <3000>
[ 2534.598099] gpio_set_bits (0): Set Bit <12> to <1>
[ 2534.598111] gpio_set_bits (0): GPIO Value <3000>
[ 2534.699066] mantis_frontend_soft_reset (0): Frontend RESET
[ 2534.699077] gpio_set_bits (0): Set Bit <13> to <0>
[ 2534.699085] gpio_set_bits (0): GPIO Value <1000>
[ 2534.800077] gpio_set_bits (0): Set Bit <13> to <0>
[ 2534.800087] gpio_set_bits (0): GPIO Value <1000>
[ 2534.901079] gpio_set_bits (0): Set Bit <13> to <1>
[ 2534.901089] gpio_set_bits (0): GPIO Value <3000>
[ 2535.002089] gpio_set_bits (0): Set Bit <13> to <1>
[ 2535.002099] gpio_set_bits (0): GPIO Value <3000>
[ 2535.354084] vp2040_frontend_init (0): Probing for CU1216 (DVB-C)
[ 2535.354096] mantis_i2c_xfer (0): Messages:2
[ 2535.354103]         mantis_i2c_write: Address=[0x50] <W>[ ff ]
[ 2535.354328]         mantis_i2c_read:  Address=[0x50] <R>[ e4 ]
[ 2535.354555] mantis_i2c_xfer (0): Messages:2
[ 2535.354560]         mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
[ 2535.354781]         mantis_i2c_read:  Address=[0x0c] <R>[ 7d ]
[ 2535.355034] mantis_i2c_xfer (0): Messages:2
[ 2535.355039]         mantis_i2c_write: Address=[0x50] <W>[ ff ]
[ 2535.355257]         mantis_i2c_read:  Address=[0x50] <R>[ e4 ]
[ 2535.355482] mantis_i2c_xfer (0): Messages:1
[ 2535.355486]         mantis_i2c_write: Address=[0x0c] <W>[ 00 33 ]
[ 2535.355819] mantis_i2c_xfer (0): Messages:2
[ 2535.355823]         mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
[ 2535.356055]         mantis_i2c_read:  Address=[0x0c] <R>[ 7d ]
[ 2535.356279] vp2040_frontend_init (0): found Philips CU1216 DVB-C
frontend (TDA10023) @ 0x0c
[ 2535.356285] vp2040_frontend_init (0): Mantis DVB-C Philips CU1216
frontend attach success
[ 2535.356291] vp2040_frontend_init (0): Done!
[ 2535.356298] DVB: registering adapter 0 frontend 0 (Philips TDA10023
DVB-C)...
[ 2535.356573] mantis_uart_init (0): Initializing UART @ 9600bps
parity:NONE
[ 2535.356602] mantis_uart_read (0): Reading ... <3f>
[ 2535.356609] mantis_uart_work (0): UART BUF:0 <3f> 
[ 2535.356613] 
[ 2535.356619] mantis_uart_init (0): UART succesfully initialized




