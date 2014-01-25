Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54175 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbaAYRLJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 47/52] msi3101: calculate tuner filters
Date: Sat, 25 Jan 2014 19:10:41 +0200
Message-Id: <1390669846-8131-48-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate tuner filters from sampling rate and use it if not
defined manually.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index cb66f81..02960c7 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1416,7 +1416,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 		{5000000, 0x04}, /* 5 MHz */
 		{6000000, 0x05}, /* 6 MHz */
 		{7000000, 0x06}, /* 7 MHz */
-		{8000000, 0x07}, /* 8 MHz */
+		{    ~0U, 0x07}, /* 8 MHz */
 	};
 
 	unsigned int f_rf = s->f_tuner;
@@ -1473,8 +1473,12 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(if_freq_lut))
 		goto err;
 
+	/* user has not requested bandwidth, set some reasonable */
+	if (bandwidth == 0)
+		bandwidth = s->f_adc;
+
 	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
-		if (bandwidth == bandwidth_lut[i].freq) {
+		if (bandwidth <= bandwidth_lut[i].freq) {
 			bandwidth = bandwidth_lut[i].val;
 			break;
 		}
@@ -1483,6 +1487,9 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(bandwidth_lut))
 		goto err;
 
+	dev_dbg(&s->udev->dev, "%s: bandwidth selected=%d\n",
+			__func__, bandwidth_lut[i].freq);
+
 #define F_OUT_STEP 1
 #define R_REF 4
 	f_vco = (f_rf + f_if + f_if1) * lo_div;
@@ -1925,9 +1932,9 @@ static int msi3101_probe(struct usb_interface *intf,
 		.id	= MSI3101_CID_TUNER_BW,
 		.type	= V4L2_CTRL_TYPE_INTEGER,
 		.name	= "Tuner Bandwidth",
-		.min	= 200000,
+		.min	= 0,
 		.max	= 8000000,
-		.def    = 600000,
+		.def    = 0,
 		.step	= 1,
 	};
 	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
-- 
1.8.5.3

