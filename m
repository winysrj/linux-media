Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47102 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaK0NYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 08:24:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/9] v4l2-mediabus: improve colorspace support
Date: Thu, 27 Nov 2014 14:23:45 +0100
Message-Id: <1417094632-31980-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
References: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add and copy the new ycbcr_enc and quantization fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-mediabus.h      | 4 ++++
 include/uapi/linux/v4l2-mediabus.h | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 59d7397..38d960d 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -94,6 +94,8 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
 	pix_fmt->height = mbus_fmt->height;
 	pix_fmt->field = mbus_fmt->field;
 	pix_fmt->colorspace = mbus_fmt->colorspace;
+	pix_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
+	pix_fmt->quantization = mbus_fmt->quantization;
 }
 
 static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
@@ -104,6 +106,8 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
 	mbus_fmt->height = pix_fmt->height;
 	mbus_fmt->field = pix_fmt->field;
 	mbus_fmt->colorspace = pix_fmt->colorspace;
+	mbus_fmt->ycbcr_enc = pix_fmt->ycbcr_enc;
+	mbus_fmt->quantization = pix_fmt->quantization;
 	mbus_fmt->code = code;
 }
 
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index b1934a3..5a86d8e 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -22,6 +22,8 @@
  * @code:	data format code (from enum v4l2_mbus_pixelcode)
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
+ * @ycbcr_enc:	YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
+ * @quantization: quantization of the data (from enum v4l2_quantization)
  */
 struct v4l2_mbus_framefmt {
 	__u32			width;
@@ -29,7 +31,9 @@ struct v4l2_mbus_framefmt {
 	__u32			code;
 	__u32			field;
 	__u32			colorspace;
-	__u32			reserved[7];
+	__u32			ycbcr_enc;
+	__u32			quantization;
+	__u32			reserved[5];
 };
 
 #ifndef __KERNEL__
-- 
2.1.3

