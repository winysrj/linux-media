Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.234]:39039 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752579AbdEDAe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 20:34:59 -0400
Received: from cm5.websitewelcome.com (cm5.websitewelcome.com [108.167.139.22])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id F12D511721
        for <linux-media@vger.kernel.org>; Wed,  3 May 2017 19:13:21 -0500 (CDT)
Date: Wed, 3 May 2017 19:13:18 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] media: i2c: initialize scalar variables
Message-ID: <20170504001317.GA11538@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize scalar variables _pid_ and _ver_ to avoid a possible misbehavior.

Addresses-Coverity-ID: 1324239
Addresses-Coverity-ID: 1324240
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/i2c/ov2659.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 6e63672..58615f8 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1308,7 +1308,8 @@ static const struct v4l2_subdev_internal_ops ov2659_subdev_internal_ops = {
 static int ov2659_detect(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	u8 pid, ver;
+	u8 pid = 0;
+	u8 ver = 0;
 	int ret;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
-- 
2.5.0
