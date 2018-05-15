Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42906 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752044AbeEOIuK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 04:50:10 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] adv7511: fix clearing of the CEC receive buffer
Message-ID: <042a8899-22de-ed0e-bcbe-26e86b8f989e@xs4all.nl>
Date: Tue, 15 May 2018 10:50:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC receive buffer was not always cleared correctly. The
datasheet was a bit confusing since sometimes it mentioned that the
bit in CEC register 0x4a had to be toggled, and sometimes it suggested
it was a 'Clear-on-write' bit. But it really needs to be toggled.

The patch also enables/disables the CEC irqs after the other irq are
enabled/disabled instead of doing it before. It may not matter, but it
feels more logical to do it in that order, and the implementation that
we (Cisco) have used until now and that is known to be reliable also
did it in that order.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index d23505a411ee..d4b191c5ac47 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -732,8 +732,8 @@ static int adv7511_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		/* power up cec section */
 		adv7511_cec_write_and_or(sd, 0x4e, 0xfc, 0x01);
 		/* legacy mode and clear all rx buffers */
+		adv7511_cec_write(sd, 0x4a, 0x00);
 		adv7511_cec_write(sd, 0x4a, 0x07);
-		adv7511_cec_write(sd, 0x4a, 0);
 		adv7511_cec_write_and_or(sd, 0x11, 0xfe, 0); /* initially disable tx */
 		/* enabled irqs: */
 		/* tx: ready */
@@ -917,9 +917,6 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 	else if (adv7511_have_hotplug(sd))
 		irqs |= MASK_ADV7511_EDID_RDY_INT;

-	adv7511_wr_and_or(sd, 0x95, 0xc0,
-			  (state->cec_enabled_adap && enable) ? 0x39 : 0x00);
-
 	/*
 	 * This i2c write can fail (approx. 1 in 1000 writes). But it
 	 * is essential that this register is correct, so retry it
@@ -933,9 +930,11 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 		irqs_rd = adv7511_rd(sd, 0x94);
 	} while (retries-- && irqs_rd != irqs);

-	if (irqs_rd == irqs)
-		return;
-	v4l2_err(sd, "Could not set interrupts: hw failure?\n");
+	if (irqs_rd != irqs)
+		v4l2_err(sd, "Could not set interrupts: hw failure?\n");
+
+	adv7511_wr_and_or(sd, 0x95, 0xc0,
+			  (state->cec_enabled_adap && enable) ? 0x39 : 0x00);
 }

 /* Interrupt handler */
@@ -982,8 +981,8 @@ static int adv7511_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			for (i = 0; i < msg.len; i++)
 				msg.msg[i] = adv7511_cec_read(sd, i + 0x15);

-			adv7511_cec_write(sd, 0x4a, 1); /* toggle to re-enable rx 1 */
-			adv7511_cec_write(sd, 0x4a, 0);
+			adv7511_cec_write(sd, 0x4a, 0); /* toggle to re-enable rx 1 */
+			adv7511_cec_write(sd, 0x4a, 1);
 			cec_received_msg(state->cec_adap, &msg);
 		}
 	}
@@ -1778,6 +1777,7 @@ static void adv7511_init_setup(struct v4l2_subdev *sd)

 	/* legacy mode */
 	adv7511_cec_write(sd, 0x4a, 0x00);
+	adv7511_cec_write(sd, 0x4a, 0x07);

 	if (cec_clk % 750000 != 0)
 		v4l2_err(sd, "%s: cec_clk %d, not multiple of 750 Khz\n",
