Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:62955 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab0INVBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 17:01:42 -0400
Subject: Re: Need info to understand TeVii S470 cx23885 MSI  problem
From: Andy Walls <awalls@md.metrocast.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201009140108.50109.liplianin@me.by>
References: <1284321417.2394.10.camel@localhost>
	 <201009132338.28664.liplianin@me.by> <201009132341.21818.liplianin@me.by>
	 <201009140108.50109.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 17:01:20 -0400
Message-ID: <1284498080.26360.45.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2010-09-14 at 01:08 +0300, Igor M. Liplianin wrote:
> В сообщении от 13 сентября 2010 23:41:21 автор Igor M. Liplianin написал:
> > В сообщении от 13 сентября 2010 23:38:28 автор Igor M. Liplianin написал:
> > > В сообщении от 12 сентября 2010 22:56:57 автор Andy Walls написал:

> > > > The linux kernel should be writing the MSI IRQ vector into the PCI
> > > > configuration space of the CX23885.  It looks like when you unload and
> > > > reload the cx23885 module, it is not changing the vector.

> > > Error appears only and if you zap actual channel(interrupts actually
> > > calls). First time module loaded and zapped some channel. At this point
> > > there is no errors. /proc/interrupts shows some irq's for cx23885.
> > > Then rmmod-insmod and szap again. Voilla! No irq vector.
> > > /proc/interrupts shows zero irq calls for cx23885.
> > > In my case Do_irq complains about irq 153, dmesq says cx23885 uses 45.

> > Forget to mention. The tree is media_tree, branch staging/v2.6.37

Hi Igor,

On the surface what is going on is now obvious to me:

> bash-4.1# szap -l10750 bridge-tv -x
> reading channels from file '/root/.szap/channels.conf'
> zapping to 6 'bridge-tv':
> sat 1, frequency = 12303 MHz H, symbolrate 27500000, vpid = 0x0134, apid = 0x0100 sid = 0x003b
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal fde8 | snr e128 | ber 00000000 | unc 0000000b | FE_HAS_LOCK
> bash-4.1# lspci -d 14f1: -xxxx -vvvv 
> 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder 
> (rev 02)
>         Subsystem: Device d470:9022

>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0300c  Data: 4191

> a0: 05 00 81 00 0c 30 e0 fe 00 00 00 00 91 41 00 00
             ^                            ^^
             |                            |
MSI Enabled--+                            |
                                          |
Linux MSI vector (0x91 = 145) ------------+


> bash-4.1# rmmod cx23885
> bash-4.1# insmod cx23885.ko
> bash-4.1# lspci -d 14f1: -xxxx -vvvv 
> 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder 
> (rev 02)
>         Subsystem: Device d470:9022

>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0300c  Data: 4199

> a0: 05 00 81 00 0c 30 e0 fe 00 00 00 00 99 41 00 00
             ^                            ^^
             |                            |
MSI Enabled--+                            |
                                          |
Linux MSI vector (0x99 = 153) ------------+ 


> bash-4.1# szap -l10750 bridge-tv -x
> reading channels from file '/root/.szap/channels.conf'
> zapping to 6 'bridge-tv':
> sat 1, frequency = 12303 MHz H, symbolrate 27500000, vpid = 0x0134, apid = 0x0100 sid = 0x003b
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal f618 | snr e128 | ber 00000000 | unc 0000000b | 
> 
> Message from syslogd@localhost at Tue Sep 14 01:00:50 2010 ...
> localhost kernel: do_IRQ: 0.145 No irq handler for vector (irq -1)
                              ^^^
                               |
Previous MSI vector used ------+
(145 = 0x91 and is not 0x99 ! )


The CX23885 hardware is sending the old/previous MSI data in the PCIe
MSI message.

The likely reasons I can think of for this to happen are:

1. The CX23885 chip has a bug and send at least one PCIe MSI message
with the old MSI data, when the MSI data payload in the PCIe config
space of the CX23885 has changed.

2. Your kernel is using the PCI Enhanced Configuration Access Method
(Linux calls it MMCONFIG in dmesg) and PCI MMIO Configuration writes to
the CX23885 are getting reordered due to motherboard/chipset design
problem.  Under these conditions, MSI on the CX23885 could be re-enabled
before the MSI Data vector is updated in the CX23885's PCI config space.

(See page 5 of:
http://www.pcisig.com/specifications/pciexpress/PciEx_ECN_MMCONFIG_040217.pdf )


To eliminate #2 being a problem, could you please boot your kernel with
"pci=nommconf" on the kernel command line and see if the MSI data vector
problem goes away?

Regards,
Andy

