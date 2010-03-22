Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754490Ab0CVLSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 07:18:04 -0400
From: "Bjoern Wuest" <bjoern.wuest@gmx.net>
To: <linux-media@vger.kernel.org>
Subject: WG: Tuning very unreliable (Technisat Skystar HD2)
Date: Mon, 22 Mar 2010 12:17:58 +0100
Message-ID: <3E43F9EB62D448E19BAC00632092C0AB@gskv.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello alltogether,


I am in the process of switching my home entertainment system from Windows
to Linux. The distro of choice is OpenSuse 11.2 . Ultimately, I want to run
MythTV with XFCE on it.

My TV cards are two pieces of Technisat Skystar HD2. In Windows, my hardware
works just fine. Yet, in Linux I have problems that I cannot explain to
myself.

I have downloaded the latest s2-liplianin drivers, compiled and installed
them (make && make install). Then I downloaded and installed scan-s2 from
the repository (make). I did this all yesterday night, with cloudy skies and
some rain. While scanning with scan-s2 –o zap dvb-s/Astra-19.2E I could fine
a number of channels, yet I did not save the channel list. As it was quite
late, I decided to shutdown the PC and continue this morning. However, now I
just get the following response from scan-s2 – under blue sky and clear
view:

media-pc-wz:~/tv/scan-s2 # ./scan-s2 -o zap dvb-s/Astra-19.2E
API major 5, minor 1
scanning dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder DVB-S  12551500 V 22000000 5/6 AUTO AUTO
initial transponder DVB-S2 12551500 V 22000000 5/6 AUTO AUTO
----------------------------------> Using DVB-S
>>> tune to: 12551:v:0:22000
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
>>> tune to: 12551:v:0:22000 (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
----------------------------------> Using DVB-S2
>>> tune to: 12551:v:0:22000
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
>>> tune to: 12551:v:0:22000 (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


My TV cards are detected (lspci-output):

03:05.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at fdfff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis

03:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdffe000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis

The only change on my system since yesterday evening, where it worked, was a
“shutdown –h now”, pressing the power switch this morning and logging in
with my username and password. Nothing else happened.


Mit besten Grüßen / Kind regards,
Bjoern Wuest


