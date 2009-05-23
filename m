Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv6.handshake.de ([193.141.176.12]:42471 "EHLO
	srv6.handshake.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZEWPgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 11:36:15 -0400
Received: from smtpproxy (helo=localhost)
	by srv6.handshake.de with local-esmtp (Exim 4.63)
	(envelope-from <operator@handshake.de>)
	id 1M7sVB-0004nC-Uf
	for linux-media@vger.kernel.org; Sat, 23 May 2009 16:47:10 +0200
Message-ID: <4A180C71.1080109@handshake.de>
Date: Sat, 23 May 2009 16:47:13 +0200
From: Andreas Besse <operator@handshake.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cannot rmmod stb0899
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm using a KNC One TV-Station DVB-S2 Plus and a WinTV-NOVA-CI PCI with
the multiprotocol drivers from http://www.jusst.de/hg/multiproto/
(changeset: 7218:2a911b8f9910, date: Wed Jul 09 23:07:29 2008 +0400)

The drivers run fine since 250 (!) days, but I have an issue with high
cpu load. So I decited to apply the patch "Fix High CPU load in 'top'
due to budget_av slot polling" from Oliver Endriss or try the current
v4l tree.

First i tried to remove the current drivers. If i call "rmmod stb0899"
the driver is not removed. Instead an Error "ERROR: Module stb0899 is in
use" is shown (but no application is using the device)

I also tried "rmmod -w stb0899". This leads to an infinite loop and I'm
not able to kill the process.

How can I rmmod the stb0899 driver without rebooting the system?

How can I kill "rmmod -w stb0899"?

regards,
Andreas Besse

===============================================

output of lsmod:
...
tsdev                   7968  0
budget_av              24192  1
saa7146_vv             45152  2 budget_av
videobuf_dma_sg        12996  1 saa7146_vv
videobuf_core          17252  2 saa7146_vv,videobuf_dma_sg
videodev               26528  2 saa7146_vv
v4l2_common            17216  2 saa7146_vv,videodev
v4l1_compat            12516  2 saa7146_vv,videodev
firmware_class          9504  2 budget_ci,budget_av
budget_core            10756  2 budget_ci,budget_av
dvb_core               79900  4 budget_ci,stv0299,budget_av,budget_core
saa7146                18248  4 budget_ci,budget_av,saa7146_vv,budget_core
ttpci_eeprom            2432  1 budget_core
ide_cd                 36416  0
cdrom                  32832  1 ide_cd
rtc                    12856  0
pcspkr                  3104  0
intel_agp              23188  1
i2c_i801                8656  0
i2c_core               23552  10
budget_ci,stv0299,i2c_isa,tda8261,stb0899,budget_av,v4l2_common,budget_core,ttpci_eeprom,i2c_i801


===============================================

output of "make rmmod" in multiprotocol directory:

Mail:~/pakete/multiproto# make rmmod
make -C /root/pakete/multiproto/v4l rmmod
make[1]: Entering directory `/root/pakete/multiproto/v4l'
scripts/rmmod.pl unload
found 230 modules
/sbin/rmmod budget_av
ERROR: Module budget_av is in use
/sbin/rmmod budget_ci
/sbin/rmmod saa7146_vv
ERROR: Module saa7146_vv is in use by budget_av
/sbin/rmmod videodev
ERROR: Module videodev is in use by saa7146_vv
/sbin/rmmod budget_core
ERROR: Module budget_core is in use by budget_av
/sbin/rmmod stv0299
/sbin/rmmod videobuf_dma_sg
ERROR: Module videobuf_dma_sg is in use by saa7146_vv
/sbin/rmmod stb0899
ERROR: Module stb0899 is in use
/sbin/rmmod v4l1_compat
ERROR: Module v4l1_compat is in use by saa7146_vv,videodev
/sbin/rmmod dvb_core
ERROR: Module dvb_core is in use by budget_av,budget_core
/sbin/rmmod tda8261
ERROR: Module tda8261 is in use
/sbin/rmmod v4l2_common
ERROR: Module v4l2_common is in use by saa7146_vv,videodev
/sbin/rmmod videobuf_core
ERROR: Module videobuf_core is in use by saa7146_vv,videobuf_dma_sg
/sbin/rmmod ir_common
/sbin/rmmod saa7146
ERROR: Module saa7146 is in use by budget_av,saa7146_vv,budget_core
/sbin/rmmod ttpci_eeprom
ERROR: Module ttpci_eeprom is in use by budget_core
/sbin/rmmod budget_av
ERROR: Module budget_av is in use
/sbin/rmmod saa7146_vv
ERROR: Module saa7146_vv is in use by budget_av
/sbin/rmmod videodev
ERROR: Module videodev is in use by saa7146_vv
/sbin/rmmod budget_core
ERROR: Module budget_core is in use by budget_av
/sbin/rmmod videobuf_dma_sg
ERROR: Module videobuf_dma_sg is in use by saa7146_vv
/sbin/rmmod stb0899
ERROR: Module stb0899 is in use
/sbin/rmmod v4l1_compat
ERROR: Module v4l1_compat is in use by saa7146_vv,videodev
/sbin/rmmod dvb_core
ERROR: Module dvb_core is in use by budget_av,budget_core
/sbin/rmmod tda8261
ERROR: Module tda8261 is in use
/sbin/rmmod v4l2_common
ERROR: Module v4l2_common is in use by saa7146_vv,videodev
/sbin/rmmod videobuf_core
ERROR: Module videobuf_core is in use by saa7146_vv,videobuf_dma_sg
/sbin/rmmod saa7146
ERROR: Module saa7146 is in use by budget_av,saa7146_vv,budget_core
/sbin/rmmod ttpci_eeprom
ERROR: Module ttpci_eeprom is in use by budget_core
Couldn't unload: ttpci_eeprom saa7146 videobuf_core v4l2_common tda8261
dvb_core v4l1_compat stb0899 videobuf_dma_sg budget_core videodev
saa7146_vv budget_av
make[1]: Leaving directory `/root/pakete/multiproto/v4l'

===============================================

lsmod after "make rmmod"

budget_av              24192  1
saa7146_vv             45152  2 budget_av
videobuf_dma_sg        12996  1 saa7146_vv
videobuf_core          17252  2 saa7146_vv,videobuf_dma_sg
videodev               26528  2 saa7146_vv
v4l2_common            17216  2 saa7146_vv,videodev
v4l1_compat            12516  2 saa7146_vv,videodev
firmware_class          9504  1 budget_av
budget_core            10756  1 budget_av
dvb_core               79900  2 budget_av,budget_core
saa7146                18248  3 budget_av,saa7146_vv,budget_core
ttpci_eeprom            2432  1 budget_core
ide_cd                 36416  0
cdrom                  32832  1 ide_cd
rtc                    12856  0
pcspkr                  3104  0
intel_agp              23188  1
i2c_i801                8656  0
i2c_core               23552  8
i2c_isa,tda8261,stb0899,budget_av,v4l2_common,budget_core,ttpci_eeprom,i2c_i801

===============================================

lspci:

0000:02:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: KNC One: Unknown device 0018
         Flags: bus master, medium devsel, latency 32, IRQ 19
         Memory at ec049000 (32-bit, non-prefetchable) [size=512]


0000:02:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: Technotrend Systemtechnik GmbH Technotrend-Budget /
Hauppauge WinTV-NOVA-CI DVB card
         Flags: medium devsel, IRQ 16
         Memory at ec04a000 (32-bit, non-prefetchable) [size=512]

