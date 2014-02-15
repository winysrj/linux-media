Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback6.mail.ru ([94.100.176.134]:51326 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaBOQfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 11:35:38 -0500
Received: from smtp48.i.mail.ru (smtp48.i.mail.ru [94.100.177.108])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 1EB523182DE0
	for <linux-media@vger.kernel.org>; Sat, 15 Feb 2014 20:35:34 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] media: dvb-frontends/stb6100.c: Fix buffer length check
Date: Sat, 15 Feb 2014 20:35:15 +0400
Message-Id: <1392482115-18045-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/dvb-frontends/stb6100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index cea175d..4ef8a5c 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -193,7 +193,7 @@ static int stb6100_write_reg_range(struct stb6100_state *state, u8 buf[], int st
 		.len	= len + 1
 	};
 
-	if (1 + len > sizeof(buf)) {
+	if (1 + len > sizeof(cmdbuf)) {
 		printk(KERN_WARNING
 		       "%s: i2c wr: len=%d is too big!\n",
 		       KBUILD_MODNAME, len);
-- 
1.8.3.2

