Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37876 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754096AbdJIKTq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 14/24] media: v4l2-subdev: convert frame description to enum
Date: Mon,  9 Oct 2017 07:19:20 -0300
Message-Id: <8f635ebfbe9b7b7a41857725929ca5b5cf01aa8f.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As kernel-doc doesn't support documenting #define values,
and using enum makes easier to identify where the values
are used, convert V4L2_MBUS_FRAME_DESC_FL_* to enum, and
use BIT() macro.

While here, fix the description at v4l2_mbus_frame_desc_entry,
in order to match what's described for
V4L2_MBUS_FRAME_DESC_FL_LEN_MAX.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 249604bbd3cb..1f34045f07ce 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -314,25 +314,32 @@ struct v4l2_subdev_audio_ops {
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 };
 
-/* Indicates the @length field specifies maximum data length. */
-#define V4L2_MBUS_FRAME_DESC_FL_LEN_MAX		(1U << 0)
-/*
- * Indicates that the format does not have line offsets, i.e. the
- * receiver should use 1D DMA.
+/**
+ * enum v4l2_mbus_frame_desc_entry - media bus frame description flags
+ *
+ * @V4L2_MBUS_FRAME_DESC_FL_LEN_MAX:
+ *	Indicates that &struct v4l2_mbus_frame_desc_entry->length field
+ *	specifies maximum data length.
+ * @V4L2_MBUS_FRAME_DESC_FL_BLOB:
+ *	Indicates that the format does not have line offsets, i.e.
+ *	the receiver should use 1D DMA.
  */
-#define V4L2_MBUS_FRAME_DESC_FL_BLOB		(1U << 1)
+enum v4l2_mbus_frame_desc_flags {
+	V4L2_MBUS_FRAME_DESC_FL_LEN_MAX	= BIT(0),
+	V4L2_MBUS_FRAME_DESC_FL_BLOB	= BIT(1),
+};
 
 /**
  * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
  *
- * @flags: bitmask flags: %V4L2_MBUS_FRAME_DESC_FL_LEN_MAX and
- *			  %V4L2_MBUS_FRAME_DESC_FL_BLOB.
- * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
- * @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB
- *	    is set
+ * @flags:	bitmask flags, as defined by &enum v4l2_mbus_frame_desc_flags.
+ * @pixelcode:	media bus pixel code, valid if @flags
+ * 		%FRAME_DESC_FL_BLOB is not set.
+ * @length:	number of octets per frame, valid if @flags
+ *		%V4L2_MBUS_FRAME_DESC_FL_LEN_MAX is set.
  */
 struct v4l2_mbus_frame_desc_entry {
-	u16 flags;
+	enum v4l2_mbus_frame_desc_flags flags;
 	u32 pixelcode;
 	u32 length;
 };
-- 
2.13.6
