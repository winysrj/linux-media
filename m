Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:52963 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZIJPEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 11:04:46 -0400
Content-Disposition: inline
From: iceberg <strakh@ispras.ru>
To: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] fix lock imbalances in /drivers/media/video/cafe_ccic.c
Date: Thu, 10 Sep 2009 18:37:34 +0000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909101837.34472.strakh@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In ./drivers/media/video/cafe_ccic.c, in function cafe_pci_probe: 
Mutex must be unlocked before exit
	1. On paths starting with mutex lock in line 1912, then continuing in lines: 
1929, 1936 (goto unreg) and 1940 (goto iounmap) . 
	2. On path starting in line 1971 mutex lock, and then continuing in line 1978 
(goto out_smbus) mutex.

Fix lock imbalances in function cafe_pci_probe.
Found by Linux Driver Verification project.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./a/drivers/media/video/cafe_ccic.c 
b/./b/drivers/media/video/cafe_ccic.c
index c4d181d..2987433 100644
--- a/./a/drivers/media/video/cafe_ccic.c
+++ b/./b/drivers/media/video/cafe_ccic.c
@@ -1925,19 +1925,24 @@ static int cafe_pci_probe(struct pci_dev *pdev,
         * Get set up on the PCI bus.
         */
        ret = pci_enable_device(pdev);
-       if (ret)
+       if (ret) {
+               mutex_unlock(&cam->s_mutex);
                goto out_unreg;
+       }
        pci_set_master(pdev);

        ret = -EIO;
        cam->regs = pci_iomap(pdev, 0, 0);
        if (! cam->regs) {
                printk(KERN_ERR "Unable to ioremap cafe-ccic regs\n");
+               mutex_unlock(&cam->s_mutex);
                goto out_unreg;
        }
        ret = request_irq(pdev->irq, cafe_irq, IRQF_SHARED, "cafe-ccic", cam);
-       if (ret)
+       if (ret) {
+               mutex_unlock(&cam->s_mutex);
                goto out_iounmap;
+       }
        /*
         * Initialize the controller and leave it powered up.  It will
         * stay that way until the sensor driver shows up.
@@ -1974,8 +1979,10 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 /*     cam->vdev.debug = V4L2_DEBUG_IOCTL_ARG;*/
        cam->vdev.v4l2_dev = &cam->v4l2_dev;
        ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-       if (ret)
+       if (ret) {
+               mutex_unlock(&cam->s_mutex);
                goto out_smbus;
+       }
        video_set_drvdata(&cam->vdev, cam);

        /*

