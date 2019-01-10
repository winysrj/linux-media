Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F018C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116D4206B7
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="c61UhPQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfAJIDQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:03:16 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60293 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfAJIDQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 03:03:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C3A7A22EFE
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 03:03:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 10 Jan 2019 03:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=/Va/PXI4nFFdgYKPqaYkFzNPg/37IxzAZsfGI/VpE
        LE=; b=c61UhPQ0Au9alKdRqGn4cR2s/RLh1VctA8EP9y9QVc7cL2yT4nEO2INBB
        x+bujpU4utRZFpaBjpgDZv1eioUAxOZ5qCNzgxt+ALFRS/KBxmvkGLgKzb6cSkYk
        tgBAz60TbxkoVB//LUYarjnX7sHtw2nnx0JudOUdJKV8HOuAxJL0gHpc5cAdJOOe
        kCen31S7PXDFaZ+65q4b7Cm0Nv2dDEfNVlYmFBlMDjbvbFvihPfhyaraXcsLHu1v
        cQ0+FMi2i7mwlQ2WAclzMLuYHKOIhZGZeLW66s8LFcQLAzNarhXE4TpnxnlPOFD+
        21GnKu4xRgSYe9F+Z0z007Q0ah7gg==
X-ME-Sender: <xms:Qvw2XEv-DMMDSCG3PT5JS3-Ta7m3snzWANaoer9ozH-sNejW2cbAfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrfedvgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuhffvfhfkff
    gfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefgughgrghrucfvhhhivghruceoihhn
    fhhosegvughgrghrthhhihgvrhdrnhgvtheqnecuffhomhgrihhnpehvihhsihhonhhonh
    hlihhnvgdrohhrghenucfkphepfedurddvtdelrdelhedrvdegvdenucfrrghrrghmpehm
    rghilhhfrhhomhepihhnfhhosegvughgrghrthhhihgvrhdrnhgvthenucevlhhushhtvg
    hrufhiiigvpedt
X-ME-Proxy: <xmx:Qvw2XFudSNEpp1RfjxEHpvVJg1g9kH28l70U9G1wbwhueEYyOs897g>
    <xmx:Qvw2XKyu2RQ6ivWOaH45x3sJWSOCDdE-qrw29LYH4ZSAkVhQHLMdfg>
    <xmx:Qvw2XLjwLLHn_BmvF1hdrAY8hwYFMQXpimG8wEU1dYzhB_V_jrCMEQ>
    <xmx:Qvw2XDaMxCmWkvIKlJ4zvTlr36rlj7Gn0Jxe5qTibiB3g7WTymoWAQ>
Received: from [192.168.0.111] (unknown [31.209.95.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18D7AE435E
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 03:03:14 -0500 (EST)
Subject: [Patch v2] v4l: Add simple packed bayer 12-bit formats
From:   Edgar Thier <info@edgarthier.net>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b9dc4c99-5aaa-db43-f6cb-f829da9fd654@edgarthier.net>
Message-ID: <462cc8c4-b288-9834-302c-02fd0d1a5d62@edgarthier.net>
Date:   Thu, 10 Jan 2019 09:03:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <b9dc4c99-5aaa-db43-f6cb-f829da9fd654@edgarthier.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


These formats are compressed 12-bit raw bayer formats with four different
pixel orders. They are similar to 10-bit bayer formats 'IPU3'.

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
Documentation/media/uapi/v4l/pixfmt-rgb.rst   |   1 +
.../media/uapi/v4l/pixfmt-srggb12sp.rst       | 123 ++++++++++++++++++
drivers/media/usb/uvc/uvc_driver.c            |  20 +++
include/uapi/linux/videodev2.h                |   7 +
4 files changed, 151 insertions(+)
create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 1f9a7e3a07c9..5da00bd085f1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -19,5 +19,6 @@ RGB Formats
	pixfmt-srggb10-ipu3
	pixfmt-srggb12
	pixfmt-srggb12p
+	pixfmt-srggb12sp
	pixfmt-srggb14p
	pixfmt-srggb16
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
b/Documentation/media/uapi/v4l/pixfmt-srggb12sp.rst
new file mode 100644
index 000000000000..829f6aef34bc
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
+V4L2_PIX_FMT_SBGGR12SP ('SRGGB12SP'), V4L2_PIX_FMT_SGBRG12SP ('SGBRG12SP'),
V4L2_PIX_FMT_SGRBG12SP('SGRBG12SP'), V4L2_PIX_FMT_SRGGB12SP ('SRGGB12SP')
+******************************************************************************************************************************************************
+
+12-bit Bayer formats
+
+Description
+===========
+
+These four pixel formats are used by industrial cameras, often in conjunction with UsbVision (see
https://www.visiononline.org/userAssets/aiaUploads/file/USB3_Vision_Specification_v1-0-1.pdf).
+
+They are raw sRGB / Bayer formats with 12 bits per sample with 6 bytes for every 4 pixels.
+The format is little endian.
+
+In other respects this format is similar to :ref:`v4l2-pix-fmt-ipu3-sbggr10`.
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
index d46dc432456c..3125ed5de3b4 100644
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
+		.name		= "Bayer 12-bit simple packed (SRGGB12SP)",
+		.guid		= UVC_GUID_FORMAT_RG12SP,
+		.fcc		= V4L2_PIX_FMT_SRGGB12SP,
+	},
+	{
+		.name		= "Bayer 12-bit simple packed (SGRBG12SP)",
+		.guid		= UVC_GUID_FORMAT_GR12SP,
+		.fcc		= V4L2_PIX_FMT_SGRBG12SP,
+	},
	{
		.name		= "Bayer 16-bit (SBGGR16)",
		.guid		= UVC_GUID_FORMAT_BG16,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5d1a3685bea9..573acd99ed09 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -605,6 +605,13 @@ struct v4l2_pix_format {
#define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
#define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
#define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
++
+/* 12bit raw bayer simple packed, 6 bytes for every 4 pixels */
+#define V4L2_PIX_FMT_SBGGR12SP v4l2_fourcc('B', 'G', 'C', 'p')
+#define V4L2_PIX_FMT_SGBRG12SP v4l2_fourcc('G', 'B', 'C', 'p')
+#define V4L2_PIX_FMT_SGRBG12SP v4l2_fourcc('G', 'R', 'C', 'p')
+#define V4L2_PIX_FMT_SRGGB12SP v4l2_fourcc('R', 'G', 'C', 'p')
+
/* 12bit raw bayer packed, 6 bytes for every 4 pixels */
#define V4L2_PIX_FMT_SBGGR12P v4l2_fourcc('p', 'B', 'C', 'C')
#define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
--
2.20.1
