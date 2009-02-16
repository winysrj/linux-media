Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxf1.bahnhof.se ([213.80.101.25]:51899 "EHLO mxf1.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZBPWKa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 17:10:30 -0500
Received: from localhost (mxf1.local [127.0.0.1])
	by mxf1-reinject (Postfix) with ESMTP id 901E55C79
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2009 22:46:22 +0100 (CET)
Received: from mxf1.bahnhof.se ([127.0.0.1])
	by localhost (mxf1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IGZEt+kHtf3T for <linux-media@vger.kernel.org>;
	Mon, 16 Feb 2009 22:46:16 +0100 (CET)
Received: from webmail.bahnhof.se (webmail.bahnhof.se [195.178.160.55])
	by mxf1.bahnhof.se (Postfix) with ESMTP id 3EAC25C3F
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2009 22:46:16 +0100 (CET)
Message-ID: <59463.79.136.92.202.1234820777.squirrel@webmail.bahnhof.se>
Date: Mon, 16 Feb 2009 22:46:17 +0100 (CET)
Subject: Tevii S650 DVB-S2 diseqc problem
From: svankan@bahnhof.se
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I just bought a Tevii S650 DVB-S2 card and I have a few questions.

My server have Ubuntu 8.10 amd64 with a custom kernel and drivers and tools
compiled from these sources.
http://mercurial.intuxication.org/hg/szap-s2
http://mercurial.intuxication.org/hg/s2-liplianin/

The scan-s2 utility only find channels from latest used transponder in VDR
and diseqc does not work. It took me many hours to have VDR working with
Tevii S650 because my old diseqc.conf did not work with this card.

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


New diseqc.conf (working with Tevii S650)
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
Why do I need to change the diseqc.conf in VDR?

Because of this problem I have to manually include all HD-channels to
channels.conf. I have tried to follow the README for scan-s2 and tried
different options. My old cards work with scan-s2 and diseqc. To be sure I
downloaded the latest drivers from www.tevii.com and extracted the
firmware from windows drivers but with the same result.
Linux driver is from 2008-08-15
Windows driver is released 2009-01-22

similar problem?
http://www.dvbnetwork.de/viewtopic.php?f=59&t=169

VDR 1.7.4 works very good with the new diseqc.conf so the card is NOT broken.
Any suggestions?

/Svankan

