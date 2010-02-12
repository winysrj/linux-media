Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:46170 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab0BLW00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 17:26:26 -0500
Received: by bwz4 with SMTP id 4so3258609bwz.2
        for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 14:26:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
References: <f509f3091001311223q19a9854fwb546e6fcadc08021@mail.gmail.com>
	 <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
Date: Fri, 12 Feb 2010 23:26:24 +0100
Message-ID: <f509f3091002121426t4c282885yfef06fe797e3e62@mail.gmail.com>
Subject: Re: [linux-dvb] Twinhan dtv 3030 mantis
From: Niklas Claesson <nicke.claesson@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I managed to create the missing .h-file by looking at some other ones.
Unfortunately, the module still doesn't work. But there has been
progress, now the module loads automagically when i boot the computer.

Is there anything I can do to help you debug?

If I let it load the module during boot I get the following lines in
syslog with "grep Mantis"

Mantis 0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
DVB: registering new adapter (Mantis DVB adapter)
Mantis: probe of 0000:05:02.0 failed with error -1

I activated debug-info by setting verbose to 9 in mantis_cards. I'm
using linux kernel 2.6.31-19-generic which is the latest in ubuntu.
The following is what I can read from syslog when I blacklist mantis
and then modprobe it.

 found a VP-3030 PCI DVB-T device on (05:02.0),
 Mantis 0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
     Mantis Rev 1 [1822:0024], irq: 23, latency: 64
    memory: 0x0, mmio: 0xf86b2000
mantis_stream_control (0): Set stream to HIF
mantis_i2c_init (0): Initializing I2C ..
mantis_i2c_init (0): Disabling I2C interrupt
mantis_i2c_xfer (0): Messages:2
         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
        mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 1a 4d f6 ]
     MAC Address=[00:08:ca:1a:4d:f6]
mantis_dma_init (0): Mantis DMA init
mantis_alloc_buffers (0): DMA=0x361c0000 cpu=0xf61c0000 size=65536
mantis_alloc_buffers (0): RISC=0x3649f000 cpu=0xf649f000 size=1000
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
         Byte <0> RXD=0x1f7f0080  [00]
mantis_dvb_init (0): !!! NO Frontends found !!!
mantis_dvb_init (0): ERROR! Adapter unregistered
mantis_pci_probe (0): ERROR: Mantis DVB initialization failed <-1>
Mantis: probe of 0000:05:02.0 failed with error -1

Any help is greatly appreciated!

Regards,
Niklas Claesson
