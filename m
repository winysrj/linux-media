Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab2HTUN3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 16:13:29 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KKDTaS001086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 16:13:29 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] flexcop: Show the item to enable debug after the driver
Date: Mon, 20 Aug 2012 17:13:25 -0300
Message-Id: <1345493605-29205-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of showing the option to show debug at the end, show
it after each driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/b2c2/Kconfig | 7 ++-----
 drivers/media/pci/b2c2/Kconfig    | 8 ++++++++
 drivers/media/usb/b2c2/Kconfig    | 8 ++++++++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/b2c2/Kconfig b/drivers/media/common/b2c2/Kconfig
index 29149de..1df9e57 100644
--- a/drivers/media/common/b2c2/Kconfig
+++ b/drivers/media/common/b2c2/Kconfig
@@ -23,9 +23,6 @@ config DVB_B2C2_FLEXCOP
 
 	  Say Y if you own such a device and want to use it.
 
+# Selected via the PCI or USB flexcop drivers
 config DVB_B2C2_FLEXCOP_DEBUG
-	bool "Enable debug for the B2C2 FlexCop drivers"
-	depends on DVB_B2C2_FLEXCOP
-	help
-	  Say Y if you want to enable the module option to control debug messages
-	  of all B2C2 FlexCop drivers.
+	bool
diff --git a/drivers/media/pci/b2c2/Kconfig b/drivers/media/pci/b2c2/Kconfig
index aaa1f30..78ced47 100644
--- a/drivers/media/pci/b2c2/Kconfig
+++ b/drivers/media/pci/b2c2/Kconfig
@@ -4,3 +4,11 @@ config DVB_B2C2_FLEXCOP_PCI
 	  Support for the Air/Sky/CableStar2 PCI card (DVB/ATSC) by Technisat/B2C2.
 
 	  Say Y if you own such a device and want to use it.
+
+config DVB_B2C2_FLEXCOP_PCI_DEBUG
+	bool "Enable debug for the B2C2 FlexCop drivers"
+	depends on DVB_B2C2_FLEXCOP_PCI
+	select DVB_B2C2_FLEXCOP_DEBUG
+	help
+	Say Y if you want to enable the module option to control debug messages
+	of all B2C2 FlexCop drivers.
diff --git a/drivers/media/usb/b2c2/Kconfig b/drivers/media/usb/b2c2/Kconfig
index 3af7c41..ba16583 100644
--- a/drivers/media/usb/b2c2/Kconfig
+++ b/drivers/media/usb/b2c2/Kconfig
@@ -4,3 +4,11 @@ config DVB_B2C2_FLEXCOP_USB
 	  Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by Technisat/B2C2,
 
 	  Say Y if you own such a device and want to use it.
+
+config DVB_B2C2_FLEXCOP_USB_DEBUG
+	bool "Enable debug for the B2C2 FlexCop drivers"
+	depends on DVB_B2C2_FLEXCOP_USB
+	select DVB_B2C2_FLEXCOP_DEBUG
+	   help
+	Say Y if you want to enable the module option to control debug messages
+	of all B2C2 FlexCop drivers.
-- 
1.7.11.4

