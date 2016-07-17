Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbcGQOaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 10:30:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 4/7] [media] doc-rst: Fix issues with RC documentation
Date: Sun, 17 Jul 2016 11:30:01 -0300
Message-Id: <0f9b6f4a3992a5525ff9128db59ee511ec2c4dd7.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel-doc script is now broken if it doesn't find all
exported symbols documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/rc-core.rst |  9 ++++++++
 include/media/lirc_dev.h             |  2 +-
 include/media/rc-core.h              | 45 ++++++++++++++++++++++++++++++++++--
 include/media/rc-map.h               | 17 +++++++++++++-
 4 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/media/kapi/rc-core.rst
index 8c8e3bbac0d7..9c244ac9ce92 100644
--- a/Documentation/media/kapi/rc-core.rst
+++ b/Documentation/media/kapi/rc-core.rst
@@ -1,6 +1,15 @@
 Remote Controller devices
 -------------------------
 
+Remote Controller core
+~~~~~~~~~~~~~~~~~~~~~~
+
 .. kernel-doc:: include/media/rc-core.h
 
+.. kernel-doc:: include/media/rc-core.h include/media/rc-map.h
+   :export: drivers/media/rc/rc-main.c drivers/media/rc/rc-raw.c
+
+LIRC
+~~~~
+
 .. kernel-doc:: include/media/lirc_dev.h
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 0ab59a571fee..cec7d35602d1 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -140,7 +140,7 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *			second.
  *
  * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
- *			LIRC_CAN_*, as defined at include/media/lirc.h.
+ *			LIRC_CAN\_\*, as defined at include/media/lirc.h.
  *
  * @chunk_size:		Size of each FIFO buffer.
  *
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b6586a91129c..ff54a71f5cd2 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -29,9 +29,16 @@ do {								\
 		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
 } while (0)
 
+/**
+ * enum rc_driver_type - type of the RC output
+ *
+ * @RC_DRIVER_SCANCODE:	Driver or hardware generates a scancode
+ * @RC_DRIVER_IR_RAW:	Driver or hardware generates pulse/space sequences.
+ *			It needs a Infra-Red pulse/space decoder
+ */
 enum rc_driver_type {
-	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
-	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
+	RC_DRIVER_SCANCODE = 0,
+	RC_DRIVER_IR_RAW,
 };
 
 /**
@@ -185,12 +192,46 @@ struct rc_dev {
  * Remote Controller, at sys/class/rc.
  */
 
+/**
+ * rc_allocate_device - Allocates a RC device
+ *
+ * returns a pointer to struct rc_dev.
+ */
 struct rc_dev *rc_allocate_device(void);
+
+/**
+ * rc_free_device - Frees a RC device
+ *
+ * @dev: pointer to struct rc_dev.
+ */
 void rc_free_device(struct rc_dev *dev);
+
+/**
+ * rc_register_device - Registers a RC device
+ *
+ * @dev: pointer to struct rc_dev.
+ */
 int rc_register_device(struct rc_dev *dev);
+
+/**
+ * rc_unregister_device - Unregisters a RC device
+ *
+ * @dev: pointer to struct rc_dev.
+ */
 void rc_unregister_device(struct rc_dev *dev);
 
+/**
+ * rc_open - Opens a RC device
+ *
+ * @rdev: pointer to struct rc_dev.
+ */
 int rc_open(struct rc_dev *rdev);
+
+/**
+ * rc_open - Closes a RC device
+ *
+ * @rdev: pointer to struct rc_dev.
+ */
 void rc_close(struct rc_dev *rdev);
 
 void rc_repeat(struct rc_dev *dev);
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 6e6557dbeb9f..726bd9374fd2 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -98,10 +98,25 @@ struct rc_map_list {
 
 /* Routines from rc-map.c */
 
+/**
+ * rc_map_register() - Registers a Remote Controler scancode map
+ *
+ * @map:	pointer to struct rc_map_list
+ */
 int rc_map_register(struct rc_map_list *map);
+
+/**
+ * rc_map_unregister() - Unregisters a Remote Controler scancode map
+ *
+ * @map:	pointer to struct rc_map_list
+ */
 void rc_map_unregister(struct rc_map_list *map);
+
+/**
+ * rc_map_get - gets an RC map from its name
+ * @name: name of the RC scancode map
+ */
 struct rc_map *rc_map_get(const char *name);
-void rc_map_init(void);
 
 /* Names of the several keytables defined in-kernel */
 
-- 
2.7.4

