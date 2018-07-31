Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48814 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729723AbeGaPOI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 11:14:08 -0400
From: Colin King <colin.king@canonical.com>
To: Jacopo Mondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: i2c: mt9v111: fix off-by-one array bounds check 
Date: Tue, 31 Jul 2018 14:33:43 +0100
Message-Id: <20180731133343.22337-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check of fse->index is off-by-one and should be using >= rather
than > to check the maximum allowed array index. Fix this.

Detected by CoverityScan, CID#172122 ("Out-of-bounds read")

Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/mt9v111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
index da8f6ab91307..b1d13f1d695e 100644
--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -848,7 +848,7 @@ static int mt9v111_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->pad || fse->index > ARRAY_SIZE(mt9v111_frame_sizes))
+	if (fse->pad || fse->index >= ARRAY_SIZE(mt9v111_frame_sizes))
 		return -EINVAL;
 
 	fse->min_width = mt9v111_frame_sizes[fse->index].width;
-- 
2.17.1
