Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:47557 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbeKBIiO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:38:14 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 21/30] v4l: Add bus type to frame descriptors
Date: Fri,  2 Nov 2018 00:31:35 +0100
Message-Id: <20181101233144.31507-22-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/media/v4l2-subdev.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5acaeeb9b3cacefa..ac1f7ee4cdb978ad 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -349,12 +349,21 @@ struct v4l2_mbus_frame_desc_entry {
 
 #define V4L2_FRAME_DESC_ENTRY_MAX	4
 
+enum {
+	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
+	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
+	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
+	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
+};
+
 /**
  * struct v4l2_mbus_frame_desc - media bus data frame description
+ * @type: type of the bus (V4L2_MBUS_FRAME_DESC_TYPE_*)
  * @entry: frame descriptors array
  * @num_entries: number of entries in @entry array
  */
 struct v4l2_mbus_frame_desc {
+	u32 type;
 	struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
 	unsigned short num_entries;
 };
-- 
2.19.1
