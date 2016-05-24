Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:62295 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbcEXQu7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:50:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 08/21] videodev2.h: Add request field to v4l2_pix_format_mplane
Date: Tue, 24 May 2016 19:47:18 +0300
Message-Id: <1464108451-28142-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

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
index ac28299..6260d0e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1972,6 +1972,7 @@ struct v4l2_plane_pix_format {
  * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
  * @quantization:	enum v4l2_quantization, colorspace quantization
  * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
+ * @request:		request ID
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1986,7 +1987,8 @@ struct v4l2_pix_format_mplane {
 	__u8				ycbcr_enc;
 	__u8				quantization;
 	__u8				xfer_func;
-	__u8				reserved[7];
+	__u8				reserved[3];
+	__u32				request;
 } __attribute__ ((packed));
 
 /**
-- 
1.9.1

