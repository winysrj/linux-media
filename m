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
Subject: [PATCH 06/12] media/i2c/tda7432: Remove compat control ops
Date: Fri, 12 Jun 2015 18:31:12 +0200
Message-id: <1434126678-7978-7-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/media/i2c/tda7432.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index cf93021a6500..d3834a4c48da 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -331,13 +331,6 @@ static const struct v4l2_ctrl_ops tda7432_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tda7432_core_ops = {
 	.log_status = tda7432_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_ops tda7432_ops = {
-- 
2.1.4
