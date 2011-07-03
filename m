Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56378 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751069Ab1GCV2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 17:28:16 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] cxd2099: Update Kconfig description (ddbridge support)
Date: Sun, 3 Jul 2011 23:27:51 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107032321.46092@orion.escape-edv.de>
In-Reply-To: <201107032321.46092@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107032327.52762@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Update Kconfig description (ddbridge with cxd2099)

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/staging/cxd2099/Kconfig |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cxd2099/Kconfig b/drivers/staging/cxd2099/Kconfig
index 9d638c3..b48aefd 100644
--- a/drivers/staging/cxd2099/Kconfig
+++ b/drivers/staging/cxd2099/Kconfig
@@ -1,9 +1,10 @@
 config DVB_CXD2099
-        tristate "CXD2099AR Common Interface driver"
-        depends on DVB_CORE && PCI && I2C && DVB_NGENE
-        ---help---
-          Support for the CI module found on cineS2 DVB-S2, supported by
-	  the Micronas PCIe device driver (ngene).
+	tristate "CXD2099AR Common Interface driver"
+	depends on DVB_CORE && PCI && I2C
+	---help---
+	  Support for the CI module found on cards based on
+	  - Micronas ngene PCIe bridge: cineS2 etc.
+	  - Digital Devices PCIe bridge: Octopus series
 
 	  For now, data is passed through '/dev/dvb/adapterX/sec0':
 	    - Encrypted data must be written to 'sec0'.
-- 
1.7.4.1

