Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34748 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760991Ab0GTB2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:28:49 -0400
Subject: [PATCH 17/17] cx23885: Require user to explicitly enable
 CX2388[57] IR via module param
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:26:26 -0400
Message-ID: <1279589186.31145.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CX23885 IR controller was reported to cause an interrupt storm
on a TeVii S470 card, but was reported fine on an HVR-1250.  Keep
integrated IR disabled by default on CX2388[57] based cards to avoid
a bad user experience in the general case.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-cards.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index b8ad935..0a3a0ad 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -30,6 +30,16 @@
 #include "netup-init.h"
 #include "cx23888-ir.h"
 
+static unsigned int enable_885_ir;
+module_param(enable_885_ir, int, 0644);
+MODULE_PARM_DESC(enable_885_ir,
+		 "Enable integrated IR controller for supported\n"
+		 "\t\t    CX2388[57] boards that are wired for it:\n"
+		 "\t\t\tHVR-1250 (reported safe)\n"
+		 "\t\t\tTeVii S470 (reported unsafe)\n"
+		 "\t\t    This can cause an interrupt storm with some cards.\n"
+		 "\t\t    Default: 0 [Disabled]");
+
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
 
@@ -985,6 +995,8 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
 		break;
 	case CX23885_BOARD_TEVII_S470:
+		if (!enable_885_ir)
+			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
 		if (dev->sd_ir == NULL) {
 			ret = -ENODEV;
@@ -994,6 +1006,8 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 				 ir_rx_pin_cfg_count, ir_rx_pin_cfg);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		if (!enable_885_ir)
+			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
 		if (dev->sd_ir == NULL) {
 			ret = -ENODEV;
@@ -1174,6 +1188,11 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	 * loaded, ensure this happens.
 	 */
 	switch (dev->board) {
+	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		/* Currently only enabled for the integrated IR controller */
+		if (!enable_885_ir)
+			break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
@@ -1186,8 +1205,6 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
-	case CX23885_BOARD_TEVII_S470:
-	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
-- 
1.7.1.1


