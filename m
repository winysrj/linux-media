Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56506 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbdCQSuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Date: Fri, 17 Mar 2017 12:48:17 -0600
Message-Id: <1489776503-3151-11-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 10/16] iio:core: utilize new cdev_device_add helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the open coded registration of the cdev and dev with the
new device_add_cdev() helper. The helper replaces a common pattern by
taking the proper reference against the parent device and adding both
the cdev and the device.

In doing so we have to remove a guard statement from cdev_del,
but this doesn't appear to be required in any way.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/iio/industrialio-core.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index d18ded4..26a03c6 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1720,18 +1720,13 @@ int iio_device_register(struct iio_dev *indio_dev)
 
 	cdev_init(&indio_dev->chrdev, &iio_buffer_fileops);
 	indio_dev->chrdev.owner = indio_dev->info->driver_module;
-	indio_dev->chrdev.kobj.parent = &indio_dev->dev.kobj;
-	ret = cdev_add(&indio_dev->chrdev, indio_dev->dev.devt, 1);
-	if (ret < 0)
-		goto error_unreg_eventset;
 
-	ret = device_add(&indio_dev->dev);
+	ret = cdev_device_add(&indio_dev->chrdev, &indio_dev->dev);
 	if (ret < 0)
-		goto error_cdev_del;
+		goto error_unreg_eventset;
 
 	return 0;
-error_cdev_del:
-	cdev_del(&indio_dev->chrdev);
+
 error_unreg_eventset:
 	iio_device_unregister_eventset(indio_dev);
 error_free_sysfs:
@@ -1752,10 +1747,8 @@ void iio_device_unregister(struct iio_dev *indio_dev)
 {
 	mutex_lock(&indio_dev->info_exist_lock);
 
-	device_del(&indio_dev->dev);
+	cdev_device_del(&indio_dev->chrdev, &indio_dev->dev);
 
-	if (indio_dev->chrdev.dev)
-		cdev_del(&indio_dev->chrdev);
 	iio_device_unregister_debugfs(indio_dev);
 
 	iio_disable_all_buffers(indio_dev);
-- 
2.1.4
