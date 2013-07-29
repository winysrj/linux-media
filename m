Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4074 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3G2Mle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/8] videodev2.h: defines to calculate blanking and frame sizes
Date: Mon, 29 Jul 2013 14:40:58 +0200
Message-Id: <1375101661-6493-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It is very common to have to calculate the total width and height of the
blanking and the full frame, so add a few defines that deal with that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 95ef455..547ef45 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1055,6 +1055,16 @@ struct v4l2_bt_timings {
    or used depends on the hardware. */
 #define V4L2_DV_FL_HALF_LINE			(1 << 3)
 
+/* A few useful defines to calculate the total blanking and frame sizes */
+#define V4L2_DV_BT_BLANKING_WIDTH(bt) \
+	(bt->hfrontporch + bt->hsync + bt->hbackporch)
+#define V4L2_DV_BT_FRAME_WIDTH(bt) \
+	(bt->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
+#define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
+	(bt->vfrontporch + bt->vsync + bt->vbackporch + \
+	 bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch)
+#define V4L2_DV_BT_FRAME_HEIGHT(bt) \
+	(bt->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
 /** struct v4l2_dv_timings - DV timings
  * @type:	the type of the timings
-- 
1.8.3.2

