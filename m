Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab0DFSSw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:52 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIqFQ010894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:52 -0400
Date: Tue, 6 Apr 2010 15:18:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 18/26] V4L/DVB: ir-nec-decoder: Reimplement the entire
 decoder
Message-ID: <20100406151801.552299b9@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Andy Walls <awalls@md.metrocast.net> for pointing me his
code, that gave me some ideas to better implement it.

After some work with saa7134 bits, I found a way to catch both IRQ
edge pulses. By enabling it, the NEC decoder can now take both
pulse and spaces into account, making it more precise.

Instead of the old strategy of handling the events all at once,
this code implements a state machine. Due to that, it handles
individual pulse or space events, validating them against the
protocol, producing a much more reliable decoding.

With the new implementation, the protocol trailer bits are properly
handled, making possible for the repeat key to work.

Also, the code is now capable of handling both NEC and NEC extended
IR devices. With NEC, it produces a 16 bits code, while with NEC
extended, a 24 bits code is returned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 0b50060..33b260f 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -14,6 +14,14 @@
 
 #include <media/ir-core.h>
 
+#define NEC_UNIT		559979 /* ns */
+#define NEC_HEADER_MARK		(16 * NEC_UNIT)
+#define NEC_HEADER_SPACE	(8 * NEC_UNIT)
+#define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
+#define NEC_MARK		(NEC_UNIT)
+#define NEC_0_SYMBOL		(NEC_UNIT)
+#define NEC_1_SYMBOL		(3 * NEC_UNIT)
+
 /* Start time: 4.5 ms + 560 us of the next pulse */
 #define MIN_START_TIME	(3900000 + 560000)
 #define MAX_START_TIME	(5100000 + 560000)
@@ -43,10 +51,32 @@
 static LIST_HEAD(decoder_list);
 static spinlock_t decoder_lock;
 
+enum nec_state {
+	STATE_INACTIVE,
+	STATE_HEADER_MARK,
+	STATE_HEADER_SPACE,
+	STATE_MARK,
+	STATE_SPACE,
+	STATE_TRAILER_MARK,
+	STATE_TRAILER_SPACE,
+};
+
+struct nec_code {
+	u8	address;
+	u8	not_address;
+	u8	command;
+	u8	not_command;
+};
+
 struct decoder_data {
 	struct list_head	list;
 	struct ir_input_dev	*ir_dev;
 	int			enabled:1;
+
+	/* State machine control */
+	enum nec_state		state;
+	struct nec_code		nec_code;
+	unsigned		count;
 };
 
 
@@ -118,139 +148,173 @@ static struct attribute_group decoder_attribute_group = {
 };
 
 
-/** is_repeat - Check if it is a NEC repeat event
- * @input_dev:	the struct input_dev descriptor of the device
- * @pos:	the position of the first event
- * @len:	the length of the buffer
- */
-static int is_repeat(struct ir_raw_event *evs, int len, int pos)
-{
-	if ((evs[pos].delta.tv_nsec < MIN_REPEAT_START_TIME) ||
-	    (evs[pos].delta.tv_nsec > MAX_REPEAT_START_TIME))
-		return 0;
-
-	if (++pos >= len)
-		return 0;
-
-	if ((evs[pos].delta.tv_nsec < MIN_REPEAT_TIME) ||
-	    (evs[pos].delta.tv_nsec > MAX_REPEAT_TIME))
-		return 0;
-
-	return 1;
-}
-
 /**
- * __ir_nec_decode() - Decode one NEC pulsecode
+ * handle_event() - Decode one NEC pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
- * @evs:	event array with type/duration of pulse/space
- * @len:	length of the array
- * @pos:	position to start seeking for a code
- * This function returns -EINVAL if no pulse got decoded,
- * 0 if buffer is empty and 1 if one keycode were handled.
+ * @ev:		event array with type/duration of pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
  */
-static int __ir_nec_decode(struct input_dev *input_dev,
-			   struct ir_raw_event *evs,
-			   int len, int *pos)
+static int handle_event(struct input_dev *input_dev,
+			struct ir_raw_event *ev)
 {
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	int count = -1;
-	int ircode = 0, not_code = 0;
-
-	/* Be sure that the first event is an start one and is a pulse */
-	for (; *pos < len; (*pos)++) {
-		/* Very long delays are considered as start events */
-		if (evs[*pos].delta.tv_nsec > MAX_NEC_TIME)
-			break;
-		if (evs[*pos].type & IR_START_EVENT)
-			break;
-		IR_dprintk(1, "%luus: Spurious NEC %s\n",
-			   (evs[*pos].delta.tv_nsec + 500) / 1000,
-			   (evs[*pos].type & IR_SPACE) ? "space" : "pulse");
-
-	}
-	if (*pos >= len)
-		return 0;
+	struct decoder_data *data;
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int bit, last_bit;
+
+	data = get_decoder_data(ir_dev);
+	if (!data)
+		return -EINVAL;
+
+	/* Except for the initial event, what matters is the previous bit */
+	bit = (ev->type & IR_PULSE) ? 1 : 0;
+
+	last_bit = !bit;
+
+	/* Discards spurious space last_bits when inactive */
 
-	(*pos)++;	/* First event doesn't contain data */
+	/* Very long delays are considered as start events */
+	if (ev->delta.tv_nsec > NEC_HEADER_MARK + NEC_HEADER_SPACE - NEC_UNIT / 2)
+		data->state = STATE_INACTIVE;
 
-	if (evs[*pos].type != IR_PULSE)
-		goto err;
+	if (ev->type & IR_START_EVENT)
+		data->state = STATE_INACTIVE;
+
+	switch (data->state) {
+	case STATE_INACTIVE:
+		if (!bit)		/* PULSE marks the start event */
+			return 0;
+
+		data->count = 0;
+		data->state = STATE_HEADER_MARK;
+		memset (&data->nec_code, 0, sizeof(data->nec_code));
+		return 0;
+	case STATE_HEADER_MARK:
+		if (!last_bit)
+			goto err;
+		if (ev->delta.tv_nsec < NEC_HEADER_MARK - 6 * NEC_UNIT)
+			goto err;
+		data->state = STATE_HEADER_SPACE;
+		return 0;
+	case STATE_HEADER_SPACE:
+		if (last_bit)
+			goto err;
+		if (ev->delta.tv_nsec >= NEC_HEADER_SPACE - NEC_UNIT / 2) {
+			data->state = STATE_MARK;
+			return 0;
+		}
 
-	/* Check if it is a NEC repeat event */
-	if (is_repeat(evs, len, *pos)) {
-		*pos += 2;
-		if (ir->keypressed) {
+		if (ev->delta.tv_nsec >= NEC_REPEAT_SPACE - NEC_UNIT / 2) {
 			ir_repeat(input_dev);
-			IR_dprintk(1, "NEC repeat event\n");
-			return 1;
-		} else {
-			IR_dprintk(1, "missing NEC repeat event\n");
+			IR_dprintk(1, "Repeat last key\n");
+			data->state = STATE_TRAILER_MARK;
 			return 0;
 		}
-	}
-
-	/* First space should have 4.5 ms otherwise is not NEC protocol */
-	if ((evs[*pos].delta.tv_nsec < MIN_START_TIME) ||
-	    (evs[*pos].delta.tv_nsec > MAX_START_TIME))
 		goto err;
+	case STATE_MARK:
+		if (!last_bit)
+			goto err;
+		if ((ev->delta.tv_nsec > NEC_MARK + NEC_UNIT / 2) ||
+		    (ev->delta.tv_nsec < NEC_MARK - NEC_UNIT / 2))
+			goto err;
+		data->state = STATE_SPACE;
+		return 0;
+	case STATE_SPACE:
+		if (last_bit)
+			goto err;
 
-	count = 0;
-	for ((*pos)++; *pos < len; (*pos)++) {
-		int bit;
-		if ((evs[*pos].delta.tv_nsec > MIN_BIT1_TIME) &&
-		    (evs[*pos].delta.tv_nsec < MAX_BIT1_TIME))
-			bit = 1;
-		else if ((evs[*pos].delta.tv_nsec > MIN_BIT0_TIME) &&
-			 (evs[*pos].delta.tv_nsec < MAX_BIT0_TIME))
+		if ((ev->delta.tv_nsec >= NEC_0_SYMBOL - NEC_UNIT / 2) &&
+		    (ev->delta.tv_nsec < NEC_0_SYMBOL + NEC_UNIT / 2))
 			bit = 0;
-		else
-			goto err;
+		else if ((ev->delta.tv_nsec >= NEC_1_SYMBOL - NEC_UNIT / 2) &&
+		         (ev->delta.tv_nsec < NEC_1_SYMBOL + NEC_UNIT / 2))
+			bit = 1;
+		else {
+			IR_dprintk(1, "Decode failed at %d-th bit (%s) @%luus\n",
+				data->count,
+				last_bit ? "pulse" : "space",
+				(ev->delta.tv_nsec + 500) / 1000);
 
+			goto err2;
+		}
+
+		/* Ok, we've got a valid bit. proccess it */
 		if (bit) {
-			int shift = count;
-			/* Address first, then command */
+			int shift = data->count;
+
+			/*
+			 * NEC transmit bytes on this temporal order:
+			 * address | not address | command | not command
+			 */
 			if (shift < 8) {
-				shift += 8;
-				ircode |= 1 << shift;
+				data->nec_code.address |= 1 << shift;
 			} else if (shift < 16) {
-				not_code |= 1 << shift;
+				data->nec_code.not_address |= 1 << (shift - 8);
 			} else if (shift < 24) {
-				shift -= 16;
-				ircode |= 1 << shift;
+				data->nec_code.command |= 1 << (shift - 16);
 			} else {
-				shift -= 24;
-				not_code |= 1 << shift;
+				data->nec_code.not_command |= 1 << (shift - 24);
 			}
 		}
-		if (++count == 32)
-			break;
-	}
-	(*pos)++;
+		if (++data->count == 32) {
+			u32 scancode;
+			/*
+			 * Fixme: may need to accept Extended NEC protocol?
+			 */
+			if ((data->nec_code.command ^ data->nec_code.not_command) != 0xff)
+				goto checksum_err;
 
-	/*
-	 * Fixme: may need to accept Extended NEC protocol?
-	 */
-	if ((ircode & ~not_code) != ircode) {
-		IR_dprintk(1, "NEC checksum error: code 0x%04x, not-code 0x%04x\n",
-			   ircode, not_code);
-		return -EINVAL;
-	}
+			if ((data->nec_code.address ^ data->nec_code.not_address) != 0xff) {
+				/* Extended NEC */
+				scancode = data->nec_code.address << 16 |
+					   data->nec_code.not_address << 8 |
+					   data->nec_code.command;
+				IR_dprintk(1, "NEC scancode 0x%06x\n", scancode);
+			} else {
+				/* normal NEC */
+				scancode = data->nec_code.address << 8 |
+					   data->nec_code.command;
+				IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
+			}
+			ir_keydown(input_dev, scancode, 0);
 
-	IR_dprintk(1, "NEC scancode 0x%04x\n", ircode);
-	ir_keydown(input_dev, ircode, 0);
+			data->state = STATE_TRAILER_MARK;
+		} else
+			data->state = STATE_MARK;
+		return 0;
+	case STATE_TRAILER_MARK:
+		if (!last_bit)
+			goto err;
+		data->state = STATE_TRAILER_SPACE;
+		return 0;
+	case STATE_TRAILER_SPACE:
+		if (last_bit)
+			goto err;
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
 
-	return 1;
 err:
-	IR_dprintk(1, "NEC decoded failed at bit %d (%s) while decoding %luus time\n",
-		   count,
-		   (evs[*pos].type & IR_SPACE) ? "space" : "pulse",
-		   (evs[*pos].delta.tv_nsec + 500) / 1000);
+	IR_dprintk(1, "NEC decoded failed at state %d (%s) @ %luus\n",
+		   data->state,
+		   bit ? "pulse" : "space",
+		   (ev->delta.tv_nsec + 500) / 1000);
+err2:
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
 
+checksum_err:
+	data->state = STATE_INACTIVE;
+	IR_dprintk(1, "NEC checksum error: received 0x%02x%02x%02x%02x\n",
+		   data->nec_code.address,
+		   data->nec_code.not_address,
+		   data->nec_code.command,
+		   data->nec_code.not_command);
 	return -EINVAL;
 }
 
 /**
- * __ir_nec_decode() - Decodes all NEC pulsecodes on a given array
+ * ir_nec_decode() - Decodes all NEC pulsecodes on a given array
  * @input_dev:	the struct input_dev descriptor of the device
  * @evs:	event array with type/duration of pulse/space
  * @len:	length of the array
@@ -269,10 +333,9 @@ static int ir_nec_decode(struct input_dev *input_dev,
 	if (!data || !data->enabled)
 		return 0;
 
-	while (pos < len) {
-		if (__ir_nec_decode(input_dev, evs, len, &pos) > 0)
-			rc++;
-	}
+	for (pos = 0; pos < len; pos++)
+		handle_event(input_dev, &evs[pos]);
+
 	return rc;
 }
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index fd3225c..5dac6b7 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -658,7 +658,8 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
 		ir_codes     = RC_MAP_AVERMEDIA_M135A_RM_JX;
-		mask_keydown = 0x0040000;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
 		mask_keycode = 0xffff;
 		raw_decode   = 1;
 		break;
@@ -1014,13 +1015,13 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 {
 	struct card_ir	*ir = dev->remote;
 	unsigned long 	timeout;
-	int pulse;
+	int space;
 
 	/* Generate initial event */
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-	pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	ir_raw_event_store(dev->remote->dev, pulse ? IR_PULSE : IR_SPACE);
+	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
+	ir_raw_event_store(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
 
 
 	/*
-- 
1.6.6.1


