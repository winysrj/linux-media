Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v2 24/27] media/pci/ivtv/ivtv-gpio: Implement g_def_ext_ctrls
 core_op
Date: Fri, 12 Jun 2015 15:12:18 +0200
Message-id: <1434114742-7420-25-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Via control framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/pci/ivtv/ivtv-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ivtv/ivtv-gpio.c b/drivers/media/pci/ivtv/ivtv-gpio.c
index af52def700cc..d16f210670e2 100644
--- a/drivers/media/pci/ivtv/ivtv-gpio.c
+++ b/drivers/media/pci/ivtv/ivtv-gpio.c
@@ -314,6 +314,7 @@ static const struct v4l2_ctrl_ops gpio_ctrl_ops = {
 static const struct v4l2_subdev_core_ops subdev_core_ops = {
 	.log_status = subdev_log_status,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.g_def_ext_ctrls = v4l2_subdev_g_def_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
 	.g_ctrl = v4l2_subdev_g_ctrl,
-- 
2.1.4
