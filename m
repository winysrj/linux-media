Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51231 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0FGTc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:26 -0400
Subject: [PATCH 2/8] ir-core: convert em28xx to not use ir-functions.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:23 +0200
Message-ID: <20100607193223.21236.36477.stgit@localhost.localdomain>
In-Reply-To: <20100607192830.21236.69701.stgit@localhost.localdomain>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers/media/video/em28xx/em28xx-input.c to not use ir-functions.c

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/em28xx/em28xx-input.c |   65 +++++++----------------------
 drivers/media/video/em28xx/em28xx.h       |    1 
 2 files changed, 17 insertions(+), 49 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index dffd026..c4d6027 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -64,17 +64,14 @@ struct em28xx_ir_poll_result {
 struct em28xx_IR {
 	struct em28xx *dev;
 	struct input_dev *input;
-	struct ir_input_state ir;
 	char name[32];
 	char phys[32];
 
 	/* poll external decoder */
 	int polling;
 	struct delayed_work work;
-	unsigned int last_toggle:1;
 	unsigned int full_code:1;
 	unsigned int last_readcount;
-	unsigned int repeat_interval;
 
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
 
@@ -290,7 +287,6 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 {
 	int result;
-	int do_sendkey = 0;
 	struct em28xx_ir_poll_result poll_result;
 
 	/* read the registers containing the IR status */
@@ -305,52 +301,28 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 		ir->last_readcount, poll_result.rc_address,
 		poll_result.rc_data[0]);
 
-	if (ir->dev->chip_id == CHIP_ID_EM2874) {
+	if (poll_result.read_count > 0 &&
+	    poll_result.read_count != ir->last_readcount) {
+		if (ir->full_code)
+			ir_keydown(ir->input,
+				   poll_result.rc_address << 8 |
+				   poll_result.rc_data[0],
+				   poll_result.toggle_bit);
+		else
+			ir_keydown(ir->input,
+				   poll_result.rc_data[0],
+				   poll_result.toggle_bit);
+	}
+
+	if (ir->dev->chip_id == CHIP_ID_EM2874)
 		/* The em2874 clears the readcount field every time the
 		   register is read.  The em2860/2880 datasheet says that it
 		   is supposed to clear the readcount, but it doesn't.  So with
 		   the em2874, we are looking for a non-zero read count as
 		   opposed to a readcount that is incrementing */
 		ir->last_readcount = 0;
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
-
-		if (ir->full_code)
-			ir_input_keydown(ir->input, &ir->ir,
-					 poll_result.rc_address << 8 |
-					 poll_result.rc_data[0]);
-		else
-			ir_input_keydown(ir->input, &ir->ir,
-					 poll_result.rc_data[0]);
-
-		ir_input_nokey(ir->input, &ir->ir);
-	}
-
-	ir->last_readcount = poll_result.read_count;
-	return;
+	else
+		ir->last_readcount = poll_result.read_count;
 }
 
 static void em28xx_ir_work(struct work_struct *work)
@@ -465,11 +437,6 @@ int em28xx_ir_init(struct em28xx *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	/* Set IR protocol */
-	err = ir_input_init(input_dev, &ir->ir, IR_TYPE_OTHER);
-	if (err < 0)
-		goto err_out_free;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_USB;
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index b252d1b..6216786 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -32,6 +32,7 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <media/ir-kbd-i2c.h>
+#include <media/ir-core.h>
 #if defined(CONFIG_VIDEO_EM28XX_DVB) || defined(CONFIG_VIDEO_EM28XX_DVB_MODULE)
 #include <media/videobuf-dvb.h>
 #endif

