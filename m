Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbbHVR2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 14/39] [media] v4l2_subdev: describe ioctl parms at the remaining structs
Date: Sat, 22 Aug 2015 14:27:59 -0300
Message-Id: <4c8e889254c066bee00adff6a84682a08db7c186.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings:

Warning(.//include/media/v4l2-subdev.h:445): No description found for parameter 'g_sliced_vbi_cap'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'enum_mbus_code'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'enum_frame_size'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'enum_frame_interval'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'get_fmt'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'set_fmt'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'get_selection'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'set_selection'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'get_edid'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'set_edid'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'dv_timings_cap'
Warning(.//include/media/v4l2-subdev.h:589): No description found for parameter 'enum_dv_timings'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c33c24360b86..c6205c038b06 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -432,6 +432,8 @@ struct v4l2_subdev_video_ops {
  *	member (to determine whether CC data from the first or second field
  *	should be obtained).
  *
+ * @g_sliced_vbi_cap: callback for VIDIOC_SLICED_VBI_CAP ioctl handler code.
+ *
  * @s_raw_fmt: setup the video encoder/decoder for raw VBI.
  *
  * @g_sliced_fmt: retrieve the current sliced VBI settings.
@@ -549,7 +551,35 @@ struct v4l2_subdev_pad_config {
 
 /**
  * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
+ *
+ * @enum_mbus_code: callback for VIDIOC_SUBDEV_ENUM_MBUS_CODE ioctl handler
+ *		    code.
+ * @enum_frame_size: callback for VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl handler
+ *		     code.
+ *
+ * @enum_frame_interval: callback for VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL ioctl
+ *			 handler code.
+ *
+ * @get_fmt: callback for VIDIOC_SUBDEV_G_FMT ioctl handler code.
+ *
+ * @set_fmt: callback for VIDIOC_SUBDEV_S_FMT ioctl handler code.
+ *
+ * @get_selection: callback for VIDIOC_SUBDEV_G_SELECTION ioctl handler code.
+ *
+ * @set_selection: callback for VIDIOC_SUBDEV_S_SELECTION ioctl handler code.
+ *
+ * @get_edid: callback for VIDIOC_SUBDEV_G_EDID ioctl handler code.
+ *
+ * @set_edid: callback for VIDIOC_SUBDEV_S_EDID ioctl handler code.
+ *
+ * @dv_timings_cap: callback for VIDIOC_SUBDEV_DV_TIMINGS_CAP ioctl handler
+ *		    code.
+ *
+ * @enum_dv_timings: callback for VIDIOC_SUBDEV_ENUM_DV_TIMINGS ioctl handler
+ *		     code.
+ *
  * @get_frame_desc: get the current low level media bus frame parameters.
+ *
  * @get_frame_desc: set the low level media bus frame parameters, @fd array
  *                  may be adjusted by the subdev driver to device capabilities.
  */
-- 
2.4.3

