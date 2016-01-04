Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:34952 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbcADBbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2016 20:31:42 -0500
Received: from smtp39.i.mail.ru (smtp39.i.mail.ru [94.100.177.99])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 8B51C663C0F4
	for <linux-media@vger.kernel.org>; Mon,  4 Jan 2016 04:31:32 +0300 (MSK)
From: koshkoshka <andreykosh000@mail.ru>
To: linux-media@vger.kernel.org
Cc: koshkoshka2 <andreykoshkosh@gmail.com>
Subject: [PATCH] 	modified:   drivers/media/tuners/si2157.c fixed frequency range
Date: Mon,  4 Jan 2016 11:31:26 +1000
Message-Id: <1451871086-5696-1-git-send-email-andreykosh000@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: koshkoshka2 <andreykoshkosh@gmail.com>

---
 drivers/media/tuners/si2157.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 0e1ca2b..5da5b42 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -364,8 +364,8 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
 		.name           = "Silicon Labs Si2146/2147/2148/2157/2158",
-		.frequency_min  = 55000000,
-		.frequency_max  = 862000000,
+		.frequency_min  = 42000000,
+		.frequency_max  = 870000000,
 	},
 
 	.init = si2157_init,
-- 
1.9.1

