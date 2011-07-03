Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56312 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751329Ab1GCV2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 17:28:15 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] ddbridge: Allow compiling of the driver
Date: Sun, 3 Jul 2011 23:25:29 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107032321.46092@orion.escape-edv.de>
In-Reply-To: <201107032321.46092@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107032325.30206@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Driver added to Makefile and Kconfig.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/Kconfig           |    4 ++++
 drivers/media/dvb/Makefile          |    3 ++-
 drivers/media/dvb/ddbridge/Kconfig  |   18 ++++++++++++++++++
 drivers/media/dvb/ddbridge/Makefile |   14 ++++++++++++++
 4 files changed, 38 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/dvb/ddbridge/Kconfig
 create mode 100644 drivers/media/dvb/ddbridge/Makefile

diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index ee214c3..f6e40b3 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -80,6 +80,10 @@ comment "Supported nGene Adapters"
 	depends on DVB_CORE && PCI && I2C
 	source "drivers/media/dvb/ngene/Kconfig"
 
+comment "Supported ddbridge ('Octopus') Adapters"
+	depends on DVB_CORE && PCI && I2C
+	source "drivers/media/dvb/ddbridge/Kconfig"
+
 comment "Supported DVB Frontends"
 	depends on DVB_CORE
 source "drivers/media/dvb/frontends/Kconfig"
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index a1a0875..b2cefe6 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -15,6 +15,7 @@ obj-y        := dvb-core/	\
 		dm1105/		\
 		pt1/		\
 		mantis/		\
-		ngene/
+		ngene/		\
+		ddbridge/
 
 obj-$(CONFIG_DVB_FIREDTV)	+= firewire/
diff --git a/drivers/media/dvb/ddbridge/Kconfig b/drivers/media/dvb/ddbridge/Kconfig
new file mode 100644
index 0000000..d099e1a
--- /dev/null
+++ b/drivers/media/dvb/ddbridge/Kconfig
@@ -0,0 +1,18 @@
+config DVB_DDBRIDGE
+	tristate "Digital Devices bridge support"
+	depends on DVB_CORE && PCI && I2C
+	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
+	select DVB_STV6110x if !DVB_FE_CUSTOMISE
+	select DVB_STV090x if !DVB_FE_CUSTOMISE
+	select DVB_DRXK if !DVB_FE_CUSTOMISE
+	select DVB_TDA18271C2DD if !DVB_FE_CUSTOMISE
+	---help---
+	  Support for cards with the Digital Devices PCI express bridge:
+	  - Octopus PCIe Bridge
+	  - Octopus mini PCIe Bridge
+	  - Octopus LE
+	  - DuoFlex S2 Octopus
+	  - DuoFlex CT Octopus
+	  - cineS2(v6)
+
+	  Say Y if you own such a card and want to use it.
diff --git a/drivers/media/dvb/ddbridge/Makefile b/drivers/media/dvb/ddbridge/Makefile
new file mode 100644
index 0000000..de4fe19
--- /dev/null
+++ b/drivers/media/dvb/ddbridge/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the ddbridge device driver
+#
+
+ddbridge-objs := ddbridge-core.o
+
+obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
+
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
+EXTRA_CFLAGS += -Idrivers/media/dvb/frontends/
+EXTRA_CFLAGS += -Idrivers/media/common/tuners/
+
+# For the staging CI driver cxd2099
+EXTRA_CFLAGS += -Idrivers/staging/cxd2099/
-- 
1.7.4.1

