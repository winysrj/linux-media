Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41662 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaCCRBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 12:01:03 -0500
Received: by mail-pa0-f47.google.com with SMTP id lj1so4025354pab.20
        for <linux-media@vger.kernel.org>; Mon, 03 Mar 2014 09:01:03 -0800 (PST)
From: Jon Mason <jdmason@kudzu.us>
To: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] staging/dt3155v4l: use PCI_VENDOR_ID_INTEL
Date: Mon,  3 Mar 2014 10:00:38 -0700
Message-Id: <1393866038-15778-1-git-send-email-jdmason@kudzu.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use PCI_VENDOR_ID_INTEL instead of creating its own vendor ID #define.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index e729e52..ef4e2aa 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -31,7 +31,6 @@
 
 #include "dt3155v4l.h"
 
-#define DT3155_VENDOR_ID 0x8086
 #define DT3155_DEVICE_ID 0x1223
 
 /* DT3155_CHUNK_SIZE is 4M (2^22) 8 full size buffers */
@@ -975,7 +974,7 @@ dt3155_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id pci_ids[] = {
-	{ PCI_DEVICE(DT3155_VENDOR_ID, DT3155_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, DT3155_DEVICE_ID) },
 	{ 0, /* zero marks the end */ },
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
-- 
1.7.10.4

