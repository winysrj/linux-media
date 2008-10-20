Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48FC8D27.60300@linuxtv.org>
Date: Mon, 20 Oct 2008 15:52:39 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------020207010006090902040007"
Subject: [linux-dvb] [PATCH/RFC] Dynamic DVB minor allocation
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------020207010006090902040007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

recently we've exceeded the limit of minor devices, when we tried to
register five demux devices on an adapter instance. We circumvented
this limit by changing the macro nums2minor, which is not acceptable if
you want to stay backwards compatible.

So I went for a cleaner solution and added a new configuration option,
which allows dynamic minor allocation for DVB devices.

I haven't tested it yet. It is loosely based on drivers/usb/core/file.c.

Any comments?

Regards,
Andreas


--------------020207010006090902040007
Content-Type: text/x-patch;
 name="dvbdev.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dvbdev.diff"

diff -r 9273407ca6e1 linux/drivers/media/dvb/Kconfig
--- a/linux/drivers/media/dvb/Kconfig	Wed Oct 15 02:50:03 2008 +0400
+++ b/linux/drivers/media/dvb/Kconfig	Mon Oct 20 15:30:50 2008 +0200
@@ -8,6 +8,18 @@
 	default y
 	---help---
 	  Say Y to select Digital TV adapters
+
+config DVB_DYNAMIC_MINORS
+	bool "Dynamic DVB minor allocation"
+	depends on DVB_CORE
+	help
+	  If you say Y here, the DVB subsystem will use dynamic minor
+	  allocation for any device that uses the DVB major number.
+	  This means that you can have more than 4 of a single type
+	  of device (like demuxes and frontends) per adapter, but udev
+	  will be required to manage the device nodes.
+
+	  If you are unsure about this, say N here.
 
 if DVB_CAPTURE_DRIVERS && DVB_CORE
 
diff -r 9273407ca6e1 linux/drivers/media/dvb/dvb-core/dvbdev.c
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.c	Wed Oct 15 02:50:03 2008 +0400
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c	Mon Oct 20 15:30:50 2008 +0200
@@ -51,33 +51,27 @@
 	"net", "osd"
 };
 
+#ifdef CONFIG_DVB_DYNAMIC_MINORS
+#define MAX_DVB_MINORS		256
+#define DVB_MAX_IDS		MAX_DVB_MINORS
+#else
 #define DVB_MAX_IDS		4
 #define nums2minor(num,type,id)	((num << 6) | (id << 4) | type)
 #define MAX_DVB_MINORS		(DVB_MAX_ADAPTERS*64)
+#endif
 
 static struct class *dvb_class;
 
-static struct dvb_device* dvbdev_find_device (int minor)
-{
-	struct dvb_adapter *adap;
-
-	list_for_each_entry(adap, &dvb_adapter_list, list_head) {
-		struct dvb_device *dev;
-		list_for_each_entry(dev, &adap->device_list, list_head)
-			if (nums2minor(adap->num, dev->type, dev->id) == minor)
-				return dev;
-	}
-
-	return NULL;
-}
-
+static struct dvb_device *dvb_minors[MAX_DVB_MINORS];
+static DECLARE_RWSEM(minor_rwsem);
 
 static int dvb_device_open(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev;
 
 	lock_kernel();
-	dvbdev = dvbdev_find_device (iminor(inode));
+	down_read(&minor_rwsem);
+	dvbdev = dvb_minors[iminor(inode)];
 
 	if (dvbdev && dvbdev->fops) {
 		int err = 0;
@@ -97,9 +91,11 @@
 			file->f_op = fops_get(old_fops);
 		}
 		fops_put(old_fops);
+		up_read(&minor_rwsem);
 		unlock_kernel();
 		return err;
 	}
+	up_read(&minor_rwsem);
 	unlock_kernel();
 	return -ENODEV;
 }
@@ -201,6 +197,7 @@
 #else
 	struct class_device *clsdev;
 #endif
+	int minor;
 	int id;
 
 	mutex_lock(&dvbdev_register_lock);
@@ -240,15 +237,35 @@
 
 	list_add_tail (&dvbdev->list_head, &adap->device_list);
 
+	down_write(&minor_rwsem);
+#ifdef CONFIG_DVB_DYNAMIC_MINORS
+	for (minor = 0; minor < MAX_DVB_MINORS; minor++)
+		if (dvb_minors[minor] == NULL)
+			break;
+
+	if (minor == MAX_DVB_MINORS) {
+		kfree(dvbdevfops);
+		kfree(dvbdev);
+		mutex_unlock(&dvbdev_register_lock);
+		return -EINVAL;
+	}
+#else
+	minor = nums2minor(adap->num, type, id);
+#endif
+
+	dvbdev->minor = minor;
+	dvb_minors[minor] = dvbdev;
+	up_write(&minor_rwsem);
+
 	mutex_unlock(&dvbdev_register_lock);
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 26)
 	clsdev = device_create_drvdata(dvb_class, adap->device,
-			       MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
+			       MKDEV(DVB_MAJOR, minor),
 			       NULL, "dvb%d.%s%d", adap->num, dnames[type], id);
 #else
 	clsdev = device_create(dvb_class, adap->device,
-			       MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
+			       MKDEV(DVB_MAJOR, minor),
 			       "dvb%d.%s%d", adap->num, dnames[type], id);
 #endif
 	if (IS_ERR(clsdev)) {
@@ -258,8 +275,7 @@
 	}
 
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
-		adap->num, dnames[type], id, nums2minor(adap->num, type, id),
-		nums2minor(adap->num, type, id));
+		adap->num, dnames[type], id, minor, minor);
 
 	return 0;
 }
@@ -271,8 +287,11 @@
 	if (!dvbdev)
 		return;
 
-	device_destroy(dvb_class, MKDEV(DVB_MAJOR, nums2minor(dvbdev->adapter->num,
-		       dvbdev->type, dvbdev->id)));
+	down_write(&minor_rwsem);
+	dvb_minors[dvbdev->minor] = NULL;
+	up_write(&minor_rwsem);
+
+	device_destroy(dvb_class, MKDEV(DVB_MAJOR, dvbdev->minor));
 
 	list_del (&dvbdev->list_head);
 	kfree (dvbdev->fops);
diff -r 9273407ca6e1 linux/drivers/media/dvb/dvb-core/dvbdev.h
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.h	Wed Oct 15 02:50:03 2008 +0400
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.h	Mon Oct 20 15:30:50 2008 +0200
@@ -70,6 +70,7 @@
 	struct file_operations *fops;
 	struct dvb_adapter *adapter;
 	int type;
+	int minor;
 	u32 id;
 
 	/* in theory, 'users' can vanish now,

--------------020207010006090902040007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020207010006090902040007--
