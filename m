Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:60625 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab3GRBd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 21:33:28 -0400
Received: by mail-we0-f171.google.com with SMTP id m46so2397936wev.16
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 18:33:27 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, crope@iki.fi, awalls@md.metrocast.net,
	Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] cx23885: Fix interrupt storm that happens in some cards when IR is enabled.
Date: Thu, 18 Jul 2013 02:33:22 +0100
Message-Id: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This i2c init should stop the interrupt storm that happens in some cards when the IR receiver in enabled.
It works perfectly in my TBS6981.

It would be good to test in other problematic cards.

In this patch I've added the IR init to the TeVii S470/S471 (and some others that fall in the same case statment).
Other cards but these that suffer the same issue should also be tested.

Give feedback!

Regards,
Luis



Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-cards.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 7e923f8..89ce132 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1081,6 +1081,27 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 	return 0;
 }
 
+void cx23885_ir_setup(struct cx23885_dev *dev)
+{
+	struct i2c_msg msg;
+	char buffer[2];
+
+	/* this should stop the IR interrupt
+	   storm that happens in some cards */
+	msg.addr = 0x4c;
+	msg.flags = 0;
+	msg.len = 2;
+	msg.buf = buffer;
+
+	buffer[0] = 0x1f;
+	buffer[1] = 0x80;
+	i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
+
+	buffer[0] = 0x23;
+	buffer[1] = 0x80;
+	i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
+}
+
 void cx23885_gpio_setup(struct cx23885_dev *dev)
 {
 	switch (dev->board) {
@@ -1664,6 +1685,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		cx23885_ir_setup(dev);
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
-- 
1.7.9.5

