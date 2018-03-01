Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967178AbeCAKHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 05:07:32 -0500
Date: Thu, 1 Mar 2018 13:07:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: ov5695: Off by one in ov5695_enum_frame_sizes()
Message-ID: <20180301100714.GA14140@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ">" should be ">=" so that we don't read one element beyond the end
of the array.

Fixes: 8a77009be4be ("media: ov5695: add support for OV5695 sensor")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/ov5695.c b/drivers/media/i2c/ov5695.c
index a4985a4715f5..9be38a0a2046 100644
--- a/drivers/media/i2c/ov5695.c
+++ b/drivers/media/i2c/ov5695.c
@@ -884,7 +884,7 @@ static int ov5695_enum_frame_sizes(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index > ARRAY_SIZE(supported_modes))
+	if (fse->index >= ARRAY_SIZE(supported_modes))
 		return -EINVAL;
 
 	if (fse->code != MEDIA_BUS_FMT_SBGGR10_1X10)
