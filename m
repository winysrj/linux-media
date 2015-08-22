Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbHVR2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 12/39] [media] v4l2-subdev: reorder the v4l2_subdev_video_ops comments
Date: Sat, 22 Aug 2015 14:27:57 -0300
Message-Id: <02be051204e880a8277d80734e788ee645d1ef14.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments for struct v4l2_subdev_video_ops are out of the
order as the parameter would appear at struct. This is not
a problem for DocBook, but humans find harder to mentally
reorder ;)

So, put them at the right order. That makes easier to check
what's missing, and to put the comments in the right place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d9315e5e8957..884a8d7c1368 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -309,6 +309,15 @@ struct v4l2_mbus_frame_desc {
 /**
  * struct v4l2_subdev_video_ops - Callbacks used when v4l device was opened
  * 				  in video mode.
+ *
+ * @s_routing: see s_routing in audio_ops, except this version is for video
+ *	devices.
+ *
+ * @s_crystal_freq: sets the frequency of the crystal used to generate the
+ *	clocks in Hz. An extra flags field allows device specific configuration
+ *	regarding clock frequency dividers, etc. If not used, then set flags
+ *	to 0. If the frequency is not supported, then -EINVAL is returned.
+ *
  * @s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
  *	video input devices.
  *
@@ -321,22 +330,15 @@ struct v4l2_mbus_frame_desc {
  * @g_tvnorms_output: get v4l2_std_id with all standards supported by the video
  *	OUTPUT device. This is ignored by video capture devices.
  *
- * @s_crystal_freq: sets the frequency of the crystal used to generate the
- *	clocks in Hz. An extra flags field allows device specific configuration
- *	regarding clock frequency dividers, etc. If not used, then set flags
- *	to 0. If the frequency is not supported, then -EINVAL is returned.
- *
  * @g_input_status: get input status. Same as the status field in the v4l2_input
  *	struct.
  *
- * @s_routing: see s_routing in audio_ops, except this version is for video
- *	devices.
- *
  * @s_dv_timings(): Set custom dv timings in the sub device. This is used
  *	when sub device is capable of setting detailed timing information
  *	in the hardware to generate/detect the video signal.
  *
  * @g_dv_timings(): Get custom dv timings in the sub device.
+ *
  * @g_mbus_config: get supported mediabus configurations
  *
  * @s_mbus_config: set a certain mediabus configuration. This operation is added
-- 
2.4.3

