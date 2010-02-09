Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.crossbone.org ([84.200.212.147]:56936 "EHLO
	ns1.crossbone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab0BIAiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 19:38:11 -0500
Received: from [IPv6:2a01:198:489:0:219:d2ff:fe0b:5e46] (unknown [IPv6:2a01:198:489:0:219:d2ff:fe0b:5e46])
	by ns1.crossbone.org (Postfix) with ESMTPSA id 452351ED0034
	for <linux-media@vger.kernel.org>; Tue,  9 Feb 2010 01:28:39 +0100 (CET)
Subject: Creatix saa7134 card produces lots of glitches.
From: Willem Bleymueller <willem@crossbone.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 01:28:37 +0100
Message-ID: <1265675317.4013.37.camel@zero>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I use a Creatix ctx929 card as dvb-s adapter. 
Whenever I watch tv with it there are lots of glitches.
The card has a TDA10086 tuner and a saa7134 chip. 
I am using kernel 2.6.32.5 at the moment. 

The card is autodetected as card number 93. 
(Medion 7134 Bridge #2) which is possibly right because Creatix made
this card for Medion.

The glitches are no matter of software, I tried vdr, mythtv, dvbstreamer
and I also used szap and cat from /dev/dvb/adapter0/dvr0 to a file. 

When I load the module dvb-core with the options dvb_demux_tscheck=1
dvbdev_debug=1 I see the following in dmesg. PID=0x6e, which is shown in
the last line, was the PID I tuned to.

[14754.455710] TEI detected. PID=0x1a7f data1=0xfa
[14754.455713] TS packet counter mismatch. PID=0x1a7f expected 0x13 got
0xb
[14759.530543] __ratelimit: 7784 callbacks suppressed
[14759.530551] TS packet counter mismatch. PID=0x54 expected 0xc got 0xb
[14759.540640] TS packet counter mismatch. PID=0x456 expected 0x2 got
0x3
[14759.540646] TS packet counter mismatch. PID=0xd2 expected 0xc got 0x8
[14759.540652] TS packet counter mismatch. PID=0x136 expected 0xb got
0x5
[14759.540657] TS packet counter mismatch. PID=0x276 expected 0x4 got
0x7
[14759.540662] TS packet counter mismatch. PID=0x6e expected 0x1 got 0x4

and so on..

Does that mean there is data lost from within the TS stream?
Can anybody tell me what I can do to correct this error (if it was an
error)?

Thanks Willem Bleymueller

