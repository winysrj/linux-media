Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:26304 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZESA6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 20:58:24 -0400
Date: Mon, 18 May 2009 18:00:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Subject: [PATCH] media: one kconfig controls them all
Message-Id: <20090518180034.cc38cb53.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Add a kconfig symbol that allows someone to disable all
multimedia config options at one time.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/Kconfig |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- lnx-2630-rc3.orig/drivers/media/Kconfig
+++ lnx-2630-rc3/drivers/media/Kconfig
@@ -2,8 +2,14 @@
 # Multimedia device configuration
 #
 
-menu "Multimedia devices"
+menuconfig MEDIA_SUPPORT
+	tristate "Multimedia support"
 	depends on HAS_IOMEM
+	help
+	  If you want to use Video for Linux, DVB for Linux, or DAB adapters,
+	  enable this option and other options below.
+
+if MEDIA_SUPPORT
 
 comment "Multimedia core support"
 
@@ -136,4 +142,4 @@ config USB_DABUSB
 	  module will be called dabusb.
 endif # DAB
 
-endmenu
+endif # MEDIA_SUPPORT
