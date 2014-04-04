Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbaDDN1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Apr 2014 09:27:12 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 22271202FB
	for <linux-media@vger.kernel.org>; Fri,  4 Apr 2014 16:25:48 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: v4l: V4L2_MBUS_FRAME_DESC_FL_BLOB is about 1D DMA
Date: Fri,  4 Apr 2014 16:24:44 +0300
Message-Id: <1396617885-5474-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1396617885-5474-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1396617885-5474-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_MBUS_FRAME_DESC_FL_BLOB intends to say the receiver must use 1D DMA to
receive the image, as the format does not have line offsets. This typically
includes all compressed formats.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 include/media/v4l2-subdev.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 28f4d8c..00f5d2b 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -234,15 +234,18 @@ struct v4l2_subdev_audio_ops {
 
 /* Indicates the @length field specifies maximum data length. */
 #define V4L2_MBUS_FRAME_DESC_FL_LEN_MAX		(1U << 0)
-/* Indicates user defined data format, i.e. non standard frame format. */
+/*
+ * Indicates that the format does not have line offsets, i.e. the
+ * receiver should use 1D DMA.
+ */
 #define V4L2_MBUS_FRAME_DESC_FL_BLOB		(1U << 1)
 
 /**
  * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
  * @flags: V4L2_MBUS_FRAME_DESC_FL_* flags
  * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
- * @length: number of octets per frame, valid for compressed or unspecified
- *          formats
+ * @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB
+ *	    is set
  */
 struct v4l2_mbus_frame_desc_entry {
 	u16 flags;
-- 
1.8.3.2

