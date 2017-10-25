Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:56586 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbdJYAkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 20:40:09 -0400
Date: Tue, 24 Oct 2017 17:40:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: av7110: switch to useing timer_setup()
Message-ID: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Also stop poking into input core internals and override its autorepeat
timer function. I am not sure why we have such convoluted autorepeat
handling in this driver instead of letting input core handle autorepeat,
but this preserves current behavior of allowing controlling autorepeat
delay and forcing autorepeat period to be whatever the hardware has.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Note that this has not been tested on the hardware. But it should
compile, so I have that going for me.

 drivers/media/pci/ttpci/av7110.h    |  4 ++--
 drivers/media/pci/ttpci/av7110_ir.c | 40 +++++++++++++++++--------------------
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 347827925c14..0aa3c6f01853 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -80,10 +80,11 @@ struct av7110;
 
 /* infrared remote control */
 struct infrared {
-	u16	key_map[256];
+	u16			key_map[256];
 	struct input_dev	*input_dev;
 	char			input_phys[32];
 	struct timer_list	keyup_timer;
+	unsigned long		keydown_time;
 	struct tasklet_struct	ir_tasklet;
 	void			(*ir_handler)(struct av7110 *av7110, u32 ircom);
 	u32			ir_command;
@@ -93,7 +94,6 @@ struct infrared {
 	u8			inversion;
 	u16			last_key;
 	u16			last_toggle;
-	u8			delay_timer_finished;
 };
 
 
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index ca05198de2c2..b602e64b3412 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -84,9 +84,9 @@ static u16 default_key_map [256] = {
 
 
 /* key-up timer */
-static void av7110_emit_keyup(unsigned long parm)
+static void av7110_emit_keyup(struct timer_list *t)
 {
-	struct infrared *ir = (struct infrared *) parm;
+	struct infrared *ir = from_timer(ir, keyup_timer, t);
 
 	if (!ir || !test_bit(ir->last_key, ir->input_dev->key))
 		return;
@@ -152,19 +152,20 @@ static void av7110_emit_key(unsigned long parm)
 		return;
 	}
 
-	if (timer_pending(&ir->keyup_timer)) {
-		del_timer(&ir->keyup_timer);
+	if (del_timer(&ir->keyup_timer)) {
 		if (ir->last_key != keycode || toggle != ir->last_toggle) {
-			ir->delay_timer_finished = 0;
+			ir->keydown_time = jiffies;
 			input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
 			input_event(ir->input_dev, EV_KEY, keycode, 1);
 			input_sync(ir->input_dev);
-		} else if (ir->delay_timer_finished) {
+		} else if (time_after(jiffies, ir->keydown_time +
+				msecs_to_jiffies(
+					ir->input_dev->rep[REP_PERIOD]))) {
 			input_event(ir->input_dev, EV_KEY, keycode, 2);
 			input_sync(ir->input_dev);
 		}
 	} else {
-		ir->delay_timer_finished = 0;
+		ir->keydown_time = jiffies;
 		input_event(ir->input_dev, EV_KEY, keycode, 1);
 		input_sync(ir->input_dev);
 	}
@@ -172,9 +173,7 @@ static void av7110_emit_key(unsigned long parm)
 	ir->last_key = keycode;
 	ir->last_toggle = toggle;
 
-	ir->keyup_timer.expires = jiffies + UP_TIMEOUT;
-	add_timer(&ir->keyup_timer);
-
+	mod_timer(&ir->keyup_timer, jiffies + UP_TIMEOUT);
 }
 
 
@@ -184,12 +183,19 @@ static void input_register_keys(struct infrared *ir)
 	int i;
 
 	set_bit(EV_KEY, ir->input_dev->evbit);
-	set_bit(EV_REP, ir->input_dev->evbit);
 	set_bit(EV_MSC, ir->input_dev->evbit);
 
 	set_bit(MSC_RAW, ir->input_dev->mscbit);
 	set_bit(MSC_SCAN, ir->input_dev->mscbit);
 
+	set_bit(EV_REP, ir->input_dev->evbit);
+	/*
+	 * By setting the delay before registering input device we
+	 * indicate that we will be implementing the autorepeat
+	 * ourselves.
+	 */
+	ir->input_dev->rep[REP_DELAY] = 250;
+
 	memset(ir->input_dev->keybit, 0, sizeof(ir->input_dev->keybit));
 
 	for (i = 0; i < ARRAY_SIZE(ir->key_map); i++) {
@@ -205,15 +211,6 @@ static void input_register_keys(struct infrared *ir)
 }
 
 
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
@@ -333,8 +330,7 @@ int av7110_ir_init(struct av7110 *av7110)
 	av_list[av_cnt++] = av7110;
 	av7110_check_ir_config(av7110, true);
 
-	setup_timer(&av7110->ir.keyup_timer, av7110_emit_keyup,
-		    (unsigned long)&av7110->ir);
+	timer_setup(&av7110->ir.keyup_timer, av7110_emit_keyup, 0);
 
 	input_dev = input_allocate_device();
 	if (!input_dev)
-- 
2.15.0.rc0.271.g36b669edcc-goog


-- 
Dmitry
