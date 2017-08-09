Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0083.outbound.protection.outlook.com ([104.47.34.83]:57331
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751932AbdHISxp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 14:53:45 -0400
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <hyun.kwon@xilinx.com>,
        Rohit Athavale <rathaval@xilinx.com>
Subject: [PATCH 2/3] media: xilinx-vip: Add 8-bit YCbCr 4:2:0 to formats table
Date: Wed, 9 Aug 2017 11:27:53 -0700
Message-ID: <1502303274-40609-3-git-send-email-rathaval@xilinx.com>
In-Reply-To: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
References: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Xilinx YCbCr 4:2:0 to xvip formats table. This commit
will allow driver to setup media pad codes to YUV 420
via DT properties.

Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-vip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
index 3112591..37b80bf 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/media-bus-format.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
@@ -27,6 +28,8 @@
  */
 
 static const struct xvip_video_format xvip_video_formats[] = {
+	{ XVIP_VF_YUV_420, 8, NULL, MEDIA_BUS_FMT_XLNX8_VUY420_1X24,
+	  2, V4L2_PIX_FMT_NV12, "4:2:0, semi-planar, YUYV" },
 	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
 	  2, V4L2_PIX_FMT_YUYV, "4:2:2, packed, YUYV" },
 	{ XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,
-- 
1.9.1
