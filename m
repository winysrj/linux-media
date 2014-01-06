Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaAFNE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 08:04:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] tuner-xc2028: Don't read status if device is powered down
Date: Mon,  6 Jan 2014 08:01:33 -0200
Message-Id: <1389002493-20134-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
References: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That removes those timeout errors:

[ 3675.930940] xc2028 19-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[ 3676.060487] xc2028 19-0061: divisor= 00 00 8d d0 (freq=567.250)
[ 3676.349449] xc2028 19-0061: Putting xc2028/3028 into poweroff mode.
[ 3698.247645] xc2028 19-0061: xc2028_get_reg 0002 called
[ 3698.253276] em2860 #0: I2C transfer timeout on writing to addr 0xc2
[ 3698.253301] xc2028 19-0061: i2c input error: rc = -121 (should be 2)
[ 3698.253327] xc2028 19-0061: xc2028_signal called
[ 3698.253339] xc2028 19-0061: xc2028_get_reg 0002 called
[ 3698.259283] em2860 #0: I2C transfer timeout on writing to addr 0xc2
[ 3698.259312] xc2028 19-0061: i2c input error: rc = -121 (should be 2)

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 75afab718ba6..cca508d4aafb 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -267,6 +267,7 @@ static int check_device_status(struct xc2028_data *priv)
 	case XC2028_WAITING_FIRMWARE:
 		return -EAGAIN;
 	case XC2028_ACTIVE:
+		return 1;
 	case XC2028_SLEEP:
 		return 0;
 	case XC2028_NODEV:
@@ -913,6 +914,12 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 	if (rc < 0)
 		return rc;
 
+	/* If the device is sleeping, no channel is tuned */
+	if (!rc) {
+		*strength = 0;
+		return 0;
+	}
+
 	mutex_lock(&priv->lock);
 
 	/* Sync Lock Indicator */
@@ -960,6 +967,12 @@ static int xc2028_get_afc(struct dvb_frontend *fe, s32 *afc)
 	if (rc < 0)
 		return rc;
 
+	/* If the device is sleeping, no channel is tuned */
+	if (!rc) {
+		*afc = 0;
+		return 0;
+	}
+
 	mutex_lock(&priv->lock);
 
 	/* Sync Lock Indicator */
@@ -1277,12 +1290,12 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 	if (rc < 0)
 		return rc;
 
-	/* Avoid firmware reload on slow devices or if PM disabled */
-	if (no_poweroff || priv->ctrl.disable_power_mgmt)
+	/* Device is already in sleep mode */
+	if (!rc)
 		return 0;
 
-	/* Device is already in sleep mode */
-	if (priv->state == XC2028_SLEEP)
+	/* Avoid firmware reload on slow devices or if PM disabled */
+	if (no_poweroff || priv->ctrl.disable_power_mgmt)
 		return 0;
 
 	tuner_dbg("Putting xc2028/3028 into poweroff mode.\n");
-- 
1.8.3.1

