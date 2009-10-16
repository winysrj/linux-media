Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <t.gruner@katodev.de>) id 1Mymdu-0005TM-Tp
	for linux-dvb@linuxtv.org; Fri, 16 Oct 2009 15:14:52 +0200
Received: from keller.home (f054146114.adsl.alicedsl.de [78.54.146.114])
	by post.strato.de (fruni mo43) (RZmta 22.1)
	with ESMTP id Q05e4fl9GCKikc for <linux-dvb@linuxtv.org>;
	Fri, 16 Oct 2009 15:14:47 +0200 (MEST)
Received: from [192.168.100.14] (unknown [192.168.100.14])
	by keller.home (Postfix) with ESMTP id A17FB24C233
	for <linux-dvb@linuxtv.org>; Fri, 16 Oct 2009 15:14:44 +0200 (CEST)
Message-ID: <4AD871C3.70800@katodev.de>
Date: Fri, 16 Oct 2009 15:14:43 +0200
From: Torsten Gruner <t.gruner@katodev.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Terratec Cinergy C PCI + CI-Modul
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hello,

could someone fix the bug in Mantis / Liplianin driver? It will be realy
great.
When I plugin an AlphaCrypt all channels receive data trash. No matter
is crypted or uncrypted.

Here are some extracts from my logs

[    0.000000] Linux version 2.6.28-11-generic (buildd@palmer) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC 2009 (Ubuntu 2.6.28-11.42-generic)
[   12.365608] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.493690] Linux agpgart interface v0.103
[   13.225566] nvidia: module license 'NVIDIA' taints kernel.
[   13.356063] Mantis 0000:01:06.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   13.356320] irq: 18, latency: 64
[   13.356321]  memory: 0xfddff000, mmio: 0xf921e000
[   13.356323] found a VP-2040 PCI DVB-C device on (01:06.0),
[   13.356325]     Mantis Rev 1 [153b:1178], irq: 18, latency: 64
[   13.356327]     memory: 0xfddff000, mmio: 0xf921e000
[   13.362941]     MAC Address=[00:08:ca:1d:bb:8e]
[   13.362962] mantis_alloc_buffers (0): DMA=0x35f20000 cpu=0xf5f20000 size=65536
[   13.363015] mantis_alloc_buffers (0): RISC=0x35d75000 cpu=0xf5d75000 size=1000
[   13.363064] DVB: registering new adapter (Mantis dvb adapter)
[   13.464110] HDA Intel 0000:00:08.0: PCI INT A -> Link[AAZA] -> GSI 21 (level, low) -> IRQ 21
[   13.464156] HDA Intel 0000:00:08.0: setting latency timer to 64
[   13.480115] nvidia 0000:03:00.0: PCI INT A -> Link[AIGP] -> GSI 22 (level, low) -> IRQ 22
[   13.480121] nvidia 0000:03:00.0: setting latency timer to 64
[   13.480284] NVRM: loading NVIDIA UNIX x86 Kernel Module  185.18.36  Fri Aug 14 17:18:04 PDT 2009
[   13.856011] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   13.880111] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[   13.883641] TDA10023: i2c-addr = 0x0c, id = 0x7d
[   13.883644] mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
[   13.883693] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
[   13.883744] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
[   13.883834] mantis_ca_init (0): Registering EN50221 device
[   13.883958] mantis_ca_init (0): Registered EN50221 device
[   13.884011] mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
[   13.884139] input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input4
[   13.984015] Mantis VP-2040 IR Receiver: unknown key: key=0x00 raw=0x00 down=1
[   14.084507] Mantis VP-2040 IR Receiver: unknown key: key=0x00 raw=0x00 down=0
[   14.734868] lp: driver loaded but no devices found
[   16.042035] dvb_ca adapter 0: DVB CAM detected and initialised successfully


Oct 13 21:16:58 stone kernel: [   38.373123] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:17:09 stone kernel: [   50.011415] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:17:14 stone kernel: [   54.981147] mantis start feed & dma
Oct 13 21:17:15 stone kernel: [   55.496914] mantis stop feed and dma
.
Oct 13 21:17:15 stone kernel: [   55.812943] mantis stop feed and dma
Oct 13 21:17:15 stone kernel: [   55.813244] mantis start feed & dma
Oct 13 21:17:17 stone vdr: [4012] [xine..put] Detected video size 720x576
.
Oct 13 21:17:55 stone vdr: [4041] [xine..put] Detected video size 720x576
Oct 13 21:17:55 stone kernel: [   95.349188] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:17:56 stone vdr: [4051] [xine..put] Detected video size 720x576
Oct 13 21:18:00 stone vdr: [4059] [xine..put] Detected video size 720x576
Oct 13 21:18:07 stone vdr: [4064] [xine..put] Detected video size 720x576
Oct 13 21:18:29 stone kernel: [  129.437387] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:18:52 stone kernel: [  152.655710] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:19:15 stone kernel: [  175.284245] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:19:30 stone kernel: [  190.439298] sr 6:0:0:0: [sr0] unaligned transfer
Oct 13 21:20:24 stone kernel: [  242.897216] sr 6:0:0:0: [sr0] unaligned transfer
Oct 13 21:20:40 stone vdr: [4301] [xine..put] Detected video size 720x576
Oct 13 21:20:56 stone vdr: [3682] [xine..put] Received valid discovery message VDR xineliboutput DISCOVERY 1.0^M Client: 255.255.255.255:37890^M ^M 
Oct 13 21:20:56 stone vdr: [3682] [xine..put] Client 0 connected: 127.0.0.1:60099
Oct 13 21:20:56 stone vdr: [3682] [xine..put] Client address: 127.0.0.1
Oct 13 21:20:59 stone kernel: [  279.974328] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:21:19 stone vdr: [4323] [xine..put] OSD bandwidth: 341322 bytes/s (2666 kbit/s)
Oct 13 21:21:23 stone vdr: [3664] [xine..put] OSD bandwidth: 168593 bytes/s (1317 kbit/s)
Oct 13 21:21:24 stone vdr: [3664] [xine..put] OSD bandwidth: 294674 bytes/s (2302 kbit/s)
Oct 13 21:21:26 stone vdr: [3664] [xine..put] OSD bandwidth: 168543 bytes/s (1316 kbit/s)
Oct 13 21:21:29 stone vdr: [4325] [xine..put] OSD bandwidth: 151427 bytes/s (1183 kbit/s)
Oct 13 21:21:33 stone vdr: [4326] [xine..put] Detected video size 720x576
Oct 13 21:21:39 stone kernel: [  320.185526] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:21:57 stone kernel: [  337.943766] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:22:21 stone kernel: [  361.933919] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:22:44 stone kernel: [  385.052584] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:23:31 stone kernel: [  431.808315] dvb_ca adapter 0: DVB CAM detected and initialised successfully
Oct 13 21:23:43 stone kernel: [  443.291316] dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
Oct 13 21:23:43 stone kernel: [  443.291321] dvb_ca adapter 0: DVB CAM link initialisation failed :(




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
