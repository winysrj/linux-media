Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56495 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbdCQSuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 14:50:25 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-mtd@lists.infradead.org,
        linux-media@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>
Date: Fri, 17 Mar 2017 12:48:18 -0600
Message-Id: <1489776503-3151-12-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 11/16] media: utilize new cdev_device_add helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the open coded registration of the cdev and dev with the
new device_add_cdev() helper. The helper replaces a common pattern by
taking the proper reference against the parent device and adding both
the cdev and the device.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-core.c  | 16 ++++------------
 drivers/media/media-devnode.c | 20 +++++---------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 37217e2..3163e03 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -137,24 +137,17 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &cec_devnode_fops);
-	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 	devnode->cdev.owner = owner;
 
-	ret = cdev_add(&devnode->cdev, devnode->dev.devt, 1);
-	if (ret < 0) {
-		pr_err("%s: cdev_add failed\n", __func__);
+	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
+	if (ret) {
+		pr_err("%s: cdev_device_add failed\n", __func__);
 		goto clr_bit;
 	}
 
-	ret = device_add(&devnode->dev);
-	if (ret)
-		goto cdev_del;
-
 	devnode->registered = true;
 	return 0;
 
-cdev_del:
-	cdev_del(&devnode->cdev);
 clr_bit:
 	mutex_lock(&cec_devnode_lock);
 	clear_bit(devnode->minor, cec_devnode_nums);
@@ -190,8 +183,7 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	devnode->unregistered = true;
 	mutex_unlock(&devnode->lock);
 
-	device_del(&devnode->dev);
-	cdev_del(&devnode->cdev);
+	cdev_device_del(&devnode->cdev, &devnode->dev);
 	put_device(&devnode->dev);
 }
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ae46753..423248f 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -248,31 +248,22 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	dev_set_name(&devnode->dev, "media%d", devnode->minor);
 	device_initialize(&devnode->dev);
 
-	/* Part 2: Initialize and register the character device */
+	/* Part 2: Initialize the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
 	devnode->cdev.owner = owner;
-	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 
-	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
+	/* Part 3: Add the media and char device */
+	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
 	if (ret < 0) {
-		pr_err("%s: cdev_add failed\n", __func__);
+		pr_err("%s: cdev_device_add failed\n", __func__);
 		goto cdev_add_error;
 	}
 
-	/* Part 3: Add the media device */
-	ret = device_add(&devnode->dev);
-	if (ret < 0) {
-		pr_err("%s: device_add failed\n", __func__);
-		goto device_add_error;
-	}
-
 	/* Part 4: Activate this minor. The char device can now be used. */
 	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 
 	return 0;
 
-device_add_error:
-	cdev_del(&devnode->cdev);
 cdev_add_error:
 	mutex_lock(&media_devnode_lock);
 	clear_bit(devnode->minor, media_devnode_nums);
@@ -298,9 +289,8 @@ void media_devnode_unregister(struct media_devnode *devnode)
 {
 	mutex_lock(&media_devnode_lock);
 	/* Delete the cdev on this minor as well */
-	cdev_del(&devnode->cdev);
+	cdev_device_del(&devnode->cdev, &devnode->dev);
 	mutex_unlock(&media_devnode_lock);
-	device_del(&devnode->dev);
 	devnode->media_dev = NULL;
 	put_device(&devnode->dev);
 }
-- 
2.1.4
