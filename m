Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc3s7.hotmail.com ([65.55.116.82]:57234 "EHLO
	BLU004-OMC3S7.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbALAdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 19:33:20 -0500
Message-ID: <BLU436-SMTP1951CF564474111B59412F0BA430@phx.gbl>
From: Michael Krufky <mkrufky@hotmail.com>
To: linux-media@vger.kernel.org
CC: m.chehab@samsung.com, Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/2] lgdt3305: add support for fixed tp clock mode
Date: Sun, 11 Jan 2015 19:33:09 -0500
In-Reply-To: <1421022789-5322-1-git-send-email-mkrufky@linuxtv.org>
References: <1421022789-5322-1-git-send-email-mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Ira Krufky <mkrufky@linuxtv.org>

Add support for controlling TP clock mode for VSB and QAM annex-B/C mode.
Gated clock mode is the default value, and does not support QAM annex-C.
The patch enables setting this control to fixed clock mode.

Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb-frontends/lgdt3305.c | 3 +++
 drivers/media/dvb-frontends/lgdt3305.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index b42d649..873c63a 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -241,6 +241,7 @@ static int lgdt3305_mpeg_mode_polarity(struct lgdt3305_state *state)
 	u8 val;
 	int ret;
 	enum lgdt3305_tp_clock_edge edge = state->cfg->tpclk_edge;
+	enum lgdt3305_tp_clock_mode mode = state->cfg->tpclk_mode;
 	enum lgdt3305_tp_valid_polarity valid = state->cfg->tpvalid_polarity;
 
 	lg_dbg("edge = %d, valid = %d\n", edge, valid);
@@ -253,6 +254,8 @@ static int lgdt3305_mpeg_mode_polarity(struct lgdt3305_state *state)
 
 	if (edge)
 		val |= 0x08;
+	if (mode)
+		val |= 0x40;
 	if (valid)
 		val |= 0x01;
 
diff --git a/drivers/media/dvb-frontends/lgdt3305.h b/drivers/media/dvb-frontends/lgdt3305.h
index d9ab556..9c03e53 100644
--- a/drivers/media/dvb-frontends/lgdt3305.h
+++ b/drivers/media/dvb-frontends/lgdt3305.h
@@ -37,6 +37,11 @@ enum lgdt3305_tp_clock_edge {
 	LGDT3305_TPCLK_FALLING_EDGE = 1,
 };
 
+enum lgdt3305_tp_clock_mode {
+	LGDT3305_TPCLK_GATED = 0,
+	LGDT3305_TPCLK_FIXED = 1,
+};
+
 enum lgdt3305_tp_valid_polarity {
 	LGDT3305_TP_VALID_LOW = 0,
 	LGDT3305_TP_VALID_HIGH = 1,
@@ -70,6 +75,7 @@ struct lgdt3305_config {
 
 	enum lgdt3305_mpeg_mode mpeg_mode;
 	enum lgdt3305_tp_clock_edge tpclk_edge;
+	enum lgdt3305_tp_clock_mode tpclk_mode;
 	enum lgdt3305_tp_valid_polarity tpvalid_polarity;
 	enum lgdt_demod_chip_type demod_chip;
 };
-- 
2.1.0

