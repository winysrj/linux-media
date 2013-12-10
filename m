Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2872 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3LJNZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 15/15] adv7604: Enable HDMI_MODE interrupt
Date: Tue, 10 Dec 2013 14:23:20 +0100
Message-Id: <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Some sources are initially detected as DVI, and change to HDMI later.
This must be detected to set the right RGB quantization range.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c195a92..cfeaaaf 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1602,18 +1602,25 @@ static int adv7604_g_mbus_fmt(struct v4l2_subdev *sd,
 
 static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
-	u8 fmt_change, fmt_change_digital, tx_5v;
+	const u8 irq_reg_0x43 = io_read(sd, 0x43);
+	const u8 irq_reg_0x6b = io_read(sd, 0x6b);
+	const u8 irq_reg_0x70 = io_read(sd, 0x70);
+	u8 fmt_change_digital;
+	u8 fmt_change;
+	u8 tx_5v;
+
+	if (irq_reg_0x43)
+		io_write(sd, 0x44, irq_reg_0x43);
+	if (irq_reg_0x70)
+		io_write(sd, 0x71, irq_reg_0x70);
+	if (irq_reg_0x6b)
+		io_write(sd, 0x6c, irq_reg_0x6b);
 
 	v4l2_dbg(2, debug, sd, "%s: ", __func__);
 
 	/* format change */
-	fmt_change = io_read(sd, 0x43) & 0x98;
-	if (fmt_change)
-		io_write(sd, 0x44, fmt_change);
-
-	fmt_change_digital = is_digital_input(sd) ? (io_read(sd, 0x6b) & 0xc0) : 0;
-	if (fmt_change_digital)
-		io_write(sd, 0x6c, fmt_change_digital);
+	fmt_change = irq_reg_0x43 & 0x98;
+	fmt_change_digital = is_digital_input(sd) ? (irq_reg_0x6b & 0xc0) : 0;
 
 	if (fmt_change || fmt_change_digital) {
 		v4l2_dbg(1, debug, sd,
@@ -1625,6 +1632,15 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 		if (handled)
 			*handled = true;
 	}
+	/* HDMI/DVI mode */
+	if (irq_reg_0x6b & 0x01) {
+		v4l2_dbg(1, debug, sd, "%s: irq %s mode\n", __func__,
+			(io_read(sd, 0x6a) & 0x01) ? "HDMI" : "DVI");
+		set_rgb_quantization_range(sd);
+		if (handled)
+			*handled = true;
+	}
+
 	/* tx 5v detect */
 	tx_5v = io_read(sd, 0x70) & 0x1e;
 	if (tx_5v) {
@@ -2138,7 +2154,7 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	io_write(sd, 0x40, 0xc2); /* Configure INT1 */
 	io_write(sd, 0x41, 0xd7); /* STDI irq for any change, disable INT2 */
 	io_write(sd, 0x46, 0x98); /* Enable SSPD, STDI and CP unlocked interrupts */
-	io_write(sd, 0x6e, 0xc0); /* Enable V_LOCKED and DE_REGEN_LCK interrupts */
+	io_write(sd, 0x6e, 0xc1); /* Enable V_LOCKED, DE_REGEN_LCK, HDMI_MODE interrupts */
 	io_write(sd, 0x73, 0x1e); /* Enable CABLE_DET_A_ST (+5v) interrupts */
 
 	return v4l2_ctrl_handler_setup(sd->ctrl_handler);
-- 
1.8.4.rc3

