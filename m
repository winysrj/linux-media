Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39102 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752929AbdHKJ5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:21 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 03/20] v4l2-subdev.h: add CSI-2 bus description to struct v4l2_mbus_frame_desc_entry
Date: Fri, 11 Aug 2017 11:56:46 +0200
Message-Id: <20170811095703.6170-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pads that carry muxed CSI-2 streams needs a way to describe which
'normal' pad is muxed to/from which stream of the multiplexed pad.
Extend struct v4l2_mbus_frame_desc_entry to carry this information.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/v4l2-subdev.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c258b1524f94f8ff..dc855135d94eafdb 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -292,6 +292,9 @@ struct v4l2_subdev_audio_ops {
  * receiver should use 1D DMA.
  */
 #define V4L2_MBUS_FRAME_DESC_FL_BLOB		(1U << 1)
+/* Indicates the the discriptor describes a muxed CSI-2 bus */
+#define V4L2_MBUS_FRAME_DESC_FL_CSI2		(1U << 2)
+
 
 /**
  * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
@@ -301,11 +304,19 @@ struct v4l2_subdev_audio_ops {
  * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
  * @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB
  *	    is set
+ * @csi2: CSI-2 bus specific parameters, valid if V4L2_MBUS_FRAME_DESC_FL_CSI2
+ *        is set
  */
 struct v4l2_mbus_frame_desc_entry {
 	u16 flags;
 	u32 pixelcode;
 	u32 length;
+
+	struct {
+		unsigned int channel;
+		unsigned int datatype;
+		unsigned int pad;
+	} csi2;
 };
 
 #define V4L2_FRAME_DESC_ENTRY_MAX	4
-- 
2.13.3
