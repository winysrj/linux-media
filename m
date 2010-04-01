Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab0DAR6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:09 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/15] V4L/DVB: ir-core/saa7134: Move ir keyup/keydown code
 to the ir-core
Message-ID: <20100401145632.60dd3a16@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 16360eb..a58c717 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -30,37 +30,35 @@
 #define MIN_BIT0_TIME	360000
 #define MAX_BIT0_TIME	760000
 
-
-/** Decode NEC pulsecode. This code can take up to 76.5 ms to run.
-	Unfortunately, using IRQ to decode pulse didn't work, since it uses
-	a pulse train of 38KHz. This means one pulse on each 52 us
-*/
-
-int ir_nec_decode(struct input_dev *input_dev,
-		  struct ir_raw_event *evs,
-		  int len)
+/**
+ * __ir_nec_decode() - Decode one NEC pulsecode
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @evs:	event array with type/duration of pulse/space
+ * @len:	length of the array
+ * @pos:	position to start seeking for a code
+ * This function returns the decoded ircode or -EINVAL if no pulse got decoded
+ */
+static int __ir_nec_decode(struct input_dev *input_dev,
+			   struct ir_raw_event *evs,
+			   int len, int *pos)
 {
-	int i, count = -1;
+	int count = -1;
 	int ircode = 0, not_code = 0;
-#if 0
-	/* Needed only after porting the event code to the decoder */
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-#endif
 
 	/* Be sure that the first event is an start one and is a pulse */
-	for (i = 0; i < len; i++) {
-		if (evs[i].type & (IR_START_EVENT | IR_PULSE))
+	for (; *pos < len; (*pos)++) {
+		if (evs[*pos].type & (IR_START_EVENT | IR_PULSE))
 			break;
 	}
-	i++;	/* First event doesn't contain data */
+	(*pos)++;	/* First event doesn't contain data */
 
-	if (i >= len)
+	if (*pos >= len)
 		return 0;
 
 	/* First space should have 4.5 ms otherwise is not NEC protocol */
-	if ((evs[i].delta.tv_nsec < MIN_START_TIME) |
-	    (evs[i].delta.tv_nsec > MAX_START_TIME) |
-	    (evs[i].type != IR_SPACE))
+	if ((evs[*pos].delta.tv_nsec < MIN_START_TIME) |
+	    (evs[*pos].delta.tv_nsec > MAX_START_TIME) |
+	    (evs[*pos].type != IR_SPACE))
 		goto err;
 
 	/*
@@ -68,24 +66,24 @@ int ir_nec_decode(struct input_dev *input_dev,
 	 */
 
 	count = 0;
-	for (i++; i < len; i++) {
+	for ((*pos)++; *pos < len; (*pos)++) {
 		int bit;
 
-		if ((evs[i].delta.tv_nsec < MIN_PULSE_TIME) |
-		    (evs[i].delta.tv_nsec > MAX_PULSE_TIME) |
-		    (evs[i].type != IR_PULSE))
+		if ((evs[*pos].delta.tv_nsec < MIN_PULSE_TIME) |
+		    (evs[*pos].delta.tv_nsec > MAX_PULSE_TIME) |
+		    (evs[*pos].type != IR_PULSE))
 			goto err;
 
-		if (++i >= len)
+		if (++*pos >= len)
 			goto err;
-		if (evs[i].type != IR_SPACE)
+		if (evs[*pos].type != IR_SPACE)
 			goto err;
 
-		if ((evs[i].delta.tv_nsec > MIN_BIT1_TIME) &&
-		    (evs[i].delta.tv_nsec < MAX_BIT1_TIME))
+		if ((evs[*pos].delta.tv_nsec > MIN_BIT1_TIME) &&
+		    (evs[*pos].delta.tv_nsec < MAX_BIT1_TIME))
 			bit = 1;
-		else if ((evs[i].delta.tv_nsec > MIN_BIT0_TIME) &&
-			 (evs[i].delta.tv_nsec < MAX_BIT0_TIME))
+		else if ((evs[*pos].delta.tv_nsec > MIN_BIT0_TIME) &&
+			 (evs[*pos].delta.tv_nsec < MAX_BIT0_TIME))
 			bit = 0;
 		else
 			goto err;
@@ -120,12 +118,40 @@ int ir_nec_decode(struct input_dev *input_dev,
 	}
 
 	IR_dprintk(1, "NEC scancode 0x%04x\n", ircode);
+	ir_keydown(input_dev, ircode);
+	ir_keyup(input_dev);
 
 	return ircode;
 err:
 	IR_dprintk(1, "NEC decoded failed at bit %d while decoding %luus time\n",
-		   count, (evs[i].delta.tv_nsec + 500) / 1000);
+		   count, (evs[*pos].delta.tv_nsec + 500) / 1000);
 
 	return -EINVAL;
 }
+
+/**
+ * __ir_nec_decode() - Decodes all NEC pulsecodes on a given array
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @evs:	event array with type/duration of pulse/space
+ * @len:	length of the array
+ * This function returns the number of decoded pulses or -EINVAL if no
+ * pulse got decoded
+ */
+int ir_nec_decode(struct input_dev *input_dev,
+			   struct ir_raw_event *evs,
+			   int len)
+{
+	int pos = 0;
+	int rc = 0;
+
+	while (pos < len) {
+		if (__ir_nec_decode(input_dev, evs, len, &pos) >= 0)
+			rc++;
+	}
+
+	if (!rc)
+		return -EINVAL;
+	return rc;
+}
+
 EXPORT_SYMBOL_GPL(ir_nec_decode);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 7382995..740adb3 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -424,18 +424,8 @@ static void saa7134_input_timer(unsigned long data)
 void ir_raw_decode_timer_end(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *)data;
-	struct card_ir *ir = dev->remote;
-	int rc;
 
-	/*
-	 * FIXME: the IR key handling code should be called by the decoder,
-	 * after implementing the repeat mode
-	 */
-	rc = ir_raw_event_handle(dev->remote->dev);
-	if (rc >= 0) {
-		ir_input_keydown(ir->dev, &ir->ir, rc);
-		ir_input_nokey(ir->dev, &ir->ir);
-	}
+	ir_raw_event_handle(dev->remote->dev);
 }
 
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 198fd61..9e03528 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -84,7 +84,8 @@ struct ir_input_dev {
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
 			    u32 scancode);
-
+void ir_keyup(struct input_dev *dev);
+void ir_keydown(struct input_dev *dev, int scancode);
 int ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props,
-- 
1.6.6.1


