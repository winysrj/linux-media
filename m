Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932518Ab0FCBXO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jun 2010 21:23:14 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 02:23:10 +0100
Message-ID: <1275528190.2870.84.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] V4L/DVB: mantis: Select correct frontends
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Kconfig selections to match the code.
Add the usual condition of !DVB_FE_CUSTOMISE.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/mantis/Kconfig |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/mantis/Kconfig b/drivers/media/dvb/mantis/Kconfig
index f7b72a3..decdeda 100644
--- a/drivers/media/dvb/mantis/Kconfig
+++ b/drivers/media/dvb/mantis/Kconfig
@@ -10,9 +10,15 @@ config MANTIS_CORE
 config DVB_MANTIS
 	tristate "MANTIS based cards"
 	depends on MANTIS_CORE && DVB_CORE && PCI && I2C
-	select DVB_MB86A16
-	select DVB_ZL10353
-	select DVB_STV0299
+	select DVB_MB86A16 if !DVB_FE_CUSTOMISE
+	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
+	select DVB_STB0899 if !DVB_FE_CUSTOMISE
+	select DVB_STB6100 if !DVB_FE_CUSTOMISE
+	select DVB_TDA665x if !DVB_FE_CUSTOMISE
+	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
+	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select DVB_PLL
 	help
 	  Support for PCI cards based on the Mantis PCI bridge.
@@ -23,7 +29,7 @@ config DVB_MANTIS
 config DVB_HOPPER
 	tristate "HOPPER based cards"
 	depends on MANTIS_CORE && DVB_CORE && PCI && I2C
-	select DVB_ZL10353
+	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select DVB_PLL
 	help
 	  Support for PCI cards based on the Hopper  PCI bridge.
-- 
1.7.1


