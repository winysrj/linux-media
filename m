Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49562 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaEZTFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:05:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 5/6] v4l: smiapp: Return V4L2_FIELD_NONE from pad-level get/set format
Date: Mon, 26 May 2014 21:06:04 +0200
Message-Id: <1401131165-3542-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SMIA++ sensors are progressive, always return the field order set to
V4L2_FIELD_NONE.

Cc: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 06fb032..c741546 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1554,6 +1554,7 @@ static int __smiapp_get_format(struct v4l2_subdev *subdev,
 		fmt->format.code = __smiapp_get_mbus_code(subdev, fmt->pad);
 		fmt->format.width = r->width;
 		fmt->format.height = r->height;
+		fmt->format.field = V4L2_FIELD_NONE;
 	}
 
 	return 0;
@@ -1687,6 +1688,7 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	fmt->format.code = __smiapp_get_mbus_code(subdev, fmt->pad);
 	fmt->format.width &= ~1;
 	fmt->format.height &= ~1;
+	fmt->format.field = V4L2_FIELD_NONE;
 
 	fmt->format.width =
 		clamp(fmt->format.width,
@@ -2674,6 +2676,7 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 		try_fmt->width = sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
 		try_fmt->height = sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
 		try_fmt->code = mbus_code;
+		try_fmt->field = V4L2_FIELD_NONE;
 
 		try_crop->top = 0;
 		try_crop->left = 0;
-- 
1.8.5.5

