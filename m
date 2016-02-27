Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback5.mail.ru ([94.100.181.253]:39414 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992667AbcB0XWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 18:22:46 -0500
Received: from smtp29.i.mail.ru (smtp29.i.mail.ru [94.100.177.89])
	by fallback5.mail.ru (mPOP.Fallback_MX) with ESMTP id 80486A77F126
	for <linux-media@vger.kernel.org>; Sun, 28 Feb 2016 02:22:43 +0300 (MSK)
From: andreykosh000@mail.ru
To: linux-media@vger.kernel.org
Cc: Andrei Koshkosh <andreykosh000@mail.ru>
Subject: [PATCH] Fixed frequency range for Si2157 tuner to 42-870 MHz
Date: Sun, 28 Feb 2016 09:22:28 +1000
Message-Id: <1456615348-2216-1-git-send-email-andreykosh000@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrei Koshkosh <andreykosh000@mail.ru>

Signed-off-by: Andrei Koshkosh <andreykosh000@mail.ru>

	modified:   drivers/media/tuners/si2157.c
This tuner supports frequency range from 42MHz to 870MHz
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

