Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4695 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3LFKRh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:17:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com,
	Dinesh Ram <dinesh.ram@cern.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 04/11] si4713: Bug fix for si4713_tx_tune_power() method in the i2c driver
Date: Fri,  6 Dec 2013 11:17:07 +0100
Message-Id: <1386325034-19344-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dinesh Ram <Dinesh.Ram@cern.ch>

In the si4713_tx_tune_power() method, the args array element 'power'
can take values between SI4713_MIN_POWER and SI4713_MAX_POWER. power = 0
is also valid. All the values (0 > power < SI4713_MIN_POWER) are illegal
and hence are all mapped to SI4713_MIN_POWER.

Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/si4713/si4713.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 096947c..4931325 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -555,14 +555,14 @@ static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
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
@@ -576,16 +576,16 @@ static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
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
@@ -1462,9 +1462,9 @@ static int si4713_probe(struct i2c_client *client,
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
1.8.4.rc3

