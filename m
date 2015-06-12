Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v2 22/27] media/i2c/wm8739: Implement g_def_ext_ctrls core_op
Date: Fri, 12 Jun 2015 15:12:16 +0200
Message-id: <1434114742-7420-23-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Via control framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/wm8739.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/wm8739.c b/drivers/media/i2c/wm8739.c
index 3be73f6a40e9..003c07bee16f 100644
--- a/drivers/media/i2c/wm8739.c
+++ b/drivers/media/i2c/wm8739.c
@@ -177,6 +177,7 @@ static const struct v4l2_ctrl_ops wm8739_ctrl_ops = {
 static const struct v4l2_subdev_core_ops wm8739_core_ops = {
 	.log_status = wm8739_log_status,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.g_def_ext_ctrls = v4l2_subdev_g_def_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
 	.g_ctrl = v4l2_subdev_g_ctrl,
-- 
2.1.4
