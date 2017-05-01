Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50456 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425014AbdEAEUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:20:23 -0400
From: Petr Cvek <petr.cvek@tul.cz>
Subject: [PATCH 3/4] [media] pxa_camera: Add (un)subscribe_event ioctl
To: robert.jarzmik@free.fr
References: <cover.1493612057.git.petr.cvek@tul.cz>
Cc: linux-media@vger.kernel.org
Message-ID: <0c2bf711-dbdf-f384-fc6f-4e7f5ed964b1@tul.cz>
Date: Mon, 1 May 2017 06:21:29 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1493612057.git.petr.cvek@tul.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2-compliance complains about nonexistent vidioc_subscribe_event
and vidioc_unsubscribe_event calls. Add them to fix the complaints.

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
---
 drivers/media/platform/pxa_camera.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index f71e7e0a652b..79fd7269d1e6 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -37,7 +37,9 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-of.h>
 
@@ -2089,6 +2091,8 @@ static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
 	.vidioc_g_register		= pxac_vidioc_g_register,
 	.vidioc_s_register		= pxac_vidioc_s_register,
 #endif
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static struct v4l2_clk_ops pxa_camera_mclk_ops = {
-- 
2.11.0
