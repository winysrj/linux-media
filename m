Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab2JQTqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 15:46:36 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9HJkaUs026323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 15:46:36 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] Kconfig: Fix dependencies for driver autoselect options
Date: Wed, 17 Oct 2012 16:46:32 -0300
Message-Id: <1350503193-8412-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This option is a merge of both analog TV and DVB CUSTOMISE.

At the merge, the dependencies were not done right: the menu
currently appears only for analog TV. It should also be opened
for digital TV. As there are other I2C devices there (flash
devices, etc) that aren't related to either one, it is better
to make it generic enough to open for all media devices with
video.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index dd13e3a..4ef0d80 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -163,19 +163,21 @@ source "drivers/media/common/Kconfig"
 #
 
 config MEDIA_SUBDRV_AUTOSELECT
-	bool "Autoselect analog and hybrid tuner modules to build"
-	depends on MEDIA_TUNER
+	bool "Autoselect tuners and i2c modules to build"
+	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT
 	default y
 	help
-	  By default, a TV driver auto-selects all possible tuners
-	  thar could be used by the driver.
+	  By default, a media driver auto-selects all possible i2c
+	  devices that are used by any of the supported devices.
 
 	  This is generally the right thing to do, except when there
-	  are strict constraints with regards to the kernel size.
+	  are strict constraints with regards to the kernel size,
+	  like on embedded systems.
 
-	  Use this option with care, as deselecting tuner drivers which
-	  are in fact necessary will result in TV devices which cannot
-	  be tuned due to lack of the tuning driver.
+	  Use this option with care, as deselecting ancillary drivers which
+	  are, in fact, necessary will result in the lack of the needed
+	  functionality for your device (it may not tune or may not have
+	  the need demodulers).
 
 	  If unsure say Y.
 
-- 
1.7.11.7

