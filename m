Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50655 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbeHWKZD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 06:25:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 29BFB21FBB
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2018 02:56:52 -0400 (EDT)
Received: from [192.168.0.112] (unknown [31.209.95.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E7B310273
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2018 02:56:51 -0400 (EDT)
Subject: [PATCH] v4l: Add simple packed Bayer raw12 pixel formats
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Edgar Thier <info@edgarthier.net>
Message-ID: <8632f42f-f274-b271-be1a-08d940c78487@edgarthier.net>
Date: Thu, 23 Aug 2018 08:56:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


These formats are compressed 12-bit raw bayer formats with four different
pixel orders. They are similar to 10-bit bayer formats 'IPU3'.
The formats added by this patch are

V4L2_PIX_FMT_SBGGR12SP
V4L2_PIX_FMT_SGBRG12SP
V4L2_PIX_FMT_SGRBG12SP
V4L2_PIX_FMT_SRGGB12SP

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
Documentation/media/uapi/v4l/pixfmt-rgb.rst   |   1 +
.../media/uapi/v4l/pixfmt-srggb12sp.rst       | 123 ++++++++++++++++++
drivers/media/usb/uvc/uvc_driver.c            |  20 +++
drivers/media/usb/uvc/uvcvideo.h              |  14 +-
include/uapi/linux/videodev2.h                |   7 +
5 files changed, 164 insertions(+), 1 deletion(-)
create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 1f9a7e3a07c9..5da00bd085f1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -19,5 +19,6 @@ RGB Formats
pixfmt-srggb10-ipu3
pixfmt-srggb12
pixfmt-srggb12p
+    pixfmt-srggb12sp
pixfmt-srggb14p
pixfmt-srggb16
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
b/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
new file mode 100644
index 000000000000..e99359709c90
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
@@ -0,0 +1,123 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _v4l2-pix-fmt-sbggr12sp:
+.. _v4l2-pix-fmt-sgbrg12sp:
+.. _v4l2-pix-fmt-sgrbg12sp:
+.. _v4l2-pix-fmt-srggb12sp:
+
+******************************************************************************************************************************************************
+V4L2_PIX_FMT_SBGGR12SP ('SRGGB12SP'), V4L2_PIX_FMT_SGBRG12SP ('SGBRG12SP'), V4L2_PIX_FMT_SGRBG12SP
('SGRBG12SP'), V4L2_PIX_FMT_SRGGB12SP ('SRGGB12SP')
+******************************************************************************************************************************************************
+
+12-bit Bayer formats
+
+Description
+===========
+
+These four pixel formats are used by Intel IPU3 driver, they are raw
+sRGB / Bayer formats with 12 bits per sample with every 8 pixels packed
+to 24 bytes.
+The format is little endian.
+
+In other respects this format is similar to :ref:`V4L2-PIX-FMT-SRGGB10-IPU3`.
+Below is an example of a small image in V4L2_PIX_FMT_SBGGR12SP format.
+
+**Byte Order.**
+Each cell is one byte.
+
+.. tabularcolumns:: |p{0.8cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
+
+.. flat-table::
+
+    * - start + 0:
+      - B\ :sub:`0000low`
+      - G\ :sub:`0001low`\ (bits 7--4)
+
+        B\ :sub:`0000high`\ (bits 0--3)
+
+      - G\ :sub:`0001high`\
+      - B\ :sub:`0002low`
+
+    * - start + 4:
+      - G\ :sub:`0003low`\ (bits 7--4)
+
+        B\ :sub:`0002high`\ (bits 0--3)
+      - G\ :sub:`0003high`
+      - B\ :sub:`0004low`
+      - G\ :sub:`0005low`\ (bits 7--2)
+
+        B\ :sub:`0004high`\ (bits 1--0)
+
+    * - start + 8:
+      - G\ :sub:`0005high`
+      - B\ :sub:`0006low`
+      - G\ :sub:`0007low`\ (bits 7--4)
+        B\ :sub:`0006high`\ (bits 3--0)
+      - G\ :sub:`0007high`
+
+    * - start + 12:
+      - G\ :sub:`0008low`
+      - R\ :sub:`0009low`\ (bits 7--4)
+
+        G\ :sub:`0008high`\ (bits 3--0)
+      - R\ :sub:`0009high`
+      - G\ :sub:`0010low`
+
+    * - start + 16:
+      - R\ :sub:`0011low`\ (bits 7--4)
+        G\ :sub:`00010high`\ (bits 3--0)
+      - R\ :sub:`0011high`
+      - G\ :sub:`0012low`
+      - R\ :sub:`0013low`\ (bits 7--4)
+        G\ :sub:`0012high`\ (bits 3--0)
+
+    * - start + 20
+      - R\ :sub:`0013high`
+      - G\ :sub:`0014low`
+      - R\ :sub:`0015low`\ (bits 7--4)
+        G\ :sub:`0014high`\ (bits 3--0)
+      - R\ :sub:`0015high`
+
+    * - start + 24:
+      - B\ :sub:`0016low`
+      - G\ :sub:`0017low`\ (bits 7--4)
+        B\ :sub:`0016high`\ (bits 0--3)
+      - G\ :sub:`0017high`\
+      - B\ :sub:`0018low`
+
+    * - start + 28:
+      - G\ :sub:`0019low`\ (bits 7--4)
+        B\ :sub:`00018high`\ (bits 0--3)
+      - G\ :sub:`0019high`
+      - B\ :sub:`0020low`
+      - G\ :sub:`0021low`\ (bits 7--2)
+        B\ :sub:`0020high`\ (bits 1--0)
+
+    * - start + 32:
+      - G\ :sub:`0021high`
+      - B\ :sub:`0022low`
+      - G\ :sub:`0023low`\ (bits 7--4)
+        B\ :sub:`0022high`\ (bits 3--0)
+      - G\ :sub:`0024high`
+
+    * - start + 36:
+      - G\ :sub:`0025low`
+      - R\ :sub:`0026low`\ (bits 7--4)
+        G\ :sub:`0025high`\ (bits 3--0)
+      - R\ :sub:`0026high`
+      - G\ :sub:`0027low`
+
+    * - start + 40:
+      - R\ :sub:`0028low`\ (bits 7--4)
+        G\ :sub:`00027high`\ (bits 3--0)
+      - R\ :sub:`0028high`
+      - G\ :sub:`0029low`
+      - R\ :sub:`0030low`\ (bits 7--4)
+        G\ :sub:`0029high`\ (bits 3--0)
+
+    * - start + 44:
+      - R\ :sub:`0030high`
+      - G\ :sub:`0031low`
+      - R\ :sub:`0033low`\ (bits 7--4)
+        G\ :sub:`0032high`\ (bits 3--0)
+      - R\ :sub:`0033high`
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d46dc432456c..9c9703bab717 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -179,6 +179,26 @@ static struct uvc_format_desc uvc_fmts[] = {
.guid		= UVC_GUID_FORMAT_RW10,
.fcc		= V4L2_PIX_FMT_SRGGB10P,
},
+	{
+		.name		= "Bayer 12-bit simple packed (SBGGR12SP)",
+		.guid		= UVC_GUID_FORMAT_BG12SP,
+		.fcc		= V4L2_PIX_FMT_SBGGR12SP,
+	},
+	{
+		.name		= "Bayer 12-bit simple packed (SGBRG12SP)",
+		.guid		= UVC_GUID_FORMAT_GB12SP,
+		.fcc		= V4L2_PIX_FMT_SGBRG12SP,
+	},
+	{
+		.name		= "Bayer 12-bit simple packed (SRGGB12P)",
+		.guid		= UVC_GUID_FORMAT_RG12SP,
+		.fcc		= V4L2_PIX_FMT_SRGGB12SP,
+	},
+	{
+		.name		= "Bayer 12-bit simple packed (SGRBG12P_ME)",
+		.guid		= UVC_GUID_FORMAT_GR12SP,
+		.fcc		= V4L2_PIX_FMT_SGRBG12SP,
+	},
{
.name		= "Bayer 16-bit (SBGGR16)",
.guid		= UVC_GUID_FORMAT_BG16,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e5f5d84f1d1d..3cf4a6d17dc1 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -108,7 +108,19 @@
#define UVC_GUID_FORMAT_RGGB \
{ 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-#define UVC_GUID_FORMAT_BG16 \
+#define UVC_GUID_FORMAT_BG12SP \
+	{ 'B',  'G',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GB12SP \
+	{ 'G',  'B',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_RG12SP \
+	{ 'R',  'G',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GR12SP \
+	{ 'G',  'R',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BG16                         \
{ 'B',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
#define UVC_GUID_FORMAT_GB16 \
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5d1a3685bea9..56807acf8c6d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -610,6 +610,13 @@ struct v4l2_pix_format {
#define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
#define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
#define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
+
+	/* 12bit raw bayer simple packed, 6 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR12SP v4l2_fourcc('B', 'G', 'C', 'p')
+#define V4L2_PIX_FMT_SGBRG12SP v4l2_fourcc('G', 'B', 'C', 'p')
+#define V4L2_PIX_FMT_SGRBG12SP v4l2_fourcc('G', 'R', 'C', 'p')
+#define V4L2_PIX_FMT_SRGGB12SP v4l2_fourcc('R', 'G', 'C', 'p')
+
/* 14bit raw bayer packed, 7 bytes for every 4 pixels */
#define V4L2_PIX_FMT_SBGGR14P v4l2_fourcc('p', 'B', 'E', 'E')
#define V4L2_PIX_FMT_SGBRG14P v4l2_fourcc('p', 'G', 'E', 'E')
--
2.18.0
