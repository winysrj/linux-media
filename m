Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:34943 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab0DXVOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:14:20 -0400
Subject: [PATCH 4/4] ir-core: remove ir-functions usage from cx231xx
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Sat, 24 Apr 2010 23:14:16 +0200
Message-ID: <20100424211416.11570.83633.stgit@localhost.localdomain>
In-Reply-To: <20100424210843.11570.82007.stgit@localhost.localdomain>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers/media/video/cx231xx/cx231xx-input.c to not
rely on ir-functions.c.

(I do not have the hardware so I can only compile test this)

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/cx231xx/cx231xx-input.c |   47 +++++----------------------
 drivers/media/video/cx231xx/cx231xx.h       |    2 +
 2 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index dbd6218..a3d6593 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -60,7 +60,6 @@ struct cx231xx_ir_poll_result {
 struct cx231xx_IR {
 	struct cx231xx *dev;
 	struct input_dev *input;
-	struct ir_input_state ir;
 	char name[32];
 	char phys[32];
 
@@ -68,9 +67,7 @@ struct cx231xx_IR {
 	int polling;
 	struct work_struct work;
 	struct timer_list timer;
-	unsigned int last_toggle:1;
 	unsigned int last_readcount;
-	unsigned int repeat_interval;
 
 	int (*get_key) (struct cx231xx_IR *, struct cx231xx_ir_poll_result *);
 };
@@ -82,7 +79,6 @@ struct cx231xx_IR {
 static void cx231xx_ir_handle_key(struct cx231xx_IR *ir)
 {
 	int result;
-	int do_sendkey = 0;
 	struct cx231xx_ir_poll_result poll_result;
 
 	/* read the registers containing the IR status */
@@ -96,44 +92,23 @@ static void cx231xx_ir_handle_key(struct cx231xx_IR *ir)
 		poll_result.toggle_bit, poll_result.read_count,
 		ir->last_readcount, poll_result.rc_data[0]);
 
-	if (ir->dev->chip_id == CHIP_ID_EM2874) {
+	if (poll_result.read_count > 0 &&
+	    poll_result.read_count != ir->last_readcount)
+		ir_keydown(ir->input,
+			   poll_result.rc_data[0],
+			   poll_result.toggle_bit);
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
+	else
+		ir->last_readcount = poll_result.read_count;
 
-	if (do_sendkey) {
-		dprintk("sending keypress\n");
-		ir_input_keydown(ir->input, &ir->ir, poll_result.rc_data[0]);
-		ir_input_nokey(ir->input, &ir->ir);
 	}
-
-	ir->last_readcount = poll_result.read_count;
-	return;
 }
 
 static void ir_timer(unsigned long data)
@@ -199,10 +174,6 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	err = ir_input_init(input_dev, &ir->ir, IR_TYPE_OTHER);
-	if (err < 0)
-		goto err_out_free;
-
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_USB;
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 17d4d1a..38d4171 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -32,7 +32,7 @@
 
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
-#include <media/ir-kbd-i2c.h>
+#include <media/ir-core.h>
 #if defined(CONFIG_VIDEO_CX231XX_DVB) || \
 	defined(CONFIG_VIDEO_CX231XX_DVB_MODULE)
 #include <media/videobuf-dvb.h>

