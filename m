Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:44466 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592AbcAKKKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 05:10:07 -0500
Received: from smtp48.i.mail.ru (smtp48.i.mail.ru [94.100.177.108])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 3CE40671A067
	for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 12:42:07 +0300 (MSK)
From: andreykosh000@mail.ru
To: linux-media@vger.kernel.org
Cc: koshkoshka <andreykosh000@mail.ru>
Subject: [PATCH] Fixed frequency range to 42-870 MHz
Date: Mon, 11 Jan 2016 19:42:00 +1000
Message-Id: <1452505320-10498-1-git-send-email-andreykosh000@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: koshkoshka <andreykosh000@mail.ru>

Signed-off-by: koshkoshka <andreykosh000@mail.ru>

	modified:   drivers/media/tuners/si2157.c
---
 drivers/media/tuners/si2157.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index ce157ed..86a753e 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -363,8 +363,8 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
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

