Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0L0LjH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:39:07 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd6v8026839
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:39:06 -0500
Received: from gaivota (vpn-11-156.rdu.redhat.com [10.11.11.156])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd1iM001764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:39:05 -0500
Date: Mon, 27 Dec 2010 09:38:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/6] [media] Remove VIDEO_V4L1 Kconfig option
Message-ID: <20101227093845.329f8991@gaivota>
In-Reply-To: <cover.1293449547.git.mchehab@redhat.com>
References: <cover.1293449547.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

There's no sense on keeping VIDEO_V4L1 Kconfig option just because of
two deprecated drivers moved to staging scheduled to die on 2.6.39.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 9ea1a6d..147c92b 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -40,20 +40,6 @@ config VIDEO_V4L2_COMMON
 	depends on (I2C || I2C=n) && VIDEO_DEV
 	default (I2C || I2C=n) && VIDEO_DEV
 
-config VIDEO_ALLOW_V4L1
-	bool "Enable Video For Linux API 1 (DEPRECATED)"
-	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
-	default VIDEO_DEV && VIDEO_V4L2_COMMON
-	---help---
-	  Enables drivers based on the legacy V4L1 API.
-
-	  This api were developed to be used at Kernel 2.2 and 2.4, but
-	  lacks support for several video standards. There are several
-	  drivers at kernel that still depends on it.
-
-	  If you are unsure as to whether this is required, answer Y.
-
-
 #
 # DVB Core
 #
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index b7b7b59..5116b4d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -7,11 +7,6 @@ config VIDEO_V4L2
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
 
-config VIDEO_V4L1
-	tristate
-	depends on VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
-	default VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
-
 config VIDEOBUF_GEN
 	tristate
 
diff --git a/drivers/staging/se401/Kconfig b/drivers/staging/se401/Kconfig
index 586fc04..ee7313e 100644
--- a/drivers/staging/se401/Kconfig
+++ b/drivers/staging/se401/Kconfig
@@ -1,6 +1,6 @@
 config USB_SE401
 	tristate "USB SE401 Camera support (DEPRECATED)"
-	depends on VIDEO_V4L1
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port. See <file:Documentation/video4linux/se401.txt>
diff --git a/drivers/staging/usbvideo/Kconfig b/drivers/staging/usbvideo/Kconfig
index aae863e..d9fc867 100644
--- a/drivers/staging/usbvideo/Kconfig
+++ b/drivers/staging/usbvideo/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_USBVIDEO
 
 config USB_VICAM
 	tristate "USB 3com HomeConnect (aka vicam) support (DEPRECATED)"
-	depends on VIDEO_V4L1 && EXPERIMENTAL
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y here if you have 3com homeconnect camera (vicam).
diff --git a/include/linux/videodev.h b/include/linux/videodev.h
index 8a7aead..f11efbe 100644
--- a/include/linux/videodev.h
+++ b/include/linux/videodev.h
@@ -16,8 +16,6 @@
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
-#if defined(CONFIG_VIDEO_V4L1) || defined(CONFIG_VIDEO_V4L1_MODULE) || !defined(__KERNEL__)
-
 #define VID_TYPE_CAPTURE	1	/* Can capture */
 #define VID_TYPE_TUNER		2	/* Can tune */
 #define VID_TYPE_TELETEXT	4	/* Does teletext */
@@ -311,8 +309,6 @@ struct video_code
 #define VID_PLAY_RESET			13
 #define VID_PLAY_END_MARK		14
 
-#endif /* CONFIG_VIDEO_V4L1 */
-
 #endif /* __LINUX_VIDEODEV_H */
 
 /*
-- 
1.7.3.4


