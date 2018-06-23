Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55298 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbeFWPg2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id v16-v6so4922025wmh.5
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:27 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 10/19] [media] ddbridge/mci: read and report signal strength and SNR
Date: Sat, 23 Jun 2018 17:36:06 +0200
Message-Id: <20180623153615.27630-11-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Implement querying signal statistics from the MCI and report this data
in read_status() as DVBv5 statistics.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c | 47 ++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index 46b20b06e2a6..7d402861fa9e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -155,6 +155,47 @@ static void release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
+static int get_info(struct dvb_frontend *fe)
+{
+	int stat;
+	struct mci *state = fe->demodulator_priv;
+	struct mci_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.command = MCI_CMD_GETSIGNALINFO;
+	cmd.demod = state->demod;
+	stat = mci_cmd(state, &cmd, &state->signal_info);
+	return stat;
+}
+
+static int get_snr(struct dvb_frontend *fe)
+{
+	struct mci *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	p->cnr.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	p->cnr.stat[0].svalue =
+		(s64)state->signal_info.dvbs2_signal_info.signal_to_noise
+		     * 10;
+	return 0;
+}
+
+static int get_strength(struct dvb_frontend *fe)
+{
+	struct mci *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	s32 str;
+
+	str = 100000 -
+	      (state->signal_info.dvbs2_signal_info.channel_power
+	       * 10 + 108750);
+	p->strength.len = 1;
+	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	p->strength.stat[0].svalue = str;
+	return 0;
+}
+
 static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	int stat;
@@ -168,10 +209,14 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 	if (stat)
 		return stat;
 	*status = 0x00;
+	get_info(fe);
+	get_strength(fe);
 	if (res.status == SX8_DEMOD_WAIT_MATYPE)
 		*status = 0x0f;
-	if (res.status == SX8_DEMOD_LOCKED)
+	if (res.status == SX8_DEMOD_LOCKED) {
 		*status = 0x1f;
+		get_snr(fe);
+	}
 	return stat;
 }
 
-- 
2.16.4
