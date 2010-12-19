Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:24349 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932522Ab0LSXJ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 18:09:59 -0500
Subject: [RESEND] [PATCH for 2.6.37] cx23885, cx25840: Provide IR Rx
 timeout event reports
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	stoth@kernellabs.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 18:10:28 -0500
Message-ID: <1292800228.3710.4.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

(Resending because Mauro reported losing some emails on IRC)

Provide CX2388[578] IR receive timeout (RTO) reports in the
final space raw event sent up the chain to the raw IR pulse
decoders. This should allow the lirc decoder to actually
measure the inter-transmission gap properly.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23888-ir.c |   12 ++++++++----
 drivers/media/video/cx25840/cx25840-ir.c |   12 ++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index e37be6f..bb1ce34 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -673,7 +673,7 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 
 	unsigned int i, n;
 	union cx23888_ir_fifo_rec *p;
-	unsigned u, v;
+	unsigned u, v, w;
 
 	n = count / sizeof(union cx23888_ir_fifo_rec)
 		* sizeof(union cx23888_ir_fifo_rec);
@@ -692,11 +692,12 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		if ((p->hw_fifo_data & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
 			/* Assume RTO was because of no IR light input */
 			u = 0;
-			v4l2_dbg(2, ir_888_debug, sd, "rx read: end of rx\n");
+			w = 1;
 		} else {
 			u = (p->hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
 			if (invert)
 				u = u ? 0 : 1;
+			w = 0;
 		}
 
 		v = (unsigned) pulse_width_count_to_ns(
@@ -707,9 +708,12 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		init_ir_raw_event(&p->ir_core_data);
 		p->ir_core_data.pulse = u;
 		p->ir_core_data.duration = v;
+		p->ir_core_data.timeout = w;
 
-		v4l2_dbg(2, ir_888_debug, sd, "rx read: %10u ns  %s\n",
-			 v, u ? "mark" : "space");
+		v4l2_dbg(2, ir_888_debug, sd, "rx read: %10u ns  %s  %s\n",
+			 v, u ? "mark" : "space", w ? "(timed out)" : "");
+		if (w)
+			v4l2_dbg(2, ir_888_debug, sd, "rx read: end of rx\n");
 	}
 	return 0;
 }
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index 627926f..b210c29 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -668,7 +668,7 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 	u16 divider;
 	unsigned int i, n;
 	union cx25840_ir_fifo_rec *p;
-	unsigned u, v;
+	unsigned u, v, w;
 
 	if (ir_state == NULL)
 		return -ENODEV;
@@ -694,11 +694,12 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		if ((p->hw_fifo_data & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
 			/* Assume RTO was because of no IR light input */
 			u = 0;
-			v4l2_dbg(2, ir_debug, sd, "rx read: end of rx\n");
+			w = 1;
 		} else {
 			u = (p->hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
 			if (invert)
 				u = u ? 0 : 1;
+			w = 0;
 		}
 
 		v = (unsigned) pulse_width_count_to_ns(
@@ -709,9 +710,12 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		init_ir_raw_event(&p->ir_core_data);
 		p->ir_core_data.pulse = u;
 		p->ir_core_data.duration = v;
+		p->ir_core_data.timeout = w;
 
-		v4l2_dbg(2, ir_debug, sd, "rx read: %10u ns  %s\n",
-			 v, u ? "mark" : "space");
+		v4l2_dbg(2, ir_debug, sd, "rx read: %10u ns  %s  %s\n",
+			 v, u ? "mark" : "space", w ? "(timed out)" : "");
+		if (w)
+			v4l2_dbg(2, ir_debug, sd, "rx read: end of rx\n");
 	}
 	return 0;
 }


