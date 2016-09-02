Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36199 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753195AbcIBXhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 19:37:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20P=C3=B6schel?= <basic.master@gmx.de>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: fix dual tuner detection with PCTV 79e
Date: Sat,  3 Sep 2016 02:37:18 +0300
Message-Id: <1472859438-10911-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Pöschel <basic.master@gmx.de>

The value 5 of the EEPROM_TS_MODE register (meaning dual tuner presence) is
only valid for AF9035 devices. For IT9135 devices it is invalid and led to a
false positive dual tuner mode detection with PCTV 79e.
Therefore on non-AF9035 devices and with value 5 the driver now defaults to
single tuner mode and outputs a regarding info message to log.

This fixes Bugzilla bug #118561.

(backport of 4.7)

Fixes: b8278f8b961a ("[media] af9035: add support for 2nd tuner of MSI DigiVox Diversity")
Cc: <stable@vger.kernel.org> # 4.6
Reported-by: Marc Duponcheel <marc@offline.be>
Signed-off-by: Stefan Pöschel <basic.master@gmx.de>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 53 +++++++++++++++++++++++------------
 drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 2638e32..14dbfeb 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -475,7 +475,8 @@ static struct i2c_algorithm af9035_i2c_algo = {
 static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct state *state = d_to_priv(d);
-	int ret;
+	int ret, ts_mode_invalid;
+	u8 tmp;
 	u8 wbuf[1] = { 1 };
 	u8 rbuf[4];
 	struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
@@ -511,6 +512,38 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 		state->eeprom_addr = EEPROM_BASE_AF9035;
 	}
 
+
+	/* check for dual tuner mode */
+	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
+	if (ret < 0)
+		goto err;
+
+	ts_mode_invalid = 0;
+	switch (tmp) {
+	case 0:
+		break;
+	case 1:
+	case 3:
+		state->dual_mode = true;
+		break;
+	case 5:
+		if (state->chip_type != 0x9135 && state->chip_type != 0x9306)
+			state->dual_mode = true;	/* AF9035 */
+		else
+			ts_mode_invalid = 1;
+		break;
+	default:
+		ts_mode_invalid = 1;
+	}
+
+	dev_dbg(&d->udev->dev, "%s: ts mode=%d dual mode=%d\n",
+			__func__, tmp, state->dual_mode);
+
+	if (ts_mode_invalid)
+		dev_info(&d->udev->dev, "%s: ts mode=%d not supported, defaulting to single tuner mode!",
+				__func__, tmp);
+
+
 	ret = af9035_ctrl_msg(d, &req);
 	if (ret < 0)
 		goto err;
@@ -680,11 +713,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	 * which is done by master demod.
 	 * Master feeds also clock and controls power via GPIO.
 	 */
-	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
-	if (ret < 0)
-		goto err;
-
-	if (tmp == 1 || tmp == 3 || tmp == 5) {
+	if (state->dual_mode) {
 		/* configure gpioh1, reset & power slave demod */
 		ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
 		if (ret < 0)
@@ -817,18 +846,6 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	}
 
 
-
-	/* check if there is dual tuners */
-	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
-	if (ret < 0)
-		goto err;
-
-	if (tmp == 1 || tmp == 3 || tmp == 5)
-		state->dual_mode = true;
-
-	dev_dbg(&d->udev->dev, "%s: ts mode=%d dual mode=%d\n", __func__,
-			tmp, state->dual_mode);
-
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
 		ret = af9035_rd_reg(d,
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index df22001..d50ff15 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -112,7 +112,7 @@ static const u32 clock_lut_it9135[] = {
  * 0  TS
  * 1  DCA + PIP
  * 3  PIP
- * 5  DCA + PIP
+ * 5  DCA + PIP (AF9035 only)
  * n  DCA
  *
  * Values 0, 3 and 5 are seen to this day. 0 for single TS and 3/5 for dual TS.
-- 
http://palosaari.fi/

