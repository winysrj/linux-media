Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp28.orange.fr ([80.12.242.100]:26731 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbZFVQcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 12:32:07 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2808.orange.fr (SMTP Server) with ESMTP id C11AF70000A4
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 18:32:04 +0200 (CEST)
Received: from [192.168.1.10] (AMontsouris-153-1-34-115.w90-2.abo.wanadoo.fr [90.2.137.115])
	by mwinf2808.orange.fr (SMTP Server) with ESMTP id 9502370000A3
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 18:32:04 +0200 (CEST)
Message-ID: <4A3FB1FE.3080902@orange.fr>
Date: Mon, 22 Jun 2009 18:31:58 +0200
From: claude <claude.vezzi@orange.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: pxdvr3200 scan failed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have upgraded my dvb-t card to a leadtek pxdvr3200 but unfortunatly
scan always fails

i use a 2.6.30 amd64 kernel

with kaffeine 0.8.7  (when tuned: signal 56% snr 88%)

Using DVB device 0:0 "Zarlink ZL10353 DVB-T"
tuning DVB-T to 586000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
.... LOCKED.
Transponders: 23/57
scanMode=0
it's dvb 2!

Invalid section length or timeout: pid=17


Invalid section length or timeout: pid=0

Frontend closed
............................

with scan

scan -v -f 0 -t 1 paris-tnt.txt
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 474166000 0 2 9 3 1 0 0
initial transponder 498166000 0 2 9 3 1 0 0
initial transponder 522166000 0 2 9 3 1 0 0
initial transponder 538166000 0 2 9 3 1 0 0
initial transponder 562166000 0 2 9 3 1 0 0
initial transponder 586166000 0 3 9 3 1 2 0
initial transponder 714166000 0 3 9 3 1 2 0
initial transponder 738166000 0 2 9 3 1 0 0
initial transponder 754166000 0 2 9 3 1 0 0
initial transponder 762166000 0 2 9 3 1 0 0
initial transponder 786166000 0 2 9 3 1 0 0
initial transponder 810166000 0 2 9 3 1 0 0
 >>> tune to:
474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
 >>> tuning status == 0x00
 >>> tuning status == 0x1e
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
...............

Each time i do a scan kernel logs

Jun 20 18:46:03 reppe kernel: xc2028 1-0061: Loading 80 firmware images
from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Jun 20 18:46:04 reppe kernel: xc2028 1-0061: Loading firmware for
type=BASE F8MHZ (3), id 0000000000000000.
Jun 20 18:46:05 reppe kernel: xc2028 1-0061: Loading firmware for
type=D2633 DTV7 (90), id 0000000000000000.
Jun 20 18:46:05 reppe kernel: xc2028 1-0061: Loading SCODE for type=DTV6
QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id
0000000000000000.
Jun 20 18:46:22 reppe kernel: xc2028 1-0061: Loading firmware for
type=D2633 DTV78 (110), id 0000000000000000.
Jun 20 18:46:22 reppe kernel: xc2028 1-0061: Loading SCODE for type=DTV6
QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id
0000000000000000.
Jun 20 18:46:34 reppe kernel: xc2028 1-0061: Loading firmware for
type=BASE F8MHZ (3), id 0000000000000000.
Jun 20 18:46:35 reppe kernel: xc2028 1-0061: Loading firmware for
type=D2633 DTV78 (110), id 0000000000000000.
Jun 20 18:46:35 reppe kernel: xc2028 1-0061: Loading SCODE for type=DTV6
QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id
0000000000000000.



