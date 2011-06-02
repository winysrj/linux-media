Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51772 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1FBWbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 18:31:14 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
	<arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 6/6] msm: iommu: move to dedicated iommu drivers folder
Date: Fri,  3 Jun 2011 01:27:43 +0300
Message-Id: <1307053663-24572-7-git-send-email-ohad@wizery.com>
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This should ease finding similarities with other platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-msm/Kconfig                          |   12 ------------
 arch/arm/mach-msm/Makefile                         |    2 +-
 drivers/iommu/Kconfig                              |   11 +++++++++++
 drivers/iommu/Makefile                             |    1 +
 .../mach-msm/iommu.c => drivers/iommu/msm-iommu.c  |    0
 5 files changed, 13 insertions(+), 13 deletions(-)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm-iommu.c (100%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index efb7b7d..14ebda1 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -148,18 +148,6 @@ config MACH_MSM8960_RUMI3
 
 endmenu
 
-config MSM_IOMMU
-	bool "MSM IOMMU Support"
-	depends on ARCH_MSM8X60 || ARCH_MSM8960
-	select IOMMU_API
-	default n
-	help
-	  Support for the IOMMUs found on certain Qualcomm SOCs.
-	  These IOMMUs allow virtualization of the address space used by most
-	  cores within the multimedia subsystem.
-
-	  If unsure, say N here.
-
 config IOMMU_PGTABLES_L2
 	def_bool y
 	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9519fd2..0bf4648 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -3,7 +3,7 @@ obj-y += clock.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
-obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
+obj-$(CONFIG_MSM_IOMMU) += iommu_dev.o devices-iommu.o
 
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 57378ac..e083ff0 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -19,3 +19,14 @@ config OMAP_IOMMU_DEBUG
          the internal state of OMAP IOMMU in debugfs.
 
          Say N unless you know you need this.
+
+config MSM_IOMMU
+	bool "MSM IOMMU Support"
+	depends on ARCH_MSM8X60 || ARCH_MSM8960
+	select IOMMU_API
+	help
+	  Support for the IOMMUs found on certain Qualcomm SOCs.
+	  These IOMMUs allow virtualization of the address space used by most
+	  cores within the multimedia subsystem.
+
+	  If unsure, say N here.
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index c094875..bfb000a 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
+obj-$(CONFIG_MSM_IOMMU) += msm-iommu.o
diff --git a/arch/arm/mach-msm/iommu.c b/drivers/iommu/msm-iommu.c
similarity index 100%
rename from arch/arm/mach-msm/iommu.c
rename to drivers/iommu/msm-iommu.c
-- 
1.7.1

