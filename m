Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:46569 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756630AbeDXIYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:24:34 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/13] media: imx274: fix typo in comment
Date: Tue, 24 Apr 2018 10:24:07 +0200
Message-Id: <1524558258-530-3-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
References: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>

---
Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 5e425db9204d..dfd04edcdd48 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -971,7 +971,7 @@ static int imx274_s_frame_interval(struct v4l2_subdev *sd,
 	if (!ret) {
 		/*
 		 * exposure time range is decided by frame interval
-		 * need to update it after frame interal changes
+		 * need to update it after frame interval changes
 		 */
 		min = IMX274_MIN_EXPOSURE_TIME;
 		max = fi->interval.numerator * 1000000
-- 
2.7.4
