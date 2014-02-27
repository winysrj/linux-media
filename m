Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4377 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaB0JFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 04:05:17 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1R95DUn009815
	for <linux-media@vger.kernel.org>; Thu, 27 Feb 2014 10:05:15 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 521782A0232
	for <linux-media@vger.kernel.org>; Thu, 27 Feb 2014 10:05:08 +0100 (CET)
Message-ID: <530EFFB9.80705@xs4all.nl>
Date: Thu, 27 Feb 2014 10:04:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH for v3.14] videodev2.h: add parenthesis around macro arguments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bt->width should be (bt)->width, and same for the other fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe..fe94bb9 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1059,14 +1059,14 @@ struct v4l2_bt_timings {
 
 /* A few useful defines to calculate the total blanking and frame sizes */
 #define V4L2_DV_BT_BLANKING_WIDTH(bt) \
-	(bt->hfrontporch + bt->hsync + bt->hbackporch)
+	((bt)->hfrontporch + (bt)->hsync + (bt)->hbackporch)
 #define V4L2_DV_BT_FRAME_WIDTH(bt) \
-	(bt->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
+	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
-	(bt->vfrontporch + bt->vsync + bt->vbackporch + \
-	 bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch)
+	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
+	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
-	(bt->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
+	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
 /** struct v4l2_dv_timings - DV timings
  * @type:	the type of the timings
-- 
1.9.0

