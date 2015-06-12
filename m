Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Andy Walls <awalls@md.metrocast.net>, Hans Verkuil <hans.verkuil@cisco.com>,
 "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
 Boris BREZILLON <boris.brezillon@free-electrons.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
 Scott Jiang <scott.jiang.linux@gmail.com>, Axel Lin <axel.lin@ingics.com>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 03/12] media/i2c/cs5345: Remove compat control ops
Date: Fri, 12 Jun 2015 18:31:09 +0200
Message-id: <1434126678-7978-4-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

They are no longer used in old non-control-framework
bridge drivers.

Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/cs5345.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/i2c/cs5345.c b/drivers/media/i2c/cs5345.c
index 34b76a9e7515..8cebf9cc8007 100644
--- a/drivers/media/i2c/cs5345.c
+++ b/drivers/media/i2c/cs5345.c
@@ -132,13 +132,6 @@ static const struct v4l2_ctrl_ops cs5345_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cs5345_core_ops = {
 	.log_status = cs5345_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cs5345_g_register,
 	.s_register = cs5345_s_register,
-- 
2.1.4
