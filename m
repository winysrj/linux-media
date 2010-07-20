Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59557 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab0GTBSZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:18:25 -0400
Subject: [PATCH 09/17] v4l2_subdev, cx23885: Differentiate IR carrier sense
 and I/O pin inversion
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:18:49 -0400
Message-ID: <1279588729.31145.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a distinction on IR Tx for the CX2388[578] chips of carrier
sense inversion (space is a carrier burst and mark is no burst) and I/O
pin level inversion (0 is high output level, 1 is low output level).
Allow the caller to set these parameters distinctly as v4l2_subdevice
IR parameters.  This permits the IR device to be configured and enabled
without the IR Tx LED being on during idle/space time due to an external
hardware level inversion

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-input.c |    2 +-
 drivers/media/video/cx23885/cx23888-ir.c    |   32 ++++++++++++++++++++------
 include/media/v4l2-subdev.h                 |    5 +++-
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index d0b1613..496d751 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -170,7 +170,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 		 * mark is received as low logic level;
 		 * falling edges are detected as rising edges; etc.
 		 */
-		params.invert = true;
+		params.invert_level = true;
 		break;
 	}
 	v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index f63d378..28ca90f 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -60,6 +60,8 @@ MODULE_PARM_DESC(ir_888_debug, "enable debug messages [CX23888 IR controller]");
 #define CNTRL_CPL	0x00001000
 #define CNTRL_LBM	0x00002000
 #define CNTRL_R		0x00004000
+/* CX23888 specific control flag */
+#define CNTRL_IVO	0x00008000
 
 #define CX23888_IR_TXCLK_REG	0x170004
 #define TXCLK_TCD	0x0000FFFF
@@ -423,6 +425,13 @@ static inline void control_tx_polarity_invert(struct cx23885_dev *dev,
 			   invert ? CNTRL_CPL : 0);
 }
 
+static inline void control_tx_level_invert(struct cx23885_dev *dev,
+					  bool invert)
+{
+	cx23888_ir_and_or4(dev, CX23888_IR_CNTRL_REG, ~CNTRL_IVO,
+			   invert ? CNTRL_IVO : 0);
+}
+
 /*
  * IR Rx & Tx Clock Register helpers
  */
@@ -782,8 +791,8 @@ static int cx23888_ir_rx_s_parameters(struct v4l2_subdev *sd,
 
 	control_rx_s_edge_detection(dev, CNTRL_EDG_BOTH);
 
-	o->invert = p->invert;
-	atomic_set(&state->rx_invert, p->invert);
+	o->invert_level = p->invert_level;
+	atomic_set(&state->rx_invert, p->invert_level);
 
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
@@ -894,8 +903,11 @@ static int cx23888_ir_tx_s_parameters(struct v4l2_subdev *sd,
 	/* FIXME - make this dependent on resolution for better performance */
 	control_tx_irq_watermark(dev, TX_FIFO_HALF_EMPTY);
 
-	control_tx_polarity_invert(dev, p->invert);
-	o->invert = p->invert;
+	control_tx_polarity_invert(dev, p->invert_carrier_sense);
+	o->invert_carrier_sense = p->invert_carrier_sense;
+
+	control_tx_level_invert(dev, p->invert_level);
+	o->invert_level = p->invert_level;
 
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
@@ -1025,8 +1037,11 @@ static int cx23888_ir_log_status(struct v4l2_subdev *sd)
 		  cntrl & CNTRL_TFE ? "enabled" : "disabled");
 	v4l2_info(sd, "\tFIFO interrupt watermark:          %s\n",
 		  cntrl & CNTRL_TIC ? "not empty" : "half full or less");
-	v4l2_info(sd, "\tSignal polarity:                   %s\n",
-		  cntrl & CNTRL_CPL ? "0:mark 1:space" : "0:space 1:mark");
+	v4l2_info(sd, "\tOutput pin level inversion         %s\n",
+		  cntrl & CNTRL_IVO ? "yes" : "no");
+	v4l2_info(sd, "\tCarrier polarity:                  %s\n",
+		  cntrl & CNTRL_CPL ? "space:burst mark:noburst"
+				    : "space:noburst mark:burst");
 	if (cntrl & CNTRL_MOD) {
 		v4l2_info(sd, "\tCarrier (16 clocks):               %u Hz\n",
 			  clock_divider_to_carrier_freq(txclk));
@@ -1146,7 +1161,7 @@ static const struct v4l2_subdev_ir_parameters default_rx_params = {
 	.noise_filter_min_width = 333333, /* ns */
 	.carrier_range_lower = 35000,
 	.carrier_range_upper = 37000,
-	.invert = false,
+	.invert_level = false,
 };
 
 static const struct v4l2_subdev_ir_parameters default_tx_params = {
@@ -1160,7 +1175,8 @@ static const struct v4l2_subdev_ir_parameters default_tx_params = {
 	.modulation = true,
 	.carrier_freq = 36000, /* 36 kHz - RC-5 carrier */
 	.duty_cycle = 25,      /* 25 %   - RC-5 carrier */
-	.invert = false,
+	.invert_level = false,
+	.invert_carrier_sense = false,
 };
 
 int cx23888_ir_probe(struct cx23885_dev *dev)
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9195ad4..a780cca 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -379,7 +379,10 @@ struct v4l2_subdev_ir_parameters {
 	u32 max_pulse_width;       /* ns,      valid only for baseband signal */
 	unsigned int carrier_freq; /* Hz,      valid only for modulated signal*/
 	unsigned int duty_cycle;   /* percent, valid only for modulated signal*/
-	bool invert;		   /* logically invert sense of mark/space */
+	bool invert_level;	   /* invert signal level */
+
+	/* Tx only */
+	bool invert_carrier_sense; /* Send 0/space as a carrier burst */
 
 	/* Rx only */
 	u32 noise_filter_min_width;       /* ns, min time of a valid pulse */
-- 
1.7.1.1


