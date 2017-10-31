Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37057 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753319AbdJaRqB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:01 -0400
Date: Tue, 31 Oct 2017 17:45:58 +0000
From: Sean Young <sean@mess.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: ttpci: remove autorepeat handling and use timer_setup
Message-ID: <20171031174558.vsdpdudcwjneq2nu@gofer.mess.org>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
 <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Leave the autorepeat handling up to the input layer, and move
to the new timer API.

Compile tested only.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/ttpci/av7110.h    |  2 +-
 drivers/media/pci/ttpci/av7110_ir.c | 54 ++++++++++++++-----------------------
 2 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 347827925c14..bcb72ecbedc0 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -93,7 +93,7 @@ struct infrared {
 	u8			inversion;
 	u16			last_key;
 	u16			last_toggle;
-	u8			delay_timer_finished;
+	bool			keypressed;
 };
 
 
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index ca05198de2c2..8207bead2224 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -84,15 +84,16 @@ static u16 default_key_map [256] = {
 
 
 /* key-up timer */
-static void av7110_emit_keyup(unsigned long parm)
+static void av7110_emit_keyup(struct timer_list *t)
 {
-	struct infrared *ir = (struct infrared *) parm;
+	struct infrared *ir = from_timer(ir, t, keyup_timer);
 
-	if (!ir || !test_bit(ir->last_key, ir->input_dev->key))
+	if (!ir || !ir->keypressed)
 		return;
 
 	input_report_key(ir->input_dev, ir->last_key, 0);
 	input_sync(ir->input_dev);
+	ir->keypressed = false;
 }
 
 
@@ -105,6 +106,7 @@ static void av7110_emit_key(unsigned long parm)
 	u8 addr;
 	u16 toggle;
 	u16 keycode;
+	bool new_event;
 
 	/* extract device address and data */
 	switch (ir->protocol) {
@@ -152,29 +154,22 @@ static void av7110_emit_key(unsigned long parm)
 		return;
 	}
 
-	if (timer_pending(&ir->keyup_timer)) {
-		del_timer(&ir->keyup_timer);
-		if (ir->last_key != keycode || toggle != ir->last_toggle) {
-			ir->delay_timer_finished = 0;
-			input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
-			input_event(ir->input_dev, EV_KEY, keycode, 1);
-			input_sync(ir->input_dev);
-		} else if (ir->delay_timer_finished) {
-			input_event(ir->input_dev, EV_KEY, keycode, 2);
-			input_sync(ir->input_dev);
-		}
-	} else {
-		ir->delay_timer_finished = 0;
-		input_event(ir->input_dev, EV_KEY, keycode, 1);
+	new_event = !ir->keypressed || ir->last_key != keycode ||
+		   toggle != ir->last_toggle;
+
+	if (new_event && ir->keypressed)
+		input_event(ir->input_dev, EV_KEY, ir->last_key, 1);
+
+	if (new_event) {
+		input_event(ir->input_dev, EV_KEY, keycode, 0);
 		input_sync(ir->input_dev);
 	}
 
+	ir->keypressed = true;
 	ir->last_key = keycode;
 	ir->last_toggle = toggle;
 
-	ir->keyup_timer.expires = jiffies + UP_TIMEOUT;
-	add_timer(&ir->keyup_timer);
-
+	mod_timer(&ir->keyup_timer, jiffies + UP_TIMEOUT);
 }
 
 
@@ -204,16 +199,6 @@ static void input_register_keys(struct infrared *ir)
 	ir->input_dev->keycodemax = ARRAY_SIZE(ir->key_map);
 }
 
-
-/* called by the input driver after rep[REP_DELAY] ms */
-static void input_repeat_key(unsigned long parm)
-{
-	struct infrared *ir = (struct infrared *) parm;
-
-	ir->delay_timer_finished = 1;
-}
-
-
 /* check for configuration changes */
 int av7110_check_ir_config(struct av7110 *av7110, int force)
 {
@@ -333,8 +318,7 @@ int av7110_ir_init(struct av7110 *av7110)
 	av_list[av_cnt++] = av7110;
 	av7110_check_ir_config(av7110, true);
 
-	setup_timer(&av7110->ir.keyup_timer, av7110_emit_keyup,
-		    (unsigned long)&av7110->ir);
+	timer_setup(&av7110->ir.keyup_timer, av7110_emit_keyup, 0);
 
 	input_dev = input_allocate_device();
 	if (!input_dev)
@@ -365,8 +349,10 @@ int av7110_ir_init(struct av7110 *av7110)
 		input_free_device(input_dev);
 		return err;
 	}
-	input_dev->timer.function = input_repeat_key;
-	input_dev->timer.data = (unsigned long) &av7110->ir;
+
+	/* Let the input layer handle autorepeat for us */
+	input_dev->rep[REP_DELAY] = 250;
+	input_dev->rep[REP_PERIOD] = 125;
 
 	if (av_cnt == 1) {
 		e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
-- 
2.13.6
