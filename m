Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24235 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752377AbdLSVAE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:00:04 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 06/10] staging: atomisp: Switch to use struct device_driver directly
Date: Tue, 19 Dec 2017 22:59:53 +0200
Message-Id: <20171219205957.10933-6-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In a preparation of split PCI glue driver from core part, convert
the driver to use more generic struct device_driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c  | 17 ++++++++---------
 .../staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h  |  5 ++---
 .../staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c   |  4 +---
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index 7129b88456cb..ceedb82b6beb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -15,9 +15,9 @@
  *
  */
 
+#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 
 #include "atomisp_compat.h"
 #include "atomisp_internal.h"
@@ -33,7 +33,7 @@
  *        bit 2: memory statistic
 */
 struct _iunit_debug {
-	struct pci_driver	*drv;
+	struct device_driver	*drv;
 	struct atomisp_device	*isp;
 	unsigned int		dbglvl;
 	unsigned int		dbgfun;
@@ -164,26 +164,25 @@ static const struct driver_attribute iunit_drvfs_attrs[] = {
 	__ATTR(dbgopt, 0644, iunit_dbgopt_show, iunit_dbgopt_store),
 };
 
-static int iunit_drvfs_create_files(struct pci_driver *drv)
+static int iunit_drvfs_create_files(struct device_driver *drv)
 {
 	int i, ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(iunit_drvfs_attrs); i++)
-		ret |= driver_create_file(&(drv->driver),
-					&iunit_drvfs_attrs[i]);
+		ret |= driver_create_file(drv, &iunit_drvfs_attrs[i]);
 
 	return ret;
 }
 
-static void iunit_drvfs_remove_files(struct pci_driver *drv)
+static void iunit_drvfs_remove_files(struct device_driver *drv)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(iunit_drvfs_attrs); i++)
-		driver_remove_file(&(drv->driver), &iunit_drvfs_attrs[i]);
+		driver_remove_file(drv, &iunit_drvfs_attrs[i]);
 }
 
-int atomisp_drvfs_init(struct pci_driver *drv, struct atomisp_device *isp)
+int atomisp_drvfs_init(struct device_driver *drv, struct atomisp_device *isp)
 {
 	int ret;
 
@@ -193,7 +192,7 @@ int atomisp_drvfs_init(struct pci_driver *drv, struct atomisp_device *isp)
 	ret = iunit_drvfs_create_files(iunit_debug.drv);
 	if (ret) {
 		dev_err(atomisp_dev, "drvfs_create_files error: %d\n", ret);
-		iunit_drvfs_remove_files(drv);
+		iunit_drvfs_remove_files(iunit_debug.drv);
 	}
 
 	return ret;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h
index b91bfef21639..7c99240d107a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h
@@ -18,8 +18,7 @@
 #ifndef	__ATOMISP_DRVFS_H__
 #define	__ATOMISP_DRVFS_H__
 
-extern int atomisp_drvfs_init(struct pci_driver *drv, struct atomisp_device
-				*isp);
-extern void atomisp_drvfs_exit(void);
+int atomisp_drvfs_init(struct device_driver *drv, struct atomisp_device *isp);
+void atomisp_drvfs_exit(void);
 
 #endif /* __ATOMISP_DRVFS_H__ */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 3c260f8b52e2..7a9efc6847ca 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1152,8 +1152,6 @@ static int init_atomisp_wdts(struct atomisp_device *isp)
 	return err;
 }
 
-static struct pci_driver atomisp_pci_driver;
-
 #define ATOM_ISP_PCI_BAR	0
 
 static int atomisp_pci_probe(struct pci_dev *dev,
@@ -1451,7 +1449,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	isp->firmware = NULL;
 	isp->css_env.isp_css_fw.data = NULL;
 
-	atomisp_drvfs_init(&atomisp_pci_driver, isp);
+	atomisp_drvfs_init(&dev->driver->driver, isp);
 
 	return 0;
 
-- 
2.15.1
