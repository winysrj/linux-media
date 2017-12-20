Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44713 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdLTQ3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:29:52 -0500
Received: by mail-wr0-f195.google.com with SMTP id l41so10596724wre.11
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:29:52 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH] [media] dvb-frontend/mxl5xx: add support for physical layer scrambling
Date: Wed, 20 Dec 2017 17:29:48 +0100
Message-Id: <20171220162948.815-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The MaxLinear MxL5xx has support for physical layer scrambling, which was
recently added to the DVB core via the new scrambling_sequence_index
property. Add required bits to the mxl5xx driver.

Picked up from dddvb master, commit 5c032058b9ba ("add support for PLS")
by Ralph Metzler <rjkm@metzlerbros.de>, adapted to the different naming
of the pls property (pls vs. scrambling_sequence_index).

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
NB, I'm also prepping up another set of patches that enable the stv0910
driver to handle the recently added PLS support.

 drivers/media/dvb-frontends/mxl5xx.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 1ebc3830579f..05f27f51fd03 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -380,6 +380,38 @@ static int get_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_HW;
 }
 
+static u32 gold2root(u32 gold)
+{
+	u32 x, g, tmp = gold;
+
+	if (tmp >= 0x3ffff)
+		tmp = 0;
+	for (g = 0, x = 1; g < tmp; g++)
+		x = (((x ^ (x >> 7)) & 1) << 17) | (x >> 1);
+	return x;
+}
+
+static int cfg_scrambler(struct mxl *state, u32 gold)
+{
+	u32 root;
+	u8 buf[26] = {
+		MXL_HYDRA_PLID_CMD_WRITE, 24,
+		0, MXL_HYDRA_DEMOD_SCRAMBLE_CODE_CMD, 0, 0,
+		state->demod, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 1, 0, 0, 0,
+	};
+
+	root = gold2root(gold);
+
+	buf[25] = (root >> 24) & 0xff;
+	buf[24] = (root >> 16) & 0xff;
+	buf[23] = (root >> 8) & 0xff;
+	buf[22] = root & 0xff;
+
+	return send_command(state, sizeof(buf), buf);
+}
+
 static int cfg_demod_abort_tune(struct mxl *state)
 {
 	struct MXL_HYDRA_DEMOD_ABORT_TUNE_T abort_tune_cmd;
@@ -437,7 +469,7 @@ static int set_parameters(struct dvb_frontend *fe)
 		demod_chan_cfg.roll_off = MXL_HYDRA_ROLLOFF_AUTO;
 		demod_chan_cfg.modulation_scheme = MXL_HYDRA_MOD_AUTO;
 		demod_chan_cfg.pilots = MXL_HYDRA_PILOTS_AUTO;
-		/* cfg_scrambler(state); */
+		cfg_scrambler(state, p->scrambling_sequence_index);
 		break;
 	default:
 		return -EINVAL;
-- 
2.13.6
