Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab0JRWyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 18:54:17 -0400
Date: Mon, 18 Oct 2010 20:52:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, jarod@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] cx231xx: Remove IR support from the driver
Message-ID: <20101018205258.5336e5d1@pedra>
In-Reply-To: <cover.1287442245.git.mchehab@redhat.com>
References: <cover.1287442245.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Polaris design uses MCE support. Instead of reinventing the wheel,
just let mceusb handle the remote controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 drivers/media/video/cx231xx/cx231xx-input.c

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2db9856..dd20b04 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -628,11 +628,6 @@ void cx231xx_card_setup(struct cx231xx *dev)
 		else
 			cx231xx_config_tuner(dev);
 	}
-
-#if 0
-	/* TBD  IR will be added later */
-	cx231xx_ir_init(dev);
-#endif
 }
 
 /*
@@ -666,12 +661,6 @@ void cx231xx_config_i2c(struct cx231xx *dev)
 */
 void cx231xx_release_resources(struct cx231xx *dev)
 {
-
-#if 0		/* TBD IR related  */
-	if (dev->ir)
-		cx231xx_ir_fini(dev);
-#endif
-
 	cx231xx_release_analog_resources(dev);
 
 	cx231xx_remove_from_devlist(dev);
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
deleted file mode 100644
index a0e8bb8..0000000
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ /dev/null
@@ -1,251 +0,0 @@
-/*
-  handle cx231xx IR remotes via linux kernel input layer.
-
-  Copyright (C) 2008 <srinivasa.deevi at conexant dot com>
-		Based on em28xx driver
-
-		< This is a place holder for IR now.>
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/input.h>
-#include <linux/usb.h>
-#include <linux/slab.h>
-
-#include "cx231xx.h"
-
-static unsigned int ir_debug;
-module_param(ir_debug, int, 0644);
-MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
-
-#define MODULE_NAME "cx231xx"
-
-#define i2cdprintk(fmt, arg...) \
-	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
-	}
-
-#define dprintk(fmt, arg...) \
-	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
-	}
-
-/**********************************************************
- Polling structure used by cx231xx IR's
- **********************************************************/
-
-struct cx231xx_ir_poll_result {
-	unsigned int toggle_bit:1;
-	unsigned int read_count:7;
-	u8 rc_address;
-	u8 rc_data[4];
-};
-
-struct cx231xx_IR {
-	struct cx231xx *dev;
-	struct input_dev *input;
-	struct ir_input_state ir;
-	char name[32];
-	char phys[32];
-
-	/* poll external decoder */
-	int polling;
-	struct work_struct work;
-	struct timer_list timer;
-	unsigned int last_toggle:1;
-	unsigned int last_readcount;
-	unsigned int repeat_interval;
-
-	int (*get_key) (struct cx231xx_IR *, struct cx231xx_ir_poll_result *);
-};
-
-/**********************************************************
- Polling code for cx231xx
- **********************************************************/
-
-static void cx231xx_ir_handle_key(struct cx231xx_IR *ir)
-{
-	int result;
-	int do_sendkey = 0;
-	struct cx231xx_ir_poll_result poll_result;
-
-	/* read the registers containing the IR status */
-	result = ir->get_key(ir, &poll_result);
-	if (result < 0) {
-		dprintk("ir->get_key() failed %d\n", result);
-		return;
-	}
-
-	dprintk("ir->get_key result tb=%02x rc=%02x lr=%02x data=%02x\n",
-		poll_result.toggle_bit, poll_result.read_count,
-		ir->last_readcount, poll_result.rc_data[0]);
-
-	if (ir->dev->chip_id == CHIP_ID_EM2874) {
-		/* The em2874 clears the readcount field every time the
-		   register is read.  The em2860/2880 datasheet says that it
-		   is supposed to clear the readcount, but it doesn't.  So with
-		   the em2874, we are looking for a non-zero read count as
-		   opposed to a readcount that is incrementing */
-		ir->last_readcount = 0;
-	}
-
-	if (poll_result.read_count == 0) {
-		/* The button has not been pressed since the last read */
-	} else if (ir->last_toggle != poll_result.toggle_bit) {
-		/* A button has been pressed */
-		dprintk("button has been pressed\n");
-		ir->last_toggle = poll_result.toggle_bit;
-		ir->repeat_interval = 0;
-		do_sendkey = 1;
-	} else if (poll_result.toggle_bit == ir->last_toggle &&
-		   poll_result.read_count > 0 &&
-		   poll_result.read_count != ir->last_readcount) {
-		/* The button is still being held down */
-		dprintk("button being held down\n");
-
-		/* Debouncer for first keypress */
-		if (ir->repeat_interval++ > 9) {
-			/* Start repeating after 1 second */
-			do_sendkey = 1;
-		}
-	}
-
-	if (do_sendkey) {
-		dprintk("sending keypress\n");
-		ir_input_keydown(ir->input, &ir->ir, poll_result.rc_data[0]);
-		ir_input_nokey(ir->input, &ir->ir);
-	}
-
-	ir->last_readcount = poll_result.read_count;
-	return;
-}
-
-static void ir_timer(unsigned long data)
-{
-	struct cx231xx_IR *ir = (struct cx231xx_IR *)data;
-
-	schedule_work(&ir->work);
-}
-
-static void cx231xx_ir_work(struct work_struct *work)
-{
-	struct cx231xx_IR *ir = container_of(work, struct cx231xx_IR, work);
-
-	cx231xx_ir_handle_key(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
-}
-
-void cx231xx_ir_start(struct cx231xx_IR *ir)
-{
-	setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
-	INIT_WORK(&ir->work, cx231xx_ir_work);
-	schedule_work(&ir->work);
-}
-
-static void cx231xx_ir_stop(struct cx231xx_IR *ir)
-{
-	del_timer_sync(&ir->timer);
-	flush_scheduled_work();
-}
-
-int cx231xx_ir_init(struct cx231xx *dev)
-{
-	struct cx231xx_IR *ir;
-	struct input_dev *input_dev;
-	u8 ir_config;
-	int err = -ENOMEM;
-
-	if (dev->board.ir_codes == NULL) {
-		/* No remote control support */
-		return 0;
-	}
-
-	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ir || !input_dev)
-		goto err_out_free;
-
-	ir->input = input_dev;
-
-	/* Setup the proper handler based on the chip */
-	switch (dev->chip_id) {
-	default:
-		printk("Unrecognized cx231xx chip id: IR not supported\n");
-		goto err_out_free;
-	}
-
-	/* This is how often we ask the chip for IR information */
-	ir->polling = 100;	/* ms */
-
-	/* init input device */
-	snprintf(ir->name, sizeof(ir->name), "cx231xx IR (%s)", dev->name);
-
-	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
-	strlcat(ir->phys, "/input0", sizeof(ir->phys));
-
-	err = ir_input_init(input_dev, &ir->ir, IR_TYPE_OTHER);
-	if (err < 0)
-		goto err_out_free;
-
-	input_dev->name = ir->name;
-	input_dev->phys = ir->phys;
-	input_dev->id.bustype = BUS_USB;
-	input_dev->id.version = 1;
-	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
-
-	input_dev->dev.parent = &dev->udev->dev;
-	/* record handles to ourself */
-	ir->dev = dev;
-	dev->ir = ir;
-
-	cx231xx_ir_start(ir);
-
-	/* all done */
-	err = ir_input_register(ir->input, dev->board.ir_codes,
-				NULL, MODULE_NAME);
-	if (err)
-		goto err_out_stop;
-
-	return 0;
-err_out_stop:
-	cx231xx_ir_stop(ir);
-	dev->ir = NULL;
-err_out_free:
-	kfree(ir);
-	return err;
-}
-
-int cx231xx_ir_fini(struct cx231xx *dev)
-{
-	struct cx231xx_IR *ir = dev->ir;
-
-	/* skip detach on non attached boards */
-	if (!ir)
-		return 0;
-
-	cx231xx_ir_stop(ir);
-	ir_input_unregister(ir->input);
-	kfree(ir);
-
-	/* done */
-	dev->ir = NULL;
-	return 0;
-}
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 3ac313d..ff8ea37 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -954,10 +954,6 @@ extern struct usb_device_id cx231xx_id_table[];
 extern const unsigned int cx231xx_bcount;
 int cx231xx_tuner_callback(void *ptr, int component, int command, int arg);
 
-/* Provided by cx231xx-input.c */
-int cx231xx_ir_init(struct cx231xx *dev);
-int cx231xx_ir_fini(struct cx231xx *dev);
-
 /* cx23885-417.c                                               */
 extern int cx231xx_417_register(struct cx231xx *dev);
 extern void cx231xx_417_unregister(struct cx231xx *dev);
-- 
1.7.1

