Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935893AbZFPFv3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 43/64] media: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:32 -0700
Message-Id: <1245131213-24168-43-git-send-email-gregkh@suse.de>
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Mike Isely <isely@pobox.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c   |    4 ++--
 drivers/media/dvb/firewire/firedtv-dvb.c    |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |   22 +++++++++++-----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-1394.c b/drivers/media/dvb/firewire/firedtv-1394.c
index 4e20765..2b6eeea 100644
--- a/drivers/media/dvb/firewire/firedtv-1394.c
+++ b/drivers/media/dvb/firewire/firedtv-1394.c
@@ -225,7 +225,7 @@ fail_free:
 
 static int node_remove(struct device *dev)
 {
-	struct firedtv *fdtv = dev->driver_data;
+	struct firedtv *fdtv = dev_get_drvdata(dev);
 
 	fdtv_dvb_unregister(fdtv);
 
@@ -242,7 +242,7 @@ static int node_remove(struct device *dev)
 
 static int node_update(struct unit_directory *ud)
 {
-	struct firedtv *fdtv = ud->device.driver_data;
+	struct firedtv *fdtv = dev_get_drvdata(&ud->device);
 
 	if (fdtv->isochannel >= 0)
 		cmp_establish_pp_connection(fdtv, fdtv->subunit,
diff --git a/drivers/media/dvb/firewire/firedtv-dvb.c b/drivers/media/dvb/firewire/firedtv-dvb.c
index 9d308dd..5742fde 100644
--- a/drivers/media/dvb/firewire/firedtv-dvb.c
+++ b/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -268,7 +268,7 @@ struct firedtv *fdtv_alloc(struct device *dev,
 	if (!fdtv)
 		return NULL;
 
-	dev->driver_data	= fdtv;
+	dev_set_drvdata(dev, fdtv);
 	fdtv->device		= dev;
 	fdtv->isochannel	= -1;
 	fdtv->voltage		= 0xff;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 299c1cb..6c23456 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -539,7 +539,7 @@ static void class_dev_destroy(struct pvr2_sysfs *sfp)
 					 &sfp->attr_unit_number);
 	}
 	pvr2_sysfs_trace("Destroying class_dev id=%p",sfp->class_dev);
-	sfp->class_dev->driver_data = NULL;
+	dev_set_drvdata(sfp->class_dev, NULL);
 	device_unregister(sfp->class_dev);
 	sfp->class_dev = NULL;
 }
@@ -549,7 +549,7 @@ static ssize_t v4l_minor_number_show(struct device *class_dev,
 				     struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return scnprintf(buf,PAGE_SIZE,"%d\n",
 			 pvr2_hdw_v4l_get_minor_number(sfp->channel.hdw,
@@ -561,7 +561,7 @@ static ssize_t bus_info_show(struct device *class_dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return scnprintf(buf,PAGE_SIZE,"%s\n",
 			 pvr2_hdw_get_bus_info(sfp->channel.hdw));
@@ -572,7 +572,7 @@ static ssize_t hdw_name_show(struct device *class_dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return scnprintf(buf,PAGE_SIZE,"%s\n",
 			 pvr2_hdw_get_type(sfp->channel.hdw));
@@ -583,7 +583,7 @@ static ssize_t hdw_desc_show(struct device *class_dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return scnprintf(buf,PAGE_SIZE,"%s\n",
 			 pvr2_hdw_get_desc(sfp->channel.hdw));
@@ -595,7 +595,7 @@ static ssize_t v4l_radio_minor_number_show(struct device *class_dev,
 					   char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return scnprintf(buf,PAGE_SIZE,"%d\n",
 			 pvr2_hdw_v4l_get_minor_number(sfp->channel.hdw,
@@ -607,7 +607,7 @@ static ssize_t unit_number_show(struct device *class_dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return scnprintf(buf,PAGE_SIZE,"%d\n",
 			 pvr2_hdw_get_unit_number(sfp->channel.hdw));
@@ -635,7 +635,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	class_dev->parent = &usb_dev->dev;
 
 	sfp->class_dev = class_dev;
-	class_dev->driver_data = sfp;
+	dev_set_drvdata(class_dev, sfp);
 	ret = device_register(class_dev);
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
@@ -792,7 +792,7 @@ static ssize_t debuginfo_show(struct device *class_dev,
 			      struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	pvr2_hdw_trigger_module_log(sfp->channel.hdw);
 	return pvr2_debugifc_print_info(sfp->channel.hdw,buf,PAGE_SIZE);
@@ -803,7 +803,7 @@ static ssize_t debugcmd_show(struct device *class_dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct pvr2_sysfs *sfp;
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 	return pvr2_debugifc_print_status(sfp->channel.hdw,buf,PAGE_SIZE);
 }
@@ -816,7 +816,7 @@ static ssize_t debugcmd_store(struct device *class_dev,
 	struct pvr2_sysfs *sfp;
 	int ret;
 
-	sfp = (struct pvr2_sysfs *)class_dev->driver_data;
+	sfp = dev_get_drvdata(class_dev);
 	if (!sfp) return -EINVAL;
 
 	ret = pvr2_debugifc_docmd(sfp->channel.hdw,buf,count);
-- 
1.6.3.2

