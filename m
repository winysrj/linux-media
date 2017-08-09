Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0063.outbound.protection.outlook.com ([104.47.36.63]:18070
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751555AbdHISxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 14:53:44 -0400
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <hyun.kwon@xilinx.com>,
        Rohit Athavale <rathaval@xilinx.com>
Subject: [PATCH 3/3] Documentation: subdev-formats: Add Xilinx YCbCr to Vendor specific area
Date: Wed, 9 Aug 2017 11:27:54 -0700
Message-ID: <1502303274-40609-4-git-send-email-rathaval@xilinx.com>
In-Reply-To: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
References: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds the custom Xilinx IP specific 8-bit YCbCr 4:2:0
to the custom formats area in the subdev-formats documentation.

Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 8e73bb0..141a837 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -7483,3 +7483,8 @@ formats.
       - 0x5001
       - Interleaved raw UYVY and JPEG image format with embedded meta-data
 	used by Samsung S3C73MX camera sensors.
+    * .. _MEDIA_BUS_FMT_XLNX8_VUY420_1X24:
+
+      - MEDIA_BUS_FMT_XLNX8_VUY420_1X24
+      - 0x5002
+      - Xilinx IP specific 8-bit color depth YCbCr 4:2:0 used by Xilinx Video IP.
-- 
1.9.1
