Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBEQlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 06/47] v4l: Add pad-level DV timings subdev operations
Date: Wed,  5 Feb 2014 17:41:57 +0100
Message-Id: <1391618558-5580-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h    | 4 ++++
 include/uapi/linux/videodev2.h | 8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d67210a..2c7355a 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -505,6 +505,10 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
 	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
+	int (*dv_timings_cap)(struct v4l2_subdev *sd,
+			      struct v4l2_dv_timings_cap *cap);
+	int (*enum_dv_timings)(struct v4l2_subdev *sd,
+			       struct v4l2_enum_dv_timings *timings);
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
 			     struct v4l2_subdev_format *source_fmt,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe..b75970d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1086,12 +1086,14 @@ struct v4l2_dv_timings {
 
 /** struct v4l2_enum_dv_timings - DV timings enumeration
  * @index:	enumeration index
+ * @pad:	the pad number for which to query capabilities
  * @reserved:	must be zeroed
  * @timings:	the timings for the given index
  */
 struct v4l2_enum_dv_timings {
 	__u32 index;
-	__u32 reserved[3];
+	__u32 pad;
+	__u32 reserved[2];
 	struct v4l2_dv_timings timings;
 };
 
@@ -1129,11 +1131,13 @@ struct v4l2_bt_timings_cap {
 
 /** struct v4l2_dv_timings_cap - DV timings capabilities
  * @type:	the type of the timings (same as in struct v4l2_dv_timings)
+ * @pad:	the pad number for which to query capabilities
  * @bt:		the BT656/1120 timings capabilities
  */
 struct v4l2_dv_timings_cap {
 	__u32 type;
-	__u32 reserved[3];
+	__u32 pad;
+	__u32 reserved[2];
 	union {
 		struct v4l2_bt_timings_cap bt;
 		__u32 raw_data[32];
-- 
1.8.3.2

