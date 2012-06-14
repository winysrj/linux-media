Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out.abv.bg ([194.153.145.70]:54017 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2FNTkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 15:40:35 -0400
Received: from nm23.abv.bg (nm23.ni.bg [192.168.151.172])
	by smtp-out.abv.bg (Postfix) with ESMTP id 5561450DA21
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 22:33:06 +0300 (EEST)
Received: from nm23.abv.bg (localhost.localdomain [127.0.0.1])
	by nm23.abv.bg (Postfix) with ESMTP id 4D28C239D4C
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 22:33:06 +0300 (EEST)
Date: Thu, 14 Jun 2012 22:33:06 +0300 (EEST)
From: "N. D." <named2@abv.bg>
To: linux-media@vger.kernel.org
Message-ID: <1560501507.509941.1339702386314.JavaMail.apache@nm23.abv.bg>
Subject: stv090x: possible bug with 8psk,fec=5/6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I own a Skystar USB HD which I use with vdr. Ever since I bought the card I have been having some strange issues with 11817V on Astra 23.5E. Femon reports that there is a lock and sound comes but the image is completely garbled. The same setup (Kernel: 3.3.8, VDR: 1.7.27) works fine with an HVR-4000. So I started to suspect that there might be something wrong with the driver. Trying to find out some more information I came across this forum:
http://rickcaylor.websitetoolbox.com/post/stv0900_core.c-patch-5481028
I tried the patch which is supposed to (among other things) make the tuner lock on high bitrate transponders (>60Mbps). But it did not help.
So using the stock driver I gave dvbsnoop a whirl to see if there was something amiss.

Astra 3B 11817.00 V DVB-S2 8PSK 27500 5/6 66.6 Mbps

packets read: 122/(343292)   d_time:  0.001 s  = 183488.000 kbit/s   (Avrg: 66142.860 kbit/s) [bad: 2]
packets read:  42/(343334)   d_time:  0.001 s  = 63168.000 kbit/s   (Avrg: 66150.953 kbit/s) [bad: 0]
packets read:  38/(343372)   d_time:  0.001 s  = 57152.000 kbit/s   (Avrg: 66158.274 kbit/s) [bad: 2]
packets read:  34/(343406)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 66164.825 kbit/s) [bad: 1]
packets read:  35/(343441)   d_time:  0.001 s  = 52640.000 kbit/s   (Avrg: 66171.569 kbit/s) [bad: 2]
packets read:  31/(343472)   d_time:  0.001 s  = 46624.000 kbit/s   (Avrg: 66177.541 kbit/s) [bad: 4]
packets read:  16/(343488)   d_time:  0.001 s  = 24064.000 kbit/s   (Avrg: 66180.624 kbit/s) [bad: 0]
packets read:  29/(343517)   d_time:  0.008 s  =  5452.000 kbit/s   (Avrg: 66118.450 kbit/s) [bad: 1]
packets read: 116/(343633)   d_time:  0.001 s  = 174464.000 kbit/s   (Avrg: 66140.777 kbit/s) [bad: 1]
packets read:  38/(343671)   d_time:  0.001 s  = 57152.000 kbit/s   (Avrg: 66148.091 kbit/s) [bad: 1]
packets read:  34/(343705)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 66154.635 kbit/s) [bad: 1]
packets read:  30/(343735)   d_time:  0.001 s  = 45120.000 kbit/s   (Avrg: 66160.410 kbit/s) [bad: 0]
packets read:  37/(343772)   d_time:  0.001 s  = 55648.000 kbit/s   (Avrg: 66167.531 kbit/s) [bad: 2]
packets read:  38/(343810)   d_time:  0.001 s  = 57152.000 kbit/s   (Avrg: 66174.845 kbit/s) [bad: 1]
packets read:  30/(343840)   d_time:  0.001 s  = 45120.000 kbit/s   (Avrg: 66180.619 kbit/s) [bad: 0]

Then I experimented with a lot of other transponders and found another one with the same behavior.

HotBird 13C 11411.00 H DVB-S2 8PSK 27500 5/6 68.2 Mbps

packets read:  40/(259860)   d_time:  0.001 s  = 60160.000 kbit/s   (Avrg: 65498.482 kbit/s) [bad: 0]
packets read:  39/(259899)   d_time:  0.001 s  = 58656.000 kbit/s   (Avrg: 65508.312 kbit/s) [bad: 0]
packets read:  34/(259933)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 65516.882 kbit/s) [bad: 1]
packets read:  34/(259967)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 65525.451 kbit/s) [bad: 0]
packets read:  36/(260003)   d_time:  0.001 s  = 54144.000 kbit/s   (Avrg: 65534.525 kbit/s) [bad: 2]
packets read:  11/(260014)   d_time:  0.001 s  = 16544.000 kbit/s   (Avrg: 65537.298 kbit/s) [bad: 1]
packets read: 349/(260363)   d_time:  0.008 s  = 65612.000 kbit/s   (Avrg: 65537.398 kbit/s) [bad: 7]
packets read:  25/(260388)   d_time:  0.008 s  =  4700.000 kbit/s   (Avrg: 65456.051 kbit/s) [bad: 0]
packets read: 129/(260517)   d_time:  0.001 s  = 194016.000 kbit/s   (Avrg: 65488.479 kbit/s) [bad: 2]
packets read:  35/(260552)   d_time:  0.001 s  = 52640.000 kbit/s   (Avrg: 65497.277 kbit/s) [bad: 0]
packets read:  37/(260589)   d_time:  0.001 s  = 55648.000 kbit/s   (Avrg: 65506.578 kbit/s) [bad: 2]
packets read:  34/(260623)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 65515.125 kbit/s) [bad: 2]
packets read:  36/(260659)   d_time:  0.001 s  = 54144.000 kbit/s   (Avrg: 65524.174 kbit/s) [bad: 3]
packets read:  34/(260693)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 65532.721 kbit/s) [bad: 0]
packets read:  21/(260714)   d_time:  0.001 s  = 31584.000 kbit/s   (Avrg: 65538.000 kbit/s) [bad: 0]

Both of these are 8psk 5/6 and have an average bitrate of over 65Mbps. The high bitrate per se could not explain what is wrong because there are a number of ~65Mbps transponders on Hotbird which are OK.

For example:

HotBird 13B 11785.00 H DVB-S2 8PSK 29900 3/4 65.1 Mbps

packets read:  33/(434934)   d_time:  0.001 s  = 49632.000 kbit/s   (Avrg: 65101.586 kbit/s) [bad: 0]
packets read:  38/(434972)   d_time:  0.001 s  = 57152.000 kbit/s   (Avrg: 65107.274 kbit/s) [bad: 0]
packets read:  34/(435006)   d_time:  0.001 s  = 51136.000 kbit/s   (Avrg: 65112.363 kbit/s) [bad: 0]
packets read:  36/(435042)   d_time:  0.001 s  = 54144.000 kbit/s   (Avrg: 65117.752 kbit/s) [bad: 0]
packets read:  17/(435059)   d_time:  0.001 s  = 25568.000 kbit/s   (Avrg: 65120.296 kbit/s) [bad: 0]
packets read:  32/(435091)   d_time:  0.007 s  =  6875.429 kbit/s   (Avrg: 65079.748 kbit/s) [bad: 0]
packets read: 122/(435213)   d_time:  0.001 s  = 183488.000 kbit/s   (Avrg: 65091.523 kbit/s) [bad: 0]
packets read:  38/(435251)   d_time:  0.001 s  = 57152.000 kbit/s   (Avrg: 65097.206 kbit/s) [bad: 0]
packets read:  36/(435287)   d_time:  0.001 s  = 54144.000 kbit/s   (Avrg: 65102.590 kbit/s) [bad: 0]
packets read:  36/(435323)   d_time:  0.001 s  = 54144.000 kbit/s   (Avrg: 65107.975 kbit/s) [bad: 0]
packets read:  35/(435358)   d_time:  0.001 s  = 52640.000 kbit/s   (Avrg: 65113.209 kbit/s) [bad: 0]
packets read:  36/(435394)   d_time:  0.001 s  = 54144.000 kbit/s   (Avrg: 65118.593 kbit/s) [bad: 0]
packets read:   8/(435402)   d_time:  0.001 s  = 12032.000 kbit/s   (Avrg: 65119.790 kbit/s) [bad: 0]
packets read: 348/(435750)   d_time:  0.008 s  = 65424.000 kbit/s   (Avrg: 65120.032 kbit/s) [bad: 0]
packets read: 344/(436094)   d_time:  0.008 s  = 64672.000 kbit/s   (Avrg: 65119.676 kbit/s) [bad: 0]

The only difference is in the code rate: 3/4 v 5/6. I also tried some DVB-S qpsk 5/6 transponders but none of them had such a high bitrate. So it seems to me that either my hardware is faulty or the combination of 8psk, fec 5/6 (and possibly the high bitrate) is triggering some bug in the driver.
I hope someone more knowledgeable could chime in and shed more light.


-----------------------------------------------------------------
Гражданска отговорност – Цените на компаниите
http://www.sdi.bg/onlineInsurance/?utm_source=gbg&utm_medium=txtLink&utm_content=home
