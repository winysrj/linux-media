Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56541 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751309AbdCQSua (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 14:50:30 -0400
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
Date: Fri, 17 Mar 2017 12:48:15 -0600
Message-Id: <1489776503-3151-9-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 08/16] IB/ucm: utilize new cdev_device_add helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

The use after free is not triggerable here because the cdev holds
the module lock and the only device_unregister is only triggered by
module unload, however make the change for consistency.

To make this work the cdev_del needs to move out of the struct device
release function.

This cleans up the error path significantly and thus also fixes a minor
bug where the devnum would not be released if cdev_add failed.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/ucm.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index cc0d51f..d15efa4 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1205,12 +1205,15 @@ static void ib_ucm_release_dev(struct device *dev)
 	struct ib_ucm_device *ucm_dev;
 
 	ucm_dev = container_of(dev, struct ib_ucm_device, dev);
-	cdev_del(&ucm_dev->cdev);
+	kfree(ucm_dev);
+}
+
+static void ib_ucm_free_dev(struct ib_ucm_device *ucm_dev)
+{
 	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
 		clear_bit(ucm_dev->devnum, dev_map);
 	else
 		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map);
-	kfree(ucm_dev);
 }
 
 static const struct file_operations ucm_fops = {
@@ -1266,7 +1269,9 @@ static void ib_ucm_add_one(struct ib_device *device)
 	if (!ucm_dev)
 		return;
 
+	device_initialize(&ucm_dev->dev);
 	ucm_dev->ib_dev = device;
+	ucm_dev->dev.release = ib_ucm_release_dev;
 
 	devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
 	if (devnum >= IB_UCM_MAX_DEVICES) {
@@ -1286,16 +1291,14 @@ static void ib_ucm_add_one(struct ib_device *device)
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
 	kobject_set_name(&ucm_dev->cdev.kobj, "ucm%d", ucm_dev->devnum);
-	if (cdev_add(&ucm_dev->cdev, base, 1))
-		goto err;
 
 	ucm_dev->dev.class = &cm_class;
 	ucm_dev->dev.parent = device->dev.parent;
-	ucm_dev->dev.devt = ucm_dev->cdev.dev;
-	ucm_dev->dev.release = ib_ucm_release_dev;
+	ucm_dev->dev.devt = base;
+
 	dev_set_name(&ucm_dev->dev, "ucm%d", ucm_dev->devnum);
-	if (device_register(&ucm_dev->dev))
-		goto err_cdev;
+	if (cdev_device_add(&ucm_dev->cdev, &ucm_dev->dev))
+		goto err_devnum;
 
 	if (device_create_file(&ucm_dev->dev, &dev_attr_ibdev))
 		goto err_dev;
@@ -1304,15 +1307,11 @@ static void ib_ucm_add_one(struct ib_device *device)
 	return;
 
 err_dev:
-	device_unregister(&ucm_dev->dev);
-err_cdev:
-	cdev_del(&ucm_dev->cdev);
-	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
-		clear_bit(devnum, dev_map);
-	else
-		clear_bit(devnum, overflow_map);
+	cdev_device_del(&ucm_dev->cdev, &ucm_dev->dev);
+err_devnum:
+	ib_ucm_free_dev(ucm_dev);
 err:
-	kfree(ucm_dev);
+	put_device(&ucm_dev->dev);
 	return;
 }
 
@@ -1323,7 +1322,9 @@ static void ib_ucm_remove_one(struct ib_device *device, void *client_data)
 	if (!ucm_dev)
 		return;
 
-	device_unregister(&ucm_dev->dev);
+	cdev_device_del(&ucm_dev->cdev, &ucm_dev->dev);
+	ib_ucm_free_dev(ucm_dev);
+	put_device(&ucm_dev->dev);
 }
 
 static CLASS_ATTR_STRING(abi_version, S_IRUGO,
-- 
2.1.4
