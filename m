Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.181.169]:43679 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992581AbcB0Xe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 18:34:59 -0500
From: andreykosh000@mail.ru
To: crope@iki.fi
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrei Koshkosh <andreykosh000@mail.ru>
Subject: [PATCH] Fixed frequency range for Si2157 tuner to 42-870 MHz
Date: Sun, 28 Feb 2016 09:24:58 +1000
Message-Id: <1456615498-2261-1-git-send-email-andreykosh000@mail.ru>
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

