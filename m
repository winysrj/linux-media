Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56459 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdFYMcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:53 -0400
Subject: [PATCH 19/19] lirc_dev: consistent device registration printk
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:51 +0200
Message-ID: <149839397127.28811.15601147061333876867.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes the message that is printed on lirc device registration to
make it more consistent with the input and rc subsystems.

Before:
  rc rc0: rc-core loopback device as /devices/virtual/rc/rc0
  input: rc-core loopback device as /devices/virtual/rc/rc0/input43
  lirc lirc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registered at minor = 0

After:
  rc rc0: rc-core loopback device as /devices/virtual/rc/rc0
  input: rc-core loopback device as /devices/virtual/rc/rc0/input23
  lirc lirc0: rc-core loopback device as /devices/virtual/rc/rc0/lirc0

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |    3 +--
 drivers/media/rc/lirc_dev.c      |    6 ++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 05f88401f694..4f33516a95a3 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -595,8 +595,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (dev->max_timeout)
 		features |= LIRC_CAN_SET_REC_TIMEOUT;
 
-	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
-		 dev->driver_name);
+	snprintf(ldev->name, sizeof(ldev->name), "%s", dev->input_name);
 	ldev->features = features;
 	ldev->data = &dev->raw->lirc;
 	ldev->buf = NULL;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index c1c917932f7e..03430a1fb192 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -105,6 +105,7 @@ int lirc_register_device(struct lirc_dev *d)
 {
 	int minor;
 	int err;
+	const char *path;
 
 	if (!d) {
 		pr_err("driver pointer must be not NULL!\n");
@@ -171,8 +172,9 @@ int lirc_register_device(struct lirc_dev *d)
 		return err;
 	}
 
-	dev_info(&d->dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 d->name, d->minor);
+	path = kobject_get_path(&d->dev.kobj, GFP_KERNEL);
+	dev_info(&d->dev, "%s as %s\n", d->name, path ?: "N/A");
+	kfree(path);
 
 	return 0;
 }
