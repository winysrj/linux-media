Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64349 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaJZMFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 08:05:40 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj1so162577pad.15
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 05:05:39 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] dvb:tc90522: bugfix of always-false expression
Date: Sun, 26 Oct 2014 21:05:29 +0900
Message-Id: <1414325129-16570-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Reported by David Binderman
---
 drivers/media/dvb-frontends/tc90522.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index d9905fb..bca81ef 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -363,7 +363,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 		u8 v;
 
 		c->isdbt_partial_reception = val[0] & 0x01;
-		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x01;
+		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x40;
 
 		/* layer A */
 		v = (val[2] & 0x78) >> 3;
-- 
2.1.2

