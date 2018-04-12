Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:47765 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbeDLQvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:51:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] imx274: slightly simplify code
Date: Thu, 12 Apr 2018 18:51:08 +0200
Message-Id: <1523551878-15754-4-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
References: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

imx274_s_frame_interval() already has a direct pointer to the v4l2
exposure control, so reuse it to simplify code.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index dfd04edcdd48..c5d00ade4d64 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -984,7 +984,7 @@ static int imx274_s_frame_interval(struct v4l2_subdev *sd,
 		}
 
 		/* update exposure time accordingly */
-		imx274_set_exposure(imx274, imx274->ctrls.exposure->val);
+		imx274_set_exposure(imx274, ctrl->val);
 
 		dev_dbg(&imx274->client->dev, "set frame interval to %uus\n",
 			fi->interval.numerator * 1000000
-- 
2.7.4
