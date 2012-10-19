Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:29969 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2JSLFD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 07:05:03 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q9JB502M020876
	for <linux-media@vger.kernel.org>; Fri, 19 Oct 2012 11:05:00 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Improve media Kconfig menu
Date: Fri, 19 Oct 2012 13:04:22 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210191304.22294.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've always found it very confusing that the "Media ancillary drivers (tuners,
sensors, i2c, frontends)" comment came after the "Autoselect" option. This patch
moves it up and changes the "Autoselect" text to correspond more closely to
the "Media ancillary drivers" comment.

It also fixes two typos.

Regards,

	Hans

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 4ef0d80..9fbfb94 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -158,17 +158,20 @@ source "drivers/media/firewire/Kconfig"
 # Common driver options
 source "drivers/media/common/Kconfig"
 
+comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
+
 #
 # Ancillary drivers (tuners, i2c, frontends)
 #
 
 config MEDIA_SUBDRV_AUTOSELECT
-	bool "Autoselect tuners and i2c modules to build"
+	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT
 	default y
 	help
-	  By default, a media driver auto-selects all possible i2c
-	  devices that are used by any of the supported devices.
+	  By default, a media driver auto-selects all possible ancillary
+	  devices such as tuners, sensors, video encoders/decoders and
+	  frontends, that are used by any of the supported devices.
 
 	  This is generally the right thing to do, except when there
 	  are strict constraints with regards to the kernel size,
@@ -177,12 +180,10 @@ config MEDIA_SUBDRV_AUTOSELECT
 	  Use this option with care, as deselecting ancillary drivers which
 	  are, in fact, necessary will result in the lack of the needed
 	  functionality for your device (it may not tune or may not have
-	  the need demodulers).
+	  the needed demodulators).
 
 	  If unsure say Y.
 
-comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
-
 source "drivers/media/i2c/Kconfig"
 source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
