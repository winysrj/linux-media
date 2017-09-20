Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50311
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751697AbdITTL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=
        <knightrider@are.ma>, Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 04/25] media: dvbdev: fully document its functions
Date: Wed, 20 Sep 2017 16:11:29 -0300
Message-Id: <8c8cf54bc6eaa6dc7ab63a59669e6d10f16caa07.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several functions at the dvbdev that are common to all
digital TV device nodes with aren't documented.

Add documentation for them. No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvbdev.h | 86 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 53058da83873..bbc1c20c0529 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -261,7 +261,7 @@ void dvb_unregister_device(struct dvb_device *dvbdev);
  * dvb_create_media_graph - Creates media graph for the Digital TV part of the
  * 				device.
  *
- * @adap:			pointer to struct dvb_adapter
+ * @adap:			pointer to &struct dvb_adapter
  * @create_rf_connector:	if true, it creates the RF connector too
  *
  * This function checks all DVB-related functions at the media controller
@@ -274,12 +274,23 @@ void dvb_unregister_device(struct dvb_device *dvbdev);
 __must_check int dvb_create_media_graph(struct dvb_adapter *adap,
 					bool create_rf_connector);
 
+/**
+ * dvb_register_media_controller - registers a media controller at DVB adapter
+ *
+ * @adap:			pointer to &struct dvb_adapter
+ * @mdev:			pointer to &struct media_device
+ */
 static inline void dvb_register_media_controller(struct dvb_adapter *adap,
 						 struct media_device *mdev)
 {
 	adap->mdev = mdev;
 }
 
+/**
+ * dvb_get_media_controller - gets the associated media controller
+ *
+ * @adap:			pointer to &struct dvb_adapter
+ */
 static inline struct media_device
 *dvb_get_media_controller(struct dvb_adapter *adap)
 {
@@ -296,20 +307,71 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 #define dvb_get_media_controller(a) NULL
 #endif
 
-int dvb_generic_open (struct inode *inode, struct file *file);
-int dvb_generic_release (struct inode *inode, struct file *file);
-long dvb_generic_ioctl (struct file *file,
-			      unsigned int cmd, unsigned long arg);
+/**
+ * dvb_generic_open - Digital TV open function, used by DVB devices
+ *
+ * @inode: pointer to &struct inode.
+ * @file: pointer to &struct file.
+ *
+ * Checks if a DVB devnode is still valid, and if the permissions are
+ * OK and increment negative use count.
+ */
+int dvb_generic_open(struct inode *inode, struct file *file);
 
-/* we don't mess with video_usercopy() any more,
-we simply define out own dvb_usercopy(), which will hopefully become
-generic_usercopy()  someday... */
+/**
+ * dvb_generic_close - Digital TV close function, used by DVB devices
+ *
+ * @inode: pointer to &struct inode.
+ * @file: pointer to &struct file.
+ *
+ * Checks if a DVB devnode is still valid, and if the permissions are
+ * OK and decrement negative use count.
+ */
+int dvb_generic_release(struct inode *inode, struct file *file);
 
+/**
+ * dvb_generic_ioctl - Digital TV close function, used by DVB devices
+ *
+ * @file: pointer to &struct file.
+ * @cmd: Ioctl name.
+ * @arg: Ioctl argument.
+ *
+ * Checks if a DVB devnode and struct dvbdev.kernel_ioctl is still valid.
+ * If so, calls dvb_usercopy().
+ */
+long dvb_generic_ioctl(struct file *file,
+		       unsigned int cmd, unsigned long arg);
+
+/**
+ * dvb_usercopy - copies data from/to userspace memory when an ioctl is
+ *      issued.
+ *
+ * @file: Pointer to struct &file.
+ * @cmd: Ioctl name.
+ * @arg: Ioctl argument.
+ * @func: function that will actually handle the ioctl
+ *
+ * Ancillary function that uses ioctl direction and size to copy from
+ * userspace. Then, it calls @func, and, if needed, data is copied back
+ * to userspace.
+ */
 int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		 int (*func)(struct file *file, unsigned int cmd, void *arg));
 
 /** generic DVB attach function. */
 #ifdef CONFIG_MEDIA_ATTACH
+
+/**
+ * dvb_attach - attaches a DVB frontend into the DVB core.
+ *
+ * @FUNCTION:	function on a frontend module to be called.
+ * @ARGS...:	@FUNCTION arguments.
+ *
+ * This ancillary function loads a frontend module in runtime and runs
+ * the @FUNCTION function there, with @ARGS.
+ * As it increments symbol usage cont, at unregister, dvb_detach()
+ * should be called.
+ */
 #define dvb_attach(FUNCTION, ARGS...) ({ \
 	void *__r = NULL; \
 	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
@@ -323,6 +385,14 @@ int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	__r; \
 })
 
+/**
+ * dvb_detach - detaches a DVB frontend loaded via dvb_attach()
+ *
+ * @FUNC:	attach function
+ *
+ * Decrements usage count for a function previously called via dvb_attach().
+ */
+
 #define dvb_detach(FUNC)	symbol_put_addr(FUNC)
 
 #else
-- 
2.13.5
