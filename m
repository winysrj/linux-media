Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50654 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031968AbdAEMeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 07:34:22 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OJB00II4498O240@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jan 2017 12:34:20 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org, s.nawrocki@samsung.com
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Binderman <dcb314@hotmail.com>
Subject: [PATCH] v4l: s5c73m3: fix negation operator
Date: Thu, 05 Jan 2017 13:34:07 +0100
Message-id: <1483619647-11753-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <VI1PR08MB1022D94ED6D0C8252129B96F9C600@VI1PR08MB1022.eurprd08.prod.outlook.com>
References: <VI1PR08MB1022D94ED6D0C8252129B96F9C600@VI1PR08MB1022.eurprd08.prod.outlook.com>
 <CGME20170105123418eucas1p1a71a62cac9e538fa2997a8db8772d249@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bool values should be negated using logical operators. Using bitwise operators
results in unexpected and possibly incorrect results.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
index 0a06033..2e71850 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
@@ -211,7 +211,7 @@ static int s5c73m3_3a_lock(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
 	}
 
 	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_FOCUS)
-		ret = s5c73m3_af_run(state, ~af_lock);
+		ret = s5c73m3_af_run(state, !af_lock);
 
 	return ret;
 }
-- 
2.7.4

