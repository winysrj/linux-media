Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51602 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387721AbeKVUlt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 15:41:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] dib0900: fix smatch warnings
Message-ID: <05c0aa2e-f220-8c09-e823-447b35f4b5fe@xs4all.nl>
Date: Thu, 22 Nov 2018 11:03:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1075 dib0090_pwm_gain_reset() warn: '*&bb_ramp_pwm_normal' 2590696709486571520 can't fit into 65535 '*bb_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1083 dib0090_pwm_gain_reset() warn: '*&bb_ramp_pwm_normal_socs' 2590696709486571520 can't fit into 65535 '*bb_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1085 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_cband_8090' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1089 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_cband_7090e_sensitivity' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1093 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_cband_7090p' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1096 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_cband' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1101 dib0090_pwm_gain_reset() warn: '*&bb_ramp_pwm_normal_socs' 2590696709486571520 can't fit into 65535 '*bb_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1104 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_vhf' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1107 dib0090_pwm_gain_reset() warn: '*&bb_ramp_pwm_normal_socs' 2590696709486571520 can't fit into 65535 '*bb_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1109 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_uhf_8090' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1111 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_uhf_7090' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1113 dib0090_pwm_gain_reset() warn: '*&rf_ramp_pwm_uhf' 2590696709486571520 can't fit into 65535 '*rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1419 dib0090_update_rframp_7090() warn: '*&rf_ramp_pwm_cband_7090e_sensitivity' 2590696709486571520 can't fit into 65535
'*state->rf_ramp'
drivers/media/dvb-frontends/dib0090.c: drivers/media/dvb-frontends/dib0090.c:1421 dib0090_update_rframp_7090() warn: '*&rf_ramp_pwm_cband_7090e_aci' 2590696709486571520 can't fit into 65535
'*state->rf_ramp'

For no apparent reason this code casts away the const of the const u16 arrays, and it
also takes the address of an array. While that's ignored in C I think smatch gets confused
by it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/dib0090.c | 32 +++++++++++++--------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 44a074261e69..4813a88eb9f7 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1072,45 +1072,45 @@ static void dib0090_set_bbramp_pwm(struct dib0090_state *state, const u16 * cfg)
 void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 {
 	struct dib0090_state *state = fe->tuner_priv;
-	u16 *bb_ramp = (u16 *)&bb_ramp_pwm_normal; /* default baseband config */
-	u16 *rf_ramp = NULL;
+	const u16 *bb_ramp = bb_ramp_pwm_normal; /* default baseband config */
+	const u16 *rf_ramp = NULL;
 	u8 en_pwm_rf_mux = 1;

 	/* reset the AGC */
 	if (state->config->use_pwm_agc) {
 		if (state->current_band == BAND_CBAND) {
 			if (state->identity.in_soc) {
-				bb_ramp = (u16 *)&bb_ramp_pwm_normal_socs;
+				bb_ramp = bb_ramp_pwm_normal_socs;
 				if (state->identity.version == SOC_8090_P1G_11R1 || state->identity.version == SOC_8090_P1G_21R1)
-					rf_ramp = (u16 *)&rf_ramp_pwm_cband_8090;
+					rf_ramp = rf_ramp_pwm_cband_8090;
 				else if (state->identity.version == SOC_7090_P1G_11R1 || state->identity.version == SOC_7090_P1G_21R1) {
 					if (state->config->is_dib7090e) {
 						if (state->rf_ramp == NULL)
-							rf_ramp = (u16 *)&rf_ramp_pwm_cband_7090e_sensitivity;
+							rf_ramp = rf_ramp_pwm_cband_7090e_sensitivity;
 						else
-							rf_ramp = (u16 *)state->rf_ramp;
+							rf_ramp = state->rf_ramp;
 					} else
-						rf_ramp = (u16 *)&rf_ramp_pwm_cband_7090p;
+						rf_ramp = rf_ramp_pwm_cband_7090p;
 				}
 			} else
-				rf_ramp = (u16 *)&rf_ramp_pwm_cband;
+				rf_ramp = rf_ramp_pwm_cband;
 		} else

 			if (state->current_band == BAND_VHF) {
 				if (state->identity.in_soc) {
-					bb_ramp = (u16 *)&bb_ramp_pwm_normal_socs;
+					bb_ramp = bb_ramp_pwm_normal_socs;
 					/* rf_ramp = &rf_ramp_pwm_vhf_socs; */ /* TODO */
 				} else
-					rf_ramp = (u16 *)&rf_ramp_pwm_vhf;
+					rf_ramp = rf_ramp_pwm_vhf;
 			} else if (state->current_band == BAND_UHF) {
 				if (state->identity.in_soc) {
-					bb_ramp = (u16 *)&bb_ramp_pwm_normal_socs;
+					bb_ramp = bb_ramp_pwm_normal_socs;
 					if (state->identity.version == SOC_8090_P1G_11R1 || state->identity.version == SOC_8090_P1G_21R1)
-						rf_ramp = (u16 *)&rf_ramp_pwm_uhf_8090;
+						rf_ramp = rf_ramp_pwm_uhf_8090;
 					else if (state->identity.version == SOC_7090_P1G_11R1 || state->identity.version == SOC_7090_P1G_21R1)
-						rf_ramp = (u16 *)&rf_ramp_pwm_uhf_7090;
+						rf_ramp = rf_ramp_pwm_uhf_7090;
 				} else
-					rf_ramp = (u16 *)&rf_ramp_pwm_uhf;
+					rf_ramp = rf_ramp_pwm_uhf;
 			}
 		if (rf_ramp)
 			dib0090_set_rframp_pwm(state, rf_ramp);
@@ -1416,9 +1416,9 @@ int dib0090_update_rframp_7090(struct dvb_frontend *fe, u8 cfg_sensitivity)
 	}

 	if (cfg_sensitivity)
-		state->rf_ramp = (const u16 *)&rf_ramp_pwm_cband_7090e_sensitivity;
+		state->rf_ramp = rf_ramp_pwm_cband_7090e_sensitivity;
 	else
-		state->rf_ramp = (const u16 *)&rf_ramp_pwm_cband_7090e_aci;
+		state->rf_ramp = rf_ramp_pwm_cband_7090e_aci;
 	dib0090_pwm_gain_reset(fe);

 	return 0;
-- 
2.19.1
