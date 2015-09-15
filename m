Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:36896 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbbIOMgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 08:36:22 -0400
From: Geliang Tang <geliangtang@163.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix kernel-doc warnings in v4l2-dv-timings.h
Date: Tue, 15 Sep 2015 05:36:01 -0700
Message-Id: <edd6478292447e7ae96066a07b204c2a218f7cda.1442349163.git.geliangtang@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following 'make htmldocs' warnings:

  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'frame_height'
  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'hfreq'
  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'vsync'
  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'active_width'
  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'polarities'
  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'interlaced'
  .//include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'fmt'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'frame_height'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'hfreq'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'vsync'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'polarities'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'interlaced'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'aspect'
  .//include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'fmt'
  .//include/media/v4l2-dv-timings.h:184: warning: No description found for parameter 'hor_landscape'
  .//include/media/v4l2-dv-timings.h:184: warning: No description found for parameter 'vert_portrait'

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 include/media/v4l2-dv-timings.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index b6130b5..9c7147b 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -127,16 +127,16 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 /**
  * v4l2_detect_cvt - detect if the given timings follow the CVT standard
  *
- * @frame_height - the total height of the frame (including blanking) in lines.
- * @hfreq - the horizontal frequency in Hz.
- * @vsync - the height of the vertical sync in lines.
- * @active_width - active width of image (does not include blanking). This
+ * @frame_height: the total height of the frame (including blanking) in lines.
+ * @hfreq: the horizontal frequency in Hz.
+ * @vsync: the height of the vertical sync in lines.
+ * @active_width: active width of image (does not include blanking). This
  * information is needed only in case of version 2 of reduced blanking.
  * In other cases, this parameter does not have any effect on timings.
- * @polarities - the horizontal and vertical polarities (same as struct
+ * @polarities: the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
- * @interlaced - if this flag is true, it indicates interlaced format
- * @fmt - the resulting timings.
+ * @interlaced: if this flag is true, it indicates interlaced format
+ * @fmt: the resulting timings.
  *
  * This function will attempt to detect if the given values correspond to a
  * valid CVT format. If so, then it will return true, and fmt will be filled
@@ -149,18 +149,18 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 /**
  * v4l2_detect_gtf - detect if the given timings follow the GTF standard
  *
- * @frame_height - the total height of the frame (including blanking) in lines.
- * @hfreq - the horizontal frequency in Hz.
- * @vsync - the height of the vertical sync in lines.
- * @polarities - the horizontal and vertical polarities (same as struct
+ * @frame_height: the total height of the frame (including blanking) in lines.
+ * @hfreq: the horizontal frequency in Hz.
+ * @vsync: the height of the vertical sync in lines.
+ * @polarities: the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
- * @interlaced - if this flag is true, it indicates interlaced format
- * @aspect - preferred aspect ratio. GTF has no method of determining the
+ * @interlaced: if this flag is true, it indicates interlaced format
+ * @aspect: preferred aspect ratio. GTF has no method of determining the
  *		aspect ratio in order to derive the image width from the
  *		image height, so it has to be passed explicitly. Usually
  *		the native screen aspect ratio is used for this. If it
  *		is not filled in correctly, then 16:9 will be assumed.
- * @fmt - the resulting timings.
+ * @fmt: the resulting timings.
  *
  * This function will attempt to detect if the given values correspond to a
  * valid GTF format. If so, then it will return true, and fmt will be filled
@@ -174,8 +174,8 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
  * v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
  *	0x15 and 0x16 from the EDID.
  *
- * @hor_landscape - byte 0x15 from the EDID.
- * @vert_portrait - byte 0x16 from the EDID.
+ * @hor_landscape: byte 0x15 from the EDID.
+ * @vert_portrait: byte 0x16 from the EDID.
  *
  * Determines the aspect ratio from the EDID.
  * See VESA Enhanced EDID standard, release A, rev 2, section 3.6.2:
-- 
1.9.1


