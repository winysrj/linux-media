Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:47006 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2HMM7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:55 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 09/13] [media] rc: do not wake up rc thread unless there is something to do
Date: Mon, 13 Aug 2012 13:59:47 +0100
Message-Id: <1344862791-30352-9-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TechnoTrend USB IR Receiver sends 125 ISO URBs per second, even when
there is no IR activity. Reduce the number of wake ups from the other
drivers too.

This saves about 0.25ms/s on a 2.4GHz Core 2 according to powertop.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/fintek-cir.c | 11 ++++++++---
 drivers/media/rc/iguanair.c   |  7 +++++--
 drivers/media/rc/ir-raw.c     |  6 ++++--
 drivers/media/rc/mceusb.c     | 10 +++++++---
 drivers/media/rc/ttusbir.c    | 19 +++++++++++++------
 5 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index ab30c64..52fd769 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -295,6 +295,7 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
 	u8 sample;
+	bool event = false;
 	int i;
 
 	for (i = 0; i < fintek->pkts; i++) {
@@ -332,7 +333,9 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 			fit_dbg("Storing %s with duration %d",
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
-			ir_raw_event_store_with_filter(fintek->rdev, &rawir);
+			if (ir_raw_event_store_with_filter(fintek->rdev,
+									&rawir))
+				event = true;
 			break;
 		}
 
@@ -342,8 +345,10 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
 
 	fintek->pkts = 0;
 
-	fit_dbg("Calling ir_raw_event_handle");
-	ir_raw_event_handle(fintek->rdev);
+	if (event) {
+		fit_dbg("Calling ir_raw_event_handle");
+		ir_raw_event_handle(fintek->rdev);
+	}
 }
 
 /* copy data from hardware rx register into driver buffer */
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 6a09c2e..66ba237 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -134,6 +134,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 	} else if (len >= 7) {
 		DEFINE_IR_RAW_EVENT(rawir);
 		unsigned i;
+		bool event = false;
 
 		init_ir_raw_event(&rawir);
 
@@ -147,10 +148,12 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 								 RX_RESOLUTION;
 			}
 
-			ir_raw_event_store_with_filter(ir->rc, &rawir);
+			if (ir_raw_event_store_with_filter(ir->rc, &rawir))
+				event = true;
 		}
 
-		ir_raw_event_handle(ir->rc);
+		if (event)
+			ir_raw_event_handle(ir->rc);
 	}
 }
 
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index a820251..97dc8d1 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -157,7 +157,9 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
  * This routine (which may be called from an interrupt context) works
  * in similar manner to ir_raw_event_store_edge.
  * This routine is intended for devices with limited internal buffer
- * It automerges samples of same type, and handles timeouts
+ * It automerges samples of same type, and handles timeouts. Returns non-zero
+ * if the event was added, and zero if the event was ignored due to idle
+ * processing.
  */
 int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
 {
@@ -184,7 +186,7 @@ int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
 	    dev->raw->this_ev.duration >= dev->timeout)
 		ir_raw_event_set_idle(dev, true);
 
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
 
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index f38d9a8..d289fd4 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -974,6 +974,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
+	bool event = false;
 	int i = 0;
 
 	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
@@ -1004,7 +1005,8 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
 
-			ir_raw_event_store_with_filter(ir->rc, &rawir);
+			if (ir_raw_event_store_with_filter(ir->rc, &rawir))
+				event = true;
 			break;
 		case CMD_DATA:
 			ir->rem--;
@@ -1032,8 +1034,10 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		if (ir->parser_state != CMD_HEADER && !ir->rem)
 			ir->parser_state = CMD_HEADER;
 	}
-	mce_dbg(ir->dev, "processed IR data, calling ir_raw_event_handle\n");
-	ir_raw_event_handle(ir->rc);
+	if (event) {
+		mce_dbg(ir->dev, "processed IR data, calling ir_raw_event_handle\n");
+		ir_raw_event_handle(ir->rc);
+	}
 }
 
 static void mceusb_dev_recv(struct urb *urb)
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 71f03ac..1aee57f 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -121,8 +121,9 @@ static void ttusbir_bulk_complete(struct urb *urb)
  */
 static void ttusbir_process_ir_data(struct ttusbir *tt, uint8_t *buf)
 {
+	struct ir_raw_event rawir;
 	unsigned i, v, b;
-	DEFINE_IR_RAW_EVENT(rawir);
+	bool event = false;
 
 	init_ir_raw_event(&rawir);
 
@@ -132,12 +133,14 @@ static void ttusbir_process_ir_data(struct ttusbir *tt, uint8_t *buf)
 		case 0xfe:
 			rawir.pulse = false;
 			rawir.duration = NS_PER_BYTE;
-			ir_raw_event_store_with_filter(tt->rc, &rawir);
+			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
+				event = true;
 			break;
 		case 0:
 			rawir.pulse = true;
 			rawir.duration = NS_PER_BYTE;
-			ir_raw_event_store_with_filter(tt->rc, &rawir);
+			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
+				event = true;
 			break;
 		default:
 			/* one edge per byte */
@@ -150,16 +153,20 @@ static void ttusbir_process_ir_data(struct ttusbir *tt, uint8_t *buf)
 			}
 
 			rawir.duration = NS_PER_BIT * (8 - b);
-			ir_raw_event_store_with_filter(tt->rc, &rawir);
+			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
+				event = true;
 
 			rawir.pulse = !rawir.pulse;
 			rawir.duration = NS_PER_BIT * b;
-			ir_raw_event_store_with_filter(tt->rc, &rawir);
+			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
+				event = true;
 			break;
 		}
 	}
 
-	ir_raw_event_handle(tt->rc);
+	/* don't wakeup when there's nothing to do */
+	if (event)
+		ir_raw_event_handle(tt->rc);
 }
 
 static void ttusbir_urb_complete(struct urb *urb)
-- 
1.7.11.2

