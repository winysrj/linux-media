Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:61641 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752214AbbGWMVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 08:21:48 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 04/13] media: adv7604: reduce support to first (digital) input
Date: Thu, 23 Jul 2015 13:21:34 +0100
Message-Id: <1437654103-26409-5-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using adv7611_read_cable_det() for ADV7612 means that full
support for '.max_port = ADV7604_PAD_HDMI_PORT_B,' isn't available
due to the need for multiple port reads to determine cable detection,
and an agreed mechanism for communicating the separate statuses.

This patch replaces adv7611_read_cable_det() with a functionally
identical copy, commented appropriately.

Earlier submissions [leading to commit 8331d30b] also set .cp_csc,
which is used in a cp_read() call within adv76xx_log_status().

Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/i2c/adv7604.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 0587d27..2524184 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -877,6 +877,16 @@ static unsigned int adv7611_read_cable_det(struct v4l2_subdev *sd)
 	return value & 1;
 }
 
+static unsigned int adv7612_read_cable_det(struct v4l2_subdev *sd)
+{
+	/*  Reads CABLE_DET_A_RAW. For input B support, need to
+	 *  account for bit 7 [MSB] of 0x6a (ie. CABLE_DET_B_RAW)
+	 */
+	u8 value = io_read(sd, 0x6f);
+
+	return value & 1;
+}
+
 static int adv76xx_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -2728,20 +2738,21 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 	[ADV7612] = {
 		.type = ADV7612,
 		.has_afe = false,
-		.max_port = ADV7604_PAD_HDMI_PORT_B,
-		.num_dv_ports = 2,
+		.max_port = ADV76XX_PAD_HDMI_PORT_A,	/* B not supported */
+		.num_dv_ports = 1,			/* normally 2 */
 		.edid_enable_reg = 0x74,
 		.edid_status_reg = 0x76,
 		.lcf_reg = 0xa3,
 		.tdms_lock_mask = 0x43,
 		.cable_det_mask = 0x01,
 		.fmt_change_digital_mask = 0x03,
+		.cp_csc = 0xf4,
 		.formats = adv7612_formats,
 		.nformats = ARRAY_SIZE(adv7612_formats),
 		.set_termination = adv7611_set_termination,
 		.setup_irqs = adv7612_setup_irqs,
 		.read_hdmi_pixelclock = adv7611_read_hdmi_pixelclock,
-		.read_cable_det = adv7611_read_cable_det,
+		.read_cable_det = adv7612_read_cable_det,
 		.recommended_settings = {
 		    [1] = adv7612_recommended_settings_hdmi,
 		},
-- 
1.7.10.4

