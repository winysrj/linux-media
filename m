Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44493 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753814AbdCTOmp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:45 -0400
Subject: [PATCH 23/24] atomisp: remove a sysfs error message that can be
 used to log spam
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:42:41 +0000
Message-ID: <149002095116.17109.15579549438168736336.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of logging this just report ERANGE as an error, which will give something close to the
right user space report.

The others of these were already removed by Dan Carpenter's patch.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index 7f7c6d5..fcfe8d7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -107,9 +107,7 @@ static ssize_t iunit_dbglvl_store(struct device_driver *drv, const char *buf,
 	if (kstrtouint(buf, 10, &iunit_debug.dbglvl)
 		|| iunit_debug.dbglvl < 1
 		|| iunit_debug.dbglvl > 9) {
-		dev_err(atomisp_dev, "%s setting %d value invalid, should be [1,9]\n",
-			__func__, iunit_debug.dbglvl);
-		return -EINVAL;
+		return -ERANGE;
 	}
 	atomisp_css_debug_set_dtrace_level(iunit_debug.dbglvl);
 
