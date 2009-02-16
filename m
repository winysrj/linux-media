Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.bahnhof.se ([213.80.101.12]:56819 "EHLO mx2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZBPVyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 16:54:25 -0500
From: Magnus Andersson <maan@svankan2.mine.nu>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Tevii S650 DVB-S2 diseqc problem
Date: Mon, 16 Feb 2009 22:34:32 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902162234.32309.maan@svankan2.mine.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I just bought a Tevii S650 DVB-S2 card and I have a few questions.

My server have Ubuntu 8.10 amd64 with a custom kernel and drivers and tools 
compiled from these sources. 
http://mercurial.intuxication.org/hg/szap-s2
http://mercurial.intuxication.org/hg/s2-liplianin/

The scan-s2 utility only find channels from latest used transponder in vdr. It 
took me many hours to have vdr working with Tevii S650 because my old 
diseqc.conf did not work with this card.

When I have a skystar2 or a Hauppauge FF rev 2.1 I can use this config.

Old diseqc.conf
#
S1W 11700 V 9750 t v W15 A W15 t
S1W 99999 V 10600 t v W15 A W15 T
S1W 11700 H 9750 t V W15 A W15 t
S1W 99999 H 10600 t V W15 A W15 T
#
S5E 11700 V 9750 t v W15 B W15 t
S5E 99999 V 10600 t v W15 B W15 T
S5E 11700 H 9750 t V W15 B W15 t
S5E 99999 H 10600 t V W15 B W15 T


New diseqc.conf
#
S1W 11700 V 9750 t v W15 [E0 10 38 F0] W15 t
S1W 99999 V 10600 t v W15 [E0 10 38 F1] W15 T
S1W 11700 H 9750 t V W15 [E0 10 38 F2] W15 t
S1W 99999 H 10600 t V W15 [E0 10 38 F3] W15 T
#
S5E 11700 V 9750 t v W15 [E0 10 38 F4] W15 t
S5E 99999 V 10600 t v W15 [E0 10 38 F5] W15 T
S5E 11700 H 9750 t V W15 [E0 10 38 F6] W15 t
S5E 99999 H 10600 t V W15 [E0 10 38 F7] W15 T

Can this diseqc “problem” cause the scan-s2 tool to fail too?
Why do I need to change the diseqc.conf in vdr? 

Because of this problem I have to manually include all HD-channels to 
channels.conf.
 I have tried to follow the README for scan-s2 and tried different options. My 
old cards work with scan and diseqc. To be sure I downloaded the latest 
drivers from www.tevii.com and extracted the firmware from windows drivers but 
with the same result.
Linux driver is from 2008-08-15
Windows driver is released 2009-01-22

similar problem?
http://www.dvbnetwork.de/viewtopic.php?f=59&t=169
Any suggestions?

VDR 1.7.4 works very good with the new diseqc.conf so the card is NOT broken.

/Svankan
