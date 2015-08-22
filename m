Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbHVR2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/39] [media] v4l2-subdev: Add description for radio ioctl handlers
Date: Sat, 22 Aug 2015 14:27:56 -0300
Message-Id: <4ce43a60d9eebfaaa33773a85a17b7aecc174e1f.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-subdev.h:224): No description found for parameter 's_radio'
Warning(.//include/media/v4l2-subdev.h:224): No description found for parameter 's_frequency'
Warning(.//include/media/v4l2-subdev.h:224): No description found for parameter 'enum_freq_bands'
Warning(.//include/media/v4l2-subdev.h:224): No description found for parameter 'g_tuner'
Warning(.//include/media/v4l2-subdev.h:224): No description found for parameter 'g_modulator'
Warning(.//include/media/v4l2-subdev.h:224): No description found for parameter 's_modulator'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 78d2f0ac1848..d9315e5e8957 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -205,13 +205,28 @@ struct v4l2_subdev_core_ops {
 /**
  * struct s_radio - Callbacks used when v4l device was opened in radio mode.
  *
- * @g_frequency: freq->type must be filled in. Normally done by video_ioctl2
- *	or the bridge driver.
- * @g_tuner:
- * @s_tuner: vt->type must be filled in. Normally done by video_ioctl2 or the
+ * @s_radio: callback for VIDIOC_S_RADIO ioctl handler code.
+ *
+ * @s_frequency: callback for VIDIOC_S_FREQUENCY ioctl handler code.
+ *
+ * @g_frequency: callback for VIDIOC_G_FREQUENCY ioctl handler code.
+ *		 freq->type must be filled in. Normally done by video_ioctl2
+ *		or the bridge driver.
+ *
+ * @enum_freq_bands: callback for VIDIOC_ENUM_FREQ_BANDS ioctl handler code.
+ *
+ * @g_tuner: callback for VIDIOC_G_TUNER ioctl handler code.
+ *
+ * @s_tuner: callback for VIDIOC_S_TUNER ioctl handler code. vt->type must be
+ *	     filled in. Normally done by video_ioctl2 or the
  *	bridge driver.
  *
+ * @g_modulator: callback for VIDIOC_G_MODULATOR ioctl handler code.
+ *
+ * @s_modulator: callback for VIDIOC_S_MODULATOR ioctl handler code.
+ *
  * @s_type_addr: sets tuner type and its I2C addr.
+ *
  * @s_config: sets tda9887 specific stuff, like port1, port2 and qss
  */
 struct v4l2_subdev_tuner_ops {
-- 
2.4.3

