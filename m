Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:48124 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752914AbdKFXhm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 18:37:42 -0500
Subject: [PATCH 1/3] atomisp: Fix up the open v load race
From: Alan <alan@linux.intel.com>
To: vincent.hervieux@gmail.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
Date: Mon, 06 Nov 2017 23:36:36 +0000
Message-ID: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This isn't the ideal final solution but it stops the main problem for now
where an open (often from udev) races the device initialization and we try
and load the firmware twice at the same time. This needless to say doesn't
usually end well.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |   12 ++++++++++++
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |    5 +++++
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |    6 ++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index dd7596d8763d..b82c53cee32c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -771,6 +771,18 @@ static int atomisp_open(struct file *file)
 
 	dev_dbg(isp->dev, "open device %s\n", vdev->name);
 
+	/* Ensure that if we are still loading we block. Once the loading
+	   is over we can proceed. We can't blindly hold the lock until
+	   that occurs as if the load fails we'll deadlock the unload */
+	rt_mutex_lock(&isp->loading);
+	/* Revisit this with a better check once the code structure is
+	   cleaned up a bit more FIXME */
+	if (!isp->ready) {
+		rt_mutex_unlock(&isp->loading);
+		return -ENXIO;
+	}
+	rt_mutex_unlock(&isp->loading);
+
 	rt_mutex_lock(&isp->mutex);
 
 	acc_node = !strncmp(vdev->name, "ATOMISP ISP ACC",
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index 52a6f8002048..808d79c840d4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -252,6 +252,11 @@ struct atomisp_device {
 	/* Purpose of mutex is to protect and serialize use of isp data
 	 * structures and css API calls. */
 	struct rt_mutex mutex;
+	/* This mutex ensures that we don't allow an open to succeed while
+	 * the initialization process is incomplete */
+	struct rt_mutex loading;
+	/* Set once the ISP is ready to allow opens */
+	bool ready;
 	/*
 	 * Serialise streamoff: mutex is dropped during streamoff to
 	 * cancel the watchdog queue. MUST be acquired BEFORE
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 3c260f8b52e2..350e298bc3a6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1220,6 +1220,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	isp->saved_regs.ispmmadr = start;
 
 	rt_mutex_init(&isp->mutex);
+	rt_mutex_init(&isp->loading);
 	mutex_init(&isp->streamoff_mutex);
 	spin_lock_init(&isp->lock);
 
@@ -1393,6 +1394,8 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 				      csi_afe_trim);
 	}
 
+	rt_mutex_lock(&isp->loading);
+
 	err = atomisp_initialize_modules(isp);
 	if (err < 0) {
 		dev_err(&dev->dev, "atomisp_initialize_modules (%d)\n", err);
@@ -1450,6 +1453,8 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	release_firmware(isp->firmware);
 	isp->firmware = NULL;
 	isp->css_env.isp_css_fw.data = NULL;
+	isp->ready = true;
+	rt_mutex_unlock(&isp->loading);
 
 	atomisp_drvfs_init(&atomisp_pci_driver, isp);
 
@@ -1468,6 +1473,7 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 register_entities_fail:
 	atomisp_uninitialize_modules(isp);
 initialize_modules_fail:
+	rt_mutex_unlock(&isp->loading);
 	pm_qos_remove_request(&isp->pm_qos);
 	atomisp_msi_irq_uninit(isp, dev);
 enable_msi_fail:
