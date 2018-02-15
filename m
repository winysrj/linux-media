Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0072.outbound.protection.outlook.com ([104.47.41.72]:22634
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753412AbeBOGmW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 01:42:22 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH v3 2/9] media: xilinx: vip: Add the pixel format for RGB24
Date: Wed, 14 Feb 2018 22:42:02 -0800
Message-ID: <1518676922-19427-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hyun Kwon <hyun.kwon@xilinx.com>

The pixel format for RGB24 is missing, and the driver
always falls back to YUYV as no format descriptor matches
with RGB24 fourcc. The pixel format is added to RGB24
format descriptor so that user can use the format.

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-vip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/pla=
tform/xilinx/xilinx-vip.c
index 3112591..d306f44 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -32,7 +32,7 @@ static const struct xvip_video_format xvip_video_formats[=
] =3D {
        { XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,
          3, V4L2_PIX_FMT_YUV444, "4:4:4, packed, YUYV" },
        { XVIP_VF_RBG, 8, NULL, MEDIA_BUS_FMT_RBG888_1X24,
-         3, 0, NULL },
+         3, V4L2_PIX_FMT_RGB24, "24-bit RGB" },
        { XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
          1, V4L2_PIX_FMT_GREY, "Greyscale 8-bit" },
        { XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
