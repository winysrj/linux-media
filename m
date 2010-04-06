Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab0DFSSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:18 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIIH3005639
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:18 -0400
Date: Tue, 6 Apr 2010 15:18:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 26/26] V4L/DVB: ir-rc5-decoder: fix state machine
Message-ID: <20100406151800.09f3c466@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reimplement the RC-5 decoder state machine. Code is now clear, and works
properly. It is also simpler than the previous implementations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index 4fb3ce4..a62277b 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -15,19 +15,17 @@
 /*
  * This code only handles 14 bits RC-5 protocols. There are other variants
  * that use a different number of bits. This is currently unsupported
+ * It considers a carrier of 36 kHz, with a total of 14 bits, where
+ * the first two bits are start bits, and a third one is a filing bit
  */
 
 #include <media/ir-core.h>
 
+static unsigned int ir_rc5_remote_gap = 888888;
+
 #define RC5_NBITS		14
-#define RC5_HALFBIT		888888 /* ns */
-#define RC5_BIT			(RC5_HALFBIT * 2)
-#define RC5_DURATION		(RC5_BIT * RC5_NBITS)
-
-#define is_rc5_halfbit(nsec) ((ev->delta.tv_nsec >= RC5_HALFBIT / 2) &&	   \
-		      (ev->delta.tv_nsec < RC5_HALFBIT + RC5_HALFBIT / 2))
-
-#define n_half(nsec) ((ev->delta.tv_nsec + RC5_HALFBIT / 2) / RC5_HALFBIT)
+#define RC5_BIT			(ir_rc5_remote_gap * 2)
+#define RC5_DURATION		(ir_rc5_remote_gap * RC5_NBITS)
 
 /* Used to register rc5_decoder clients */
 static LIST_HEAD(decoder_list);
@@ -35,19 +33,8 @@ static spinlock_t decoder_lock;
 
 enum rc5_state {
 	STATE_INACTIVE,
-	STATE_START2_SPACE,
-	STATE_START2_MARK,
 	STATE_MARKSPACE,
-	STATE_TRAILER_MARK,
-};
-
-static char *st_name[] = {
-	"Inactive",
-	"start2 sapce",
-	"start2 mark",
-	"mark",
-	"space",
-	"trailer"
+	STATE_TRAILER,
 };
 
 struct rc5_code {
@@ -63,8 +50,7 @@ struct decoder_data {
 	/* State machine control */
 	enum rc5_state		state;
 	struct rc5_code		rc5_code;
-	unsigned		n_half;
-	unsigned		count;
+	unsigned		code, elapsed, last_bit, last_code;
 };
 
 
@@ -147,7 +133,7 @@ static int ir_rc5_decode(struct input_dev *input_dev,
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int bit, last_bit, n_half;
+	int is_pulse, scancode, delta, toggle;
 
 	data = get_decoder_data(ir_dev);
 	if (!data)
@@ -156,122 +142,79 @@ static int ir_rc5_decode(struct input_dev *input_dev,
 	if (!data->enabled)
 		return 0;
 
-	/* Except for the initial event, what matters is the previous bit */
-	bit = (ev->type & IR_PULSE) ? 1 : 0;
+	delta = DIV_ROUND_CLOSEST(ev->delta.tv_nsec, ir_rc5_remote_gap);
 
-	last_bit = !bit;
-
-	/* Discards spurious space last_bits when inactive */
+	/* The duration time refers to the last bit time */
+	is_pulse = (ev->type & IR_PULSE) ? 1 : 0;
 
 	/* Very long delays are considered as start events */
-	if (ev->delta.tv_nsec > RC5_DURATION + RC5_HALFBIT / 2)
-		data->state = STATE_INACTIVE;
-
-	if (ev->type & IR_START_EVENT)
+	if (delta > RC5_DURATION || (ev->type & IR_START_EVENT))
 		data->state = STATE_INACTIVE;
 
 	switch (data->state) {
 	case STATE_INACTIVE:
-IR_dprintk(1, "currently inative. Received bit (%s) @%luus\n",
-	last_bit ? "pulse" : "space",
-	(ev->delta.tv_nsec + 500) / 1000);
+	IR_dprintk(2, "currently inative. Start bit (%s) @%uus\n",
+		   is_pulse ? "pulse" : "space",
+		   (unsigned)(ev->delta.tv_nsec + 500) / 1000);
 
 		/* Discards the initial start space */
-		if (bit)
-			return 0;
-		data->count = 0;
-		data->n_half = 0;
-		memset (&data->rc5_code, 0, sizeof(data->rc5_code));
-
-		data->state = STATE_START2_SPACE;
-		return 0;
-	case STATE_START2_SPACE:
-		if (last_bit)
+		if (!is_pulse)
 			goto err;
-		if (!is_rc5_halfbit(ev->delta.tv_nsec))
-			goto err;
-		data->state = STATE_START2_MARK;
-		return 0;
-	case STATE_START2_MARK:
-		if (!last_bit)
-			goto err;
-
-		if (!is_rc5_halfbit(ev->delta.tv_nsec))
-			goto err;
-
+		data->code = 1;
+		data->last_bit = 1;
+		data->elapsed = 0;
+		memset(&data->rc5_code, 0, sizeof(data->rc5_code));
 		data->state = STATE_MARKSPACE;
 		return 0;
 	case STATE_MARKSPACE:
-		n_half = n_half(ev->delta.tv_nsec);
-		if (n_half < 1 || n_half > 3) {
-			IR_dprintk(1, "Decode failed at %d-th bit (%s) @%luus\n",
-				data->count,
-				last_bit ? "pulse" : "space",
-				(ev->delta.tv_nsec + 500) / 1000);
-printk("%d halves\n", n_half);
-			goto err2;
-		}
-		data->n_half += n_half;
+		if (delta != 1)
+			data->last_bit = data->last_bit ? 0 : 1;
 
-		if (!last_bit)
+		data->elapsed += delta;
+
+		if ((data->elapsed % 2) == 1)
 			return 0;
 
-		/* Got one complete mark/space cycle */
+		data->code <<= 1;
+		data->code |= data->last_bit;
 
-		bit = ((data->count + 1) * 2)/ data->n_half;
+		/* Fill the 2 unused bits at the command with 0 */
+		if (data->elapsed / 2 == 6)
+			data->code <<= 2;
 
-printk("%d halves, %d bits\n", n_half, bit);
+		if (data->elapsed >= (RC5_NBITS - 1) * 2) {
+			scancode = data->code;
 
-#if 1 /* SANITY check - while testing the decoder */
-		if (bit > 1) {
-			IR_dprintk(1, "Decoder HAS failed at %d-th bit (%s) @%luus\n",
-				data->count,
-				last_bit ? "pulse" : "space",
-				(ev->delta.tv_nsec + 500) / 1000);
+			/* Check for the start bits */
+			if ((scancode & 0xc000) != 0xc000) {
+				IR_dprintk(1, "Code 0x%04x doesn't have two start bits. It is not RC-5\n", scancode);
+				goto err;
+			}
 
-			goto err2;
-		}
-#endif
-		/* Ok, we've got a valid bit. proccess it */
-		if (bit) {
-			int shift = data->count;
+			toggle = (scancode & 0x2000) ? 1 : 0;
 
-			/*
-			 * RC-5 transmit bytes on this temporal order:
-			 * address | not address | command | not command
-			 */
-			if (shift < 8) {
-				data->rc5_code.address |= 1 << shift;
+			if (scancode == data->last_code) {
+				IR_dprintk(1, "RC-5 repeat\n");
+				ir_repeat(input_dev);
 			} else {
-				data->rc5_code.command |= 1 << (shift - 8);
+				data->last_code = scancode;
+				scancode &= 0x1fff;
+				IR_dprintk(1, "RC-5 scancode 0x%04x\n", scancode);
+
+				ir_keydown(input_dev, scancode, 0);
 			}
-		}
-		IR_dprintk(1, "RC-5: bit #%d: %d (%d)\n",
-				data->count, bit, data->n_half);
-		if (++data->count >= RC5_NBITS) {
-			u32 scancode;
-			scancode = data->rc5_code.address << 8 |
-					data->rc5_code.command;
-			IR_dprintk(1, "RC-5 scancode 0x%04x\n", scancode);
-
-			ir_keydown(input_dev, scancode, 0);
-
-			data->state = STATE_TRAILER_MARK;
+			data->state = STATE_TRAILER;
 		}
 		return 0;
-	case STATE_TRAILER_MARK:
-		if (!last_bit)
-			goto err;
+	case STATE_TRAILER:
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
 err:
-	IR_dprintk(1, "RC-5 decoded failed at state %s (%s) @ %luus\n",
-		   st_name[data->state],
-		   bit ? "pulse" : "space",
+	IR_dprintk(1, "RC-5 decoded failed at %s @ %luus\n",
+		   is_pulse ? "pulse" : "space",
 		   (ev->delta.tv_nsec + 500) / 1000);
-err2:
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
-- 
1.6.6.1

