Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43124 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3K2XBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 18:01:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH] v4l: vs6624: Fix warning due to unused function
Date: Sat, 30 Nov 2013 00:01:34 +0100
Message-Id: <1385766094-29621-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vs6624_read() is only called in the conditionally-compiled
vs6624_g_register() function. Make the former conditionally-compiled as
well to silence build warnings.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/vs6624.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 25bdd93..23f4f65 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -503,6 +503,7 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 	return &container_of(ctrl->handler, struct vs6624, hdl)->sd;
 }
 
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vs6624_read(struct v4l2_subdev *sd, u16 index)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -515,6 +516,7 @@ static int vs6624_read(struct v4l2_subdev *sd, u16 index)
 
 	return buf[0];
 }
+#endif
 
 static int vs6624_write(struct v4l2_subdev *sd, u16 index,
 				u8 value)
-- 
1.8.3.2

