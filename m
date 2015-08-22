Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbHVR2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/39] [media] v4l2-subdev: Add description for core ioctl handlers
Date: Sat, 22 Aug 2015 14:27:55 -0300
Message-Id: <d683353acee9cab09c592c52f712df13f0c5086d.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 'queryctrl'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 'g_ctrl'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 's_ctrl'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 'g_ext_ctrls'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 's_ext_ctrls'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 'try_ext_ctrls'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 'querymenu'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 'g_register'
Warning(.//include/media/v4l2-subdev.h:183): No description found for parameter 's_register'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 7b15eccaceb3..78d2f0ac1848 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -119,7 +119,9 @@ struct v4l2_subdev_io_pin_config {
 };
 
 /**
- * struct v4l2_subdev_core_ops - Define ops callbacks for subdevs
+ * struct v4l2_subdev_core_ops - Define core ops callbacks for subdevs
+ *
+ * @log_status: callback for VIDIOC_LOG_STATUS ioctl handler code.
  *
  * @s_io_pin_config: configure one or more chip I/O pins for chips that
  *	multiplex different internal signal pads out to IO pins.  This function
@@ -141,6 +143,24 @@ struct v4l2_subdev_io_pin_config {
  * @s_gpio: set GPIO pins. Very simple right now, might need to be extended with
  *	a direction argument if needed.
  *
+ * @queryctrl: callback for VIDIOC_QUERYCTL ioctl handler code.
+ *
+ * @g_ctrl: callback for VIDIOC_G_CTRL ioctl handler code.
+ *
+ * @s_ctrl: callback for VIDIOC_S_CTRL ioctl handler code.
+ *
+ * @g_ext_ctrls: callback for VIDIOC_G_EXT_CTRLS ioctl handler code.
+ *
+ * @s_ext_ctrls: callback for VIDIOC_S_EXT_CTRLS ioctl handler code.
+ *
+ * @try_ext_ctrls: callback for VIDIOC_TRY_EXT_CTRLS ioctl handler code.
+ *
+ * @querymenu: callback for VIDIOC_QUERYMENU ioctl handler code.
+ *
+ * @g_register: callback for VIDIOC_G_REGISTER ioctl handler code.
+ *
+ * @s_register: callback for VIDIOC_G_REGISTER ioctl handler code.
+ *
  * @s_power: puts subdevice in power saving mode (on == 0) or normal operation
  *	mode (on == 1).
  *
-- 
2.4.3

