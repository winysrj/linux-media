Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab0JTRSu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 13:18:50 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9KHInNO031925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 13:18:50 -0400
Received: from [10.3.226.56] (vpn-226-56.phx2.redhat.com [10.3.226.56])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9KHIlaP022403
	for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 13:18:48 -0400
Message-ID: <4CBF2477.9020008@redhat.com>
Date: Wed, 20 Oct 2010 15:18:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC]  ir-rc5-decoder: don't wait for the end space to produce
 a code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The RC5 decoding is complete at a BIT_END state. there's no reason
to wait for the next space to produce a code.
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index df4770d..4139678 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -98,9 +98,36 @@ again:
 		if (!is_transition(&ev, &ir_dev->raw->prev_ev))
 			break;
 
-		if (data->count == data->wanted_bits)
+		if (data->count == data->wanted_bits) {
 			data->state = STATE_FINISHED;
-		else if (data->count == CHECK_RC5X_NBITS)
+
+			if (data->wanted_bits == RC5X_NBITS) {
+				/* RC5X */
+				u8 xdata, command, system;
+				xdata    = (data->bits & 0x0003F) >> 0;
+				command  = (data->bits & 0x00FC0) >> 6;
+				system   = (data->bits & 0x1F000) >> 12;
+				toggle   = (data->bits & 0x20000) ? 1 : 0;
+				command += (data->bits & 0x01000) ? 0 : 0x40;
+				scancode = system << 16 | command << 8 | xdata;
+
+				IR_dprintk(1, "RC5X scancode 0x%06x (toggle: %u)\n",
+					   scancode, toggle);
+			} else {
+				/* RC5 */
+				u8 command, system;
+				command  = (data->bits & 0x0003F) >> 0;
+				system   = (data->bits & 0x007C0) >> 6;
+				toggle   = (data->bits & 0x00800) ? 1 : 0;
+				command += (data->bits & 0x01000) ? 0 : 0x40;
+				scancode = system << 8 | command;
+
+				IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
+					   scancode, toggle);
+			}
+
+			ir_keydown(input_dev, scancode, toggle);
+		} else if (data->count == CHECK_RC5X_NBITS)
 			data->state = STATE_CHECK_RC5X;
 		else
 			data->state = STATE_BIT_START;
@@ -124,33 +151,6 @@ again:
 		if (ev.pulse)
 			break;
 
-		if (data->wanted_bits == RC5X_NBITS) {
-			/* RC5X */
-			u8 xdata, command, system;
-			xdata    = (data->bits & 0x0003F) >> 0;
-			command  = (data->bits & 0x00FC0) >> 6;
-			system   = (data->bits & 0x1F000) >> 12;
-			toggle   = (data->bits & 0x20000) ? 1 : 0;
-			command += (data->bits & 0x01000) ? 0 : 0x40;
-			scancode = system << 16 | command << 8 | xdata;
-
-			IR_dprintk(1, "RC5X scancode 0x%06x (toggle: %u)\n",
-				   scancode, toggle);
-
-		} else {
-			/* RC5 */
-			u8 command, system;
-			command  = (data->bits & 0x0003F) >> 0;
-			system   = (data->bits & 0x007C0) >> 6;
-			toggle   = (data->bits & 0x00800) ? 1 : 0;
-			command += (data->bits & 0x01000) ? 0 : 0x40;
-			scancode = system << 8 | command;
-
-			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
-				   scancode, toggle);
-		}
-
-		ir_keydown(input_dev, scancode, toggle);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 61ccb8f..d779f20 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -674,6 +674,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
 	int i, start_index = 0;
+	bool has_events;
 	u8 hdr = MCE_CONTROL_HEADER;
 
 	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
@@ -698,9 +699,12 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			return;
 		}
 
+		has_events = false;
 		for (; (ir->rem > 0) && (i < buf_len); i++) {
 			ir->rem--;
 
+			has_events = true;
+
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
 					 * MCE_TIME_UNIT * 1000;
@@ -728,8 +732,10 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		if (ir->buf_in[i] == 0x80 || ir->buf_in[i] == 0x9f)
 			ir->rem = 0;
 
-		dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
-		ir_raw_event_handle(ir->idev);
+		if (has_events) {
+			dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
+			ir_raw_event_handle(ir->idev);
+		}
 	}
 }
 
@@ -772,6 +778,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 
 	case -EPIPE:
 	default:
+		dev_dbg(ir->dev, "Error: urb status = %d\n");
 		break;
 	}
 
