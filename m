Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:62982 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757832AbaEKLOT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:14:19 -0400
Date: 11 May 2014 07:14:18 -0400
Message-ID: <20140511111418.14709.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 04/10] ati_remote: Generalize KIND_ACCEL to accept diagonals
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rather than having special code cases for diagonal mouse
movements, extend the general purpose code used for the
cardinal directions to handle arbitrary (x,y) deltas.

The deltas themselves are stored in translation table's "code"
field; this is also progress toward the goal of eliminating
the "value" element entirely.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/ati_remote.c | 71 ++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 48 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 933d614475..ba5c1bba53 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -281,11 +281,7 @@ struct ati_remote {
 #define KIND_END        0
 #define KIND_LITERAL    1   /* Simply pass to input system */
 #define KIND_FILTERED   2   /* Add artificial key-up events, drop keyrepeats */
-#define KIND_LU         3   /* Directional keypad diagonals - left up, */
-#define KIND_RU         4   /*   right up,  */
-#define KIND_LD         5   /*   left down, */
-#define KIND_RD         6   /*   right down */
-#define KIND_ACCEL      7   /* Directional keypad - left, right, up, down.*/
+#define KIND_ACCEL      3   /* Directional keypad - left, right, up, down.*/
 
 /* Translation table from hardware messages to input events. */
 static const struct {
@@ -295,16 +291,17 @@ static const struct {
 	unsigned short code;
 	signed char value;
 }  ati_remote_tbl[] = {
-	/* Directional control pad axes */
-	{KIND_ACCEL,   0x70, EV_REL, REL_X, -1},   /* left */
-	{KIND_ACCEL,   0x71, EV_REL, REL_X, 1},    /* right */
-	{KIND_ACCEL,   0x72, EV_REL, REL_Y, -1},   /* up */
-	{KIND_ACCEL,   0x73, EV_REL, REL_Y, 1},    /* down */
+	/* Directional control pad axes.  Code is xxyy */
+	{KIND_ACCEL,   0x70, EV_REL, 0xff00, 0},	/* left */
+	{KIND_ACCEL,   0x71, EV_REL, 0x0100, 0},	/* right */
+	{KIND_ACCEL,   0x72, EV_REL, 0x00ff, 0},	/* up */
+	{KIND_ACCEL,   0x73, EV_REL, 0x0001, 0},	/* down */
+
 	/* Directional control pad diagonals */
-	{KIND_LU,      0x74, EV_REL, 0, 0},        /* left up */
-	{KIND_RU,      0x75, EV_REL, 0, 0},        /* right up */
-	{KIND_LD,      0x77, EV_REL, 0, 0},        /* left down */
-	{KIND_RD,      0x76, EV_REL, 0, 0},        /* right down */
+	{KIND_ACCEL,   0x74, EV_REL, 0xffff, 0},	/* left up */
+	{KIND_ACCEL,   0x75, EV_REL, 0x01ff, 0},	/* right up */
+	{KIND_ACCEL,   0x77, EV_REL, 0xff01, 0},	/* left down */
+	{KIND_ACCEL,   0x76, EV_REL, 0x0101, 0},	/* right down */
 
 	/* "Mouse button" buttons */
 	{KIND_LITERAL, 0x78, EV_KEY, BTN_LEFT, 1}, /* left btn down */
@@ -493,7 +490,6 @@ static void ati_remote_input_report(struct urb *urb)
 	unsigned char *data= ati_remote->inbuf;
 	struct input_dev *dev = ati_remote->idev;
 	int index = -1;
-	int acc;
 	int remote_num;
 	unsigned char scancode;
 	u32 wheel_keycode = KEY_RESERVED;
@@ -573,10 +569,8 @@ static void ati_remote_input_report(struct urb *urb)
 		input_sync(dev);
 
 		ati_remote->old_jiffies = jiffies;
-		return;
-	}
 
-	if (index < 0 || ati_remote_tbl[index].kind == KIND_FILTERED) {
+	} else if (index < 0 || ati_remote_tbl[index].kind == KIND_FILTERED) {
 		unsigned long now = jiffies;
 
 		/* Filter duplicate events which happen "too close" together. */
@@ -636,46 +630,27 @@ static void ati_remote_input_report(struct urb *urb)
 			ati_remote_tbl[index].code, 0);
 		input_sync(dev);
 
-	} else {
+	} else if (ati_remote_tbl[index].kind == KIND_ACCEL) {
+		signed char dx = ati_remote_tbl[index].code >> 8;
+		signed char dy = ati_remote_tbl[index].code & 255;
 
 		/*
 		 * Other event kinds are from the directional control pad, and
 		 * have an acceleration factor applied to them.  Without this
 		 * acceleration, the control pad is mostly unusable.
 		 */
-		acc = ati_remote_compute_accel(ati_remote);
-
-		switch (ati_remote_tbl[index].kind) {
-		case KIND_ACCEL:
-			input_event(dev, ati_remote_tbl[index].type,
-				ati_remote_tbl[index].code,
-				ati_remote_tbl[index].value * acc);
-			break;
-		case KIND_LU:
-			input_report_rel(dev, REL_X, -acc);
-			input_report_rel(dev, REL_Y, -acc);
-			break;
-		case KIND_RU:
-			input_report_rel(dev, REL_X, acc);
-			input_report_rel(dev, REL_Y, -acc);
-			break;
-		case KIND_LD:
-			input_report_rel(dev, REL_X, -acc);
-			input_report_rel(dev, REL_Y, acc);
-			break;
-		case KIND_RD:
-			input_report_rel(dev, REL_X, acc);
-			input_report_rel(dev, REL_Y, acc);
-			break;
-		default:
-			dev_dbg(&ati_remote->interface->dev,
-				"ati_remote kind=%d\n",
-				ati_remote_tbl[index].kind);
-		}
+		int acc = ati_remote_compute_accel(ati_remote);
+		if (dx)
+			input_report_rel(dev, REL_X, dx * acc);
+		if (dy)
+			input_report_rel(dev, REL_Y, dy * acc);
 		input_sync(dev);
 
 		ati_remote->old_jiffies = jiffies;
 		ati_remote->old_data = data[2];
+	} else {
+		dev_dbg(&ati_remote->interface->dev, "ati_remote kind=%d\n",
+			ati_remote_tbl[index].kind);
 	}
 }
 
-- 
1.9.2

