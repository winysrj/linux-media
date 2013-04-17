Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab3DQAmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:54 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gsek021055
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 04/31] [media] r820t: Set gain mode to auto
Date: Tue, 16 Apr 2013 21:42:15 -0300
Message-Id: <1366159362-3773-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This tuner works with 2 modes: automatic gain mode and manual
gain mode. Put it into automatic mode, as we currently don't
have any API for manual gain adjustment.
The logic to allow setting the manual mode is there, as it is
just a few extra code. This way, if/when we latter add support
for setting the gain mode, the code is already there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 91 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ed9cd65..0fa355d 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -321,6 +321,20 @@ static int r820t_xtal_capacitor[][2] = {
 };
 
 /*
+ * measured with a Racal 6103E GSM test set at 928 MHz with -60 dBm
+ * input power, for raw results see:
+ *	http://steve-m.de/projects/rtl-sdr/gain_measurement/r820t/
+ */
+
+static const int r820t_lna_gain_steps[]  = {
+	0, 9, 13, 40, 38, 13, 31, 22, 26, 31, 26, 14, 19, 5, 35, 13
+};
+
+static const int r820t_mixer_gain_steps[]  = {
+	0, 5, 10, 10, 19, 9, 10, 25, 17, 10, 8, 16, 13, 6, 3, -8
+};
+
+/*
  * I2C read/write code and shadow registers logic
  */
 static void shadow_store(struct r820t_priv *priv, u8 reg, const u8 *val,
@@ -1094,6 +1108,78 @@ static int r820t_read_gain(struct r820t_priv *priv)
 	return ((data[3] & 0x0f) << 1) + ((data[3] & 0xf0) >> 4);
 }
 
+static int r820t_set_gain_mode(struct r820t_priv *priv,
+			       bool set_manual_gain,
+			       int gain)
+{
+	int rc;
+
+	if (set_manual_gain) {
+		int i, total_gain = 0;
+		uint8_t mix_index = 0, lna_index = 0;
+		u8 data[4];
+
+		/* LNA auto off */
+		rc = r820t_write_reg_mask(priv, 0x05, 0x10, 0x10);
+		if (rc < 0)
+			return rc;
+
+		 /* Mixer auto off */
+		rc = r820t_write_reg_mask(priv, 0x07, 0, 0x10);
+		if (rc < 0)
+			return rc;
+
+		rc = r820_read(priv, 0x00, data, sizeof(data));
+		if (rc < 0)
+			return rc;
+
+		/* set fixed VGA gain for now (16.3 dB) */
+		rc = r820t_write_reg_mask(priv, 0x0c, 0x08, 0x9f);
+		if (rc < 0)
+			return rc;
+
+		for (i = 0; i < 15; i++) {
+			if (total_gain >= gain)
+				break;
+
+			total_gain += r820t_lna_gain_steps[++lna_index];
+
+			if (total_gain >= gain)
+				break;
+
+			total_gain += r820t_mixer_gain_steps[++mix_index];
+		}
+
+		/* set LNA gain */
+		rc = r820t_write_reg_mask(priv, 0x05, lna_index, 0x0f);
+		if (rc < 0)
+			return rc;
+
+		/* set Mixer gain */
+		rc = r820t_write_reg_mask(priv, 0x07, mix_index, 0x0f);
+		if (rc < 0)
+			return rc;
+	} else {
+		/* LNA */
+		rc = r820t_write_reg_mask(priv, 0x05, 0, 0xef);
+		if (rc < 0)
+			return rc;
+
+		/* Mixer */
+		rc = r820t_write_reg_mask(priv, 0x07, 0x10, 0xef);
+		if (rc < 0)
+			return rc;
+
+		/* set fixed VGA gain for now (26.5 dB) */
+		rc = r820t_write_reg_mask(priv, 0x0c, 0x0b, 0x9f);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+
 static int generic_set_freq(struct dvb_frontend *fe,
 			    u32 freq /* in HZ */,
 			    unsigned bw,
@@ -1121,6 +1207,11 @@ static int generic_set_freq(struct dvb_frontend *fe,
 	rc = r820t_set_mux(priv, lo_freq);
 	if (rc < 0)
 		goto err;
+
+	rc = r820t_set_gain_mode(priv, true, 0);
+	if (rc < 0)
+		goto err;
+
 	rc = r820t_set_pll(priv, lo_freq);
 	if (rc < 0 || !priv->has_lock)
 		goto err;
-- 
1.8.1.4

