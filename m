Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0HBV3c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 17:29:32 -0400
Date: Mon, 2 Aug 2010 17:29:22 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org, greg@kroah.com
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: [PATCH 1/2] staging/lirc: port lirc_streamzap to ir-core
Message-ID: <20100802212922.GA17746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ports lirc_streamzap.c over to ir-core in-place, to be followed by
a patch moving the driver over to drivers/media/IR/streamzap.c and
enabling the proper Kconfig bits.

Presently, the in-kernel keymap doesn't work, as the stock Streamzap
remote uses an RC-5-like, but not-quite-RC-5 protocol, which the
in-kernel RC-5 decoder doesn't cope with. The remote can be used right
now with the lirc bridge driver though, and other remotes (at least an
RC-6(A) MCE remote) work perfectly with the driver.

I'll take a look at making the existing RC-5 decoder cope with this odd
duck, possibly implement another standalone decoder engine, or just
throw up my hands and say "meh, use lirc"... But the driver itself
should be perfectly sound.

Remaining items on the streamzap TODO list:
- add LIRC_SET_REC_TIMEOUT-alike support
- add LIRC_GET_M{AX,IN}_TIMEOUT-alike support
- add LIRC_GET_REC_RESOLUTION-alike support

All of the above should be trivial to add. There are patches pending to
add this support to ir-core from Maxim Levitsky, and I'll take care of
these once his patches get integrated. None of them are currently
essential though.

CC: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/keymaps/Makefile           |    1 +
 drivers/media/IR/keymaps/rc-rc5-streamzap.c |   81 +++
 drivers/staging/lirc/lirc_streamzap.c       |  812 ++++++++++++---------------
 include/media/rc-map.h                      |    1 +
 4 files changed, 449 insertions(+), 446 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-rc5-streamzap.c

diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 86d3d1f..af81224 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-purpletv.o \
 			rc-pv951.o \
 			rc-rc5-hauppauge-new.o \
+			rc-rc5-streamzap.o \
 			rc-rc5-tv.o \
 			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
diff --git a/drivers/media/IR/keymaps/rc-rc5-streamzap.c b/drivers/media/IR/keymaps/rc-rc5-streamzap.c
new file mode 100644
index 0000000..4c19c58
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-rc5-streamzap.c
@@ -0,0 +1,81 @@
+/* rc-rc5-streamzap.c - Keytable for Streamzap PC Remote, for use
+ * with the Streamzap PC Remote IR Receiver.
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct ir_scancode rc5_streamzap[] = {
+/*
+ * FIXME: The Streamzap remote isn't actually true RC-5, it has an extra
+ * bit in it, which presently throws the in-kernel RC-5 decoder for a loop.
+ * We either have to enhance the decoder to support it, add a new decoder,
+ * or just rely on lirc userspace decoding.
+ */
+	{ 0x00, KEY_NUMERIC_0 },
+	{ 0x01, KEY_NUMERIC_1 },
+	{ 0x02, KEY_NUMERIC_2 },
+	{ 0x03, KEY_NUMERIC_3 },
+	{ 0x04, KEY_NUMERIC_4 },
+	{ 0x05, KEY_NUMERIC_5 },
+	{ 0x06, KEY_NUMERIC_6 },
+	{ 0x07, KEY_NUMERIC_7 },
+	{ 0x08, KEY_NUMERIC_8 },
+	{ 0x0a, KEY_POWER },
+	{ 0x0b, KEY_MUTE },
+	{ 0x0c, KEY_CHANNELUP },
+	{ 0x0d, KEY_VOLUMEUP },
+	{ 0x0e, KEY_CHANNELDOWN },
+	{ 0x0f, KEY_VOLUMEDOWN },
+	{ 0x10, KEY_UP },
+	{ 0x11, KEY_LEFT },
+	{ 0x12, KEY_OK },
+	{ 0x13, KEY_RIGHT },
+	{ 0x14, KEY_DOWN },
+	{ 0x15, KEY_MENU },
+	{ 0x16, KEY_EXIT },
+	{ 0x17, KEY_PLAY },
+	{ 0x18, KEY_PAUSE },
+	{ 0x19, KEY_STOP },
+	{ 0x1a, KEY_BACK },
+	{ 0x1b, KEY_FORWARD },
+	{ 0x1c, KEY_RECORD },
+	{ 0x1d, KEY_REWIND },
+	{ 0x1e, KEY_FASTFORWARD },
+	{ 0x20, KEY_RED },
+	{ 0x21, KEY_GREEN },
+	{ 0x22, KEY_YELLOW },
+	{ 0x23, KEY_BLUE },
+
+};
+
+static struct rc_keymap rc5_streamzap_map = {
+	.map = {
+		.scan    = rc5_streamzap,
+		.size    = ARRAY_SIZE(rc5_streamzap),
+		.ir_type = IR_TYPE_RC5,
+		.name    = RC_MAP_RC5_STREAMZAP,
+	}
+};
+
+static int __init init_rc_map_rc5_streamzap(void)
+{
+	return ir_register_map(&rc5_streamzap_map);
+}
+
+static void __exit exit_rc_map_rc5_streamzap(void)
+{
+	ir_unregister_map(&rc5_streamzap_map);
+}
+
+module_init(init_rc_map_rc5_streamzap)
+module_exit(exit_rc_map_rc5_streamzap)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/staging/lirc/lirc_streamzap.c b/drivers/staging/lirc/lirc_streamzap.c
index 5b46ac4..058e29f 100644
--- a/drivers/staging/lirc/lirc_streamzap.c
+++ b/drivers/staging/lirc/lirc_streamzap.c
@@ -2,6 +2,7 @@
  * Streamzap Remote Control driver
  *
  * Copyright (c) 2005 Christoph Bartelmus <lirc@bartelmus.de>
+ * Copyright (c) 2010 Jarod Wilson <jarod@wilsonet.com>
  *
  * This driver was based on the work of Greg Wickham and Adrian
  * Dewhurst. It was substantially rewritten to support correct signal
@@ -10,6 +11,8 @@
  * delay buffer an ugly hack would be required in lircd, which can
  * cause sluggish signal decoding in certain situations.
  *
+ * Ported to in-kernel ir-core interface by Jarod Wilson
+ *
  * This driver is based on the USB skeleton driver packaged with the
  * kernel; copyright (C) 2001-2003 Greg Kroah-Hartman (greg@kroah.com)
  *
@@ -28,36 +31,26 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/slab.h>
+#include <linux/device.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
-#include <linux/completion.h>
-#include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/input.h>
+#include <media/ir-core.h>
 
-#include <media/lirc.h>
-#include <media/lirc_dev.h>
-
-#define DRIVER_VERSION	"1.28"
-#define DRIVER_NAME	"lirc_streamzap"
+#define DRIVER_VERSION	"1.60"
+#define DRIVER_NAME	"streamzap"
 #define DRIVER_DESC	"Streamzap Remote Control driver"
 
+#ifdef CONFIG_USB_DEBUG
+static int debug = 1;
+#else
 static int debug;
+#endif
 
 #define USB_STREAMZAP_VENDOR_ID		0x0e9c
 #define USB_STREAMZAP_PRODUCT_ID	0x0000
 
-/* Use our own dbg macro */
-#define dprintk(fmt, args...)					\
-	do {							\
-		if (debug)					\
-			printk(KERN_DEBUG DRIVER_NAME "[%d]: "	\
-			       fmt "\n", ## args);		\
-	} while (0)
-
 /* table of devices that work with this driver */
 static struct usb_device_id streamzap_table[] = {
 	/* Streamzap Remote Control */
@@ -74,7 +67,7 @@ MODULE_DEVICE_TABLE(usb, streamzap_table);
 #define STREAMZAP_RESOLUTION 256
 
 /* number of samples buffered */
-#define STREAMZAP_BUF_LEN 128
+#define SZ_BUF_LEN 128
 
 enum StreamzapDecoderState {
 	PulseSpace,
@@ -83,65 +76,52 @@ enum StreamzapDecoderState {
 	IgnorePulse
 };
 
-/* Structure to hold all of our device specific stuff
- *
- * some remarks regarding locking:
- * theoretically this struct can be accessed from three threads:
- *
- * - from lirc_dev through set_use_inc/set_use_dec
- *
- * - from the USB layer throuh probe/disconnect/irq
- *
- *   Careful placement of lirc_register_driver/lirc_unregister_driver
- *   calls will prevent conflicts. lirc_dev makes sure that
- *   set_use_inc/set_use_dec are not being executed and will not be
- *   called after lirc_unregister_driver returns.
- *
- * - by the timer callback
- *
- *   The timer is only running when the device is connected and the
- *   LIRC device is open. Making sure the timer is deleted by
- *   set_use_dec will make conflicts impossible.
- */
-struct usb_streamzap {
+/* structure to hold our device specific stuff */
+struct streamzap_ir {
+
+	/* ir-core */
+	struct ir_dev_props *props;
+	struct ir_raw_event rawir;
+
+	/* core device info */
+	struct device *dev;
+	struct input_dev *idev;
 
 	/* usb */
-	/* save off the usb device pointer */
-	struct usb_device	*udev;
-	/* the interface for this device */
+	struct usb_device	*usbdev;
 	struct usb_interface	*interface;
+	struct usb_endpoint_descriptor *endpoint;
+	struct urb		*urb_in;
 
 	/* buffer & dma */
 	unsigned char		*buf_in;
 	dma_addr_t		dma_in;
 	unsigned int		buf_in_len;
 
-	struct usb_endpoint_descriptor *endpoint;
-
-	/* IRQ */
-	struct urb		*urb_in;
-
-	/* lirc */
-	struct lirc_driver	*driver;
-	struct lirc_buffer	*delay_buf;
-
 	/* timer used to support delay buffering */
 	struct timer_list	delay_timer;
-	int			timer_running;
+	bool			timer_running;
 	spinlock_t		timer_lock;
+	struct timer_list	flush_timer;
+	bool			flush;
+
+	/* delay buffer */
+	struct kfifo fifo;
+	bool fifo_initialized;
 
+	/* track what state we're in */
+	enum StreamzapDecoderState decoder_state;
 	/* tracks whether we are currently receiving some signal */
-	int			idle;
+	bool			idle;
 	/* sum of signal lengths received since signal start */
 	unsigned long		sum;
 	/* start time of signal; necessary for gap tracking */
 	struct timeval		signal_last;
 	struct timeval		signal_start;
-	enum StreamzapDecoderState decoder_state;
-	struct timer_list	flush_timer;
-	int			flush;
-	int			in_use;
-	int			timeout_enabled;
+	/* bool			timeout_enabled; */
+
+	char			name[128];
+	char			phys[64];
 };
 
 
@@ -149,16 +129,11 @@ struct usb_streamzap {
 static int streamzap_probe(struct usb_interface *interface,
 			   const struct usb_device_id *id);
 static void streamzap_disconnect(struct usb_interface *interface);
-static void usb_streamzap_irq(struct urb *urb);
-static int streamzap_use_inc(void *data);
-static void streamzap_use_dec(void *data);
-static long streamzap_ioctl(struct file *filep, unsigned int cmd,
-			    unsigned long arg);
+static void streamzap_callback(struct urb *urb);
 static int streamzap_suspend(struct usb_interface *intf, pm_message_t message);
 static int streamzap_resume(struct usb_interface *intf);
 
 /* usb specific object needed to register this driver with the usb subsystem */
-
 static struct usb_driver streamzap_driver = {
 	.name =		DRIVER_NAME,
 	.probe =	streamzap_probe,
@@ -168,13 +143,13 @@ static struct usb_driver streamzap_driver = {
 	.id_table =	streamzap_table,
 };
 
-static void stop_timer(struct usb_streamzap *sz)
+static void streamzap_stop_timer(struct streamzap_ir *sz)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&sz->timer_lock, flags);
 	if (sz->timer_running) {
-		sz->timer_running = 0;
+		sz->timer_running = false;
 		spin_unlock_irqrestore(&sz->timer_lock, flags);
 		del_timer_sync(&sz->delay_timer);
 	} else {
@@ -182,175 +157,183 @@ static void stop_timer(struct usb_streamzap *sz)
 	}
 }
 
-static void flush_timeout(unsigned long arg)
+static void streamzap_flush_timeout(unsigned long arg)
 {
-	struct usb_streamzap *sz = (struct usb_streamzap *) arg;
+	struct streamzap_ir *sz = (struct streamzap_ir *)arg;
+
+	dev_info(sz->dev, "%s: callback firing\n", __func__);
 
 	/* finally start accepting data */
-	sz->flush = 0;
+	sz->flush = false;
 }
-static void delay_timeout(unsigned long arg)
+
+static void streamzap_delay_timeout(unsigned long arg)
 {
+	struct streamzap_ir *sz = (struct streamzap_ir *)arg;
+	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
 	unsigned long flags;
+	int len, ret;
+	static unsigned long delay;
+	bool wake = false;
+
 	/* deliver data every 10 ms */
-	static unsigned long timer_inc =
-		(10000/(1000000/HZ)) == 0 ? 1 : (10000/(1000000/HZ));
-	struct usb_streamzap *sz = (struct usb_streamzap *) arg;
-	int data;
+	delay = msecs_to_jiffies(10);
 
 	spin_lock_irqsave(&sz->timer_lock, flags);
 
-	if (!lirc_buffer_empty(sz->delay_buf) &&
-	    !lirc_buffer_full(sz->driver->rbuf)) {
-		lirc_buffer_read(sz->delay_buf, (unsigned char *) &data);
-		lirc_buffer_write(sz->driver->rbuf, (unsigned char *) &data);
+	if (kfifo_len(&sz->fifo) > 0) {
+		ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
+		if (ret != sizeof(rawir))
+			dev_err(sz->dev, "Problem w/kfifo_out...\n");
+		ir_raw_event_store(sz->idev, &rawir);
+		wake = true;
 	}
-	if (!lirc_buffer_empty(sz->delay_buf)) {
-		while (lirc_buffer_available(sz->delay_buf) <
-		       STREAMZAP_BUF_LEN / 2 &&
-		       !lirc_buffer_full(sz->driver->rbuf)) {
-			lirc_buffer_read(sz->delay_buf,
-					   (unsigned char *) &data);
-			lirc_buffer_write(sz->driver->rbuf,
-					    (unsigned char *) &data);
-		}
-		if (sz->timer_running) {
-			sz->delay_timer.expires = jiffies + timer_inc;
-			add_timer(&sz->delay_timer);
+
+	len = kfifo_len(&sz->fifo);
+	if (len > 0) {
+		while ((len < SZ_BUF_LEN / 2) &&
+		       (len < SZ_BUF_LEN * sizeof(int))) {
+			ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
+			if (ret != sizeof(rawir))
+				dev_err(sz->dev, "Problem w/kfifo_out...\n");
+			ir_raw_event_store(sz->idev, &rawir);
+			wake = true;
+			len = kfifo_len(&sz->fifo);
 		}
+		if (sz->timer_running)
+			mod_timer(&sz->delay_timer, jiffies + delay);
+
 	} else {
-		sz->timer_running = 0;
+		sz->timer_running = false;
 	}
 
-	if (!lirc_buffer_empty(sz->driver->rbuf))
-		wake_up(&sz->driver->rbuf->wait_poll);
+	if (wake)
+		ir_raw_event_handle(sz->idev);
 
 	spin_unlock_irqrestore(&sz->timer_lock, flags);
 }
 
-static void flush_delay_buffer(struct usb_streamzap *sz)
+static void streamzap_flush_delay_buffer(struct streamzap_ir *sz)
 {
-	int data;
-	int empty = 1;
-
-	while (!lirc_buffer_empty(sz->delay_buf)) {
-		empty = 0;
-		lirc_buffer_read(sz->delay_buf, (unsigned char *) &data);
-		if (!lirc_buffer_full(sz->driver->rbuf)) {
-			lirc_buffer_write(sz->driver->rbuf,
-					    (unsigned char *) &data);
-		} else {
-			dprintk("buffer overflow", sz->driver->minor);
-		}
+	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	bool wake = false;
+	int ret;
+
+	while (kfifo_len(&sz->fifo) > 0) {
+		ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
+		if (ret != sizeof(rawir))
+			dev_err(sz->dev, "Problem w/kfifo_out...\n");
+		ir_raw_event_store(sz->idev, &rawir);
+		wake = true;
 	}
-	if (!empty)
-		wake_up(&sz->driver->rbuf->wait_poll);
+
+	if (wake)
+		ir_raw_event_handle(sz->idev);
 }
 
-static void push(struct usb_streamzap *sz, unsigned char *data)
+static void sz_push(struct streamzap_ir *sz)
 {
+	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&sz->timer_lock, flags);
-	if (lirc_buffer_full(sz->delay_buf)) {
-		int read_data;
-
-		lirc_buffer_read(sz->delay_buf,
-				   (unsigned char *) &read_data);
-		if (!lirc_buffer_full(sz->driver->rbuf)) {
-			lirc_buffer_write(sz->driver->rbuf,
-					    (unsigned char *) &read_data);
-		} else {
-			dprintk("buffer overflow", sz->driver->minor);
-		}
+	if (kfifo_len(&sz->fifo) >= sizeof(int) * SZ_BUF_LEN) {
+		ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
+		if (ret != sizeof(rawir))
+			dev_err(sz->dev, "Problem w/kfifo_out...\n");
+		ir_raw_event_store(sz->idev, &rawir);
 	}
 
-	lirc_buffer_write(sz->delay_buf, data);
+	kfifo_in(&sz->fifo, &sz->rawir, sizeof(rawir));
 
 	if (!sz->timer_running) {
-		sz->delay_timer.expires = jiffies + HZ/10;
+		sz->delay_timer.expires = jiffies + (HZ / 10);
 		add_timer(&sz->delay_timer);
-		sz->timer_running = 1;
+		sz->timer_running = true;
 	}
 
 	spin_unlock_irqrestore(&sz->timer_lock, flags);
 }
 
-static void push_full_pulse(struct usb_streamzap *sz,
-			    unsigned char value)
+static void sz_push_full_pulse(struct streamzap_ir *sz,
+			       unsigned char value)
 {
-	int pulse;
-
 	if (sz->idle) {
 		long deltv;
-		int tmp;
 
 		sz->signal_last = sz->signal_start;
 		do_gettimeofday(&sz->signal_start);
 
-		deltv = sz->signal_start.tv_sec-sz->signal_last.tv_sec;
+		deltv = sz->signal_start.tv_sec - sz->signal_last.tv_sec;
+		sz->rawir.pulse = false;
 		if (deltv > 15) {
 			/* really long time */
-			tmp = LIRC_SPACE(LIRC_VALUE_MASK);
+			sz->rawir.duration = IR_MAX_DURATION;
 		} else {
-			tmp = (int) (deltv*1000000+
-					sz->signal_start.tv_usec -
-					sz->signal_last.tv_usec);
-			tmp -= sz->sum;
-			tmp = LIRC_SPACE(tmp);
+			sz->rawir.duration = (int)(deltv * 1000000 +
+				sz->signal_start.tv_usec -
+				sz->signal_last.tv_usec);
+			sz->rawir.duration -= sz->sum;
+			sz->rawir.duration *= 1000;
+			sz->rawir.duration &= IR_MAX_DURATION;
 		}
-		dprintk("ls %u", sz->driver->minor, tmp);
-		push(sz, (char *)&tmp);
+		dev_dbg(sz->dev, "ls %u\n", sz->rawir.duration);
+		sz_push(sz);
 
 		sz->idle = 0;
 		sz->sum = 0;
 	}
 
-	pulse = ((int) value) * STREAMZAP_RESOLUTION;
-	pulse += STREAMZAP_RESOLUTION / 2;
-	sz->sum += pulse;
-	pulse = LIRC_PULSE(pulse);
-
-	dprintk("p %u", sz->driver->minor, pulse & PULSE_MASK);
-	push(sz, (char *)&pulse);
+	sz->rawir.pulse = true;
+	sz->rawir.duration = ((int) value) * STREAMZAP_RESOLUTION;
+	sz->rawir.duration += STREAMZAP_RESOLUTION / 2;
+	sz->sum += sz->rawir.duration;
+	sz->rawir.duration *= 1000;
+	sz->rawir.duration &= IR_MAX_DURATION;
+	dev_dbg(sz->dev, "p %u\n", sz->rawir.duration);
+	sz_push(sz);
 }
 
-static void push_half_pulse(struct usb_streamzap *sz,
-			    unsigned char value)
+static void sz_push_half_pulse(struct streamzap_ir *sz,
+			       unsigned char value)
 {
-	push_full_pulse(sz, (value & STREAMZAP_PULSE_MASK)>>4);
+	sz_push_full_pulse(sz, (value & STREAMZAP_PULSE_MASK) >> 4);
 }
 
-static void push_full_space(struct usb_streamzap *sz,
-			    unsigned char value)
+static void sz_push_full_space(struct streamzap_ir *sz,
+			       unsigned char value)
 {
-	int space;
-
-	space = ((int) value)*STREAMZAP_RESOLUTION;
-	space += STREAMZAP_RESOLUTION/2;
-	sz->sum += space;
-	space = LIRC_SPACE(space);
-	dprintk("s %u", sz->driver->minor, space);
-	push(sz, (char *)&space);
+	sz->rawir.pulse = false;
+	sz->rawir.duration = ((int) value) * STREAMZAP_RESOLUTION;
+	sz->rawir.duration += STREAMZAP_RESOLUTION / 2;
+	sz->sum += sz->rawir.duration;
+	sz->rawir.duration *= 1000;
+	dev_dbg(sz->dev, "s %u\n", sz->rawir.duration);
+	sz_push(sz);
 }
 
-static void push_half_space(struct usb_streamzap *sz,
-			    unsigned char value)
+static void sz_push_half_space(struct streamzap_ir *sz,
+			       unsigned long value)
 {
-	push_full_space(sz, value & STREAMZAP_SPACE_MASK);
+	sz_push_full_space(sz, value & STREAMZAP_SPACE_MASK);
 }
 
 /**
- * usb_streamzap_irq - IRQ handler
+ * streamzap_callback - usb IRQ handler callback
  *
  * This procedure is invoked on reception of data from
  * the usb remote.
  */
-static void usb_streamzap_irq(struct urb *urb)
+static void streamzap_callback(struct urb *urb)
 {
-	struct usb_streamzap *sz;
-	int		len;
-	unsigned int	i = 0;
+	struct streamzap_ir *sz;
+	unsigned int i;
+	int len;
+	#if 0
+	static int timeout = (((STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION) &
+				IR_MAX_DURATION) | 0x03000000);
+	#endif
 
 	if (!urb)
 		return;
@@ -366,51 +349,52 @@ static void usb_streamzap_irq(struct urb *urb)
 		 * this urb is terminated, clean up.
 		 * sz might already be invalid at this point
 		 */
-		dprintk("urb status: %d", -1, urb->status);
+		dev_err(sz->dev, "urb terminated, status: %d\n", urb->status);
 		return;
 	default:
 		break;
 	}
 
-	dprintk("received %d", sz->driver->minor, urb->actual_length);
+	dev_dbg(sz->dev, "%s: received urb, len %d\n", __func__, len);
 	if (!sz->flush) {
 		for (i = 0; i < urb->actual_length; i++) {
-			dprintk("%d: %x", sz->driver->minor,
-				i, (unsigned char) sz->buf_in[i]);
+			dev_dbg(sz->dev, "%d: %x\n", i,
+				(unsigned char)sz->buf_in[i]);
 			switch (sz->decoder_state) {
 			case PulseSpace:
-				if ((sz->buf_in[i]&STREAMZAP_PULSE_MASK) ==
+				if ((sz->buf_in[i] & STREAMZAP_PULSE_MASK) ==
 				    STREAMZAP_PULSE_MASK) {
 					sz->decoder_state = FullPulse;
 					continue;
-				} else if ((sz->buf_in[i]&STREAMZAP_SPACE_MASK)
+				} else if ((sz->buf_in[i] & STREAMZAP_SPACE_MASK)
 					   == STREAMZAP_SPACE_MASK) {
-					push_half_pulse(sz, sz->buf_in[i]);
+					sz_push_half_pulse(sz, sz->buf_in[i]);
 					sz->decoder_state = FullSpace;
 					continue;
 				} else {
-					push_half_pulse(sz, sz->buf_in[i]);
-					push_half_space(sz, sz->buf_in[i]);
+					sz_push_half_pulse(sz, sz->buf_in[i]);
+					sz_push_half_space(sz, sz->buf_in[i]);
 				}
 				break;
 			case FullPulse:
-				push_full_pulse(sz, sz->buf_in[i]);
+				sz_push_full_pulse(sz, sz->buf_in[i]);
 				sz->decoder_state = IgnorePulse;
 				break;
 			case FullSpace:
 				if (sz->buf_in[i] == STREAMZAP_TIMEOUT) {
 					sz->idle = 1;
-					stop_timer(sz);
+					streamzap_stop_timer(sz);
+					#if 0
 					if (sz->timeout_enabled) {
-						int timeout =
-							LIRC_TIMEOUT
-							(STREAMZAP_TIMEOUT *
-							STREAMZAP_RESOLUTION);
-						push(sz, (char *)&timeout);
+						sz->rawir.pulse = false;
+						sz->rawir.duration = timeout;
+						sz->rawir.duration *= 1000;
+						sz_push(sz);
 					}
-					flush_delay_buffer(sz);
+					#endif
+					streamzap_flush_delay_buffer(sz);
 				} else
-					push_full_space(sz, sz->buf_in[i]);
+					sz_push_full_space(sz, sz->buf_in[i]);
 				sz->decoder_state = PulseSpace;
 				break;
 			case IgnorePulse:
@@ -419,7 +403,7 @@ static void usb_streamzap_irq(struct urb *urb)
 					sz->decoder_state = FullSpace;
 					continue;
 				}
-				push_half_space(sz, sz->buf_in[i]);
+				sz_push_half_space(sz, sz->buf_in[i]);
 				sz->decoder_state = PulseSpace;
 				break;
 			}
@@ -431,16 +415,80 @@ static void usb_streamzap_irq(struct urb *urb)
 	return;
 }
 
-static struct file_operations streamzap_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= streamzap_ioctl,
-	.read		= lirc_dev_fop_read,
-	.write		= lirc_dev_fop_write,
-	.poll		= lirc_dev_fop_poll,
-	.open		= lirc_dev_fop_open,
-	.release	= lirc_dev_fop_close,
-};
+static struct input_dev *streamzap_init_input_dev(struct streamzap_ir *sz)
+{
+	struct input_dev *idev;
+	struct ir_dev_props *props;
+	struct device *dev = sz->dev;
+	int ret;
+
+	idev = input_allocate_device();
+	if (!idev) {
+		dev_err(dev, "remote input dev allocation failed\n");
+		goto idev_alloc_failed;
+	}
+
+	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
+	if (!props) {
+		dev_err(dev, "remote ir dev props allocation failed\n");
+		goto props_alloc_failed;
+	}
+
+	snprintf(sz->name, sizeof(sz->name), "Streamzap PC Remote Infrared "
+		 "Receiver (%04x:%04x)",
+		 le16_to_cpu(sz->usbdev->descriptor.idVendor),
+		 le16_to_cpu(sz->usbdev->descriptor.idProduct));
+
+	idev->name = sz->name;
+	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
+	strlcat(sz->phys, "/input0", sizeof(sz->phys));
+	idev->phys = sz->phys;
+
+	props->priv = sz;
+	props->driver_type = RC_DRIVER_IR_RAW;
+	/* FIXME: not sure about supported protocols, check on this */
+	props->allowed_protos = IR_TYPE_RC5 | IR_TYPE_RC6;
+
+	sz->props = props;
+
+	ret = ir_input_register(idev, RC_MAP_RC5_STREAMZAP, props, DRIVER_NAME);
+	if (ret < 0) {
+		dev_err(dev, "remote input device register failed\n");
+		goto irdev_failed;
+	}
+
+	return idev;
+
+irdev_failed:
+	kfree(props);
+props_alloc_failed:
+	input_free_device(idev);
+idev_alloc_failed:
+	return NULL;
+}
+
+static int streamzap_delay_buf_init(struct streamzap_ir *sz)
+{
+	int ret;
+
+	ret = kfifo_alloc(&sz->fifo, sizeof(int) * SZ_BUF_LEN,
+			  GFP_KERNEL);
+	if (ret == 0)
+		sz->fifo_initialized = 1;
 
+	return ret;
+}
+
+static void streamzap_start_flush_timer(struct streamzap_ir *sz)
+{
+	sz->flush_timer.expires = jiffies + HZ;
+	sz->flush = true;
+	add_timer(&sz->flush_timer);
+
+	sz->urb_in->dev = sz->usbdev;
+	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
+		dev_err(sz->dev, "urb submit failed\n");
+}
 
 /**
  *	streamzap_probe
@@ -449,33 +497,30 @@ static struct file_operations streamzap_fops = {
  *	On any failure the return value is the ERROR
  *	On success return 0
  */
-static int streamzap_probe(struct usb_interface *interface,
-			   const struct usb_device_id *id)
+static int __devinit streamzap_probe(struct usb_interface *intf,
+				     const struct usb_device_id *id)
 {
-	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_device *usbdev = interface_to_usbdev(intf);
 	struct usb_host_interface *iface_host;
-	struct usb_streamzap *sz;
-	struct lirc_driver *driver;
-	struct lirc_buffer *lirc_buf;
-	struct lirc_buffer *delay_buf;
+	struct streamzap_ir *sz = NULL;
 	char buf[63], name[128] = "";
 	int retval = -ENOMEM;
-	int minor = 0;
+	int pipe, maxp;
 
 	/* Allocate space for device driver specific data */
-	sz = kzalloc(sizeof(struct usb_streamzap), GFP_KERNEL);
-	if (sz == NULL)
+	sz = kzalloc(sizeof(struct streamzap_ir), GFP_KERNEL);
+	if (!sz)
 		return -ENOMEM;
 
-	sz->udev = udev;
-	sz->interface = interface;
+	sz->usbdev = usbdev;
+	sz->interface = intf;
 
 	/* Check to ensure endpoint information matches requirements */
-	iface_host = interface->cur_altsetting;
+	iface_host = intf->cur_altsetting;
 
 	if (iface_host->desc.bNumEndpoints != 1) {
-		err("%s: Unexpected desc.bNumEndpoints (%d)", __func__,
-		    iface_host->desc.bNumEndpoints);
+		dev_err(&intf->dev, "%s: Unexpected desc.bNumEndpoints (%d)\n",
+			__func__, iface_host->desc.bNumEndpoints);
 		retval = -ENODEV;
 		goto free_sz;
 	}
@@ -483,219 +528,110 @@ static int streamzap_probe(struct usb_interface *interface,
 	sz->endpoint = &(iface_host->endpoint[0].desc);
 	if ((sz->endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
 	    != USB_DIR_IN) {
-		err("%s: endpoint doesn't match input device 02%02x",
-		    __func__, sz->endpoint->bEndpointAddress);
+		dev_err(&intf->dev, "%s: endpoint doesn't match input device "
+			"02%02x\n", __func__, sz->endpoint->bEndpointAddress);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
 	if ((sz->endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
 	    != USB_ENDPOINT_XFER_INT) {
-		err("%s: endpoint attributes don't match xfer 02%02x",
-		    __func__, sz->endpoint->bmAttributes);
+		dev_err(&intf->dev, "%s: endpoint attributes don't match xfer "
+			"02%02x\n", __func__, sz->endpoint->bmAttributes);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
-	if (sz->endpoint->wMaxPacketSize == 0) {
-		err("%s: endpoint message size==0? ", __func__);
+	pipe = usb_rcvintpipe(usbdev, sz->endpoint->bEndpointAddress);
+	maxp = usb_maxpacket(usbdev, pipe, usb_pipeout(pipe));
+
+	if (maxp == 0) {
+		dev_err(&intf->dev, "%s: endpoint Max Packet Size is 0!?!\n",
+			__func__);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
 	/* Allocate the USB buffer and IRQ URB */
-
-	sz->buf_in_len = sz->endpoint->wMaxPacketSize;
-	sz->buf_in = usb_alloc_coherent(sz->udev, sz->buf_in_len,
-				      GFP_ATOMIC, &sz->dma_in);
-	if (sz->buf_in == NULL)
+	sz->buf_in = usb_alloc_coherent(usbdev, maxp, GFP_ATOMIC, &sz->dma_in);
+	if (!sz->buf_in)
 		goto free_sz;
 
 	sz->urb_in = usb_alloc_urb(0, GFP_KERNEL);
-	if (sz->urb_in == NULL)
-		goto free_sz;
-
-	/* Connect this device to the LIRC sub-system */
-	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!driver)
-		goto free_sz;
+	if (!sz->urb_in)
+		goto free_buf_in;
 
-	lirc_buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!lirc_buf)
-		goto free_driver;
-	if (lirc_buffer_init(lirc_buf, sizeof(int), STREAMZAP_BUF_LEN))
-		goto kfree_lirc_buf;
-
-	delay_buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!delay_buf)
-		goto free_lirc_buf;
-	if (lirc_buffer_init(delay_buf, sizeof(int), STREAMZAP_BUF_LEN))
-		goto kfree_delay_buf;
-
-	sz->driver = driver;
-	strcpy(sz->driver->name, DRIVER_NAME);
-	sz->driver->minor = -1;
-	sz->driver->sample_rate = 0;
-	sz->driver->code_length = sizeof(int) * 8;
-	sz->driver->features = LIRC_CAN_REC_MODE2 |
-		LIRC_CAN_GET_REC_RESOLUTION |
-		LIRC_CAN_SET_REC_TIMEOUT;
-	sz->driver->data = sz;
-	sz->driver->min_timeout = STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION;
-	sz->driver->max_timeout = STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION;
-	sz->driver->rbuf = lirc_buf;
-	sz->delay_buf = delay_buf;
-	sz->driver->set_use_inc = &streamzap_use_inc;
-	sz->driver->set_use_dec = &streamzap_use_dec;
-	sz->driver->fops = &streamzap_fops;
-	sz->driver->dev = &interface->dev;
-	sz->driver->owner = THIS_MODULE;
-
-	sz->idle = 1;
-	sz->decoder_state = PulseSpace;
-	init_timer(&sz->delay_timer);
-	sz->delay_timer.function = delay_timeout;
-	sz->delay_timer.data = (unsigned long) sz;
-	sz->timer_running = 0;
-	spin_lock_init(&sz->timer_lock);
-
-	init_timer(&sz->flush_timer);
-	sz->flush_timer.function = flush_timeout;
-	sz->flush_timer.data = (unsigned long) sz;
-	/* Complete final initialisations */
+	sz->dev = &intf->dev;
+	sz->buf_in_len = maxp;
 
-	usb_fill_int_urb(sz->urb_in, udev,
-		usb_rcvintpipe(udev, sz->endpoint->bEndpointAddress),
-		sz->buf_in, sz->buf_in_len, usb_streamzap_irq, sz,
-		sz->endpoint->bInterval);
-	sz->urb_in->transfer_dma = sz->dma_in;
-	sz->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
-	if (udev->descriptor.iManufacturer
-	    && usb_string(udev, udev->descriptor.iManufacturer,
+	if (usbdev->descriptor.iManufacturer
+	    && usb_string(usbdev, usbdev->descriptor.iManufacturer,
 			  buf, sizeof(buf)) > 0)
 		strlcpy(name, buf, sizeof(name));
 
-	if (udev->descriptor.iProduct
-	    && usb_string(udev, udev->descriptor.iProduct,
+	if (usbdev->descriptor.iProduct
+	    && usb_string(usbdev, usbdev->descriptor.iProduct,
 			  buf, sizeof(buf)) > 0)
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	minor = lirc_register_driver(driver);
-
-	if (minor < 0)
-		goto free_delay_buf;
-
-	sz->driver->minor = minor;
-
-	usb_set_intfdata(interface, sz);
-
-	printk(KERN_INFO DRIVER_NAME "[%d]: %s on usb%d:%d attached\n",
-	       sz->driver->minor, name,
-	       udev->bus->busnum, sz->udev->devnum);
-
-	return 0;
-
-free_delay_buf:
-	lirc_buffer_free(sz->delay_buf);
-kfree_delay_buf:
-	kfree(delay_buf);
-free_lirc_buf:
-	lirc_buffer_free(sz->driver->rbuf);
-kfree_lirc_buf:
-	kfree(lirc_buf);
-free_driver:
-	kfree(driver);
-free_sz:
-	if (retval == -ENOMEM)
-		err("Out of memory");
-
-	if (sz) {
-		usb_free_urb(sz->urb_in);
-		usb_free_coherent(udev, sz->buf_in_len, sz->buf_in, sz->dma_in);
-		kfree(sz);
-	}
-
-	return retval;
-}
-
-static int streamzap_use_inc(void *data)
-{
-	struct usb_streamzap *sz = data;
-
-	if (!sz) {
-		dprintk("%s called with no context", -1, __func__);
-		return -EINVAL;
+	retval = streamzap_delay_buf_init(sz);
+	if (retval) {
+		dev_err(&intf->dev, "%s: delay buffer init failed\n", __func__);
+		goto free_urb_in;
 	}
-	dprintk("set use inc", sz->driver->minor);
 
-	lirc_buffer_clear(sz->driver->rbuf);
-	lirc_buffer_clear(sz->delay_buf);
+	sz->idev = streamzap_init_input_dev(sz);
+	if (!sz->idev)
+		goto input_dev_fail;
 
-	sz->flush_timer.expires = jiffies + HZ;
-	sz->flush = 1;
-	add_timer(&sz->flush_timer);
+	sz->idle = true;
+	sz->decoder_state = PulseSpace;
+	#if 0
+	/* not yet supported, depends on patches from maxim */
+	/* see also: LIRC_GET_REC_RESOLUTION and LIRC_SET_REC_TIMEOUT */
+	sz->timeout_enabled = false;
+	sz->min_timeout = STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION * 1000;
+	sz->max_timeout = STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION * 1000;
+	#endif
 
-	sz->urb_in->dev = sz->udev;
-	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC)) {
-		dprintk("open result = -EIO error submitting urb",
-			sz->driver->minor);
-		return -EIO;
-	}
-	sz->in_use++;
+	init_timer(&sz->delay_timer);
+	sz->delay_timer.function = streamzap_delay_timeout;
+	sz->delay_timer.data = (unsigned long)sz;
+	spin_lock_init(&sz->timer_lock);
 
-	return 0;
-}
+	init_timer(&sz->flush_timer);
+	sz->flush_timer.function = streamzap_flush_timeout;
+	sz->flush_timer.data = (unsigned long)sz;
 
-static void streamzap_use_dec(void *data)
-{
-	struct usb_streamzap *sz = data;
+	do_gettimeofday(&sz->signal_start);
 
-	if (!sz) {
-		dprintk("%s called with no context", -1, __func__);
-		return;
-	}
-	dprintk("set use dec", sz->driver->minor);
+	/* Complete final initialisations */
+	usb_fill_int_urb(sz->urb_in, usbdev, pipe, sz->buf_in,
+			 maxp, (usb_complete_t)streamzap_callback,
+			 sz, sz->endpoint->bInterval);
+	sz->urb_in->transfer_dma = sz->dma_in;
+	sz->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-	if (sz->flush) {
-		sz->flush = 0;
-		del_timer_sync(&sz->flush_timer);
-	}
+	usb_set_intfdata(intf, sz);
 
-	usb_kill_urb(sz->urb_in);
+	streamzap_start_flush_timer(sz);
 
-	stop_timer(sz);
+	dev_info(sz->dev, "Registered %s on usb%d:%d\n", name,
+		 usbdev->bus->busnum, usbdev->devnum);
 
-	sz->in_use--;
-}
+	return 0;
 
-static long streamzap_ioctl(struct file *filep, unsigned int cmd,
-			    unsigned long arg)
-{
-	int result = 0;
-	int val;
-	struct usb_streamzap *sz = lirc_get_pdata(filep);
+input_dev_fail:
+	kfifo_free(&sz->fifo);
+free_urb_in:
+	usb_free_urb(sz->urb_in);
+free_buf_in:
+	usb_free_coherent(usbdev, maxp, sz->buf_in, sz->dma_in);
+free_sz:
+	kfree(sz);
 
-	switch (cmd) {
-	case LIRC_GET_REC_RESOLUTION:
-		result = put_user(STREAMZAP_RESOLUTION, (unsigned int *) arg);
-		break;
-	case LIRC_SET_REC_TIMEOUT:
-		result = get_user(val, (int *)arg);
-		if (result == 0) {
-			if (val == STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION)
-				sz->timeout_enabled = 1;
-			else if (val == 0)
-				sz->timeout_enabled = 0;
-			else
-				result = -EINVAL;
-		}
-		break;
-	default:
-		return lirc_dev_fop_ioctl(filep, cmd, arg);
-	}
-	return result;
+	return retval;
 }
 
 /**
@@ -704,116 +640,100 @@ static long streamzap_ioctl(struct file *filep, unsigned int cmd,
  * Called by the usb core when the device is removed from the system.
  *
  * This routine guarantees that the driver will not submit any more urbs
- * by clearing dev->udev.  It is also supposed to terminate any currently
+ * by clearing dev->usbdev.  It is also supposed to terminate any currently
  * active urbs.  Unfortunately, usb_bulk_msg(), used in streamzap_read(),
  * does not provide any way to do this.
  */
 static void streamzap_disconnect(struct usb_interface *interface)
 {
-	struct usb_streamzap *sz;
-	int errnum;
-	int minor;
-
-	sz = usb_get_intfdata(interface);
+	struct streamzap_ir *sz = usb_get_intfdata(interface);
+	struct usb_device *usbdev = interface_to_usbdev(interface);
 
-	/* unregister from the LIRC sub-system */
+	usb_set_intfdata(interface, NULL);
 
-	errnum = lirc_unregister_driver(sz->driver->minor);
-	if (errnum != 0)
-		dprintk("error in lirc_unregister: (returned %d)",
-			sz->driver->minor, errnum);
+	if (!sz)
+		return;
 
-	lirc_buffer_free(sz->delay_buf);
-	lirc_buffer_free(sz->driver->rbuf);
+	if (sz->flush) {
+		sz->flush = false;
+		del_timer_sync(&sz->flush_timer);
+	}
 
-	/* unregister from the USB sub-system */
+	streamzap_stop_timer(sz);
 
+	sz->usbdev = NULL;
+	ir_input_unregister(sz->idev);
+	usb_kill_urb(sz->urb_in);
 	usb_free_urb(sz->urb_in);
+	usb_free_coherent(usbdev, sz->buf_in_len, sz->buf_in, sz->dma_in);
 
-	usb_free_coherent(sz->udev, sz->buf_in_len, sz->buf_in, sz->dma_in);
-
-	minor = sz->driver->minor;
-	kfree(sz->driver->rbuf);
-	kfree(sz->driver);
-	kfree(sz->delay_buf);
 	kfree(sz);
-
-	printk(KERN_INFO DRIVER_NAME "[%d]: disconnected\n", minor);
 }
 
 static int streamzap_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	struct usb_streamzap *sz = usb_get_intfdata(intf);
+	struct streamzap_ir *sz = usb_get_intfdata(intf);
 
-	printk(KERN_INFO DRIVER_NAME "[%d]: suspend\n", sz->driver->minor);
-	if (sz->in_use) {
-		if (sz->flush) {
-			sz->flush = 0;
-			del_timer_sync(&sz->flush_timer);
-		}
+	if (sz->flush) {
+		sz->flush = false;
+		del_timer_sync(&sz->flush_timer);
+	}
 
-		stop_timer(sz);
+	streamzap_stop_timer(sz);
+
+	usb_kill_urb(sz->urb_in);
 
-		usb_kill_urb(sz->urb_in);
-	}
 	return 0;
 }
 
 static int streamzap_resume(struct usb_interface *intf)
 {
-	struct usb_streamzap *sz = usb_get_intfdata(intf);
+	struct streamzap_ir *sz = usb_get_intfdata(intf);
 
-	lirc_buffer_clear(sz->driver->rbuf);
-	lirc_buffer_clear(sz->delay_buf);
+	if (sz->fifo_initialized)
+		kfifo_reset(&sz->fifo);
 
-	if (sz->in_use) {
-		sz->flush_timer.expires = jiffies + HZ;
-		sz->flush = 1;
-		add_timer(&sz->flush_timer);
+	sz->flush_timer.expires = jiffies + HZ;
+	sz->flush = true;
+	add_timer(&sz->flush_timer);
 
-		sz->urb_in->dev = sz->udev;
-		if (usb_submit_urb(sz->urb_in, GFP_ATOMIC)) {
-			dprintk("open result = -EIO error submitting urb",
-				sz->driver->minor);
-			return -EIO;
-		}
+	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC)) {
+		dev_err(sz->dev, "Error sumbiting urb\n");
+		return -EIO;
 	}
+
 	return 0;
 }
 
 /**
- *	usb_streamzap_init
+ *	streamzap_init
  */
-static int __init usb_streamzap_init(void)
+static int __init streamzap_init(void)
 {
-	int result;
+	int ret;
 
 	/* register this driver with the USB subsystem */
-	result = usb_register(&streamzap_driver);
-
-	if (result) {
-		err("usb_register failed. Error number %d",
-		    result);
-		return result;
-	}
+	ret = usb_register(&streamzap_driver);
+	if (ret < 0)
+		printk(KERN_ERR DRIVER_NAME ": usb register failed, "
+		       "result = %d\n", ret);
 
-	printk(KERN_INFO DRIVER_NAME " " DRIVER_VERSION " registered\n");
-	return 0;
+	return ret;
 }
 
 /**
- *	usb_streamzap_exit
+ *	streamzap_exit
  */
-static void __exit usb_streamzap_exit(void)
+static void __exit streamzap_exit(void)
 {
 	usb_deregister(&streamzap_driver);
 }
 
 
-module_init(usb_streamzap_init);
-module_exit(usb_streamzap_exit);
+module_init(streamzap_init);
+module_exit(streamzap_exit);
 
-MODULE_AUTHOR("Christoph Bartelmus, Greg Wickham, Adrian Dewhurst");
+MODULE_AUTHOR("Jarod Wilson <jarod@wilsonet.com>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index a329858..a9965c7 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -112,6 +112,7 @@ void rc_map_init(void);
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
 #define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
+#define RC_MAP_RC5_STREAMZAP             "rc-rc5-streamzap"
 #define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
-- 
1.7.2

-- 
Jarod Wilson
jarod@redhat.com

