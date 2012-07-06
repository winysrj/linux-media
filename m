Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab2GFMQH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 08:16:07 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q66CG6sq011142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 6 Jul 2012 08:16:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] Kconfig: Split the core support options from the driver ones
Date: Fri,  6 Jul 2012 09:16:00 -0300
Message-Id: <1341576960-19782-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better arrange the remote controller driver items to happen after the
core support, on their proper menus, and making clerarer what is media
core options and what is media driver options.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig    |    3 ++-
 drivers/media/rc/Kconfig |   11 +++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 6d10ccb..d941581 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -59,7 +59,7 @@ config MEDIA_RADIO_SUPPORT
 		support radio reception. Disabling this option will
 		disable support for them.
 
-menuconfig MEDIA_RC_SUPPORT
+config MEDIA_RC_SUPPORT
 	bool "Remote Controller support"
 	depends on INPUT
 	---help---
@@ -138,6 +138,7 @@ config DVB_NET
 	  You may want to disable the network support on embedded devices. If
 	  unsure say Y.
 
+comment "Media drivers"
 source "drivers/media/common/Kconfig"
 source "drivers/media/rc/Kconfig"
 
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d2655f1..2478b06 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -4,6 +4,14 @@ config RC_CORE
 	depends on INPUT
 	default y
 
+source "drivers/media/rc/keymaps/Kconfig"
+
+menuconfig RC_DECODERS
+        bool "Remote controller decoders"
+	depends on RC_CORE
+	default y
+
+if RC_DECODERS
 config LIRC
 	tristate "LIRC interface driver"
 	depends on RC_CORE
@@ -15,8 +23,6 @@ config LIRC
 	   LIRC daemon handles protocol decoding for IR reception and
 	   encoding for IR transmitting (aka "blasting").
 
-source "drivers/media/rc/keymaps/Kconfig"
-
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
 	depends on RC_CORE
@@ -99,6 +105,7 @@ config IR_MCE_KBD_DECODER
 	   Enable this option if you have a Microsoft Remote Keyboard for
 	   Windows Media Center Edition, which you would like to use with
 	   a raw IR receiver in your system.
+endif #RC_DECODERS
 
 menuconfig RC_DEVICES
 	bool "Remote Controller devices"
-- 
1.7.10.4

