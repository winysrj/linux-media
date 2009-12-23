Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61247 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZLWTdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 14:33:07 -0500
Received: by fxm25 with SMTP id 25so2293572fxm.21
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 11:33:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B3269AE.6080602@freenet.de>
References: <4B1D6194.4090308@freenet.de> <1261578615.8948.4.camel@slash.doma>
	 <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
Date: Wed, 23 Dec 2009 23:24:55 +0400
Message-ID: <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
From: Manu Abraham <abraham.manu@gmail.com>
To: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
Cc: =?UTF-8?Q?Alja=C5=BE_Prusnik?= <prusnik@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ruediger,

On Wed, Dec 23, 2009 at 11:04 PM, Ruediger Dohmhardt
<ruediger.dohmhardt@freenet.de> wrote:
> Aljaž Prusnik schrieb:
>>
>> If using the http://jusst.de/hg/v4l-dvb tree, everything compiles ok,
>> module loads, but there is no remote anywhere (there is an IR folder
>> with the ir-common.ko file, under common there is not).
>>
>>
> Aljaz, do you have the module mantis.ko?
>
> Ruediger
>

There was a build issue when i posted the link originally, but it had
been fixed..

manu@manu-04:/stor/work/merge/v4l-dvb/v4l> ls *.ko |grep mantis
mantis_core.ko
mantis.ko


Dec 12 01:18:25 manu-04 kernel: [168362.291827] found a VP-2033 PCI
DVB-C device on (06:01.0),
Dec 12 01:18:25 manu-04 kernel: [168362.291842] Mantis 0000:06:01.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
Dec 12 01:18:25 manu-04 kernel: [168362.291848] Mantis 0000:06:01.0:
enabling bus mastering
Dec 12 01:18:25 manu-04 kernel: [168362.291876]     Mantis Rev 1
[1822:0008], irq: 17, latency: 64
Dec 12 01:18:25 manu-04 kernel: [168362.291881]     memory: 0x0, mmio:
0xf875e000
Dec 12 01:18:25 manu-04 kernel: [168362.292577] i2c-adapter i2c-7:
adapter [Mantis I2C] registered
Dec 12 01:18:25 manu-04 kernel: [168362.292586] i2c-adapter i2c-7:
master_xfer[0] W, addr=0x50, len=1
Dec 12 01:18:25 manu-04 kernel: [168362.292590] i2c-adapter i2c-7:
master_xfer[1] R, addr=0x50, len=6
Dec 12 01:18:25 manu-04 kernel: [168362.292593]
mantis_i2c_write: Address=[0x50] <W>[ 08 ]
Dec 12 01:18:25 manu-04 kernel: [168362.292813]
mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 19 ea ee ]
Dec 12 01:18:25 manu-04 kernel: [168362.293539]     MAC
Address=[00:08:ca:19:ea:ee]
Dec 12 01:18:25 manu-04 kernel: [168362.293565] mantis_alloc_buffers
(0): DMA=0x2c50000 cpu=0xc2c50000 size=65536
Dec 12 01:18:25 manu-04 kernel: [168362.293571] mantis_alloc_buffers
(0): RISC=0x31e36000 cpu=0xf1e36000 size=1000
Dec 12 01:18:25 manu-04 kernel: [168362.293575] DVB: registering new
adapter (Mantis DVB adapter)
Dec 12 01:18:26 manu-04 kernel: [168363.172508] vp2033_frontend_init
(0): Probing for CU1216 (DVB-C)
Dec 12 01:18:26 manu-04 kernel: [168363.172515] i2c-adapter i2c-7:
master_xfer[0] W, addr=0x50, len=1
Dec 12 01:18:26 manu-04 kernel: [168363.172519] i2c-adapter i2c-7:
master_xfer[1] R, addr=0x50, len=1
Dec 12 01:18:26 manu-04 kernel: [168363.172522]
mantis_i2c_write: Address=[0x50] <W>[ ff ]
Dec 12 01:18:26 manu-04 kernel: [168363.172741]
mantis_i2c_read:  Address=[0x50] <R>[ 22 ]
Dec 12 01:18:26 manu-04 kernel: [168363.172967] i2c-adapter i2c-7:
master_xfer[0] W, addr=0x0c, len=1
Dec 12 01:18:26 manu-04 kernel: [168363.172970] i2c-adapter i2c-7:
master_xfer[1] R, addr=0x0c, len=1
Dec 12 01:18:26 manu-04 kernel: [168363.172973]
mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
Dec 12 01:18:26 manu-04 kernel: [168363.173194]
mantis_i2c_read:  Address=[0x0c] <R>[ 7c ]
Dec 12 01:18:26 manu-04 kernel: [168363.173416] TDA10021: i2c-addr =
0x0c, id = 0x7c
Dec 12 01:18:26 manu-04 kernel: [168363.173419] vp2033_frontend_init
(0): found Philips CU1216 DVB-C frontend (TDA10021) @ 0x0c
Dec 12 01:18:26 manu-04 kernel: [168363.173422] vp2033_frontend_init
(0): Mantis DVB-C Philips CU1216 frontend attach success
Dec 12 01:18:26 manu-04 kernel: [168363.173428] DVB: registering
adapter 0 frontend 0 (Philips TDA10021 DVB-C)...
Dec 12 01:18:26 manu-04 kernel: [168363.173549] mantis_uart_init (0):
Initializing UART @ 9600 bps NONE parity
Dec 12 01:18:26 manu-04 kernel: [168363.175459] mantis_uart_work (0):
UART BUF:0 <3f>


The IR stuff needs a bit more work, which I will be pushing out, later ..

Regards,
Manu
