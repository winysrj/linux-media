Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:55552 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbeACJ2C (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 04:28:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Hyungwoo Yang <hyungwoo.yang@intel.com>,
        Vijaykumar Ramya <ramya.vijaykumar@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: intel-ipu3: cio2: mark PM functions as __maybe_unused
Date: Wed,  3 Jan 2018 10:27:26 +0100
Message-Id: <20180103092747.1981583-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_PM is disabled, we get harmless warnings about the
suspend/resume callbacks being unused:

drivers/media/pci/intel/ipu3/ipu3-cio2.c:1993:12: error: 'cio2_resume' defined but not used [-Werror=unused-function]
drivers/media/pci/intel/ipu3/ipu3-cio2.c:1967:12: error: 'cio2_suspend' defined but not used [-Werror=unused-function]

This marks them as __maybe_unused to shut up the warnings.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 941caa987dab..c2f1447eec0b 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1964,7 +1964,7 @@ static void cio2_fbpt_rearrange(struct cio2_device *cio2, struct cio2_queue *q)
 		cio2_fbpt_entry_enable(cio2, q->fbpt + i * CIO2_MAX_LOPS);
 }
 
-static int cio2_suspend(struct device *dev)
+static int __maybe_unused cio2_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
@@ -1990,7 +1990,7 @@ static int cio2_suspend(struct device *dev)
 	return 0;
 }
 
-static int cio2_resume(struct device *dev)
+static int __maybe_unused cio2_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
-- 
2.9.0
