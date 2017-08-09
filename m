Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0075.outbound.protection.outlook.com ([104.47.42.75]:54976
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751560AbdHISxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 14:53:44 -0400
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <hyun.kwon@xilinx.com>,
        Rohit Athavale <rathaval@xilinx.com>
Subject: [PATCH 1/3] uapi: media-bus-format: Add Xilinx specific YCbCr 4:2:0 media bus format
Date: Wed, 9 Aug 2017 11:27:52 -0700
Message-ID: <1502303274-40609-2-git-send-email-rathaval@xilinx.com>
In-Reply-To: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
References: <1502303274-40609-1-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds Xilinx Video IP specific 8-bit color depth YCbCr 4:2:0
to the media bus format uapi.

Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
---
 include/uapi/linux/media-bus-format.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index ef6fb30..6f65607 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -143,10 +143,12 @@
 /* JPEG compressed formats - next is	0x4002 */
 #define MEDIA_BUS_FMT_JPEG_1X8			0x4001
 
-/* Vendor specific formats - next is	0x5002 */
+/* Vendor specific formats - next is	0x5003 */
 
 /* S5C73M3 sensor specific interleaved UYVY and JPEG */
 #define MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8		0x5001
+/* Xilinx IP Specific 8-bit YCbCr 4:2:0 */
+#define MEDIA_BUS_FMT_XLNX8_VUY420_1X24		0x5002
 
 /* HSV - next is	0x6002 */
 #define MEDIA_BUS_FMT_AHSV8888_1X32		0x6001
-- 
1.9.1
