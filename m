Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab0DFSSj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:39 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIcV3008619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:39 -0400
Date: Tue, 6 Apr 2010 15:18:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 22/26] V4L-DVB: ir-core: remove the ancillary buffer
Message-ID: <20100406151800.312b5cfd@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the decoders are state machine, there's no need to create
an ancillary buffer while decoding the protocol. Just call the decoders
code directly, event by event.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 087211c..28d7735 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -125,14 +125,14 @@ static struct attribute_group decoder_attribute_group = {
 
 
 /**
- * handle_event() - Decode one NEC pulse or space
+ * ir_nec_decode() - Decode one NEC pulse or space
  * @input_dev:	the struct input_dev descriptor of the device
  * @ev:		event array with type/duration of pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int handle_event(struct input_dev *input_dev,
-			struct ir_raw_event *ev)
+static int ir_nec_decode(struct input_dev *input_dev,
+			 struct ir_raw_event *ev)
 {
 	struct decoder_data *data;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
@@ -289,32 +289,6 @@ checksum_err:
 	return -EINVAL;
 }
 
-/**
- * ir_nec_decode() - Decodes all NEC pulsecodes on a given array
- * @input_dev:	the struct input_dev descriptor of the device
- * @evs:	event array with type/duration of pulse/space
- * @len:	length of the array
- * This function returns the number of decoded pulses
- */
-static int ir_nec_decode(struct input_dev *input_dev,
-			 struct ir_raw_event *evs,
-			 int len)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct decoder_data *data;
-	int pos = 0;
-	int rc = 0;
-
-	data = get_decoder_data(ir_dev);
-	if (!data || !data->enabled)
-		return 0;
-
-	for (pos = 0; pos < len; pos++)
-		handle_event(input_dev, &evs[pos]);
-
-	return rc;
-}
-
 static int ir_nec_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 617e437..57990a3 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -138,37 +138,33 @@ int ir_raw_event_handle(struct input_dev *input_dev)
 {
 	struct ir_input_dev		*ir = input_get_drvdata(input_dev);
 	int				rc;
-	struct ir_raw_event		*evs;
+	struct ir_raw_event		ev;
 	int 				len, i;
 
 	/*
 	 * Store the events into a temporary buffer. This allows calling more than
 	 * one decoder to deal with the received data
 	 */
-	len = kfifo_len(&ir->raw->kfifo) / sizeof(*evs);
+	len = kfifo_len(&ir->raw->kfifo) / sizeof(ev);
 	if (!len)
 		return 0;
-	evs = kmalloc(len * sizeof(*evs), GFP_ATOMIC);
 
 	for (i = 0; i < len; i++) {
-		rc = kfifo_out(&ir->raw->kfifo, &evs[i], sizeof(*evs));
-		if (rc != sizeof(*evs)) {
+		rc = kfifo_out(&ir->raw->kfifo, &ev, sizeof(ev));
+		if (rc != sizeof(ev)) {
 			IR_dprintk(1, "overflow error: received %d instead of %zd\n",
-				   rc, sizeof(*evs));
+				   rc, sizeof(ev));
 			return -EINVAL;
 		}
 		IR_dprintk(2, "event type %d, time before event: %07luus\n",
-			evs[i].type, (evs[i].delta.tv_nsec + 500) / 1000);
+			ev.type, (ev.delta.tv_nsec + 500) / 1000);
+		rc = RUN_DECODER(decode, input_dev, &ev);
 	}
 
 	/*
 	 * Call all ir decoders. This allows decoding the same event with
-	 * more than one protocol handler. It returns the number of keystrokes
-	 * sent to the event interface
+	 * more than one protocol handler.
 	 */
-	rc = RUN_DECODER(decode, input_dev, evs, len);
-
-	kfree(evs);
 
 	return rc;
 }
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index 4b7eafe..61b5839 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -142,7 +142,7 @@ static struct attribute_group decoder_attribute_group = {
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
-static int handle_event(struct input_dev *input_dev,
+static int ir_rc5_decode(struct input_dev *input_dev,
 			struct ir_raw_event *ev)
 {
 	struct decoder_data *data;
@@ -273,32 +273,6 @@ err2:
 	return -EINVAL;
 }
 
-/**
- * ir_rc5_decode() - Decodes all RC-5 pulsecodes on a given array
- * @input_dev:	the struct input_dev descriptor of the device
- * @evs:	event array with type/duration of pulse/space
- * @len:	length of the array
- * This function returns the number of decoded pulses
- */
-static int ir_rc5_decode(struct input_dev *input_dev,
-			 struct ir_raw_event *evs,
-			 int len)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct decoder_data *data;
-	int pos = 0;
-	int rc = 0;
-
-	data = get_decoder_data(ir_dev);
-	if (!data || !data->enabled)
-		return 0;
-
-	for (pos = 0; pos < len; pos++)
-		handle_event(input_dev, &evs[pos]);
-
-	return rc;
-}
-
 static int ir_rc5_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 4090073..1c1e8d9 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -101,8 +101,7 @@ struct ir_raw_handler {
 	struct list_head list;
 
 	int (*decode)(struct input_dev *input_dev,
-		      struct ir_raw_event *evs,
-		      int len);
+		      struct ir_raw_event *ev);
 	int (*raw_register)(struct input_dev *input_dev);
 	int (*raw_unregister)(struct input_dev *input_dev);
 };
-- 
1.6.6.1


