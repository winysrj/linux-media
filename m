Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47846 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbdJIKTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 12/24] media: v4l2-subdev: fix description of tuner.s_radio ops
Date: Mon,  9 Oct 2017 07:19:18 -0300
Message-Id: <352f6cfb16d6ac6b7d2e13e379a5b11fafd0d868.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description there is completely broken and it mentions
an ioctl that doesn't exist.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b299cf63972b..c43e3d650fe6 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -216,7 +216,10 @@ struct v4l2_subdev_core_ops {
  * struct v4l2_subdev_tuner_ops - Callbacks used when v4l device was opened
  *	in radio mode.
  *
- * @s_radio: callback for VIDIOC_S_RADIO() ioctl handler code.
+ * @s_radio: callback that switches the tuner to radio mode.
+ *	     drivers should explicitly call it when a tuner ops should
+ *	     operate on radio mode, before being able to handle it.
+ *	     Used on devices that have both AM/FM radio receiver and TV.
  *
  * @s_frequency: callback for VIDIOC_S_FREQUENCY() ioctl handler code.
  *
@@ -239,6 +242,22 @@ struct v4l2_subdev_core_ops {
  * @s_type_addr: sets tuner type and its I2C addr.
  *
  * @s_config: sets tda9887 specific stuff, like port1, port2 and qss
+ *
+ * .. note::
+ *
+ * 	On devices that have both AM/FM and TV, it is up to the driver
+ *	to explicitly call s_radio when the tuner should be switched to
+ *	radio mode, before handling other &struct v4l2_subdev_tuner_ops
+ *	that would require it. An example of such usage is::
+ *
+ *	  static void s_frequency(void *priv, const struct v4l2_frequency *f)
+ *	  {
+ * 		...
+ *		if (f.type == V4L2_TUNER_RADIO)
+ *			v4l2_device_call_all(v4l2_dev, 0, tuner, s_radio);
+ *		...
+ *		v4l2_device_call_all(v4l2_dev, 0, tuner, s_frequency);
+ *	  }
  */
 struct v4l2_subdev_tuner_ops {
 	int (*s_radio)(struct v4l2_subdev *sd);
-- 
2.13.6
