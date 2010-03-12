Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55477 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab0CLUuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 15:50:50 -0500
Received: by bwz1 with SMTP id 1so1415526bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 12:50:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361003121240q39129f5fhb9450c691b79d52b@mail.gmail.com>
References: <f509f3091001311223q19a9854fwb546e6fcadc08021@mail.gmail.com>
	 <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
	 <f509f3091003120927n4feca4d4h6616524adf0d36ee@mail.gmail.com>
	 <1a297b361003121240q39129f5fhb9450c691b79d52b@mail.gmail.com>
Date: Fri, 12 Mar 2010 21:50:48 +0100
Message-ID: <f509f3091003121250g6286e74jcd782f08a88ff9e1@mail.gmail.com>
Subject: Re: [linux-dvb] Twinhan dtv 3030 mantis
From: Niklas Claesson <nicke.claesson@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/3/12 Manu Abraham <abraham.manu@gmail.com>:
>
> Can you please load the mantis driver with module option verbose=5 and
> post the details ?
>
> Regards,
> Manu
>

Here you go:

Mar 12 21:49:29 niklas-desktop kernel: [   70.660177] found a VP-3030
PCI DVB-T device on (05:02.0),
Mar 12 21:49:29 niklas-desktop kernel: [   70.660188] Mantis
0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Mar 12 21:49:29 niklas-desktop kernel: [   70.660207]     Mantis Rev 1
[1822:0024], irq: 23, latency: 64
Mar 12 21:49:29 niklas-desktop kernel: [   70.660210]     memory: 0x0,
mmio: 0xf86ce000
Mar 12 21:49:29 niklas-desktop kernel: [   70.660218]
mantis_stream_control (0): Set stream to HIF
Mar 12 21:49:29 niklas-desktop kernel: [   70.660245] mantis_i2c_init
(0): Initializing I2C ..
Mar 12 21:49:29 niklas-desktop kernel: [   70.660248] mantis_i2c_init
(0): Disabling I2C interrupt
Mar 12 21:49:29 niklas-desktop kernel: [   70.660252] mantis_i2c_xfer
(0): Messages:2
Mar 12 21:49:29 niklas-desktop kernel: [   70.660254]
mantis_i2c_write: Address=[0x50] <W>[ 08 ]
Mar 12 21:49:29 niklas-desktop kernel: [   70.660474]
mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 1a 4d f6 ]
Mar 12 21:49:29 niklas-desktop kernel: [   70.661200]     MAC
Address=[00:08:ca:1a:4d:f6]
Mar 12 21:49:29 niklas-desktop kernel: [   70.661202] mantis_dma_init
(0): Mantis DMA init
Mar 12 21:49:29 niklas-desktop kernel: [   70.661219]
mantis_alloc_buffers (0): DMA=0x36300000 cpu=0xf6300000 size=65536
Mar 12 21:49:29 niklas-desktop kernel: [   70.661223]
mantis_alloc_buffers (0): RISC=0x34d99000 cpu=0xf4d99000 size=1000
Mar 12 21:49:29 niklas-desktop kernel: [   70.661226]
mantis_calc_lines (0): Mantis RISC block bytes=[4096], line
bytes=[2048], line count=[32]
Mar 12 21:49:29 niklas-desktop kernel: [   70.661228] mantis_dvb_init
(0): dvb_register_adapter
Mar 12 21:49:29 niklas-desktop kernel: [   70.661230] DVB: registering
new adapter (Mantis DVB adapter)
Mar 12 21:49:29 niklas-desktop kernel: [   70.661232] mantis_dvb_init
(0): dvb_dmx_init
Mar 12 21:49:29 niklas-desktop kernel: [   70.661304] mantis_dvb_init
(0): dvb_dmxdev_init
Mar 12 21:49:29 niklas-desktop kernel: [   70.661434] gpio_set_bits
(0): Set Bit <13> to <0>
Mar 12 21:49:29 niklas-desktop kernel: [   70.661437] gpio_set_bits
(0): GPIO Value <00>
Mar 12 21:49:29 niklas-desktop kernel: [   70.764121]
mantis_frontend_power (0): Power ON
Mar 12 21:49:29 niklas-desktop kernel: [   70.764127] gpio_set_bits
(0): Set Bit <12> to <1>
Mar 12 21:49:29 niklas-desktop kernel: [   70.764131] gpio_set_bits
(0): GPIO Value <1000>
Mar 12 21:49:29 niklas-desktop kernel: [   70.868076] gpio_set_bits
(0): Set Bit <12> to <1>
Mar 12 21:49:29 niklas-desktop kernel: [   70.868081] gpio_set_bits
(0): GPIO Value <1000>
Mar 12 21:49:29 niklas-desktop kernel: [   71.076032] gpio_set_bits
(0): Set Bit <13> to <1>
Mar 12 21:49:29 niklas-desktop kernel: [   71.076037] gpio_set_bits
(0): GPIO Value <3000>
Mar 12 21:49:29 niklas-desktop kernel: [   71.332045]
vp3030_frontend_init (0): Probing for 10353 (DVB-T)
Mar 12 21:49:29 niklas-desktop kernel: [   71.332051] mantis_i2c_xfer
(0): Messages:2
Mar 12 21:49:29 niklas-desktop kernel: [   71.332053]         Byte MODE:
Mar 12 21:49:29 niklas-desktop kernel: [   71.332056]         Byte <0>
RXD=0x1f7f0080  [00]
Mar 12 21:49:29 niklas-desktop kernel: [   71.332059] mantis_dvb_init
(0): !!! NO Frontends found !!!
Mar 12 21:49:29 niklas-desktop kernel: [   71.334430] mantis_dvb_init
(0): ERROR! Adapter unregistered
Mar 12 21:49:29 niklas-desktop kernel: [   71.334433] mantis_pci_probe
(0): ERROR: Mantis DVB initialization failed <-1>
Mar 12 21:49:29 niklas-desktop kernel: [   71.334448] Mantis: probe of
0000:05:02.0 failed with error -1

Regards,
Niklas Claesson
