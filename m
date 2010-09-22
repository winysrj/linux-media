Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42807 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab0IVKjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 06:39:11 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o8MAdBaH010393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 05:39:11 -0500
From: x0130808@ti.com
To: linux-media@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
	Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 9/9] Staging:ti-st: Update Kconfig and Makefile for
Date: Wed, 22 Sep 2010 07:50:02 -0400
Message-Id: <1285156202-28569-10-git-send-email-x0130808@ti.com>
In-Reply-To: <1285156202-28569-9-git-send-email-x0130808@ti.com>
References: <1285156202-28569-1-git-send-email-x0130808@ti.com>
 <1285156202-28569-2-git-send-email-x0130808@ti.com>
 <1285156202-28569-3-git-send-email-x0130808@ti.com>
 <1285156202-28569-4-git-send-email-x0130808@ti.com>
 <1285156202-28569-5-git-send-email-x0130808@ti.com>
 <1285156202-28569-6-git-send-email-x0130808@ti.com>
 <1285156202-28569-7-git-send-email-x0130808@ti.com>
 <1285156202-28569-8-git-send-email-x0130808@ti.com>
 <1285156202-28569-9-git-send-email-x0130808@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Raja Mani <raja_mani@ti.com>

Add new menu option in Kconfig and compilation option in Makefile for
TI FM driver.

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/staging/ti-st/Kconfig  |    8 ++++++++
 drivers/staging/ti-st/Makefile |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ti-st/Kconfig b/drivers/staging/ti-st/Kconfig
index 1b264a3..7e48749 100644
--- a/drivers/staging/ti-st/Kconfig
+++ b/drivers/staging/ti-st/Kconfig
@@ -23,4 +23,12 @@ config ST_BT
 	  This makes use of shared transport line discipline core driver to
 	  communicate with the BT core of the combo chip.
 
+config ST_FM
+	tristate "fm driver for ST"
+	depends on VIDEO_DEV
+	select TI_ST
+	help
+	  This enables the FM driver for TI BT/FM/GPS combo devices
+	  This makes use of shared transport line discipline core driver to
+	  communicate with the FM core of the combo chip.
 endmenu
diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
index 0167d1d..bd29c83 100644
--- a/drivers/staging/ti-st/Makefile
+++ b/drivers/staging/ti-st/Makefile
@@ -5,3 +5,5 @@
 obj-$(CONFIG_TI_ST) 		+= st_drv.o
 st_drv-objs			:= st_core.o st_kim.o st_ll.o
 obj-$(CONFIG_ST_BT) 		+= bt_drv.o
+obj-$(CONFIG_ST_FM) 		+= fm_drv.o
+fm_drv-objs     		:= fmdrv_common.o fmdrv_rx.o fmdrv_tx.o fmdrv_v4l2.o
-- 
1.5.6.3

