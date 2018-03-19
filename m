Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47424 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755096AbeCSM6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 08:58:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] v4l2-mediabus.h: add hsv_enc
Date: Mon, 19 Mar 2018 13:58:16 +0100
Message-Id: <20180319125820.31254-2-hverkuil@xs4all.nl>
In-Reply-To: <20180319125820.31254-1-hverkuil@xs4all.nl>
References: <20180319125820.31254-1-hverkuil@xs4all.nl>
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
