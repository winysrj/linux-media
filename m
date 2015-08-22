Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40511 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/39] [media] v4l2_subdev: describe ioctl parms at v4l2_subdev_video_ops
Date: Sat, 22 Aug 2015 14:27:58 -0300
Message-Id: <595b95fe301211715aa5f55211796b4c7fd9f7f4.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'g_std'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 's_std'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'querystd'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'cropcap'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'g_crop'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 's_crop'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'g_parm'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 's_parm'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'g_frame_interval'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 's_frame_interval'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 's_dv_timings'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'g_dv_timings'
Warning(.//include/media/v4l2-subdev.h:381): No description found for parameter 'query_dv_timings'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 884a8d7c1368..c33c24360b86 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -318,12 +318,18 @@ struct v4l2_mbus_frame_desc {
  *	regarding clock frequency dividers, etc. If not used, then set flags
  *	to 0. If the frequency is not supported, then -EINVAL is returned.
  *
+ * @g_std: callback for VIDIOC_G_STD ioctl handler code.
+ *
+ * @s_std: callback for VIDIOC_S_STD ioctl handler code.
+ *
  * @s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
  *	video input devices.
  *
  * @g_std_output: get current standard for video OUTPUT devices. This is ignored
  *	by video input devices.
  *
+ * @querystd: callback for VIDIOC_QUERYSTD ioctl handler code.
+ *
  * @g_tvnorms: get v4l2_std_id with all standards supported by the video
  *	CAPTURE device. This is ignored by video output devices.
  *
@@ -333,11 +339,27 @@ struct v4l2_mbus_frame_desc {
  * @g_input_status: get input status. Same as the status field in the v4l2_input
  *	struct.
  *
- * @s_dv_timings(): Set custom dv timings in the sub device. This is used
+ * @cropcap: callback for VIDIOC_CROPCAP ioctl handler code.
+ *
+ * @g_crop: callback for VIDIOC_G_CROP ioctl handler code.
+ *
+ * @s_crop: callback for VIDIOC_S_CROP ioctl handler code.
+ *
+ * @g_parm: callback for VIDIOC_G_PARM ioctl handler code.
+ *
+ * @s_parm: callback for VIDIOC_S_PARM ioctl handler code.
+ *
+ * @g_frame_interval: callback for VIDIOC_G_FRAMEINTERVAL ioctl handler code.
+ *
+ * @s_frame_interval: callback for VIDIOC_S_FRAMEINTERVAL ioctl handler code.
+ *
+ * @s_dv_timings: Set custom dv timings in the sub device. This is used
  *	when sub device is capable of setting detailed timing information
  *	in the hardware to generate/detect the video signal.
  *
- * @g_dv_timings(): Get custom dv timings in the sub device.
+ * @g_dv_timings: Get custom dv timings in the sub device.
+ *
+ * @query_dv_timings: callback for VIDIOC_QUERY_DV_TIMINGS ioctl handler code.
  *
  * @g_mbus_config: get supported mediabus configurations
  *
-- 
2.4.3

