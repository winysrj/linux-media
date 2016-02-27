Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50103 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbcB0KsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:48:01 -0500
Date: Sat, 27 Feb 2016 13:47:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] v4l2-mc: using logical instead of bitwise OR
Message-ID: <20160227104752.GC14086@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We intended to do a bitwise OR here but there is a typo so we do a
logical || instead.

Fixes: 7047f2982a22 ('[media] v4l2-mc: add an ancillary routine for PCI-based MC')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index a7f41b3..523998a 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -40,8 +40,8 @@ struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
 
 	sprintf(mdev->bus_info, "PCI:%s", pci_name(pci_dev));
 
-	mdev->hw_revision = pci_dev->subsystem_vendor << 16
-			    || pci_dev->subsystem_device;
+	mdev->hw_revision = pci_dev->subsystem_vendor << 16 |
+			    pci_dev->subsystem_device;
 
 	mdev->driver_version = LINUX_VERSION_CODE;
 
