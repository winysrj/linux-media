Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1KBLqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 07:46:22 -0400
Date: Wed, 2 Nov 2011 09:45:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] move cx25821 out of staging
Message-ID: <20111102094507.6309a788@redhat.com>
In-Reply-To: <cover.1320233265.git.mchehab@redhat.com>
References: <cover.1320233265.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver had the major issues already fixed. Move it out
of staging.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 rename drivers/{staging => media/video}/cx25821/Kconfig (100%)
 rename drivers/{staging => media/video}/cx25821/Makefile (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-alsa.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio-upstream.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio-upstream.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-biffuncs.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-cards.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-core.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-gpio.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-i2c.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-defines.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-reg.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-video.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-video.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-reg.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-sram.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream-ch2.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream-ch2.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821.h (100%)
 delete mode 100644 drivers/staging/cx25821/README

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index b80bea2..81ac09a 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -736,6 +736,8 @@ source "drivers/media/video/cx88/Kconfig"
 
 source "drivers/media/video/cx23885/Kconfig"
 
+source "drivers/media/video/cx25821/Kconfig"
+
 source "drivers/media/video/au0828/Kconfig"
 
 source "drivers/media/video/ivtv/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 11fff97..faba1e3 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
+obj-$(CONFIG_VIDEO_CX25821) += cx25821/
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
 obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
diff --git a/drivers/staging/cx25821/Kconfig b/drivers/media/video/cx25821/Kconfig
similarity index 100%
rename from drivers/staging/cx25821/Kconfig
rename to drivers/media/video/cx25821/Kconfig
diff --git a/drivers/staging/cx25821/Makefile b/drivers/media/video/cx25821/Makefile
similarity index 100%
rename from drivers/staging/cx25821/Makefile
rename to drivers/media/video/cx25821/Makefile
diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/media/video/cx25821/cx25821-alsa.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-alsa.c
rename to drivers/media/video/cx25821/cx25821-alsa.c
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/media/video/cx25821/cx25821-audio-upstream.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-audio-upstream.c
rename to drivers/media/video/cx25821/cx25821-audio-upstream.c
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.h b/drivers/media/video/cx25821/cx25821-audio-upstream.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-audio-upstream.h
rename to drivers/media/video/cx25821/cx25821-audio-upstream.h
diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/media/video/cx25821/cx25821-audio.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-audio.h
rename to drivers/media/video/cx25821/cx25821-audio.h
diff --git a/drivers/staging/cx25821/cx25821-biffuncs.h b/drivers/media/video/cx25821/cx25821-biffuncs.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-biffuncs.h
rename to drivers/media/video/cx25821/cx25821-biffuncs.h
diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/media/video/cx25821/cx25821-cards.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-cards.c
rename to drivers/media/video/cx25821/cx25821-cards.c
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-core.c
rename to drivers/media/video/cx25821/cx25821-core.c
diff --git a/drivers/staging/cx25821/cx25821-gpio.c b/drivers/media/video/cx25821/cx25821-gpio.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-gpio.c
rename to drivers/media/video/cx25821/cx25821-gpio.c
diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/media/video/cx25821/cx25821-i2c.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-i2c.c
rename to drivers/media/video/cx25821/cx25821-i2c.c
diff --git a/drivers/staging/cx25821/cx25821-medusa-defines.h b/drivers/media/video/cx25821/cx25821-medusa-defines.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-medusa-defines.h
rename to drivers/media/video/cx25821/cx25821-medusa-defines.h
diff --git a/drivers/staging/cx25821/cx25821-medusa-reg.h b/drivers/media/video/cx25821/cx25821-medusa-reg.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-medusa-reg.h
rename to drivers/media/video/cx25821/cx25821-medusa-reg.h
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/media/video/cx25821/cx25821-medusa-video.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-medusa-video.c
rename to drivers/media/video/cx25821/cx25821-medusa-video.c
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.h b/drivers/media/video/cx25821/cx25821-medusa-video.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-medusa-video.h
rename to drivers/media/video/cx25821/cx25821-medusa-video.h
diff --git a/drivers/staging/cx25821/cx25821-reg.h b/drivers/media/video/cx25821/cx25821-reg.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-reg.h
rename to drivers/media/video/cx25821/cx25821-reg.h
diff --git a/drivers/staging/cx25821/cx25821-sram.h b/drivers/media/video/cx25821/cx25821-sram.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-sram.h
rename to drivers/media/video/cx25821/cx25821-sram.h
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-video-upstream-ch2.c
rename to drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h b/drivers/media/video/cx25821/cx25821-video-upstream-ch2.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-video-upstream-ch2.h
rename to drivers/media/video/cx25821/cx25821-video-upstream-ch2.h
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/media/video/cx25821/cx25821-video-upstream.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-video-upstream.c
rename to drivers/media/video/cx25821/cx25821-video-upstream.c
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.h b/drivers/media/video/cx25821/cx25821-video-upstream.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-video-upstream.h
rename to drivers/media/video/cx25821/cx25821-video-upstream.h
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/media/video/cx25821/cx25821-video.c
similarity index 100%
rename from drivers/staging/cx25821/cx25821-video.c
rename to drivers/media/video/cx25821/cx25821-video.c
diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/media/video/cx25821/cx25821-video.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821-video.h
rename to drivers/media/video/cx25821/cx25821-video.h
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/media/video/cx25821/cx25821.h
similarity index 100%
rename from drivers/staging/cx25821/cx25821.h
rename to drivers/media/video/cx25821/cx25821.h
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 0cd26b8..280da2f 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -30,8 +30,6 @@ source "drivers/staging/slicoss/Kconfig"
 
 source "drivers/staging/go7007/Kconfig"
 
-source "drivers/staging/cx25821/Kconfig"
-
 source "drivers/staging/cxd2099/Kconfig"
 
 source "drivers/staging/usbip/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 583facc..e66ab00 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -6,7 +6,6 @@ obj-$(CONFIG_STAGING)		+= staging.o
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
 obj-$(CONFIG_VIDEO_GO7007)	+= go7007/
-obj-$(CONFIG_VIDEO_CX25821)	+= cx25821/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_USBIP_CORE)	+= usbip/
diff --git a/drivers/staging/cx25821/README b/drivers/staging/cx25821/README
deleted file mode 100644
index a9ba50b..0000000
--- a/drivers/staging/cx25821/README
+++ /dev/null
@@ -1,6 +0,0 @@
-Todo:
-	- checkpatch.pl cleanups
-	- sparse cleanups
-
-Please send patches to linux-media@vger.kernel.org
-
-- 
1.7.6.4


