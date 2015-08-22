Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbHVWmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 18:42:40 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] dvbdev: document most of the functions/data structs
Date: Sat, 22 Aug 2015 19:42:29 -0300
Message-Id: <f26b1056154540e2416fcf58aaedb7eaac2faa4e.1440283315.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the most relevant functions and data structs for
developers that are working with the DVB subsystem.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 5c9375b98303..93b74884ae24 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -237,6 +237,7 @@ X!Isound/sound_firmware.c
 !Idrivers/media/dvb-core/dvb_frontend.h
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
+!Idrivers/media/dvb-core/dvbdev.h
      </sect1>
      <sect1><title>Remote Controller devices</title>
 !Iinclude/media/rc-core.h
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 12629b8ecb0c..c61a4f03a66f 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -57,6 +57,25 @@
 
 struct dvb_frontend;
 
+/**
+ * struct dvb_adapter - represents a Digital TV adapter using Linux DVB API
+ *
+ * @num:		Number of the adapter
+ * @list_head:		List with the DVB adapters
+ * @device_list:	List with the DVB devices
+ * @name:		Name of the adapter
+ * @proposed_mac:	proposed MAC address for the adapter
+ * @priv:		private data
+ * @device:		pointer to struct device
+ * @module:		pointer to struct module
+ * @mfe_shared:		mfe shared: indicates mutually exclusive frontends
+ *			Thie usage of this flag is currently deprecated
+ * @mfe_dvbdev:		Frontend device in use, in the case of MFE
+ * @mfe_lock:		Lock to prevent using the other frontends when MFE is
+ *			used.
+ * @mdev:		pointer to struct media_device, used when the media
+ *			controller is used.
+ */
 struct dvb_adapter {
 	int num;
 	struct list_head list_head;
@@ -78,7 +97,34 @@ struct dvb_adapter {
 #endif
 };
 
-
+/**
+ * struct dvb_device - represents a DVB device node
+ *
+ * @list_head:	List head with all DVB devices
+ * @fops:	pointer to struct file_operations
+ * @adapter:	pointer to the adapter that holds this device node
+ * @type:	type of the device: DVB_DEVICE_SEC, DVB_DEVICE_FRONTEND,
+ *		DVB_DEVICE_DEMUX, DVB_DEVICE_DVR, DVB_DEVICE_CA, DVB_DEVICE_NET
+ * @minor:	devnode minor number. Major number is always DVB_MAJOR.
+ * @id:		device ID number, inside the adapter
+ * @readers:	Initialized by the caller. Each call to open() in Read Only mode
+ *		decreases this counter by one.
+ * @writers:	Initialized by the caller. Each call to open() in Read/Write
+ *		mode decreases this counter by one.
+ * @users:	Initialized by the caller. Each call to open() in any mode
+ *		decreases this counter by one.
+ * @wait_queue:	wait queue, used to wait for certain events inside one of
+ *		the DVB API callers
+ * @kernel_ioctl: callback function used to handle ioctl calls from userspace.
+ * @name:	Name to be used for the device at the Media Controller
+ * @entity:	pointer to struct media_entity associated with the device node
+ * @pads:	pointer to struct media_pad associated with @entity;
+ * @priv:	private data
+ *
+ * This structure is used by the DVB core (frontend, CA, net, demux) in
+ * order to create the device nodes. Usually, driver should not initialize
+ * this struct diretly.
+ */
 struct dvb_device {
 	struct list_head list_head;
 	const struct file_operations *fops;
@@ -109,19 +155,55 @@ struct dvb_device {
 	void *priv;
 };
 
+/**
+ * dvb_register_adapter - Registers a new DVB adapter
+ *
+ * @adap:	pointer to struct dvb_adapter
+ * @name:	Adapter's name
+ * @module:	initialized with THIS_MODULE at the caller
+ * @device:	pointer to struct device that corresponds to the device driver
+ * @adapter_nums: Array with a list of the numbers for @dvb_register_adapter;
+ * 		to select among them. Typically, initialized with:
+ *		DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nums)
+ */
+int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
+			 struct module *module, struct device *device,
+			 short *adapter_nums);
 
-extern int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
-				struct module *module, struct device *device,
-				short *adapter_nums);
-extern int dvb_unregister_adapter (struct dvb_adapter *adap);
+/**
+ * dvb_unregister_adapter - Unregisters a DVB adapter
+ *
+ * @adap:	pointer to struct dvb_adapter
+ */
+int dvb_unregister_adapter(struct dvb_adapter *adap);
 
-extern int dvb_register_device (struct dvb_adapter *adap,
-				struct dvb_device **pdvbdev,
-				const struct dvb_device *template,
-				void *priv,
-				int type);
+/**
+ * dvb_register_device - Registers a new DVB device
+ *
+ * @adap:	pointer to struct dvb_adapter
+ * @pdvbdev:	pointer to the place where the new struct dvb_device will be
+ *		stored
+ * @template:	Template used to create &pdvbdev;
+ * @device:	pointer to struct device that corresponds to the device driver
+ * @adapter_nums: Array with a list of the numbers for @dvb_register_adapter;
+ * 		to select among them. Typically, initialized with:
+ *		DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nums)
+ * @priv:	private data
+ * @type:	type of the device: DVB_DEVICE_SEC, DVB_DEVICE_FRONTEND,
+ *		DVB_DEVICE_DEMUX, DVB_DEVICE_DVR, DVB_DEVICE_CA, DVB_DEVICE_NET
+ */
+int dvb_register_device(struct dvb_adapter *adap,
+			struct dvb_device **pdvbdev,
+			const struct dvb_device *template,
+			void *priv,
+			int type);
 
-extern void dvb_unregister_device (struct dvb_device *dvbdev);
+/**
+ * dvb_unregister_device - Unregisters a DVB device
+ *
+ * @dvbdev:	pointer to struct dvb_device
+ */
+void dvb_unregister_device(struct dvb_device *dvbdev);
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 void dvb_create_media_graph(struct dvb_adapter *adap);
@@ -136,17 +218,17 @@ static inline void dvb_create_media_graph(struct dvb_adapter *adap) {}
 #define dvb_register_media_controller(a, b) {}
 #endif
 
-extern int dvb_generic_open (struct inode *inode, struct file *file);
-extern int dvb_generic_release (struct inode *inode, struct file *file);
-extern long dvb_generic_ioctl (struct file *file,
+int dvb_generic_open (struct inode *inode, struct file *file);
+int dvb_generic_release (struct inode *inode, struct file *file);
+long dvb_generic_ioctl (struct file *file,
 			      unsigned int cmd, unsigned long arg);
 
 /* we don't mess with video_usercopy() any more,
 we simply define out own dvb_usercopy(), which will hopefully become
 generic_usercopy()  someday... */
 
-extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
-			    int (*func)(struct file *file, unsigned int cmd, void *arg));
+int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
+		 int (*func)(struct file *file, unsigned int cmd, void *arg));
 
 /** generic DVB attach function. */
 #ifdef CONFIG_MEDIA_ATTACH
-- 
2.4.3

