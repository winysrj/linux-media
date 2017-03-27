Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43445 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752292AbdC0PPO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:15:14 -0400
Subject: [PATCH 5/5] Staging: atomisp - octal permissions, style fix
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 27 Mar 2017 16:14:23 +0100
Message-ID: <149062766269.15399.5719790361622579594.stgit@rszulisx-mobl.ger.corp.intel.com>
In-Reply-To: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
References: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Derek Robson <robsonde@gmail.com>

Changed permissions to octal style
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |    9 +++------
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    8 ++++----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index fcfe8d7..1ae2358 100644
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
index 1f07c7a..151abf0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -160,10 +160,10 @@ static ssize_t dynamic_pool_show(struct device *dev,
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
