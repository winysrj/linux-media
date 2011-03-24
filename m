Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab1CXU1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:27:30 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2OKRTMY004878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 16:27:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] ttusb-budget: driver has a debug param, use it
Date: Thu, 24 Mar 2011 16:27:26 -0400
Message-Id: <1300998446-5774-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove DEBUG define, key debug spew off of the module's debug param that
already exists.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   60 +++++++++-----------
 1 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index cbe2f0d..420bb42 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -52,7 +52,7 @@
     my TTUSB, so let it undef'd unless you want to implement another
     frontend. never tested.
 
-  DEBUG:
+  debug:
     define it to > 3 for really hardcore debugging. you probably don't want
     this unless the device doesn't load at all. > 2 for bandwidth statistics.
 */
@@ -134,20 +134,19 @@ struct ttusb {
 /* ugly workaround ... don't know why it's necessary to read */
 /* all result codes. */
 
-#define DEBUG 0
 static int ttusb_cmd(struct ttusb *ttusb,
 	      const u8 * data, int len, int needresult)
 {
 	int actual_len;
 	int err;
-#if DEBUG >= 3
 	int i;
 
-	printk(">");
-	for (i = 0; i < len; ++i)
-		printk(" %02x", data[i]);
-	printk("\n");
-#endif
+	if (debug >= 3) {
+		printk(KERN_DEBUG ">");
+		for (i = 0; i < len; ++i)
+			printk(KERN_CONT " %02x", data[i]);
+		printk(KERN_CONT "\n");
+	}
 
 	if (mutex_lock_interruptible(&ttusb->semusb) < 0)
 		return -EAGAIN;
@@ -176,13 +175,15 @@ static int ttusb_cmd(struct ttusb *ttusb,
 		mutex_unlock(&ttusb->semusb);
 		return err;
 	}
-#if DEBUG >= 3
-	actual_len = ttusb->last_result[3] + 4;
-	printk("<");
-	for (i = 0; i < actual_len; ++i)
-		printk(" %02x", ttusb->last_result[i]);
-	printk("\n");
-#endif
+
+	if (debug >= 3) {
+		actual_len = ttusb->last_result[3] + 4;
+		printk(KERN_DEBUG "<");
+		for (i = 0; i < actual_len; ++i)
+			printk(KERN_CONT " %02x", ttusb->last_result[i]);
+		printk(KERN_CONT "\n");
+	}
+
 	if (!needresult)
 		mutex_unlock(&ttusb->semusb);
 	return 0;
@@ -636,16 +637,13 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 				++ttusb->mux_state;
 			else {
 				ttusb->mux_state = 0;
-#if DEBUG > 3
-				if (ttusb->insync)
-					printk("%02x ", data[-1]);
-#else
 				if (ttusb->insync) {
-					printk("%s: lost sync.\n",
+					dprintk("%s: %02x\n",
+						__func__, data[-1]);
+					printk(KERN_INFO "%s: lost sync.\n",
 					       __func__);
 					ttusb->insync = 0;
 				}
-#endif
 			}
 			break;
 		case 3:
@@ -744,6 +742,9 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 static void ttusb_iso_irq(struct urb *urb)
 {
 	struct ttusb *ttusb = urb->context;
+	struct usb_iso_packet_descriptor *d;
+	u8 *data;
+	int len, i;
 
 	if (!ttusb->iso_streaming)
 		return;
@@ -755,21 +756,14 @@ static void ttusb_iso_irq(struct urb *urb)
 #endif
 
 	if (!urb->status) {
-		int i;
 		for (i = 0; i < urb->number_of_packets; ++i) {
-			struct usb_iso_packet_descriptor *d;
-			u8 *data;
-			int len;
 			numpkt++;
 			if (time_after_eq(jiffies, lastj + HZ)) {
-#if DEBUG > 2
-				printk
-				    ("frames/s: %d (ts: %d, stuff %d, sec: %d, invalid: %d, all: %d)\n",
-				     numpkt * HZ / (jiffies - lastj),
-				     numts, numstuff, numsec, numinvalid,
-				     numts + numstuff + numsec +
-				     numinvalid);
-#endif
+				dprintk("frames/s: %lu (ts: %d, stuff %d, "
+					"sec: %d, invalid: %d, all: %d)\n",
+					numpkt * HZ / (jiffies - lastj),
+					numts, numstuff, numsec, numinvalid,
+					numts + numstuff + numsec + numinvalid);
 				numts = numstuff = numsec = numinvalid = 0;
 				lastj = jiffies;
 				numpkt = 0;
-- 
1.7.1

