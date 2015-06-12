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
Subject: [PATCH 11/12] pci/ivtv/ivtv-gpio: Remove compat control ops
Date: Fri, 12 Jun 2015 18:31:17 +0200
Message-id: <1434126678-7978-12-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/media/pci/ivtv/ivtv-gpio.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-gpio.c b/drivers/media/pci/ivtv/ivtv-gpio.c
index af52def700cc..f752f3993687 100644
--- a/drivers/media/pci/ivtv/ivtv-gpio.c
+++ b/drivers/media/pci/ivtv/ivtv-gpio.c
@@ -313,13 +313,6 @@ static const struct v4l2_ctrl_ops gpio_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops subdev_core_ops = {
 	.log_status = subdev_log_status,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_tuner_ops subdev_tuner_ops = {
-- 
2.1.4
