Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505AbcGOLBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 07:01:07 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B9650C05AA49
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 11:01:06 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: linux-media@vger.kernel.org
cc: dhowells@redhat.com
Subject: Trying to pass the port number to udev for a multiport DVB card
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22947.1468580465.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2016 12:01:05 +0100
Message-ID: <22948.1468580465@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Can someone give me a hand with unpicking the tangle of spaghetti that's the
DVB core?

Attached is a patch that can pass various attributes, including,
theoretically, the port number of the separate ports of a multiport card, such
as the DVBSky S952 and T982 cards, so that udev can create persistent names.

However, the port number I've added to the dvb_adapter struct is always seen
as zero in the attribute function I've written.  Putting in some printks shows
that the dvb_adapter struct seen in the attribute struct has a *different*
address to the one seen in dvb_register() in cx23885-dvb.c.  Does anyone know
what's going on?  I should also add that the MAC address *does* go through,
though I can't see where it's copied.

David
---
commit c100b0ddc9436152e770a80eedfdd90644c1ee3d
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 13 23:05:34 2016 +0100

    dvb: Save port number and provide sysfs attributes to pass values to udev
    
    Some devices, such as the DVBSky S952 and T982 cards, are dual port cards
    that provide two cx23885 devices on the same PCI device, which means the
    attributes available for writing udev rules are exactly the same, apart
    from the adapter number.  Unfortunately, the adapter numbers are dependent
    on the order in which things are initialised, so this can change over
    different releases of the kernel.
    
    The struct cx23885_tsport has a port number available, which is printed
    during boot:
    
    	[   10.951517] DVBSky T982 port 1 MAC address: 00:17:42:54:09:87
    	...
    	[   10.984875] DVBSky T982 port 2 MAC address: 00:17:42:54:09:88
    
    To make it possible to distinguish these in udev, do the following steps:
    
     (1) Save the port number into struct dvb_adapter.
    
     (2) Provide sysfs attributes to export port number and also MAC address,
         adapter number and type.  There are other fields that could perhaps be
         exported also.
    
    The new sysfs attributes can be seen from userspace as:
    
    	[root@deneb ~]# ls /sys/class/dvb/dvb0.frontend0/
    	dev  device  dvb_adapter  dvb_mac  dvb_port  dvb_type
    	power  subsystem  uevent
    	[root@deneb ~]# cat /sys/class/dvb/dvb0.frontend0/dvb_*
    	0
    	00:17:42:54:09:87
    	0
    	frontend
    
    They can be used in udev rules:
    
    	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:17:42:54:09:87", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9820/%%s $${K#*.}'", SYMLINK+="%c"
    	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:17:42:54:09:88", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9821/%%s $${K#*.}'", SYMLINK+="%c"
    
    where the match is made with ATTR{dvb_mac} or similar.  The rules above
    make symlinks from /dev/dvb/adapter982/* to /dev/dvb/adapterXX/*.
    
    Note that binding the dvb-net device to a network interface and changing it
    there does not reflect back into the the dvb_adapter struct and doesn't
    change the MAC address here.  This means that a system with two identical
    cards in it may need to distinguish them by some other means than MAC
    address.
    
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 75a3f4b57fd4..638719483167 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -901,6 +901,51 @@ out:
 	return err;
 }
 
+static ssize_t dvb_adapter_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", dvbdev->adapter->num);
+}
+static DEVICE_ATTR_RO(dvb_adapter);
+
+static ssize_t dvb_mac_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%pM\n", dvbdev->adapter->proposed_mac);
+}
+static DEVICE_ATTR_RO(dvb_mac);
+
+static ssize_t dvb_port_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", dvbdev->adapter->port_num);
+}
+static DEVICE_ATTR_RO(dvb_port);
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
+	&dev_attr_dvb_mac.attr,
+	&dev_attr_dvb_port.attr,
+	&dev_attr_dvb_type.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(dvb_class);
+
 static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct dvb_device *dvbdev = dev_get_drvdata(dev);
@@ -941,6 +986,7 @@ static int __init init_dvbdev(void)
 		retval = PTR_ERR(dvb_class);
 		goto error;
 	}
+	dvb_class->dev_groups = dvb_class_groups,
 	dvb_class->dev_uevent = dvb_uevent;
 	dvb_class->devnode = dvb_devnode;
 	return 0;
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 4aff7bd3dea8..cf4d5fc501e0 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -65,6 +65,7 @@ struct dvb_frontend;
  * @device_list:	List with the DVB devices
  * @name:		Name of the adapter
  * @proposed_mac:	proposed MAC address for the adapter
+ * @port_num:		Port number for multi-adapter devices
  * @priv:		private data
  * @device:		pointer to struct device
  * @module:		pointer to struct module
@@ -85,6 +86,7 @@ struct dvb_adapter {
 	struct list_head device_list;
 	const char *name;
 	u8 proposed_mac [6];
+	u8 port_num;
 	void* priv;
 
 	struct device *device;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index f041b6931ba8..a4260fa8eec7 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1209,6 +1209,8 @@ static int dvb_register(struct cx23885_tsport *port)
 	/* Sets the gate control callback to be used by i2c command calls */
 	port->gate_ctrl = cx23885_dvb_gate_ctrl;
 
+	port->frontends.adapter.port_num = port->nr;
+
 	/* init frontend */
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
