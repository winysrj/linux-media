Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oberstel@gmail.com>) id 1KH2ym-0007vE-DV
	for linux-dvb@linuxtv.org; Thu, 10 Jul 2008 22:43:05 +0200
Received: by yx-out-2324.google.com with SMTP id 8so998885yxg.41
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 13:42:55 -0700 (PDT)
Message-ID: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>
Date: Thu, 10 Jul 2008 22:42:54 +0200
From: "Leif Oberste-Berghaus" <oberstel@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400 (VP-2040) &
	mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1981196834=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1981196834==
Content-Type: multipart/alternative;
	boundary="----=_Part_16235_5442021.1215722574740"

------=_Part_16235_5442021.1215722574740
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

I have serious trouble using the mantis driver from
http://jusst.de/hg/mantis.

After loading the driver and using it in conjunction with VDR, the PC freeze
after a while (10min to 6h).
"Freeze" in this case means, that the PC does not react on any action (using
the remote, keyboard, ping or anything else) but the TV-Livesignal and sound
are still on the TV!

Just before this "freeze" happend, I recognized many "mantis start/stop feed
& dma" in dmesg.

Jul 9 08:55:21 vdr kernel: mantis_alloc_buffers (0): DMA=0x2ed90000
cpu=0xeed90000 size=65536
Jul 9 08:55:21 vdr kernel: mantis_alloc_buffers (0): RISC=0x2f354000
cpu=0xef354000 size=1000
Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): Probing for CU1216
(DVB-C)
Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): found Philips CU1216
DVB-C frontend (TDA10023) @ 0x0c
Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): Mantis DVB-C Philips
CU1216 frontend attach success
Jul 9 08:56:29 vdr kernel: mantis start feed & dma
Jul 9 08:56:29 vdr kernel: mantis stop feed and dma
Jul 9 08:56:29 vdr kernel: mantis start feed & dma
Jul 9 08:56:29 vdr kernel: mantis stop feed and dma

Some Information about the system:
Linux myserver 2.6.24.7 #1 SMP Tue Jul 8 16:40:13 CEST 2008
One AMD x86_64 1000MHz processor, 2010.54 total bogomips, 511M RAM
System library 2.7.0

lspci -vs 01:07.0
01:07.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
    Subsystem: TERRATEC Electronic GmbH Unknown device 1178
    Flags: bus master, medium devsel, latency 32, IRQ 22
    Memory at fdfff000 (32-bit, prefetchable) [size=4K]

What's wrong?
Do I have to use a different kernel version?
Are there any preconditions to take in account?

Thanks for your help
L

------=_Part_16235_5442021.1215722574740
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,<br><br>I have serious trouble using the mantis driver from <a href="http://jusst.de/hg/mantis">http://jusst.de/hg/mantis</a>.<br><br>After loading the driver and using it in conjunction with VDR, the PC freeze after a while (10min to 6h).<br>
&quot;Freeze&quot; in this case means, that the PC does not react on any action (using the remote, keyboard, ping or anything else) but the TV-Livesignal and sound are still on the TV!<br><br>Just before this &quot;freeze&quot; happend, I recognized many &quot;mantis start/stop feed &amp; dma&quot; in dmesg.<br>
<br>Jul 9 08:55:21 vdr kernel: mantis_alloc_buffers (0): DMA=0x2ed90000 cpu=0xeed90000 size=65536<br>Jul 9 08:55:21 vdr kernel: mantis_alloc_buffers (0): RISC=0x2f354000 cpu=0xef354000 size=1000<br>Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): Probing for CU1216 (DVB-C)<br>
Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c<br>Jul 9 08:55:21 vdr kernel: mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success<br>Jul 9 08:56:29 vdr kernel: mantis start feed &amp; dma<br>
Jul 9 08:56:29 vdr kernel: mantis stop feed and dma<br>Jul 9 08:56:29 vdr kernel: mantis start feed &amp; dma<br>Jul 9 08:56:29 vdr kernel: mantis stop feed and dma<br><br>Some Information about the system:<br>Linux myserver <a href="http://2.6.24.7">2.6.24.7</a> #1 SMP Tue Jul 8 16:40:13 CEST 2008<br>
One AMD x86_64 1000MHz processor, 2010.54 total bogomips, 511M RAM<br>System library 2.7.0<br><br>lspci -vs 01:07.0<br>01:07.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)<br>
&nbsp;&nbsp;&nbsp; Subsystem: TERRATEC Electronic GmbH Unknown device 1178<br>&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 32, IRQ 22<br>&nbsp;&nbsp;&nbsp; Memory at fdfff000 (32-bit, prefetchable) [size=4K]<br><br>What&#39;s wrong?<br>Do I have to use a different kernel version?<br>
Are there any preconditions to take in account?<br><br>Thanks for your help<br>L<br><br><br><br>

------=_Part_16235_5442021.1215722574740--


--===============1981196834==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1981196834==--
