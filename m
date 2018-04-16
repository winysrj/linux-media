Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:38709 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754955AbeDPNV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:21:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/9] v4l2-mediabus.h: add hsv_enc
Date: Mon, 16 Apr 2018 15:21:13 +0200
Message-Id: <20180416132121.46205-2-hverkuil@xs4all.nl>
In-Reply-To: <20180416132121.46205-1-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just like struct v4l2_pix_format add a hsv_enc field to describe
the HSV encoding. It is in a union with the ycbcr_enc, since it
is one or the other.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-mediabus.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 123a231001a8..52fd6cc9d491 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -24,6 +24,7 @@
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
  * @ycbcr_enc:	YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
+ * @hsv_enc:	HSV encoding of the data (from enum v4l2_hsv_encoding)
  * @quantization: quantization of the data (from enum v4l2_quantization)
  * @xfer_func:  transfer function of the data (from enum v4l2_xfer_func)
  */
@@ -33,7 +34,12 @@ struct v4l2_mbus_framefmt {
 	__u32			code;
 	__u32			field;
 	__u32			colorspace;
-	__u16			ycbcr_enc;
+	union {
+		/* enum v4l2_ycbcr_encoding */
+		__u16		ycbcr_enc;
+		/* enum v4l2_hsv_encoding */
+		__u16		hsv_enc;
+	};
 	__u16			quantization;
 	__u16			xfer_func;
 	__u16			reserved[11];
-- 
2.15.1
