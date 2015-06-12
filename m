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
Subject: [PATCH 12/12] media/radio/saa7706h: Remove compat control ops
Date: Fri, 12 Jun 2015 18:31:18 +0200
Message-id: <1434126678-7978-13-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/media/radio/saa7706h.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index ec805b09c608..183e92719140 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -336,19 +336,7 @@ static const struct v4l2_ctrl_ops saa7706h_ctrl_ops = {
 	.s_ctrl = saa7706h_s_ctrl,
 };
 
-static const struct v4l2_subdev_core_ops saa7706h_core_ops = {
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-};
-
-static const struct v4l2_subdev_ops saa7706h_ops = {
-	.core = &saa7706h_core_ops,
-};
+static const struct v4l2_subdev_ops empty_ops = {};
 
 /*
  * Generic i2c probe
@@ -373,7 +361,7 @@ static int saa7706h_probe(struct i2c_client *client,
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
-	v4l2_i2c_subdev_init(sd, client, &saa7706h_ops);
+	v4l2_i2c_subdev_init(sd, client, &empty_ops);
 
 	v4l2_ctrl_handler_init(&state->hdl, 4);
 	v4l2_ctrl_new_std(&state->hdl, &saa7706h_ctrl_ops,
-- 
2.1.4
