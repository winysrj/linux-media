Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:51347 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233Ab0LNNFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 08:05:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PSUYz-0000h6-TT
	for linux-media@vger.kernel.org; Tue, 14 Dec 2010 14:05:05 +0100
Received: from host109-7-dynamic.54-79-r.retail.telecomitalia.it ([79.54.7.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 14:05:05 +0100
Received: from jjjanez by host109-7-dynamic.54-79-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 14:05:05 +0100
To: linux-media@vger.kernel.org
From: Janez <jjjanez@alice.it>
Subject: Terratec Cinergy HT MKII has a VHF problem.
Date: Tue, 14 Dec 2010 12:58:11 +0000 (UTC)
Message-ID: <loom.20101214T135629-694@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>>>

I think I found a bug in the "Terratec Cinergy HT PCI MKII."
The card basically works, but the DVB stations in the VHF band have a problem.
I can watch them (with xine or me-TV) or scan them only after a reboot, because
if I change to a UHF station and then I re-tune to the previous VHF station, it
doesn't work anymore.
Here what happens with scandvb:

[janez@athlon650 ~]$ cat rai
T 177500000 7MHz 3/4 NONE QAM64 8k 1/32 NONE
[janez@athlon650 ~]$ cat med
T 698000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
[janez@athlon650 ~]$ scandvb rai
scanning rai
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 177500000 1 3 9 3 1 0 0
>>> tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x0000 0x0d49: pmt_pid 0x0102 RAI -- Rai 1 (running)
0x0000 0x0d4a: pmt_pid 0x0101 RAI -- Rai 2 (running)
0x0000 0x0d4b: pmt_pid 0x0100 RAI -- Rai 3 TGR Veneto (running)
0x0000 0x0d53: pmt_pid 0x0118 RAI -- Rai News (running)
0x0000 0x0d4c: pmt_pid 0x0103 Rai -- Rai Radio1 (running)
0x0000 0x0d4d: pmt_pid 0x0104 Rai -- Rai Radio2 (running)
0x0000 0x0d4e: pmt_pid 0x0105 Rai -- Rai Radio3 (running)
Network Name 'Rai'
>>> tune to:
1600000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22
Invalid argument
>>> tune to:
1600000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22
Invalid argument
dumping lists (7 services)
Rai 1:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:512:650:3401
Rai 2:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:513:651:3402
Rai 3 TGR Veneto:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:514:652:3403
Rai News:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:520:690:3411
Rai Radio1:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:653:3404
Rai Radio2:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:654:3405
Rai Radio3:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:655:3406
Done.
[janez@athlon650 ~]$ scandvb med
scanning med
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 698000000 0 2 9 3 1 0 0
>>> tune to:
698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x0000 0x0001: pmt_pid 0x0065 (null) -- Servizio OTA  (running)
0x0000 0x03ec: pmt_pid 0x0101 (null) -- Servizio4 (running)
0x0000 0x03ed: pmt_pid 0x0105 (null) -- Servizio5 (running)
0x0000 0x03ee: pmt_pid 0x0106 (null) -- Servizio6 (running)
0x0000 0x03ef: pmt_pid 0x0107 (null) -- Servizio7 (running)
0x0000 0x03f0: pmt_pid 0x0108 (null) -- Servizio8 (running)
0x0000 0x03f1: pmt_pid 0x0109 (null) -- Servizio9 (running)
0x0000 0x03f2: pmt_pid 0x010a (null) -- Servizio10 (running)
0x0000 0x03f3: pmt_pid 0x010b (null) -- Servizio11 (running)
0x0000 0x03f4: pmt_pid 0x010c (null) -- Servizio12 (running)
0x0000 0x0fa4: pmt_pid 0x00cc Mediaset -- Rete4 (running)
0x0000 0x0fa5: pmt_pid 0x00cd Mediaset -- Canale5 (running)
0x0000 0x0fa6: pmt_pid 0x00ce Mediaset -- Italia1 (running)
0x0000 0x0fab: pmt_pid 0x00d3 Mediaset -- Mediaset Extra (running)
0x0000 0x0fad: pmt_pid 0x00d5 Mediaset -- La 5 (running)
Network Name 'Mediaset4'
dumping lists (15 services)
Servizio OTA:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1
Servizio4:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1004
Servizio5:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1005
Servizio6:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1006
Servizio7:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1007
Servizio8:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1008
Servizio9:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1009
Servizio10:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1010
Servizio11:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1011
Servizio12:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1012
Rete4:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1630:1631:4004
Canale5:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1610:1611:4005
Italia1:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1620:1621:4006
Mediaset Extra:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1760:1761:4011
La 5:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1730:1731:4013
Done.
[janez@athlon650 ~]$ scandvb rai
scanning rai
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 177500000 1 3 9 3 1 0 0
>>> tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0010
dumping lists (7 services)
[0d49]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:512:650:3401
[0d4a]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:513:651:3402
[0d4b]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:514:652:3403
[0d53]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:520:690:3411
[0d4c]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:653:3404
[0d4d]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:654:3405
[0d4e]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:
QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:655:3406
Done.
[janez@athlon650 ~]$

As you can see the second time the scanning of that frequency doesn't work
anymore. It will work again only after a reboot!

There is the same behaviour with me-TV. I cannot watch the VHF stations if I
watched (or scanned) a UHF station before.

The card works in Windows XP (the VHF stations too). So it is not an hardware
problem.

PS: There is another problem with "Rai 3 TGR Veneto", I cannot see anything,
only the audio works (only after a reboot, of course).

