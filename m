Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56517 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbdCQSuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Date: Fri, 17 Mar 2017 12:48:12 -0600
Message-Id: <1489776503-3151-6-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 05/16] gpiolib: utilize new cdev_device_add helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the open coded registration of the cdev and dev with the
new device_add_cdev() helper. The helper replaces a common pattern by
taking the proper reference against the parent device and adding both
the cdev and the device.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8b4d721..3ce2a27 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1035,18 +1035,14 @@ static int gpiochip_setup_dev(struct gpio_device *gdev)
 
 	cdev_init(&gdev->chrdev, &gpio_fileops);
 	gdev->chrdev.owner = THIS_MODULE;
-	gdev->chrdev.kobj.parent = &gdev->dev.kobj;
 	gdev->dev.devt = MKDEV(MAJOR(gpio_devt), gdev->id);
-	status = cdev_add(&gdev->chrdev, gdev->dev.devt, 1);
-	if (status < 0)
-		chip_warn(gdev->chip, "failed to add char device %d:%d\n",
-			  MAJOR(gpio_devt), gdev->id);
-	else
-		chip_dbg(gdev->chip, "added GPIO chardev (%d:%d)\n",
-			 MAJOR(gpio_devt), gdev->id);
-	status = device_add(&gdev->dev);
+
+	status = cdev_device_add(&gdev->chrdev, &gdev->dev);
 	if (status)
-		goto err_remove_chardev;
+		return status;
+
+	chip_dbg(gdev->chip, "added GPIO chardev (%d:%d)\n",
+		 MAJOR(gpio_devt), gdev->id);
 
 	status = gpiochip_sysfs_register(gdev);
 	if (status)
@@ -1061,9 +1057,7 @@ static int gpiochip_setup_dev(struct gpio_device *gdev)
 	return 0;
 
 err_remove_device:
-	device_del(&gdev->dev);
-err_remove_chardev:
-	cdev_del(&gdev->chrdev);
+	cdev_device_del(&gdev->chrdev, &gdev->dev);
 	return status;
 }
 
@@ -1347,8 +1341,7 @@ void gpiochip_remove(struct gpio_chip *chip)
 	 * be removed, else it will be dangling until the last user is
 	 * gone.
 	 */
-	cdev_del(&gdev->chrdev);
-	device_del(&gdev->dev);
+	cdev_device_del(&gdev->chrdev, &gdev->dev);
 	put_device(&gdev->dev);
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
-- 
2.1.4
