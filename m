Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60964 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751284Ab0CRJSy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 05:18:54 -0400
Date: Thu, 18 Mar 2010 10:18:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-embedded@vger.kernel.org
Subject: [PATCH} V4L: do not autoselect components on embedded systems
Message-ID: <Pine.LNX.4.64.1003181009190.4485@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuner, DVB frontend and video helper chip drivers are by default 
autoselected by their respective host cards, this, however, doesn't make 
much sense on SoC-based systems. Disable autoselection on EMBEDDED 
systems.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

We have discussed this in length yesterday on IRC with Mauro, still, I 
feel a bit uncomfortable about this. I think, many x86- or other PCI- or 
USB-host-enabled systems will select ENABLED to finetune their kernel 
options, and now suddenly their v4l (USB or PCI) devices will stop 
working... Don't think this would please them. Maybe we need a better 
option or just drop this idea altogether... Added embedded ML to cc.

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 409a426..b3ed5da 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -34,7 +34,7 @@ config MEDIA_TUNER
 menuconfig MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default n
+	default y if EMBEDDED
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index cd7f9b7..bed1a83 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,7 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default N
+	default y if EMBEDDED
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 73d1465..dc63311 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -83,7 +83,7 @@ config VIDEO_HELPER_CHIPS_AUTO_DISABLE
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
 	depends on !VIDEO_HELPER_CHIPS_AUTO_DISABLE
-	default y
+	default y if !EMBEDDED
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect
