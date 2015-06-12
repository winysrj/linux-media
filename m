Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v3 09/19] media/i2c/bt819: Implement g_def_ext_ctrls core_op
Date: Fri, 12 Jun 2015 18:46:28 +0200
Message-id: <1434127598-11719-10-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Via control framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/bt819.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 76b334a6a56d..b3e9ac3616b5 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -381,6 +381,7 @@ static const struct v4l2_ctrl_ops bt819_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops bt819_core_ops = {
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.g_def_ext_ctrls = v4l2_subdev_g_def_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
 	.g_ctrl = v4l2_subdev_g_ctrl,
-- 
2.1.4
