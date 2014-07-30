Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4348 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaG3OX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 10:23:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 12/12] vivid: enable the vivid driver
Date: Wed, 30 Jul 2014 16:23:15 +0200
Message-Id: <1406730195-64365-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl>
References: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the Kconfig and Makefile files so this driver can be compiled.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig        |  5 ++++-
 drivers/media/platform/Makefile       |  2 ++
 drivers/media/platform/vivid/Kconfig  | 19 +++++++++++++++++++
 drivers/media/platform/vivid/Makefile |  6 ++++++
 4 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vivid/Kconfig
 create mode 100644 drivers/media/platform/vivid/Makefile

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 433f0bf..b408532 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -242,8 +242,11 @@ menuconfig V4L_TEST_DRIVERS
 	depends on MEDIA_CAMERA_SUPPORT
 
 if V4L_TEST_DRIVERS
+
+source "drivers/media/platform/vivid/Kconfig"
+
 config VIDEO_VIVI
-	tristate "Virtual Video Driver"
+	tristate "Old Virtual Video Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
 	select FONT_SUPPORT
 	select FONT_8x16
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e5269da..dfdc216 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -15,8 +15,10 @@ obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
+
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 
+obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
 
 obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
new file mode 100644
index 0000000..d71139a
--- /dev/null
+++ b/drivers/media/platform/vivid/Kconfig
@@ -0,0 +1,19 @@
+config VIDEO_VIVID
+	tristate "Virtual Video Test Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	select FONT_SUPPORT
+	select FONT_8x16
+	select VIDEOBUF2_VMALLOC
+	default n
+	---help---
+	  Enables a virtual video driver. This driver emulates a webcam,
+	  TV, S-Video and HDMI capture hardware, including VBI support for
+	  the SDTV inputs. Also video output, VBI output, radio receivers,
+	  transmitters and software defined radio capture is emulated.
+
+	  It is highly configurable and is ideal for testing applications.
+	  Error injection is supported to test rare errors that are hard
+	  to reproduce in real hardware.
+
+	  Say Y here if you want to test video apps or debug V4L devices.
+	  When in doubt, say N.
diff --git a/drivers/media/platform/vivid/Makefile b/drivers/media/platform/vivid/Makefile
new file mode 100644
index 0000000..756fc12
--- /dev/null
+++ b/drivers/media/platform/vivid/Makefile
@@ -0,0 +1,6 @@
+vivid-objs := vivid-core.o vivid-ctrls.o vivid-vid-common.o vivid-vbi-gen.o \
+		vivid-vid-cap.o vivid-vid-out.o vivid-kthread-cap.o vivid-kthread-out.o \
+		vivid-radio-rx.o vivid-radio-tx.o vivid-radio-common.o \
+		vivid-rds-gen.o vivid-sdr-cap.o vivid-vbi-cap.o vivid-vbi-out.o \
+		vivid-osd.o vivid-tpg.o vivid-tpg-colors.o
+obj-$(CONFIG_VIDEO_VIVID) += vivid.o
-- 
2.0.1

