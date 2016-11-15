Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35798 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbcKOM3R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:29:17 -0500
Received: by mail-qt0-f195.google.com with SMTP id m48so8098180qta.2
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2016 04:29:17 -0800 (PST)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2-ctl: Show HSV encodings names
Date: Tue, 15 Nov 2016 13:29:14 +0100
Message-Id: <20161115122914.19981-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add HSV encoding names to v4l2-ctl. I.e.

Format Video Capture:
	Width/Height      : 640/360
	Pixel Format      : 'HSV3'
	Field             : None
	Bytes per Line    : 1920
	Size Image        : 691200
	Colorspace        : sRGB
	Transfer Function : Default
	YCbCr/HSV Encoding: Hue 0 - 179
	Quantization      : Default
	Flags             :

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl.cpp | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 8a2b3e6d186e..fe398233e28c 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -451,6 +451,10 @@ static std::string ycbcr_enc2s(int val)
 		return "BT.2020 Constant Luminance";
 	case V4L2_YCBCR_ENC_SMPTE240M:
 		return "SMPTE 240M";
+	case V4L2_HSV_ENC_180:
+		return "Hue 0 - 179";
+	case V4L2_HSV_ENC_256:
+		return "Hue 0 - 255";
 	default:
 		return "Unknown (" + num2s(val) + ")";
 	}
@@ -532,7 +536,7 @@ void printfmt(const struct v4l2_format &vfmt)
 		printf("\tSize Image        : %u\n", vfmt.fmt.pix.sizeimage);
 		printf("\tColorspace        : %s\n", colorspace2s(vfmt.fmt.pix.colorspace).c_str());
 		printf("\tTransfer Function : %s\n", xfer_func2s(vfmt.fmt.pix.xfer_func).c_str());
-		printf("\tYCbCr Encoding    : %s\n", ycbcr_enc2s(vfmt.fmt.pix.ycbcr_enc).c_str());
+		printf("\tYCbCr/HSV Encoding: %s\n", ycbcr_enc2s(vfmt.fmt.pix.ycbcr_enc).c_str());
 		printf("\tQuantization      : %s\n", quantization2s(vfmt.fmt.pix.quantization).c_str());
 		if (vfmt.fmt.pix.priv == V4L2_PIX_FMT_PRIV_MAGIC)
 			printf("\tFlags             : %s\n", pixflags2s(vfmt.fmt.pix.flags).c_str());
-- 
2.10.2

