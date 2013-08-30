Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:8819 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3H3L33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:29:29 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: dinesh.ram@cern.ch, Dinesh Ram <dinram@cisco.com>
Subject: [PATCH 3/6] si4713 : Bug fix for si4713_tx_tune_power() method in the i2c driver
Date: Fri, 30 Aug 2013 13:28:21 +0200
Message-Id: <637d28441ff1e63ae72385afcba990fda11e0210.1377861337.git.dinram@cisco.com>
In-Reply-To: <1377862104-15429-1-git-send-email-dinram@cisco.com>
References: <1377862104-15429-1-git-send-email-dinram@cisco.com>
In-Reply-To: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the si4713_tx_tune_power() method, the args array element 'power' can take values between
SI4713_MIN_POWER and SI4713_MAX_POWER. power = 0 is also valid.
All the values (0 > power < SI4713_MIN_POWER) are illegal and hence
are all mapped to SI4713_MIN_POWER.

Signed-off-by: Dinesh Ram <dinram@cisco.com>
---
 drivers/media/radio/si4713/si4713.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 55c4d27..5d0be87 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -550,14 +550,14 @@ static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
 }
 
 /*
- * si4713_tx_tune_power - Sets the RF voltage level between 88 and 115 dBuV in
+ * si4713_tx_tune_power - Sets the RF voltage level between 88 and 120 dBuV in
  * 			1 dB units. A value of 0x00 indicates off. The command
  * 			also sets the antenna tuning capacitance. A value of 0
  * 			indicates autotuning, and a value of 1 - 191 indicates
  * 			a manual override, which results in a tuning
  * 			capacitance of 0.25 pF x @antcap.
  * @sdev: si4713_device structure for the device we are communicating
- * @power: tuning power (88 - 115 dBuV, unit/step 1 dB)
+ * @power: tuning power (88 - 120 dBuV, unit/step 1 dB)
  * @antcap: value of antenna tuning capacitor (0 - 191)
  */
 static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
@@ -571,16 +571,16 @@ static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
 	 * 	.Third byte = power
 	 * 	.Fourth byte = antcap
 	 */
-	const u8 args[SI4713_TXPWR_NARGS] = {
+	u8 args[SI4713_TXPWR_NARGS] = {
 		0x00,
 		0x00,
 		power,
 		antcap,
 	};
 
-	if (((power > 0) && (power < SI4713_MIN_POWER)) ||
-		power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
-		return -EDOM;
+	/* Map power values 1-87 to MIN_POWER (88) */
+	if (power > 0 && power < SI4713_MIN_POWER)
+		args[2] = power = SI4713_MIN_POWER;
 
 	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_POWER,
 				  args, ARRAY_SIZE(args), val,
@@ -1457,9 +1457,9 @@ static int si4713_probe(struct i2c_client *client,
 			V4L2_CID_TUNE_PREEMPHASIS,
 			V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
 	sdev->tune_pwr_level = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER_LEVEL);
+			V4L2_CID_TUNE_POWER_LEVEL, 0, SI4713_MAX_POWER, 1, DEFAULT_POWER_LEVEL);
 	sdev->tune_ant_cap = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, 191, 1, 0);
+			V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, SI4713_MAX_ANTCAP, 1, 0);
 
 	if (hdl->error) {
 		rval = hdl->error;
-- 
1.8.4.rc2

