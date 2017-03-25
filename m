Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35976 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937094AbdCYCzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 22:55:47 -0400
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com, robsonde@gmail.com, dan.carpenter@oracle.com,
        jeremy.lefaure@lse.epita.fr, rvarsha016@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: atomisp - octal permissions, style fix
Date: Sat, 25 Mar 2017 15:55:32 +1300
Message-Id: <20170325025532.20685-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed permissions to octal style
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c | 9 +++------
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c       | 8 ++++----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index fcfe8d7190b0..763bc5f2a033 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -163,12 +163,9 @@ static ssize_t iunit_dbgopt_store(struct device_driver *drv, const char *buf,
 }
 
 static struct driver_attribute iunit_drvfs_attrs[] = {
-	__ATTR(dbglvl, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH, iunit_dbglvl_show,
-		iunit_dbglvl_store),
-	__ATTR(dbgfun, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH, iunit_dbgfun_show,
-		iunit_dbgfun_store),
-	__ATTR(dbgopt, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH, iunit_dbgopt_show,
-		iunit_dbgopt_store),
+	__ATTR(dbglvl, 0644, iunit_dbglvl_show, iunit_dbglvl_store),
+	__ATTR(dbgfun, 0644, iunit_dbgfun_show, iunit_dbgfun_store),
+	__ATTR(dbgopt, 0644, iunit_dbgopt_show, iunit_dbgopt_store),
 };
 
 static int iunit_drvfs_create_files(struct pci_driver *drv)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index a362b492ec8e..edf554e8e96e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -161,10 +161,10 @@ static ssize_t dynamic_pool_show(struct device *dev,
 	return ret;
 };
 
-static DEVICE_ATTR(active_bo, S_IRUGO, active_bo_show, NULL);
-static DEVICE_ATTR(free_bo, S_IRUGO, free_bo_show, NULL);
-static DEVICE_ATTR(reserved_pool, S_IRUGO, reserved_pool_show, NULL);
-static DEVICE_ATTR(dynamic_pool, S_IRUGO, dynamic_pool_show, NULL);
+static DEVICE_ATTR(active_bo, 0444, active_bo_show, NULL);
+static DEVICE_ATTR(free_bo, 0444, free_bo_show, NULL);
+static DEVICE_ATTR(reserved_pool, 0444, reserved_pool_show, NULL);
+static DEVICE_ATTR(dynamic_pool, 0444, dynamic_pool_show, NULL);
 
 static struct attribute *sysfs_attrs_ctrl[] = {
 	&dev_attr_active_bo.attr,
-- 
2.12.0
