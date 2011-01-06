Return-path: <mchehab@gaivota>
Received: from mail-out.m-online.net ([212.18.0.10]:59183 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1AFRhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 12:37:01 -0500
Received: from frontend1.mail.m-online.net (frontend1.mail.intern.m-online.net [192.168.8.180])
	by mail-out.m-online.net (Postfix) with ESMTP id 7BBC2188A192
	for <linux-media@vger.kernel.org>; Thu,  6 Jan 2011 18:36:59 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.8.164])
	by mail.m-online.net (Postfix) with ESMTP id 83B4A1C00295
	for <linux-media@vger.kernel.org>; Thu,  6 Jan 2011 18:36:59 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.8.180])
	by localhost (dynscan1.mail.m-online.net [192.168.8.164]) (amavisd-new, port 10024)
	with ESMTP id uzFrTvjzWsPR for <linux-media@vger.kernel.org>;
	Thu,  6 Jan 2011 18:36:59 +0100 (CET)
Received: from [10.232.2.136] (ppp-88-217-109-45.dynamic.mnet-online.de [88.217.109.45])
	by mail.mnet-online.de (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Thu,  6 Jan 2011 18:36:58 +0100 (CET)
Message-ID: <4D25FDBA.7070407@mulder.franken.de>
Date: Thu, 06 Jan 2011 18:36:58 +0100
From: Michael Meier <poempelfox@mulder.franken.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Corrections to dvb-apps util/scan/dvb-c/de-neftv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The scan config for de-neftv seems to be outdated: It is missing some
channels, and (more importantly) has incorrect settings for some other
channels, as their settings differ a little from the rest [*].
The following patch fixes that (and, at least for me, allows reception
on these channels to finally work).

Signed-off-by: Michael Meier <poempelfox@mulder.franken.de>

[*] src: http://www.herzomedia.de/front_content.php?idcat=126 - This
requires a little explanation: herzomedia is not the same as neftv, but
takes over their signal; neftv itself unfortunately doesn't provide
proper information on symbolrate/qam used, which is why I have to resort
to herzomedia. The 466 MHz transponder is supplemented by herzomedia, it
is not available on neftv - I propose including it anyways, as apart
from the additional channel they are the same.

--- dvb-c/de-neftv.orig      2010-11-16 17:45:00.933069587 +0100
+++ dvb-c/de-neftv   2011-01-06 18:10:37.249569601 +0100
@@ -1,23 +1,34 @@
 # Cable conf for NEFtv
-# (Nuernberg, Erlangen, Fuerth and Herzogenaurach)
+# (Nuernberg, Erlangen, Fuerth and Herzogenaurach (herzomedia))

 # freq sr fec mod
+C 113000000 6900000 NONE QAM64
 C 346000000 6875000 NONE QAM64
 C 354000000 6875000 NONE QAM64
 C 362000000 6875000 NONE QAM64
 C 370000000 6875000 NONE QAM64
 C 378000000 6875000 NONE QAM64
 C 386000000 6875000 NONE QAM64
 C 394000000 6875000 NONE QAM64
 C 402000000 6875000 NONE QAM64
-C 410000000 6875000 NONE QAM64
+C 410000000 6900000 NONE QAM64
 C 418000000 6875000 NONE QAM64
-C 426000000 6875000 NONE QAM64
-C 434000000 6875000 NONE QAM64
-C 450000000 6875000 NONE QAM64
+C 426000000 6900000 NONE QAM64
+C 434000000 6900000 NONE QAM64
+C 442000000 6900000 NONE QAM256
+C 450000000 6900000 NONE QAM256
 C 458000000 6875000 NONE QAM64
+# The following channel is only available in Herzogenaurach
+C 466000000 6900000 NONE QAM64
 C 474000000 6875000 NONE QAM64
 C 490000000 6875000 NONE QAM64
 C 498000000 6875000 NONE QAM64
 C 514000000 6875000 NONE QAM64
+C 522000000 6900000 NONE QAM64
 C 546000000 6875000 NONE QAM64
+C 618000000 6900000 NONE QAM64
+C 634000000 6900000 NONE QAM64
+C 786000000 6900000 NONE QAM256
+C 794000000 6900000 NONE QAM64
+C 802000000 6900000 NONE QAM64
+C 810000000 6900000 NONE QAM64

