Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbbLQIlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:06 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 26/48] videodev2.h: Add request field to v4l2_pix_format_mplane
Date: Thu, 17 Dec 2015 10:40:04 +0200
Message-Id: <1450341626-6695-27-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let userspace specify a request ID when getting or setting formats. The
support is limited to the multi-planar API at the moment, extending it
to the single-planar API is possible if needed.

>From a userspace point of view the API change is also minimized and
doesn't require any new ioctl.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 include/uapi/linux/videodev2.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5af1d2d87558..5b2a8bc80eb2 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1973,6 +1973,7 @@ struct v4l2_plane_pix_format {
  * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
  * @quantization:	enum v4l2_quantization, colorspace quantization
  * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
+ * @request:		request ID
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1987,7 +1988,8 @@ struct v4l2_pix_format_mplane {
 	__u8				ycbcr_enc;
 	__u8				quantization;
 	__u8				xfer_func;
-	__u8				reserved[7];
+	__u8				reserved[3];
+	__u32				request;
 } __attribute__ ((packed));
 
 /**
-- 
2.4.10

