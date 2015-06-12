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
Subject: [PATCH 08/12] media/i2c/tvp514x: Remove compat control ops
Date: Fri, 12 Jun 2015 18:31:14 +0200
Message-id: <1434126678-7978-9-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/media/i2c/tvp514x.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 24e47279e30c..a93985a9b070 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -957,16 +957,6 @@ static int tvp514x_set_pad_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-};
-
 static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.s_std = tvp514x_s_std,
 	.s_routing = tvp514x_s_routing,
@@ -983,7 +973,6 @@ static const struct v4l2_subdev_pad_ops tvp514x_pad_ops = {
 };
 
 static const struct v4l2_subdev_ops tvp514x_ops = {
-	.core = &tvp514x_core_ops,
 	.video = &tvp514x_video_ops,
 	.pad = &tvp514x_pad_ops,
 };
-- 
2.1.4
