Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:43560 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab1DWUz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 16:55:59 -0400
Message-ID: <4DB33CBF.6010003@usa.net>
Date: Sat, 23 Apr 2011 22:55:27 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: tuxoholic@hotmail.de, Manu Abraham <abraham.manu@gmail.com>
Subject: stb0899/stb6100 tuning problems
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Running kernel 2.6.39rc4. I've got trouble with tuning some transponders
on Hotbird 13°E with a TT S2-3200.
The transponders have been emitting DVB-S until end of march when they
now emit DVB-S2 signals. They are:
- 11681.00H 27500 3/4 8psk nid:319 tid:15900 on Hotbird 6
- 12692.00H 27500 3/4 8psk nid:319 tid:9900 on Hotbird 9


[1] https://patchwork.kernel.org/patch/244201/
[2] http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html

1) Patch [2] is merged into kernel 2.6.39rc4. Using scan-s2, I get no
service available.

2) I applied patch [1] and still could not get any service with scan-s2
from those transponders.

3) I *reverted* patch[2] and now scan-s2 returns partial results.
scan-s2 can tune onto the transponder on Hotbird 6 really quick and
gives back the full services list.
But I have to run scan-s2 with scan iterations count set to as high as
100 to be able to get results from the transponder on Hotbird 9.

When those transponders were emitting in DVB-S, I had no problem at all.

Can someone try the same thing on those transponders and report please ?

Thx
--
Issa
