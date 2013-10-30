Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33339 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3J3FlR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 01:41:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] r820t: add support for R828D
Date: Wed, 30 Oct 2013 07:40:33 +0200
Message-Id: <1383111636-19743-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small changes in order to support tuner version R828D @ 16 MHz clock.

There was 'vco_fine_tune' check, which seems to adjust synthesizer
output divider (mixer dix / LO div / Rout) by one. R828D seems to
return vco_fine_tune=1 every time and that condition causes tuning
fail as output divider was increased by one.
Resolve problem by skipping whole condition in case of R828D tuner.
Just to mention, other tuner, R820T, seems to return 2 here.

Synthesizer maximum frequency check was hard coded to check synthesizer N
and thus worked correctly only for clock frequencies around 30 MHz.
As whole test is quite useless in any case, I removed it totally.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/r820t.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 1c23666..d9ee43f 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -612,10 +612,19 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 
 	vco_fine_tune = (data[4] & 0x30) >> 4;
 
-	if (vco_fine_tune > VCO_POWER_REF)
-		div_num = div_num - 1;
-	else if (vco_fine_tune < VCO_POWER_REF)
-		div_num = div_num + 1;
+	tuner_dbg("mix_div=%d div_num=%d vco_fine_tune=%d\n",
+			mix_div, div_num, vco_fine_tune);
+
+	/*
+	 * XXX: R828D/16MHz seems to have always vco_fine_tune=1.
+	 * Due to that, this calculation goes wrong.
+	 */
+	if (priv->cfg->rafael_chip != CHIP_R828D) {
+		if (vco_fine_tune > VCO_POWER_REF)
+			div_num = div_num - 1;
+		else if (vco_fine_tune < VCO_POWER_REF)
+			div_num = div_num + 1;
+	}
 
 	rc = r820t_write_reg_mask(priv, 0x10, div_num << 5, 0xe0);
 	if (rc < 0)
@@ -637,11 +646,6 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 		vco_fra = pll_ref * 129 / 128;
 	}
 
-	if (nint > 63) {
-		tuner_info("No valid PLL values for %u kHz!\n", freq);
-		return -EINVAL;
-	}
-
 	ni = (nint - 13) / 4;
 	si = nint - 4 * ni - 13;
 
-- 
1.8.3.1

