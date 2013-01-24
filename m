Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34072 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab3AXXQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 18:16:19 -0500
Received: by mail-yh0-f74.google.com with SMTP id z12so880454yhz.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 15:16:18 -0800 (PST)
From: Simon Que <sque@chromium.org>
To: mchehab@redhat.com, linux-media@vger.kernel.org
Cc: msb@chromium.org, posciak@chromium.org,
	Simon Que <sque@chromium.org>
Subject: [PATCH] media: config option for building tuners
Date: Thu, 24 Jan 2013 14:11:56 -0800
Message-Id: <1359065516-8222-1-git-send-email-sque@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch provides a Kconfig option, MEDIA_TUNER_SUPPORT, that
determines whether media/tuners is included in the build.  This way,
the tuners don't have to be unconditionally included in the build.

Signed-off-by: Simon Que <sque@chromium.org>
---
 drivers/media/Kconfig  | 9 +++++++++
 drivers/media/Makefile | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 4ef0d80..a266da2 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -73,6 +73,15 @@ config MEDIA_RC_SUPPORT
 
 	  Say Y when you have a TV or an IR device.
 
+config MEDIA_TUNER_SUPPORT
+	tristate
+	help
+	  This enables the tuner modules in the tuners directory.  Use this
+	  option to turn on tuners.  The individual tuner modules can then be
+	  turned on/off one-by-one.
+
+	  Say Y when you have a V4L/DVB tuner in your system.
+
 #
 # Media controller
 #	Selectable only for webcam/grabbers, as other drivers don't use it
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 620f275..679db94 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,7 +8,8 @@ media-objs	:= media-device.o media-devnode.o media-entity.o
 # I2C drivers should come before other drivers, otherwise they'll fail
 # when compiled as builtin drivers
 #
-obj-y += i2c/ tuners/
+obj-y += i2c/
+obj-$(CONFIG_MEDIA_TUNER_SUPPORT)  += tuners/
 obj-$(CONFIG_DVB_CORE)  += dvb-frontends/
 
 #
-- 
1.8.1

