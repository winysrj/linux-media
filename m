Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2JQUCH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 16:02:07 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9HK27Vb032500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 16:02:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 3/3] [media] common/*/Kconfig: Remove unused helps
Date: Wed, 17 Oct 2012 17:01:58 -0300
Message-Id: <1350504118-8901-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1350504118-8901-1-git-send-email-mchehab@redhat.com>
References: <1350503193-8412-1-git-send-email-mchehab@redhat.com>
 <1350504118-8901-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those items don't have any menu anymore; they're auto-selected by
USB/PCI/MMC drivers. So, there's no sense on keeping any help
there anymore.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/b2c2/Kconfig  | 5 -----
 drivers/media/common/siano/Kconfig | 7 -------
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/common/b2c2/Kconfig b/drivers/media/common/b2c2/Kconfig
index 1df9e57..a8c6cdf 100644
--- a/drivers/media/common/b2c2/Kconfig
+++ b/drivers/media/common/b2c2/Kconfig
@@ -17,11 +17,6 @@ config DVB_B2C2_FLEXCOP
 	select DVB_CX24123 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_CX24113 if MEDIA_SUBDRV_AUTOSELECT
-	help
-	  Support for the digital TV receiver chip made by B2C2 Inc. included in
-	  Technisats PCI cards and USB boxes.
-
-	  Say Y if you own such a device and want to use it.
 
 # Selected via the PCI or USB flexcop drivers
 config DVB_B2C2_FLEXCOP_DEBUG
diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index 08d5b58..3cb7823 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -7,14 +7,7 @@ config SMS_SIANO_MDTV
 	depends on DVB_CORE && HAS_DMA
 	depends on SMS_USB_DRV || SMS_SDIO_DRV
 	default y
-	---help---
-	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
-
-	  To compile this driver as a module, choose M here
-	  (The module will be called smsmdtv).
 
-	  Further documentation on this driver can be found on the WWW
-	  at http://www.siano-ms.com/
 config SMS_SIANO_RC
 	bool "Enable Remote Controller support for Siano devices"
 	depends on SMS_SIANO_MDTV && RC_CORE
-- 
1.7.11.7

