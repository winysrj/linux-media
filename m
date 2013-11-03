Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51833 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KCAqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:46:13 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1VclpU-0001v6-Nx
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:46:12 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 1B1FB140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:46:12 +0100 (CET)
Date: Sun, 3 Nov 2013 01:46:12 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/12] ddbridge: Kconfig and Makefile fixes to build latest
 ddbridge
Message-ID: <20131103004611.GP7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed Kconfig and Makefile to build latest version off ddbridge. It
adds support for the following devices:

  - Octopus DVB adapter
  - Octopus V3 DVB adapter
  - Octopus LE DVB adapter
  - Octopus OEM
  - Octopus Mini
  - Cine S2 V6 DVB adapter
  - Cine S2 V6.5 DVB adapter
  - Octopus CI
  - Octopus CI single
  - DVBCT V6.1 DVB adapter
  - DVB-C modulator
  - SaTiX-S2 V3 DVB adapter

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/pci/ddbridge/Kconfig  | 21 +++++++++++++++------
 drivers/media/pci/ddbridge/Makefile |  2 +-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index 44e5dc1..a30848f 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -6,13 +6,22 @@ config DVB_DDBRIDGE
 	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_STV0367DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA18212DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2843 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
-	  - Octopus PCIe Bridge
-	  - Octopus mini PCIe Bridge
-	  - Octopus LE
-	  - DuoFlex S2 Octopus
-	  - DuoFlex CT Octopus
-	  - cineS2(v6)
+	  - Octopus DVB adapter
+	  - Octopus V3 DVB adapter
+	  - Octopus LE DVB adapter
+	  - Octopus OEM
+	  - Octopus Mini
+	  - Cine S2 V6 DVB adapter
+	  - Cine S2 V6.5 DVB adapter
+	  - Octopus CI
+	  - Octopus CI single
+	  - DVBCT V6.1 DVB adapter
+	  - DVB-C modulator
+	  - SaTiX-S2 V3 DVB adapter
 
 	  Say Y if you own such a card and want to use it.
diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 7446c8b..c274b81 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the ddbridge device driver
 #
 
-ddbridge-objs := ddbridge-core.o
+ddbridge-objs := ddbridge-core.o ddbridge-i2c.o ddbridge-mod.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
-- 
1.8.4.2
