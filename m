Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KI12e-0006XV-OX
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 14:51:06 +0200
Message-ID: <4879FA31.2080803@kolumbus.fi>
Date: Sun, 13 Jul 2008 15:50:57 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Leif Oberste-Berghaus <oberstel@gmail.com>
References: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>
In-Reply-To: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
 (VP-2040) &	mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi,

I have Twinhan DVB-C 2033.
I have had freezes /reboots.

I did following things with the driver to stabilize things (my own 
driver version):
- Implement both 64byte and 188 byte alignment for DMA transfers.
- Generate less IRQs from DMA transfers.

That has helped: My AMD dualcore don't do hard reset so often and the
saved TV programs are now usable (without my changes the dvb stream
lost voice and VDR couldn't show them more than a few minutes).
My version seems to use less power (Too weak power supply
might be part of my problem though).

I don't know yet though whether Manu or others are interested in my patches.
I use too new kernel version to deliver patches for Manu easilly.

Regards,
Marko Ristola

Leif Oberste-Berghaus wrote:
> Hi All,
>
> I have serious trouble using the mantis driver from 
> http://jusst.de/hg/mantis.
>
> After loading the driver and using it in conjunction with VDR, the PC 
> freeze after a while (10min to 6h).
> "Freeze" in this case means, that the PC does not react on any action 
> (using the remote, keyboard, ping or anything else) but the 
> TV-Livesignal and sound are still on the TV!
>
> Just before this "freeze" happend, I recognized many "mantis 
> start/stop feed & dma" in dmesg.
>
> Jul 9 08:55:21 vdr kernel: mantis_alloc_buffers (0): DMA=0x2ed90000 
> cpu=0xeed90000 size=65536
> Jul 9 08:55:21 vdr kernel: mantis_alloc_buffers (0): RISC=0x2f354000 
> cpu=0xef354000 size=1000
> Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): Probing for 
> CU1216 (DVB-C)
> Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): found Philips 
> CU1216 DVB-C frontend (TDA10023) @ 0x0c
> Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): Mantis DVB-C 
> Philips CU1216 frontend attach success
> Jul 9 08:56:29 vdr kernel: mantis start feed & dma
> Jul 9 08:56:29 vdr kernel: mantis stop feed and dma
> Jul 9 08:56:29 vdr kernel: mantis start feed & dma
> Jul 9 08:56:29 vdr kernel: mantis stop feed and dma
>
> Some Information about the system:
> Linux myserver 2.6.24.7 <http://2.6.24.7> #1 SMP Tue Jul 8 16:40:13 
> CEST 2008
> One AMD x86_64 1000MHz processor, 2010.54 total bogomips, 511M RAM
> System library 2.7.0
>
> lspci -vs 01:07.0
> 01:07.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV 
> PCI Bridge Controller [Ver 1.0] (rev 01)
>     Subsystem: TERRATEC Electronic GmbH Unknown device 1178
>     Flags: bus master, medium devsel, latency 32, IRQ 22
>     Memory at fdfff000 (32-bit, prefetchable) [size=4K]
>
> What's wrong?
> Do I have to use a different kernel version?
> Are there any preconditions to take in account?
>
> Thanks for your help
> L
>
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
