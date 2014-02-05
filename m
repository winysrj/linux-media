Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaBEQmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:42:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 32/47] adv7604: Cache register contents when reading multiple bits
Date: Wed,  5 Feb 2014 17:42:23 +0100
Message-Id: <1391618558-5580-33-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When extracting multiple bits from a single register read the register
once and extract the bits on the read value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 3d6876d..2a044d1 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1207,6 +1207,8 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 
 static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 {
+	u8 polarity;
+
 	if (no_lock_stdi(sd) || no_lock_sspd(sd)) {
 		v4l2_dbg(2, debug, sd, "%s: STDI and/or SSPD not locked\n", __func__);
 		return -1;
@@ -1219,11 +1221,12 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 	stdi->interlaced = io_read(sd, 0x12) & 0x10;
 
 	/* read SSPD */
-	if ((cp_read(sd, 0xb5) & 0x03) == 0x01) {
-		stdi->hs_pol = ((cp_read(sd, 0xb5) & 0x10) ?
-				((cp_read(sd, 0xb5) & 0x08) ? '+' : '-') : 'x');
-		stdi->vs_pol = ((cp_read(sd, 0xb5) & 0x40) ?
-				((cp_read(sd, 0xb5) & 0x20) ? '+' : '-') : 'x');
+	polarity = cp_read(sd, 0xb5);
+	if ((polarity & 0x03) == 0x01) {
+		stdi->hs_pol = polarity & 0x10
+			     ? (polarity & 0x08 ? '+' : '-') : 'x';
+		stdi->vs_pol = polarity & 0x40
+			     ? (polarity & 0x20 ? '+' : '-') : 'x';
 	} else {
 		stdi->hs_pol = 'x';
 		stdi->vs_pol = 'x';
@@ -1885,6 +1888,8 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	struct v4l2_dv_timings timings;
 	struct stdi_readback stdi;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
+	u8 edid_enabled;
+	u8 cable_det;
 
 	static const char * const csc_coeff_sel_rb[16] = {
 		"bypassed", "YPbPr601 -> RGB", "reserved", "YPbPr709 -> RGB",
@@ -1914,20 +1919,22 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
+	edid_enabled = rep_read(sd, 0x7d);
 	v4l2_info(sd, "EDID enabled port A: %s, B: %s, C: %s, D: %s\n",
-			((rep_read(sd, 0x7d) & 0x01) ? "Yes" : "No"),
-			((rep_read(sd, 0x7d) & 0x02) ? "Yes" : "No"),
-			((rep_read(sd, 0x7d) & 0x04) ? "Yes" : "No"),
-			((rep_read(sd, 0x7d) & 0x08) ? "Yes" : "No"));
+			((edid_enabled & 0x01) ? "Yes" : "No"),
+			((edid_enabled & 0x02) ? "Yes" : "No"),
+			((edid_enabled & 0x04) ? "Yes" : "No"),
+			((edid_enabled & 0x08) ? "Yes" : "No"));
 	v4l2_info(sd, "CEC: %s\n", !!(cec_read(sd, 0x2a) & 0x01) ?
 			"enabled" : "disabled");
 
 	v4l2_info(sd, "-----Signal status-----\n");
+	cable_det = io_read(sd, 0x6f);
 	v4l2_info(sd, "Cable detected (+5V power) port A: %s, B: %s, C: %s, D: %s\n",
-			((io_read(sd, 0x6f) & 0x10) ? "Yes" : "No"),
-			((io_read(sd, 0x6f) & 0x08) ? "Yes" : "No"),
-			((io_read(sd, 0x6f) & 0x04) ? "Yes" : "No"),
-			((io_read(sd, 0x6f) & 0x02) ? "Yes" : "No"));
+			((cable_det & 0x10) ? "Yes" : "No"),
+			((cable_det & 0x08) ? "Yes" : "No"),
+			((cable_det & 0x04) ? "Yes" : "No"),
+			((cable_det & 0x02) ? "Yes" : "No"));
 	v4l2_info(sd, "TMDS signal detected: %s\n",
 			no_signal_tmds(sd) ? "false" : "true");
 	v4l2_info(sd, "TMDS signal locked: %s\n",
-- 
1.8.3.2

