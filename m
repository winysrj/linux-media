Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35468 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754085AbdJIKTi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 09/24] media: v4l2-dev: document video_device flags
Date: Mon,  9 Oct 2017 07:19:15 -0300
Message-Id: <e639d4ff59747c9b300ea0328ffa82fb5bca9679.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert #defines to enums and add kernel-doc markups for V4L2
video_device flags.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-dev.h | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 87dac58c7799..33a5256232f8 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -61,12 +61,22 @@ struct video_device;
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 
-/* Flag to mark the video_device struct as registered.
-   Drivers can clear this flag if they want to block all future
-   device access. It is cleared by video_unregister_device. */
-#define V4L2_FL_REGISTERED	(0)
-/* file->private_data points to struct v4l2_fh */
-#define V4L2_FL_USES_V4L2_FH	(1)
+/**
+ * enum v4l2_video_device_flags - Flags used by &struct video_device
+ *
+ * @V4L2_FL_REGISTERED:
+ * 	indicates that a &struct video_device is registered.
+ *	Drivers can clear this flag if they want to block all future
+ *	device access. It is cleared by video_unregister_device.
+ * @V4L2_FL_USES_V4L2_FH:
+ *	indicates that file->private_data points to &struct v4l2_fh.
+ *	This flag is set by the core when v4l2_fh_init() is called.
+ *	All new drivers should use it.
+ */
+enum v4l2_video_device_flags {
+	V4L2_FL_REGISTERED	= 0,
+	V4L2_FL_USES_V4L2_FH	= 1,
+};
 
 /* Priority helper functions */
 
@@ -214,7 +224,8 @@ struct v4l2_file_operations {
  * @vfl_dir: V4L receiver, transmitter or m2m
  * @minor: device node 'minor'. It is set to -1 if the registration failed
  * @num: number of the video device node
- * @flags: video device flags. Use bitops to set/clear/test flags
+ * @flags: video device flags. Use bitops to set/clear/test flags.
+ *	   Contains a set of &enum v4l2_video_device_flags.
  * @index: attribute to differentiate multiple indices on one physical device
  * @fh_lock: Lock for all v4l2_fhs
  * @fh_list: List of &struct v4l2_fh
-- 
2.13.6
