Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaAFNFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 08:05:00 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] tuner-xc2028: Don't try to sleep twice
Date: Mon,  6 Jan 2014 08:01:32 -0200
Message-Id: <1389002493-20134-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
References: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only send a power down command for the device if it is not already
in power down state. That prevents a timeout when trying to talk
with the device.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 1057da54c6e0..75afab718ba6 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -709,6 +709,8 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 	return 0;
 }
 
+static int xc2028_sleep(struct dvb_frontend *fe);
+
 static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 			  v4l2_std_id std, __u16 int_freq)
 {
@@ -881,7 +883,7 @@ read_not_reliable:
 	return 0;
 
 fail:
-	priv->state = XC2028_SLEEP;
+	priv->state = XC2028_NO_FIRMWARE;
 
 	memset(&priv->cur_fw, 0, sizeof(priv->cur_fw));
 	if (retry_count < 8) {
@@ -891,6 +893,9 @@ fail:
 		goto retry;
 	}
 
+	/* Firmware didn't load. Put the device to sleep */
+	xc2028_sleep(fe);
+
 	if (rc == -ENOENT)
 		rc = -EINVAL;
 	return rc;
@@ -1276,6 +1281,10 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 	if (no_poweroff || priv->ctrl.disable_power_mgmt)
 		return 0;
 
+	/* Device is already in sleep mode */
+	if (priv->state == XC2028_SLEEP)
+		return 0;
+
 	tuner_dbg("Putting xc2028/3028 into poweroff mode.\n");
 	if (debug > 1) {
 		tuner_dbg("Printing sleep stack trace:\n");
@@ -1289,7 +1298,8 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 	else
 		rc = send_seq(priv, {0x80, XREG_POWER_DOWN, 0x00, 0x00});
 
-	priv->state = XC2028_SLEEP;
+	if (rc >= 0)
+		priv->state = XC2028_SLEEP;
 
 	mutex_unlock(&priv->lock);
 
@@ -1357,7 +1367,7 @@ static void load_firmware_cb(const struct firmware *fw,
 
 	if (rc < 0)
 		return;
-	priv->state = XC2028_SLEEP;
+	priv->state = XC2028_ACTIVE;
 }
 
 static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
-- 
1.8.3.1

