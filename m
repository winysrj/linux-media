Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36703 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaHHNdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 09:33:01 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so6957542pdj.8
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 06:33:00 -0700 (PDT)
Message-ID: <1407504776.5615.2.camel@phoenix>
Subject: [PATCH] [media] tda7432: Fix setting TDA7432_MUTE bit for
 TDA7432_RF register
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Date: Fri, 08 Aug 2014 21:32:56 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a copy-paste bug when converting to the control framework.

Fixes: commit 5d478e0de871 ("[media] tda7432: convert to the control framework")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/tda7432.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index 72af644..cf93021 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -293,7 +293,7 @@ static int tda7432_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (t->mute->val) {
 			lf |= TDA7432_MUTE;
 			lr |= TDA7432_MUTE;
-			lf |= TDA7432_MUTE;
+			rf |= TDA7432_MUTE;
 			rr |= TDA7432_MUTE;
 		}
 		/* Mute & update balance*/
-- 
1.9.1



