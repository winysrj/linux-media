Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward17.mail.yandex.net ([95.108.253.142]:40926 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3KBVKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 17:10:34 -0400
Received: from smtp16.mail.yandex.net (smtp16.mail.yandex.net [95.108.252.16])
	by forward17.mail.yandex.net (Yandex) with ESMTP id 1FC0610600AC
	for <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:04:55 +0400 (MSK)
Received: from smtp16.mail.yandex.net (localhost [127.0.0.1])
	by smtp16.mail.yandex.net (Yandex) with ESMTP id 00F016A02F7
	for <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:04:54 +0400 (MSK)
Message-ID: <527568E6.2000600@narod.ru>
Date: Sat, 02 Nov 2013 23:04:38 +0200
From: CrazyCat <crazycat69@narod.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cxd2820r_c: Fix if_ctl calculation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix tune for DVB-C.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 125a440..5c6ab49 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -78,7 +78,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)

  	num = if_freq / 1000; /* Hz => kHz */
  	num *= 0x4000;
-	if_ctl = cxd2820r_div_u64_round_closest(num, 41000);
+	if_ctl = 0x4000 - cxd2820r_div_u64_round_closest(num, 41000);
  	buf[0] = (if_ctl >> 8) & 0x3f;
  	buf[1] = (if_ctl >> 0) & 0xff;


