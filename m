Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0GPRZh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 13:25:37 -0400
Date: Fri, 16 Jul 2010 13:25:33 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH] IR/lirc: make lirc userspace and staging modules buildable
Message-ID: <20100716172533.GA4447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc userspace needs all the current ioctls defined, and we need to
put the header files in places out-of-tree and/or staging lirc drivers
(which I plan to prep soon) can easily build with. I've actually tested this
in a tree w/all the lirc drivers queued up to be submitted for staging. I'm
also reasonably sure that Andy Walls is going to need most of the ioctls
anyway for his cx23888 IR driver work.

CC: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-lirc-codec.c |    2 +-
 drivers/media/IR/lirc_dev.c      |    2 +-
 drivers/media/IR/lirc_dev.h      |  225 --------------------------------------
 include/media/lirc.h             |   34 +++---
 include/media/lirc_dev.h         |  225 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 245 insertions(+), 243 deletions(-)
 delete mode 100644 drivers/media/IR/lirc_dev.h
 create mode 100644 include/media/lirc_dev.h

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 178bc5b..afb1ada 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -15,9 +15,9 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <media/lirc.h>
+#include <media/lirc_dev.h>
 #include <media/ir-core.h>
 #include "ir-core-priv.h"
-#include "lirc_dev.h"
 
 #define LIRCBUF_SIZE 256
 
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index c11b8f7..899891b 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -37,7 +37,7 @@
 #include <linux/cdev.h>
 
 #include <media/lirc.h>
-#include "lirc_dev.h"
+#include <media/lirc_dev.h>
 
 static int debug;
 
diff --git a/drivers/media/IR/lirc_dev.h b/drivers/media/IR/lirc_dev.h
deleted file mode 100644
index b1f6066..0000000
--- a/drivers/media/IR/lirc_dev.h
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * LIRC base driver
- *
- * by Artur Lipowski <alipowski@interia.pl>
- *        This code is licensed under GNU GPL
- *
- */
-
-#ifndef _LINUX_LIRC_DEV_H
-#define _LINUX_LIRC_DEV_H
-
-#define MAX_IRCTL_DEVICES 4
-#define BUFLEN            16
-
-#define mod(n, div) ((n) % (div))
-
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/ioctl.h>
-#include <linux/poll.h>
-#include <linux/kfifo.h>
-#include <media/lirc.h>
-
-struct lirc_buffer {
-	wait_queue_head_t wait_poll;
-	spinlock_t fifo_lock;
-	unsigned int chunk_size;
-	unsigned int size; /* in chunks */
-	/* Using chunks instead of bytes pretends to simplify boundary checking
-	 * And should allow for some performance fine tunning later */
-	struct kfifo fifo;
-	u8 fifo_initialized;
-};
-
-static inline void lirc_buffer_clear(struct lirc_buffer *buf)
-{
-	unsigned long flags;
-
-	if (buf->fifo_initialized) {
-		spin_lock_irqsave(&buf->fifo_lock, flags);
-		kfifo_reset(&buf->fifo);
-		spin_unlock_irqrestore(&buf->fifo_lock, flags);
-	} else
-		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
-		     __func__);
-}
-
-static inline int lirc_buffer_init(struct lirc_buffer *buf,
-				    unsigned int chunk_size,
-				    unsigned int size)
-{
-	int ret;
-
-	init_waitqueue_head(&buf->wait_poll);
-	spin_lock_init(&buf->fifo_lock);
-	buf->chunk_size = chunk_size;
-	buf->size = size;
-	ret = kfifo_alloc(&buf->fifo, size * chunk_size, GFP_KERNEL);
-	if (ret == 0)
-		buf->fifo_initialized = 1;
-
-	return ret;
-}
-
-static inline void lirc_buffer_free(struct lirc_buffer *buf)
-{
-	if (buf->fifo_initialized) {
-		kfifo_free(&buf->fifo);
-		buf->fifo_initialized = 0;
-	} else
-		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
-		     __func__);
-}
-
-static inline int lirc_buffer_len(struct lirc_buffer *buf)
-{
-	int len;
-	unsigned long flags;
-
-	spin_lock_irqsave(&buf->fifo_lock, flags);
-	len = kfifo_len(&buf->fifo);
-	spin_unlock_irqrestore(&buf->fifo_lock, flags);
-
-	return len;
-}
-
-static inline int lirc_buffer_full(struct lirc_buffer *buf)
-{
-	return lirc_buffer_len(buf) == buf->size * buf->chunk_size;
-}
-
-static inline int lirc_buffer_empty(struct lirc_buffer *buf)
-{
-	return !lirc_buffer_len(buf);
-}
-
-static inline int lirc_buffer_available(struct lirc_buffer *buf)
-{
-	return buf->size - (lirc_buffer_len(buf) / buf->chunk_size);
-}
-
-static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
-					    unsigned char *dest)
-{
-	unsigned int ret = 0;
-
-	if (lirc_buffer_len(buf) >= buf->chunk_size)
-		ret = kfifo_out_locked(&buf->fifo, dest, buf->chunk_size,
-				       &buf->fifo_lock);
-	return ret;
-
-}
-
-static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
-					     unsigned char *orig)
-{
-	unsigned int ret;
-
-	ret = kfifo_in_locked(&buf->fifo, orig, buf->chunk_size,
-			      &buf->fifo_lock);
-
-	return ret;
-}
-
-struct lirc_driver {
-	char name[40];
-	int minor;
-	unsigned long code_length;
-	unsigned int buffer_size; /* in chunks holding one code each */
-	int sample_rate;
-	unsigned long features;
-
-	unsigned int chunk_size;
-
-	void *data;
-	int min_timeout;
-	int max_timeout;
-	int (*add_to_buf) (void *data, struct lirc_buffer *buf);
-	struct lirc_buffer *rbuf;
-	int (*set_use_inc) (void *data);
-	void (*set_use_dec) (void *data);
-	struct file_operations *fops;
-	struct device *dev;
-	struct module *owner;
-};
-
-/* name:
- * this string will be used for logs
- *
- * minor:
- * indicates minor device (/dev/lirc) number for registered driver
- * if caller fills it with negative value, then the first free minor
- * number will be used (if available)
- *
- * code_length:
- * length of the remote control key code expressed in bits
- *
- * sample_rate:
- *
- * data:
- * it may point to any driver data and this pointer will be passed to
- * all callback functions
- *
- * add_to_buf:
- * add_to_buf will be called after specified period of the time or
- * triggered by the external event, this behavior depends on value of
- * the sample_rate this function will be called in user context. This
- * routine should return 0 if data was added to the buffer and
- * -ENODATA if none was available. This should add some number of bits
- * evenly divisible by code_length to the buffer
- *
- * rbuf:
- * if not NULL, it will be used as a read buffer, you will have to
- * write to the buffer by other means, like irq's (see also
- * lirc_serial.c).
- *
- * set_use_inc:
- * set_use_inc will be called after device is opened
- *
- * set_use_dec:
- * set_use_dec will be called after device is closed
- *
- * fops:
- * file_operations for drivers which don't fit the current driver model.
- *
- * Some ioctl's can be directly handled by lirc_dev if the driver's
- * ioctl function is NULL or if it returns -ENOIOCTLCMD (see also
- * lirc_serial.c).
- *
- * owner:
- * the module owning this struct
- *
- */
-
-
-/* following functions can be called ONLY from user context
- *
- * returns negative value on error or minor number
- * of the registered device if success
- * contents of the structure pointed by p is copied
- */
-extern int lirc_register_driver(struct lirc_driver *d);
-
-/* returns negative value on error or 0 if success
-*/
-extern int lirc_unregister_driver(int minor);
-
-/* Returns the private data stored in the lirc_driver
- * associated with the given device file pointer.
- */
-void *lirc_get_pdata(struct file *file);
-
-/* default file operations
- * used by drivers if they override only some operations
- */
-int lirc_dev_fop_open(struct inode *inode, struct file *file);
-int lirc_dev_fop_close(struct inode *inode, struct file *file);
-unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
-long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-ssize_t lirc_dev_fop_read(struct file *file, char *buffer, size_t length,
-			  loff_t *ppos);
-ssize_t lirc_dev_fop_write(struct file *file, const char *buffer, size_t length,
-			   loff_t *ppos);
-
-#endif
diff --git a/include/media/lirc.h b/include/media/lirc.h
index 8dffd4f..42c467c 100644
--- a/include/media/lirc.h
+++ b/include/media/lirc.h
@@ -1,6 +1,6 @@
 /*
  * lirc.h - linux infrared remote control header file
- * last modified 2010/06/03 by Jarod Wilson
+ * last modified 2010/07/13 by Jarod Wilson
  */
 
 #ifndef _LINUX_LIRC_H
@@ -33,6 +33,9 @@
 #define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
 #define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
 
+/* used heavily by lirc userspace */
+#define lirc_t int
+
 /*** lirc compatible hardware features ***/
 
 #define LIRC_MODE2SEND(x) (x)
@@ -95,12 +98,10 @@
 #define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
 #define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
 
-#if 0	/* these ioctls are not used at the moment */
 #define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
 #define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
 #define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
 #define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
-#endif
 
 /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
 #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
@@ -121,23 +122,30 @@
  */
 #define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
 
-#if 0	/* these ioctls are not used at the moment */
+/* 1 enables, 0 disables timeout reports in MODE2 */
+#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
+
 /*
  * pulses shorter than this are filtered out by hardware (software
  * emulation in lirc_dev?)
  */
-#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x00000019, __u32)
+#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x0000001a, __u32)
 /*
  * spaces shorter than this are filtered out by hardware (software
  * emulation in lirc_dev?)
  */
-#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001a, __u32)
+#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001b, __u32)
 /*
  * if filter cannot be set independantly for pulse/space, this should
  * be used
  */
-#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001b, __u32)
-#endif
+#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001c, __u32)
+
+/*
+ * if enabled from the next key press on the driver will send
+ * LIRC_MODE2_FREQUENCY packets
+ */
+#define LIRC_SET_MEASURE_CARRIER_MODE  _IOW('i', 0x0000001d, __u32)
 
 /*
  * to set a range use
@@ -151,13 +159,7 @@
 
 #define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
 
-#if 0	/* these ioctls are not used at the moment */
-/*
- * from the next key press on the driver will send
- * LIRC_MODE2_FREQUENCY packets
- */
-#define LIRC_MEASURE_CARRIER_ENABLE    _IO('i', 0x00000021)
-#define LIRC_MEASURE_CARRIER_DISABLE   _IO('i', 0x00000022)
-#endif
+#define LIRC_SETUP_START               _IO('i', 0x00000021)
+#define LIRC_SETUP_END                 _IO('i', 0x00000022)
 
 #endif
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
new file mode 100644
index 0000000..b1f6066
--- /dev/null
+++ b/include/media/lirc_dev.h
@@ -0,0 +1,225 @@
+/*
+ * LIRC base driver
+ *
+ * by Artur Lipowski <alipowski@interia.pl>
+ *        This code is licensed under GNU GPL
+ *
+ */
+
+#ifndef _LINUX_LIRC_DEV_H
+#define _LINUX_LIRC_DEV_H
+
+#define MAX_IRCTL_DEVICES 4
+#define BUFLEN            16
+
+#define mod(n, div) ((n) % (div))
+
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/ioctl.h>
+#include <linux/poll.h>
+#include <linux/kfifo.h>
+#include <media/lirc.h>
+
+struct lirc_buffer {
+	wait_queue_head_t wait_poll;
+	spinlock_t fifo_lock;
+	unsigned int chunk_size;
+	unsigned int size; /* in chunks */
+	/* Using chunks instead of bytes pretends to simplify boundary checking
+	 * And should allow for some performance fine tunning later */
+	struct kfifo fifo;
+	u8 fifo_initialized;
+};
+
+static inline void lirc_buffer_clear(struct lirc_buffer *buf)
+{
+	unsigned long flags;
+
+	if (buf->fifo_initialized) {
+		spin_lock_irqsave(&buf->fifo_lock, flags);
+		kfifo_reset(&buf->fifo);
+		spin_unlock_irqrestore(&buf->fifo_lock, flags);
+	} else
+		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+		     __func__);
+}
+
+static inline int lirc_buffer_init(struct lirc_buffer *buf,
+				    unsigned int chunk_size,
+				    unsigned int size)
+{
+	int ret;
+
+	init_waitqueue_head(&buf->wait_poll);
+	spin_lock_init(&buf->fifo_lock);
+	buf->chunk_size = chunk_size;
+	buf->size = size;
+	ret = kfifo_alloc(&buf->fifo, size * chunk_size, GFP_KERNEL);
+	if (ret == 0)
+		buf->fifo_initialized = 1;
+
+	return ret;
+}
+
+static inline void lirc_buffer_free(struct lirc_buffer *buf)
+{
+	if (buf->fifo_initialized) {
+		kfifo_free(&buf->fifo);
+		buf->fifo_initialized = 0;
+	} else
+		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+		     __func__);
+}
+
+static inline int lirc_buffer_len(struct lirc_buffer *buf)
+{
+	int len;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->fifo_lock, flags);
+	len = kfifo_len(&buf->fifo);
+	spin_unlock_irqrestore(&buf->fifo_lock, flags);
+
+	return len;
+}
+
+static inline int lirc_buffer_full(struct lirc_buffer *buf)
+{
+	return lirc_buffer_len(buf) == buf->size * buf->chunk_size;
+}
+
+static inline int lirc_buffer_empty(struct lirc_buffer *buf)
+{
+	return !lirc_buffer_len(buf);
+}
+
+static inline int lirc_buffer_available(struct lirc_buffer *buf)
+{
+	return buf->size - (lirc_buffer_len(buf) / buf->chunk_size);
+}
+
+static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
+					    unsigned char *dest)
+{
+	unsigned int ret = 0;
+
+	if (lirc_buffer_len(buf) >= buf->chunk_size)
+		ret = kfifo_out_locked(&buf->fifo, dest, buf->chunk_size,
+				       &buf->fifo_lock);
+	return ret;
+
+}
+
+static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
+					     unsigned char *orig)
+{
+	unsigned int ret;
+
+	ret = kfifo_in_locked(&buf->fifo, orig, buf->chunk_size,
+			      &buf->fifo_lock);
+
+	return ret;
+}
+
+struct lirc_driver {
+	char name[40];
+	int minor;
+	unsigned long code_length;
+	unsigned int buffer_size; /* in chunks holding one code each */
+	int sample_rate;
+	unsigned long features;
+
+	unsigned int chunk_size;
+
+	void *data;
+	int min_timeout;
+	int max_timeout;
+	int (*add_to_buf) (void *data, struct lirc_buffer *buf);
+	struct lirc_buffer *rbuf;
+	int (*set_use_inc) (void *data);
+	void (*set_use_dec) (void *data);
+	struct file_operations *fops;
+	struct device *dev;
+	struct module *owner;
+};
+
+/* name:
+ * this string will be used for logs
+ *
+ * minor:
+ * indicates minor device (/dev/lirc) number for registered driver
+ * if caller fills it with negative value, then the first free minor
+ * number will be used (if available)
+ *
+ * code_length:
+ * length of the remote control key code expressed in bits
+ *
+ * sample_rate:
+ *
+ * data:
+ * it may point to any driver data and this pointer will be passed to
+ * all callback functions
+ *
+ * add_to_buf:
+ * add_to_buf will be called after specified period of the time or
+ * triggered by the external event, this behavior depends on value of
+ * the sample_rate this function will be called in user context. This
+ * routine should return 0 if data was added to the buffer and
+ * -ENODATA if none was available. This should add some number of bits
+ * evenly divisible by code_length to the buffer
+ *
+ * rbuf:
+ * if not NULL, it will be used as a read buffer, you will have to
+ * write to the buffer by other means, like irq's (see also
+ * lirc_serial.c).
+ *
+ * set_use_inc:
+ * set_use_inc will be called after device is opened
+ *
+ * set_use_dec:
+ * set_use_dec will be called after device is closed
+ *
+ * fops:
+ * file_operations for drivers which don't fit the current driver model.
+ *
+ * Some ioctl's can be directly handled by lirc_dev if the driver's
+ * ioctl function is NULL or if it returns -ENOIOCTLCMD (see also
+ * lirc_serial.c).
+ *
+ * owner:
+ * the module owning this struct
+ *
+ */
+
+
+/* following functions can be called ONLY from user context
+ *
+ * returns negative value on error or minor number
+ * of the registered device if success
+ * contents of the structure pointed by p is copied
+ */
+extern int lirc_register_driver(struct lirc_driver *d);
+
+/* returns negative value on error or 0 if success
+*/
+extern int lirc_unregister_driver(int minor);
+
+/* Returns the private data stored in the lirc_driver
+ * associated with the given device file pointer.
+ */
+void *lirc_get_pdata(struct file *file);
+
+/* default file operations
+ * used by drivers if they override only some operations
+ */
+int lirc_dev_fop_open(struct inode *inode, struct file *file);
+int lirc_dev_fop_close(struct inode *inode, struct file *file);
+unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
+long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+ssize_t lirc_dev_fop_read(struct file *file, char *buffer, size_t length,
+			  loff_t *ppos);
+ssize_t lirc_dev_fop_write(struct file *file, const char *buffer, size_t length,
+			   loff_t *ppos);
+
+#endif
-- 
1.7.1.1


-- 
Jarod Wilson
jarod@redhat.com

