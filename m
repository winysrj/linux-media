Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729575AbeKAAuR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 20:50:17 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <12108.1540984768@warthog.procyon.org.uk>
References: <12108.1540984768@warthog.procyon.org.uk> <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org> <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org> <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk> <20181030110319.764f33f0@coco.lan> <8474.1540982182@warthog.procyon.org.uk>
To: Sean Young <sean@mess.org>
Cc: dhowells@redhat.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device names with udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13766.1541001100.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 31 Oct 2018 15:51:40 +0000
Message-ID: <13768.1541001100@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> > > > Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
> > > > I think.
> > > 
> > > I'm not sure that's possible within the core infrastructure.  It's a
> > > class attribute set when the class is created; I'm not sure it can be
> > > overridden on a per-device basis.
> > > 
> > > Possibly the file could return "" or "none" in this case?
> > 
> > That's very ugly. Have a look at, for example, rc-core wakeup filters:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/media/rc/rc-main.c#n1844
> 
> By analogy, then, I think the thing to do is to put something like struct
> rc_dev::sysfs_groups[] into struct dvb_device (or maybe struct dvb_adapter)
> and then the dvb_mac attribute in there during dvb_register_device() based on
> whether or not the MAC address is not all zeros at that point.

Hmmm...  This is trickier than it seems.  At the point the device struct is
registered, the MAC address hasn't yet been read:

[   13.865905] cx23885: CORE cx23885[1]: subsystem: 4254:0952, board: DVBSky S952 [card=50,autodetected]
[   14.095559] cx25840 8-0044: cx23885 A/V decoder found @ 0x88 (cx23885[1])
[   14.723127] cx25840 8-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[   14.738377] cx23885: cx23885_dvb_register() allocating 1 frontend(s)
[   14.738378] cx23885: cx23885[1]: cx23885 based dvb card
[   14.742536] i2c i2c-7: Added multiplexed i2c bus 9
[   15.096912] ts2020 9-0060: Montage Technology TS2022 successfully identified
[   15.096933] dvbdev: DVB: registering new adapter (cx23885[1])
[   15.096936] cx23885 0000:06:00.0: DVB: registering adapter 2 frontend 0 (Montage Technology M88DS3103)...
[   15.124665] cx23885: DVBSky S952 port 1 MAC address: 00:17:42:54:09:52
[   15.124666] cx23885: cx23885_dvb_register() allocating 1 frontend(s)
[   15.124674] cx23885: cx23885[1]: cx23885 based dvb card
[   15.128860] i2c i2c-6: Added multiplexed i2c bus 10
[   15.228172] ts2020 10-0060: Montage Technology TS2022 successfully identified
[   15.228188] dvbdev: DVB: registering new adapter (cx23885[1])
[   15.228190] cx23885 0000:06:00.0: DVB: registering adapter 3 frontend 0 (Montage Technology M88DS3103)...
[   15.255996] cx23885: DVBSky S952 port 2 MAC address: 00:17:42:54:09:53
[   15.255999] cx23885: cx23885_dev_checkrevision() Hardware revision = 0xa5
[   15.256004] cx23885: cx23885[1]/0: found at 0000:06:00.0, rev: 4, irq: 19, latency: 0, mmio: 0xf7a00000

The device structs are registered at 15.096936 and 15.228190 and this is the
point by which I think I have to set the device::groups pointer.

However, the device isn't fully initialised at this point and the MAC address
hasn't yet been read - and so the attribute doesn't appear.  proposed_mac is
set right after lines 15.124665 and 15.255996.  Interestingly, a third of a
second elapses between the device registration and the MAC being printed for
each adapter.

Any suggestions?

David
---
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index b7171bf094fb..edbfa5549994 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -450,6 +450,23 @@ static int dvb_register_media_device(struct dvb_device *dvbdev,
 	return 0;
 }
 
+static ssize_t dvb_mac_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%pM\n", dvbdev->adapter->proposed_mac);
+}
+static DEVICE_ATTR_RO(dvb_mac);
+
+static struct attribute *dvb_device_attrs[] = {
+	&dev_attr_dvb_mac.attr,
+	NULL
+};
+static const struct attribute_group dvb_device_attr_grp = {
+	.attrs	= dvb_device_attrs,
+};
+
 int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv,
 			enum dvb_device_type type, int demux_sink_pads)
@@ -533,6 +550,14 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 
 	mutex_unlock(&dvbdev_register_lock);
 
+	if (adap->proposed_mac[0] || adap->proposed_mac[1] ||
+	    adap->proposed_mac[2] || adap->proposed_mac[3] ||
+	    adap->proposed_mac[4] || adap->proposed_mac[5]) {
+		dvbdev->sysfs_groups[0] = &dvb_device_attr_grp;
+		dvbdev->sysfs_groups[1] = NULL;
+		adap->device->groups = dvbdev->sysfs_groups;
+	}
+
 	clsdev = device_create(dvb_class, adap->device,
 			       MKDEV(DVB_MAJOR, minor),
 			       dvbdev, "dvb%d.%s%d", adap->num, dnames[type], id);
@@ -1010,6 +1035,31 @@ void dvb_module_release(struct i2c_client *client)
 EXPORT_SYMBOL_GPL(dvb_module_release);
 #endif
 
+static ssize_t dvb_adapter_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", dvbdev->adapter->num);
+}
+static DEVICE_ATTR_RO(dvb_adapter);
+
+static ssize_t dvb_type_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", dnames[dvbdev->type]);
+}
+static DEVICE_ATTR_RO(dvb_type);
+
+static struct attribute *dvb_class_attrs[] = {
+	&dev_attr_dvb_adapter.attr,
+	&dev_attr_dvb_type.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(dvb_class);
+
 static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct dvb_device *dvbdev = dev_get_drvdata(dev);
@@ -1050,6 +1100,7 @@ static int __init init_dvbdev(void)
 		retval = PTR_ERR(dvb_class);
 		goto error;
 	}
+	dvb_class->dev_groups = dvb_class_groups,
 	dvb_class->dev_uevent = dvb_uevent;
 	dvb_class->devnode = dvb_devnode;
 	return 0;
diff --git a/include/media/dvbdev.h b/include/media/dvbdev.h
index 881ca461b7bb..d6becdd2d56e 100644
--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -127,6 +127,7 @@ struct dvb_adapter {
  *
  * @list_head:	List head with all DVB devices
  * @fops:	pointer to struct file_operations
+ * @sysfs_groups: Additional sysfs attributes
  * @adapter:	pointer to the adapter that holds this device node
  * @type:	type of the device, as defined by &enum dvb_device_type.
  * @minor:	devnode minor number. Major number is always DVB_MAJOR.
@@ -157,6 +158,7 @@ struct dvb_adapter {
 struct dvb_device {
 	struct list_head list_head;
 	const struct file_operations *fops;
+	const struct attribute_group *sysfs_groups[2];
 	struct dvb_adapter *adapter;
 	enum dvb_device_type type;
 	int minor;
