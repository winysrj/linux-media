Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34841 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdHaHtG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 03:49:06 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org
Subject: [PATCH] Staging: atomisp: constify driver_attribute
Date: Thu, 31 Aug 2017 13:18:37 +0530
Message-Id: <a6ed8285b5512f245f0950f2446b07b50c6843dd.1504165443.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

driver_attribute are not supposed to change at runtime.
Functions driver_create_file/driver_remove_file are working with
const driver_attribute. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index 1ae2358..9f74b2d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -162,7 +162,7 @@ static ssize_t iunit_dbgopt_store(struct device_driver *drv, const char *buf,
 	return size;
 }
 
-static struct driver_attribute iunit_drvfs_attrs[] = {
+static const struct driver_attribute iunit_drvfs_attrs[] = {
 	__ATTR(dbglvl, 0644, iunit_dbglvl_show, iunit_dbglvl_store),
 	__ATTR(dbgfun, 0644, iunit_dbgfun_show, iunit_dbgfun_store),
 	__ATTR(dbgopt, 0644, iunit_dbgopt_show, iunit_dbgopt_store),
-- 
1.9.1
