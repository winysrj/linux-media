Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0074.outbound.protection.outlook.com ([104.47.32.74]:45263
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752172AbeBIBVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 20:21:50 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Rohit Athavale <rohit.athavale@xilinx.com>,
        Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH v2 4/9] media-bus: uapi: Add YCrCb 420 media bus format
Date: Thu, 8 Feb 2018 17:21:34 -0800
Message-ID: <1518139294-21723-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rohit Athavale <rohit.athavale@xilinx.com>

This commit adds a YUV 420 media bus format. Currently, one
doesn't exist. VYYUYY8_1X24 does not describe the way the pixels are
sent over the bus, but is an approximation.

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 include/uapi/linux/media-bus-format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/med=
ia-bus-format.h
index 9e35117..ade7e9d 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -62,7 +62,7 @@
 #define MEDIA_BUS_FMT_RGB121212_1X36           0x1019
 #define MEDIA_BUS_FMT_RGB161616_1X48           0x101a

-/* YUV (including grey) - next is      0x202c */
+/* YUV (including grey) - next is      0x202d */
 #define MEDIA_BUS_FMT_Y8_1X8                   0x2001
 #define MEDIA_BUS_FMT_UV8_1X8                  0x2015
 #define MEDIA_BUS_FMT_UYVY8_1_5X8              0x2002
@@ -106,6 +106,7 @@
 #define MEDIA_BUS_FMT_YUV12_1X36               0x2029
 #define MEDIA_BUS_FMT_YUV16_1X48               0x202a
 #define MEDIA_BUS_FMT_UYYVYY16_0_5X48          0x202b
+#define MEDIA_BUS_FMT_VYYUYY8_1X24             0x202c

 /* Bayer - next is     0x3021 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8               0x3001
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
