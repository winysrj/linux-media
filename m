Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41162 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbFGKcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 06:32:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/6] adv7511: replace uintX_t by uX for consistency
Date: Sun,  7 Jun 2015 12:32:30 +0200
Message-Id: <1433673155-20179-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
References: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Currently this driver mixes u8/u16 and uint8_t/uint16_t. Standardize on
u8/u16.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 32 ++++++++++++++++----------------
 include/media/adv7511.h     |  6 +++---
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 9032567..d9bb90b 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -77,7 +77,7 @@ struct adv7511_state_edid {
 	u32 blocks;
 	/* Number of segments read */
 	u32 segments;
-	uint8_t data[EDID_MAX_SEGM * 256];
+	u8 data[EDID_MAX_SEGM * 256];
 	/* Number of EDID read retries left */
 	unsigned read_retries;
 	bool complete;
@@ -89,8 +89,8 @@ struct adv7511_state {
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	int chip_revision;
-	uint8_t i2c_edid_addr;
-	uint8_t i2c_cec_addr;
+	u8 i2c_edid_addr;
+	u8 i2c_cec_addr;
 	/* Is the adv7511 powered on? */
 	bool power_on;
 	/* Did we receive hotplug and rx-sense signals? */
@@ -201,7 +201,7 @@ static int adv7511_wr(struct v4l2_subdev *sd, u8 reg, u8 val)
 
 /* To set specific bits in the register, a clear-mask is given (to be AND-ed),
    and then the value-mask (to be OR-ed). */
-static inline void adv7511_wr_and_or(struct v4l2_subdev *sd, u8 reg, uint8_t clr_mask, uint8_t val_mask)
+static inline void adv7511_wr_and_or(struct v4l2_subdev *sd, u8 reg, u8 clr_mask, u8 val_mask)
 {
 	adv7511_wr(sd, reg, (adv7511_rd(sd, reg) & clr_mask) | val_mask);
 }
@@ -223,7 +223,7 @@ static int adv_smbus_read_i2c_block_data(struct i2c_client *client,
 	return ret;
 }
 
-static inline void adv7511_edid_rd(struct v4l2_subdev *sd, uint16_t len, uint8_t *buf)
+static inline void adv7511_edid_rd(struct v4l2_subdev *sd, u16 len, u8 *buf)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	int i;
@@ -248,7 +248,7 @@ static inline bool adv7511_have_rx_sense(struct v4l2_subdev *sd)
 	return adv7511_rd(sd, 0x42) & MASK_ADV7511_MSEN_DETECT;
 }
 
-static void adv7511_csc_conversion_mode(struct v4l2_subdev *sd, uint8_t mode)
+static void adv7511_csc_conversion_mode(struct v4l2_subdev *sd, u8 mode)
 {
 	adv7511_wr_and_or(sd, 0x18, 0x9f, (mode & 0x3)<<5);
 }
@@ -292,7 +292,7 @@ static void adv7511_csc_coeff(struct v4l2_subdev *sd,
 static void adv7511_csc_rgb_full2limit(struct v4l2_subdev *sd, bool enable)
 {
 	if (enable) {
-		uint8_t csc_mode = 0;
+		u8 csc_mode = 0;
 		adv7511_csc_conversion_mode(sd, csc_mode);
 		adv7511_csc_coeff(sd,
 				  4096-564, 0, 0, 256,
@@ -546,8 +546,8 @@ static int adv7511_s_power(struct v4l2_subdev *sd, int on)
 /* Enable interrupts */
 static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 {
-	uint8_t irqs = MASK_ADV7511_HPD_INT | MASK_ADV7511_MSEN_INT;
-	uint8_t irqs_rd;
+	u8 irqs = MASK_ADV7511_HPD_INT | MASK_ADV7511_MSEN_INT;
+	u8 irqs_rd;
 	int retries = 100;
 
 	v4l2_dbg(2, debug, sd, "%s: %s\n", __func__, enable ? "enable" : "disable");
@@ -580,7 +580,7 @@ static void adv7511_set_isr(struct v4l2_subdev *sd, bool enable)
 /* Interrupt handler */
 static int adv7511_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
-	uint8_t irq_status;
+	u8 irq_status;
 
 	/* disable interrupts to prevent a race condition */
 	adv7511_set_isr(sd, false);
@@ -1033,7 +1033,7 @@ static const struct v4l2_subdev_ops adv7511_ops = {
 };
 
 /* ----------------------------------------------------------------------- */
-static void adv7511_dbg_dump_edid(int lvl, int debug, struct v4l2_subdev *sd, int segment, uint8_t *buf)
+static void adv7511_dbg_dump_edid(int lvl, int debug, struct v4l2_subdev *sd, int segment, u8 *buf)
 {
 	if (debug >= lvl) {
 		int i, j;
@@ -1145,7 +1145,7 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	/* read hotplug and rx-sense state */
-	uint8_t status = adv7511_rd(sd, 0x42);
+	u8 status = adv7511_rd(sd, 0x42);
 
 	v4l2_dbg(1, debug, sd, "%s: status: 0x%x%s%s\n",
 			 __func__,
@@ -1189,9 +1189,9 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 	}
 }
 
-static bool edid_block_verify_crc(uint8_t *edid_block)
+static bool edid_block_verify_crc(u8 *edid_block)
 {
-	uint8_t sum = 0;
+	u8 sum = 0;
 	int i;
 
 	for (i = 0; i < 128; i++)
@@ -1203,7 +1203,7 @@ static bool edid_verify_crc(struct v4l2_subdev *sd, u32 segment)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	u32 blocks = state->edid.blocks;
-	uint8_t *data = state->edid.data;
+	u8 *data = state->edid.data;
 
 	if (!edid_block_verify_crc(&data[segment * 256]))
 		return false;
@@ -1228,7 +1228,7 @@ static bool edid_verify_header(struct v4l2_subdev *sd, u32 segment)
 static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
-	uint8_t edidRdy = adv7511_rd(sd, 0xc5);
+	u8 edidRdy = adv7511_rd(sd, 0xc5);
 
 	v4l2_dbg(1, debug, sd, "%s: edid ready (retries: %d)\n",
 			 __func__, EDID_MAX_RETRIES - state->edid.read_retries);
diff --git a/include/media/adv7511.h b/include/media/adv7511.h
index bb78bed..f351eff 100644
--- a/include/media/adv7511.h
+++ b/include/media/adv7511.h
@@ -40,9 +40,9 @@ struct adv7511_cec_arg {
 };
 
 struct adv7511_platform_data {
-	uint8_t i2c_edid;
-	uint8_t i2c_cec;
-	uint32_t cec_clk;
+	u8 i2c_edid;
+	u8 i2c_cec;
+	u32 cec_clk;
 };
 
 #endif
-- 
2.1.4

