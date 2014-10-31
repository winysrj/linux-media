Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63517 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789AbaJaNWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:22:04 -0400
Received: by mail-pd0-f174.google.com with SMTP id p10so7214354pdj.5
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:22:03 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2] dvb:tc90522: fix always-false expression
Date: Fri, 31 Oct 2014 22:21:50 +0900
Message-Id: <1414761710-1409-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
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
2.1.3

