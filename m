Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36251 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbbHSPpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 11:45:23 -0400
From: Ravinder Atla <rednivaralat@gmail.com>
To: mchehab@osg.samsung.com
Cc: gregkh@linuxfoundation.org, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mahfouz.saif.elyazal@gmail.com,
	boris.brezillon@free-electrons.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	navyasri.tech@gmail.com, Ravinder Atla <rednivaralat@gmail.com>
Subject: [PATCH] /media/davinci_vpfe/dm365_resizer.c:Bug containing more than 80 characters  in a line is fixed.
Date: Wed, 19 Aug 2015 21:14:56 +0530
Message-Id: <1439999096-3496-1-git-send-email-rednivaralat@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ravinder Atla <rednivaralat@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 6218230..273aea3 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1393,8 +1393,8 @@ resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
  * return -EINVAL or zero on success
  */
 static int resizer_set_format(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg, struct v4l2_subdev_format *
-					fmt)
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
@@ -1454,8 +1454,8 @@ static int resizer_set_format(struct v4l2_subdev *sd,
  * return -EINVAL or zero on success
  */
 static int resizer_get_format(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg, struct v4l2_subdev_format *
-				fmt)
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *format;
 
-- 
1.9.1

