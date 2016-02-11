Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcBKQEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 11:04:39 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] [media] rc-core: don't lock device at rc_register_device()
Date: Thu, 11 Feb 2016 14:03:15 -0200
Message-Id: <63bc60a7a76f3946508b4958d9156bdfcde6d323.1455206587.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex lock at rc_register_device() was added by commit 08aeb7c9a42a
("[media] rc: add locking to fix register/show race").

It is meant to avoid race issues when trying to open a sysfs file while
the RC register didn't complete.

Adding a lock there causes troubles, as detected by the Kernel lock
debug instrumentation at the Kernel:

    ======================================================
    [ INFO: possible circular locking dependency detected ]
    4.5.0-rc3+ #46 Not tainted
    -------------------------------------------------------
    systemd-udevd/2681 is trying to acquire lock:
     (s_active#171){++++.+}, at: [<ffffffff8171a115>] kernfs_remove_by_name_ns+0x45/0xa0

    but task is already holding lock:
     (&dev->lock){+.+.+.}, at: [<ffffffffa0724def>] rc_register_device+0xb2f/0x1450 [rc_core]

    which lock already depends on the new lock.

    the existing dependency chain (in reverse order) is:

    -> #1 (&dev->lock){+.+.+.}:
           [<ffffffff8124817d>] lock_acquire+0x13d/0x320
           [<ffffffff822de966>] mutex_lock_nested+0xb6/0x860
           [<ffffffffa0721f2b>] show_protocols+0x3b/0x3f0 [rc_core]
           [<ffffffff81cdaba5>] dev_attr_show+0x45/0xc0
           [<ffffffff8171f1b3>] sysfs_kf_seq_show+0x203/0x3c0
           [<ffffffff8171a6a1>] kernfs_seq_show+0x121/0x1b0
           [<ffffffff81617c71>] seq_read+0x2f1/0x1160
           [<ffffffff8171c911>] kernfs_fop_read+0x321/0x460
           [<ffffffff815abc20>] __vfs_read+0xe0/0x3d0
           [<ffffffff815ae90e>] vfs_read+0xde/0x2d0
           [<ffffffff815b1d01>] SyS_read+0x111/0x230
           [<ffffffff822e8636>] entry_SYSCALL_64_fastpath+0x16/0x76

    -> #0 (s_active#171){++++.+}:
           [<ffffffff81244f24>] __lock_acquire+0x4304/0x5990
           [<ffffffff8124817d>] lock_acquire+0x13d/0x320
           [<ffffffff81717d3a>] __kernfs_remove+0x58a/0x810
           [<ffffffff8171a115>] kernfs_remove_by_name_ns+0x45/0xa0
           [<ffffffff81721592>] remove_files.isra.0+0x72/0x190
           [<ffffffff8172174b>] sysfs_remove_group+0x9b/0x150
           [<ffffffff81721854>] sysfs_remove_groups+0x54/0xa0
           [<ffffffff81cd97d0>] device_remove_attrs+0xb0/0x140
           [<ffffffff81cdb27c>] device_del+0x38c/0x6b0
           [<ffffffffa0724b8b>] rc_register_device+0x8cb/0x1450 [rc_core]
           [<ffffffffa1326a7b>] dvb_usb_remote_init+0x66b/0x14d0 [dvb_usb]
           [<ffffffffa1321c81>] dvb_usb_device_init+0xf21/0x1860 [dvb_usb]
           [<ffffffffa13517dc>] dib0700_probe+0x14c/0x410 [dvb_usb_dib0700]
           [<ffffffff81dbb1dd>] usb_probe_interface+0x45d/0x940
           [<ffffffff81ce7e7a>] driver_probe_device+0x21a/0xc30
           [<ffffffff81ce89b1>] __driver_attach+0x121/0x160
           [<ffffffff81ce21bf>] bus_for_each_dev+0x11f/0x1a0
           [<ffffffff81ce6cdd>] driver_attach+0x3d/0x50
           [<ffffffff81ce5df9>] bus_add_driver+0x4c9/0x770
           [<ffffffff81cea39c>] driver_register+0x18c/0x3b0
           [<ffffffff81db6e98>] usb_register_driver+0x1f8/0x440
           [<ffffffffa074001e>] dib0700_driver_init+0x1e/0x1000 [dvb_usb_dib0700]
           [<ffffffff810021b1>] do_one_initcall+0x141/0x300
           [<ffffffff8144d8eb>] do_init_module+0x1d0/0x5ad
           [<ffffffff812f27b6>] load_module+0x6666/0x9ba0
           [<ffffffff812f5fe8>] SyS_finit_module+0x108/0x130
           [<ffffffff822e8636>] entry_SYSCALL_64_fastpath+0x16/0x76

    other info that might help us debug this:

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(&dev->lock);
                                   lock(s_active#171);
                                   lock(&dev->lock);
      lock(s_active#171);

     *** DEADLOCK ***

    3 locks held by systemd-udevd/2681:
     #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>] __driver_attach+0xa3/0x160
     #1:  (&dev->mutex){......}, at: [<ffffffff81ce8941>] __driver_attach+0xb1/0x160
     #2:  (&dev->lock){+.+.+.}, at: [<ffffffffa0724def>] rc_register_device+0xb2f/0x1450 [rc_core]

In this specific case, some error happened during device init,
causing IR to be disabled.

Let's fix it by adding a var that will tell when the device is
initialized. Any calls before that will return a -EINVAL.

That should prevent the race issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/rc-main.c | 45 ++++++++++++++++++++++++++-------------------
 include/media/rc-core.h    |  2 ++
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1042fa331a07..dcf20d9cbe09 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -723,12 +723,18 @@ int rc_open(struct rc_dev *rdev)
 		return -EINVAL;
 
 	mutex_lock(&rdev->lock);
+	if (!rdev->initialized) {
+		rval = -EINVAL;
+		goto unlock;
+	}
+
 	if (!rdev->users++ && rdev->open != NULL)
 		rval = rdev->open(rdev);
 
 	if (rval)
 		rdev->users--;
 
+unlock:
 	mutex_unlock(&rdev->lock);
 
 	return rval;
@@ -874,6 +880,10 @@ static ssize_t show_protocols(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
+	if (!dev->initialized) {
+		mutex_unlock(&dev->lock);
+		return -EINVAL;
+	}
 
 	if (fattr->type == RC_FILTER_NORMAL) {
 		enabled = dev->enabled_protocols;
@@ -1074,6 +1084,10 @@ static ssize_t store_protocols(struct device *device,
 	}
 
 	mutex_lock(&dev->lock);
+	if (!dev->initialized) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	old_protocols = *current_protocols;
 	new_protocols = old_protocols;
@@ -1154,12 +1168,17 @@ static ssize_t show_filter(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	mutex_lock(&dev->lock);
+	if (!dev->initialized) {
+		mutex_unlock(&dev->lock);
+		return -EINVAL;
+	}
+
 	if (fattr->type == RC_FILTER_NORMAL)
 		filter = &dev->scancode_filter;
 	else
 		filter = &dev->scancode_wakeup_filter;
 
-	mutex_lock(&dev->lock);
 	if (fattr->mask)
 		val = filter->mask;
 	else
@@ -1222,6 +1241,10 @@ static ssize_t store_filter(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
+	if (!dev->initialized) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	new_filter = *filter;
 	if (fattr->mask)
@@ -1419,14 +1442,6 @@ int rc_register_device(struct rc_dev *dev)
 		dev->sysfs_groups[attr++] = &rc_dev_wakeup_protocol_attr_grp;
 	dev->sysfs_groups[attr++] = NULL;
 
-	/*
-	 * Take the lock here, as the device sysfs node will appear
-	 * when device_add() is called, which may trigger an ir-keytable udev
-	 * rule, which will in turn call show_protocols and access
-	 * dev->enabled_protocols before it has been initialized.
-	 */
-	mutex_lock(&dev->lock);
-
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_unlock;
@@ -1440,13 +1455,7 @@ int rc_register_device(struct rc_dev *dev)
 	dev->input_dev->phys = dev->input_phys;
 	dev->input_dev->name = dev->input_name;
 
-	/* input_register_device can call ir_open, so unlock mutex here */
-	mutex_unlock(&dev->lock);
-
 	rc = input_register_device(dev->input_dev);
-
-	mutex_lock(&dev->lock);
-
 	if (rc)
 		goto out_table;
 
@@ -1475,10 +1484,7 @@ int rc_register_device(struct rc_dev *dev)
 			request_module_nowait("ir-lirc-codec");
 			raw_init = true;
 		}
-		/* calls ir_register_device so unlock mutex here*/
-		mutex_unlock(&dev->lock);
 		rc = ir_raw_event_register(dev);
-		mutex_lock(&dev->lock);
 		if (rc < 0)
 			goto out_input;
 	}
@@ -1491,6 +1497,8 @@ int rc_register_device(struct rc_dev *dev)
 		dev->enabled_protocols = rc_type;
 	}
 
+	mutex_lock(&dev->lock);
+	dev->initialized = true;
 	mutex_unlock(&dev->lock);
 
 	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
@@ -1512,7 +1520,6 @@ out_table:
 out_dev:
 	device_del(&dev->dev);
 out_unlock:
-	mutex_unlock(&dev->lock);
 	ida_simple_remove(&rc_ida, minor);
 	return rc;
 }
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f6494709e230..c41dd7018fa8 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -60,6 +60,7 @@ enum rc_filter_type {
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
+ * @initialized: true if the device init has completed
  * @sysfs_groups: sysfs attribute groups
  * @input_name: name of the input child device
  * @input_phys: physical path to the input child device
@@ -121,6 +122,7 @@ enum rc_filter_type {
  */
 struct rc_dev {
 	struct device			dev;
+	bool				initialized;
 	const struct attribute_group	*sysfs_groups[5];
 	const char			*input_name;
 	const char			*input_phys;
-- 
2.5.0

