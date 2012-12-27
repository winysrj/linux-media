Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab2L0QxK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 11:53:10 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBRGrAW5006443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 11:53:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] ttpci: Fix a missing Kconfig dependency
Date: Thu, 27 Dec 2012 14:52:41 -0200
Message-Id: <1356627162-27815-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a Kconfig warning that appears with allmodconfig on arm:

	warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig           | 6 ++++++
 drivers/media/pci/ttpci/Kconfig | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 4ef0d80..4d9b4c2 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -135,6 +135,12 @@ config DVB_NET
 	  You may want to disable the network support on embedded devices. If
 	  unsure say Y.
 
+# This Kconfig option is used by both PCI and USB drivers
+config TTPCI_EEPROM
+        tristate
+        depends on I2C
+        default n
+
 source "drivers/media/dvb-core/Kconfig"
 
 comment "Media drivers"
diff --git a/drivers/media/pci/ttpci/Kconfig b/drivers/media/pci/ttpci/Kconfig
index 314e417..0dcb8cd 100644
--- a/drivers/media/pci/ttpci/Kconfig
+++ b/drivers/media/pci/ttpci/Kconfig
@@ -1,8 +1,3 @@
-config TTPCI_EEPROM
-	tristate
-	depends on I2C
-	default n
-
 config DVB_AV7110
 	tristate "AV7110 cards"
 	depends on DVB_CORE && PCI && I2C
-- 
1.7.11.7

