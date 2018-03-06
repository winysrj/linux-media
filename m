Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44185 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753168AbeCFTPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:40 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/4] cx25840: Use subdev host data for PLL override
Date: Tue,  6 Mar 2018 13:15:34 -0600
Message-Id: <1520363737-25724-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
References: <1520363737-25724-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx25840 driver currently configures 885, 887, and 888 using
default divisors for each chip. This check to see if the cx23885
driver has passed the cx25840 a non-default clock rate for a
specific chip. If a cx23885 board has left clk_freq at 0, the
clock default values will be used to configure the PLLs.

This patch only has effect on 888 boards who set clk_freq to 25M.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 98be63a..b168bf3 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -463,8 +463,13 @@ static void cx23885_initialize(struct i2c_client *client)
 {
 	DEFINE_WAIT(wait);
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
+	u32 clk_freq = 0;
 	struct workqueue_struct *q;
 
+	/* cx23885 sets hostdata to clk_freq pointer */
+	if (v4l2_get_subdev_hostdata(&state->sd))
+		clk_freq = *((u32 *)v4l2_get_subdev_hostdata(&state->sd));
+
 	/*
 	 * Come out of digital power down
 	 * The CX23888, at least, needs this, otherwise registers aside from
@@ -500,8 +505,13 @@ static void cx23885_initialize(struct i2c_client *client)
 		 * 50.0 MHz * (0xb + 0xe8ba26/0x2000000)/4 = 5 * 28.636363 MHz
 		 * 572.73 MHz before post divide
 		 */
-		/* HVR1850 or 50MHz xtal */
-		cx25840_write(client, 0x2, 0x71);
+		if (clk_freq == 25000000) {
+			/* 888/ImpactVCBe or 25Mhz xtal */
+			; /* nothing to do */
+		} else {
+			/* HVR1850 or 50MHz xtal */
+			cx25840_write(client, 0x2, 0x71);
+		}
 		cx25840_write4(client, 0x11c, 0x01d1744c);
 		cx25840_write4(client, 0x118, 0x00000416);
 		cx25840_write4(client, 0x404, 0x0010253e);
@@ -544,9 +554,15 @@ static void cx23885_initialize(struct i2c_client *client)
 	/* HVR1850 */
 	switch (state->id) {
 	case CX23888_AV:
-		/* 888/HVR1250 specific */
-		cx25840_write4(client, 0x10c, 0x13333333);
-		cx25840_write4(client, 0x108, 0x00000515);
+		if (clk_freq == 25000000) {
+			/* 888/ImpactVCBe or 25MHz xtal */
+			cx25840_write4(client, 0x10c, 0x01b6db7b);
+			cx25840_write4(client, 0x108, 0x00000512);
+		} else {
+			/* 888/HVR1250 or 50MHz xtal */
+			cx25840_write4(client, 0x10c, 0x13333333);
+			cx25840_write4(client, 0x108, 0x00000515);
+		}
 		break;
 	default:
 		cx25840_write4(client, 0x10c, 0x002be2c9);
@@ -576,7 +592,7 @@ static void cx23885_initialize(struct i2c_client *client)
 		 * 368.64 MHz before post divide
 		 * 122.88 MHz / 0xa = 12.288 MHz
 		 */
-		/* HVR1850  or 50MHz xtal */
+		/* HVR1850 or 50MHz xtal or 25MHz xtal */
 		cx25840_write4(client, 0x114, 0x017dbf48);
 		cx25840_write4(client, 0x110, 0x000a030e);
 		break;
-- 
2.7.4
