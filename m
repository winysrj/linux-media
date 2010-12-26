Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62607 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0LZOkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 09:40:22 -0500
Received: by wyb28 with SMTP id 28so7917192wyb.19
        for <linux-media@vger.kernel.org>; Sun, 26 Dec 2010 06:40:21 -0800 (PST)
Message-ID: <4D1753CF.9010205@gmail.com>
Date: Sun, 26 Dec 2010 15:40:15 +0100
From: =?ISO-8859-1?Q?Ludovic_BOU=C9?= <ludovic.boue@gmail.com>
MIME-Version: 1.0
To: linux-media@dinkum.org.uk, linux-media@vger.kernel.org
CC: o.endriss@gmx.de
Subject: Re: ngene & Satix-S2 dual problems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

I have a Satix-S2 Dual and I'm trying to get to work without his CI in a first time. I'm trying ngene-test2 
from http://linuxtv.org/hg/~endriss/ngene-test2/ under 
2.6.32-21-generic.

It contains too much nodes (extra demuxes, dvrs & nets):

> ubuntu@ubuntu:~/ngene-test2/v4l$ ls -l /dev/dvb/adapter*
> total 0
> crw-rw----+ 1 root video 212,  0 2010-12-26 13:08 demux0
> crw-rw----+ 1 root video 212,  4 2010-12-26 13:08 demux1
> crw-rw----+ 1 root video 212,  8 2010-12-26 13:08 demux2
> crw-rw----+ 1 root video 212, 11 2010-12-26 13:08 demux3
> crw-rw----+ 1 root video 212, 14 2010-12-26 13:08 demux4
> crw-rw----+ 1 root video 212,  1 2010-12-26 13:08 dvr0
> crw-rw----+ 1 root video 212,  5 2010-12-26 13:08 dvr1
> crw-rw----+ 1 root video 212,  9 2010-12-26 13:08 dvr2
> crw-rw----+ 1 root video 212, 12 2010-12-26 13:08 dvr3
> crw-rw----+ 1 root video 212, 15 2010-12-26 13:08 dvr4
> crw-rw----+ 1 root video 212,  3 2010-12-26 13:08 frontend0
> crw-rw----+ 1 root video 212,  7 2010-12-26 13:08 frontend1
> crw-rw----+ 1 root video 212,  2 2010-12-26 13:08 net0
> crw-rw----+ 1 root video 212,  6 2010-12-26 13:08 net1
> crw-rw----+ 1 root video 212, 10 2010-12-26 13:08 net2
> crw-rw----+ 1 root video 212, 13 2010-12-26 13:08 net3
> crw-rw----+ 1 root video 212, 16 2010-12-26 13:08 net4
Is it connected to this commit (http://linuxtv.org/hg/~endriss/ngene-test2/rev/eb4142f0d0ac) about "Support up to 4 tuners for cineS2 v5, duoflex & mystique v2" ?

Here is what dmesg reports I do 'modprobe ngene'

> [ 3248.072496] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
> [ 3248.072533] ngene 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 3248.072548] ngene: Found Mystique SaTiX-S2 Dual (v2)
> [ 3248.075765] ngene 0000:02:00.0: setting latency timer to 64
> [ 3248.075926] ngene: Device version 1
> [ 3248.075938] ngene 0000:02:00.0: firmware: requesting ngene_18.fw
> [ 3248.079319] ngene: Loading firmware file ngene_18.fw.
> [ 3248.090194]   alloc irq_desc for 28 on node -1
> [ 3248.090197]   alloc kstat_irqs on node -1
> [ 3248.090212] ngene 0000:02:00.0: irq 28 for MSI/MSI-X
> [ 3248.091778] error in i2c_read_reg
> [ 3248.091781] No CXD2099 detected at 40	<---- No dedicated ASIC is a
> Sony CXD2099AR
> [ 3248.091943] DVB: registering new adapter (nGene)
> [ 3248.414997] LNBx2x attached on addr=a
> [ 3248.421091] stv6110x_attach: Attaching STV6110x
> [ 3248.421095] DVB: registering adapter 0 frontend 0 (STV090x Multistandard)...
> [ 3248.422500] LNBx2x attached on addr=8
> [ 3248.422568] stv6110x_attach: Attaching STV6110x
> [ 3248.422571] DVB: registering adapter 0 frontend 0 (STV090x Multistandard)...
About the module :
> ubuntu@ubuntu:~/ngene-test2/v4l$ modinfo ngene
> filename:
> /lib/modules/2.6.32-21-generic/kernel/drivers/media/dvb/ngene/ngene.ko
> license:        GPL
> author:         Micronas, Ralph Metzler, Manfred Voelkel
> description:    nGene
> license:        GPL
> author:         Ralph Metzler <rjkm@metzlerbros.de>
> description:    cxd2099
> srcversion:     AC815F965A079912E969015
> alias:          pci:v000018C3d00000720sv00001461sd0000062Ebc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000DD20bc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000DD10bc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000DD00bc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000DB02bc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000DB01bc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000ABC4bc*sc*i*
> alias:          pci:v000018C3d00000720sv000018C3sd0000ABC3bc*sc*i*
> depends:        dvb-core
> vermagic:       2.6.32-21-generic SMP mod_unload modversions 586
> parm:           one_adapter:Use only one adapter. (int)
> parm:           shutdown_workaround:Activate workaround for shutdown
> problem with some chipsets. (int)
> parm:           debug:Print debugging information. (int)
> parm:           adapter_nr:DVB adapter numbers (array of short)

When I put the option "one_adapter=0" :

> sudo modprobe ngene debug=1 one_adapter=0

> [ 6077.066311] ngene 0000:02:00.0: PCI INT A disabled
> [ 6101.525377] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
> [ 6101.525405] ngene 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 6101.525418] ngene: Found Mystique SaTiX-S2 Dual (v2)
> [ 6101.530520] ngene 0000:02:00.0: setting latency timer to 64
> [ 6101.530683] ngene: Device version 1
> [ 6101.530692] ngene 0000:02:00.0: firmware: requesting ngene_18.fw
> [ 6101.532043] ngene: Loading firmware file ngene_18.fw.
> [ 6101.542919] ngene 0000:02:00.0: irq 28 for MSI/MSI-X
> [ 6101.545199] error in i2c_read_reg
> [ 6101.545206] No CXD2099 detected at 40
> [ 6101.545374] DVB: registering new adapter (nGene)
> [ 6101.844886] LNBx2x attached on addr=a
> [ 6101.845092] stv6110x_attach: Attaching STV6110x
> [ 6101.845101] DVB: registering adapter 0 frontend 0 (STV090x Multistandard)...
> [ 6101.846175] DVB: registering new adapter (nGene)
> [ 6101.850023] LNBx2x attached on addr=8
> [ 6101.850231] stv6110x_attach: Attaching STV6110x
> [ 6101.850238] DVB: registering adapter 1 frontend 0 (STV090x Multistandard)...
> [ 6101.850584] DVB: registering new adapter (nGene) <---- No need to register this 
> adapter
> [ 6101.852948] DVB: registering new adapter (nGene) <---- No need to register this 
> adapter 
> [ 6101.855690] DVB: registering new adapter (nGene) <---- No need to register this 
> adapter
You can see that adapter 2, 3 and 4 are registering and the is no need to.
> ubuntu@ubuntu:~/ngene-test2/v4l$ ls -l /dev/dvb/adapter*
> /dev/dvb/adapter0:
> total 0
> crw-rw----+ 1 root video 212, 0 2010-12-26 12:52 demux0
> crw-rw----+ 1 root video 212, 1 2010-12-26 12:52 dvr0
> crw-rw----+ 1 root video 212, 3 2010-12-26 12:52 frontend0
> crw-rw----+ 1 root video 212, 2 2010-12-26 12:52 net0
>
> /dev/dvb/adapter1:
> total 0
> crw-rw----+ 1 root video 212, 4 2010-12-26 12:52 demux0
> crw-rw----+ 1 root video 212, 5 2010-12-26 12:52 dvr0
> crw-rw----+ 1 root video 212, 7 2010-12-26 12:52 frontend0
> crw-rw----+ 1 root video 212, 6 2010-12-26 12:52 net0
>
> /dev/dvb/adapter2:
> total 0
> crw-rw----+ 1 root video 212,  8 2010-12-26 12:52 demux0
> crw-rw----+ 1 root video 212,  9 2010-12-26 12:52 dvr0
> crw-rw----+ 1 root video 212, 10 2010-12-26 12:52 net0
>
> /dev/dvb/adapter3:
> total 0
> crw-rw----+ 1 root video 212, 11 2010-12-26 12:52 demux0
> crw-rw----+ 1 root video 212, 12 2010-12-26 12:52 dvr0
> crw-rw----+ 1 root video 212, 13 2010-12-26 12:52 net0
>
> /dev/dvb/adapter4:
> total 0
> crw-rw----+ 1 root video 212, 14 2010-12-26 12:52 demux0
> crw-rw----+ 1 root video 212, 15 2010-12-26 12:52 dvr0
> crw-rw----+ 1 root video 212, 16 2010-12-26 12:52 net0
Is the no test to check how many andapters are needed with the card ? I
was working with stable driver dans 1.5 firmware.

Ludovic,


-- 
Ludovic BOUÉ

