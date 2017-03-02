Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:57693 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754092AbdCBRLR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 12:11:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kasan-dev@googlegroups.com
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/26] brcmsmac: split up wlc_phy_workarounds_nphy
Date: Thu,  2 Mar 2017 17:38:17 +0100
Message-Id: <20170302163834.2273519-10-arnd@arndb.de>
In-Reply-To: <20170302163834.2273519-1-arnd@arndb.de>
References: <20170302163834.2273519-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stack consumption in this driver is still relatively high, with one
remaining warning if the warning level is lowered to 1536 bytes:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:17135:1: error: the frame size of 1880 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

The affected function is actually a collection of three separate implementations,
and each of them is fairly large by itself. Splitting them up is done easily
and improves readability at the same time.

I'm leaving the original indentation to make the review easier.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        | 178 ++++++++++++---------
 1 file changed, 104 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 48a4df488d75..d76c092bb6b4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -16061,52 +16061,8 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 	}
 }
 
-static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
+static void wlc_phy_workarounds_nphy_rev7(struct brcms_phy *pi)
 {
-	static const u8 rfseq_rx2tx_events[] = {
-		NPHY_RFSEQ_CMD_NOP,
-		NPHY_RFSEQ_CMD_RXG_FBW,
-		NPHY_RFSEQ_CMD_TR_SWITCH,
-		NPHY_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_RFSEQ_CMD_TX_GAIN,
-		NPHY_RFSEQ_CMD_EXT_PA
-	};
-	u8 rfseq_rx2tx_dlys[] = { 8, 6, 6, 2, 4, 60, 1 };
-	static const u8 rfseq_tx2rx_events[] = {
-		NPHY_RFSEQ_CMD_NOP,
-		NPHY_RFSEQ_CMD_EXT_PA,
-		NPHY_RFSEQ_CMD_TX_GAIN,
-		NPHY_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_RFSEQ_CMD_TR_SWITCH,
-		NPHY_RFSEQ_CMD_RXG_FBW,
-		NPHY_RFSEQ_CMD_CLR_HIQ_DIS
-	};
-	static const u8 rfseq_tx2rx_dlys[] = { 8, 6, 2, 4, 4, 6, 1 };
-	static const u8 rfseq_tx2rx_events_rev3[] = {
-		NPHY_REV3_RFSEQ_CMD_EXT_PA,
-		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
-		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
-		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
-		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
-		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_REV3_RFSEQ_CMD_END
-	};
-	static const u8 rfseq_tx2rx_dlys_rev3[] = { 8, 4, 2, 2, 4, 4, 6, 1 };
-	u8 rfseq_rx2tx_events_rev3[] = {
-		NPHY_REV3_RFSEQ_CMD_NOP,
-		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
-		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
-		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
-		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
-		NPHY_REV3_RFSEQ_CMD_EXT_PA,
-		NPHY_REV3_RFSEQ_CMD_END
-	};
-	u8 rfseq_rx2tx_dlys_rev3[] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
-
 	static const u8 rfseq_rx2tx_events_rev3_ipa[] = {
 		NPHY_REV3_RFSEQ_CMD_NOP,
 		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
@@ -16120,29 +16076,15 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 	};
 	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
 	static const u16 rfseq_rx2tx_dacbufpu_rev7[] = { 0x10f, 0x10f };
-
-	s16 alpha0, alpha1, alpha2;
-	s16 beta0, beta1, beta2;
-	u32 leg_data_weights, ht_data_weights, nss1_data_weights,
-	    stbc_data_weights;
+	u32 leg_data_weights;
 	u8 chan_freq_range = 0;
 	static const u16 dac_control = 0x0002;
 	u16 aux_adc_vmid_rev7_core0[] = { 0x8e, 0x96, 0x96, 0x96 };
 	u16 aux_adc_vmid_rev7_core1[] = { 0x8f, 0x9f, 0x9f, 0x96 };
-	u16 aux_adc_vmid_rev4[] = { 0xa2, 0xb4, 0xb4, 0x89 };
-	u16 aux_adc_vmid_rev3[] = { 0xa2, 0xb4, 0xb4, 0x89 };
-	u16 *aux_adc_vmid;
 	u16 aux_adc_gain_rev7[] = { 0x02, 0x02, 0x02, 0x02 };
-	u16 aux_adc_gain_rev4[] = { 0x02, 0x02, 0x02, 0x00 };
-	u16 aux_adc_gain_rev3[] = { 0x02, 0x02, 0x02, 0x00 };
-	u16 *aux_adc_gain;
-	static const u16 sk_adc_vmid[] = { 0xb4, 0xb4, 0xb4, 0x24 };
-	static const u16 sk_adc_gain[] = { 0x02, 0x02, 0x02, 0x02 };
 	s32 min_nvar_val = 0x18d;
 	s32 min_nvar_offset_6mbps = 20;
 	u8 pdetrange;
-	u8 triso;
-	u16 regval;
 	u16 afectrl_adc_ctrl1_rev7 = 0x20;
 	u16 afectrl_adc_ctrl2_rev7 = 0x0;
 	u16 rfseq_rx2tx_lpf_h_hpc_rev7 = 0x77;
@@ -16171,17 +16113,6 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 	u16 freq;
 	int coreNum;
 
-	if (CHSPEC_IS5G(pi->radio_chanspec))
-		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 0);
-	else
-		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 1);
-
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
-
-	or_phy_reg(pi, 0xb1, NPHY_IQFlip_ADC1 | NPHY_IQFlip_ADC2);
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)) {
 			mod_phy_reg(pi, 0x221, (0x1 << 4), (1 << 4));
@@ -16703,8 +16634,62 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 					 &aux_adc_gain_rev7);
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x1c, 16,
 					 &aux_adc_gain_rev7);
+}
 
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+static void wlc_phy_workarounds_nphy_rev3(struct brcms_phy *pi)
+{
+	static const u8 rfseq_tx2rx_events_rev3[] = {
+		NPHY_REV3_RFSEQ_CMD_EXT_PA,
+		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
+		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
+		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
+		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
+		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_REV3_RFSEQ_CMD_END
+	};
+	static const u8 rfseq_tx2rx_dlys_rev3[] = { 8, 4, 2, 2, 4, 4, 6, 1 };
+	u8 rfseq_rx2tx_events_rev3[] = {
+		NPHY_REV3_RFSEQ_CMD_NOP,
+		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
+		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
+		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
+		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
+		NPHY_REV3_RFSEQ_CMD_EXT_PA,
+		NPHY_REV3_RFSEQ_CMD_END
+	};
+	u8 rfseq_rx2tx_dlys_rev3[] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
+	static const u8 rfseq_rx2tx_events_rev3_ipa[] = {
+		NPHY_REV3_RFSEQ_CMD_NOP,
+		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
+		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
+		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
+		NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS,
+		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
+		NPHY_REV3_RFSEQ_CMD_END
+	};
+	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+	s16 alpha0, alpha1, alpha2;
+	s16 beta0, beta1, beta2;
+	u32 leg_data_weights, ht_data_weights, nss1_data_weights,
+	    stbc_data_weights;
+	u8 chan_freq_range = 0;
+	static const u16 dac_control = 0x0002;
+	u16 aux_adc_vmid_rev4[] = { 0xa2, 0xb4, 0xb4, 0x89 };
+	u16 aux_adc_vmid_rev3[] = { 0xa2, 0xb4, 0xb4, 0x89 };
+	u16 *aux_adc_vmid;
+	u16 aux_adc_gain_rev4[] = { 0x02, 0x02, 0x02, 0x00 };
+	u16 aux_adc_gain_rev3[] = { 0x02, 0x02, 0x02, 0x00 };
+	u16 *aux_adc_gain;
+	static const u16 sk_adc_vmid[] = { 0xb4, 0xb4, 0xb4, 0x24 };
+	static const u16 sk_adc_gain[] = { 0x02, 0x02, 0x02, 0x02 };
+	s32 min_nvar_val = 0x18d;
+	u8 pdetrange;
+	u8 triso;
 
 		write_phy_reg(pi, 0x23f, 0x1f8);
 		write_phy_reg(pi, 0x240, 0x1f8);
@@ -17030,7 +17015,33 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 					      MHF4_BPHY_TXCORE0,
 					      MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
 		}
-	} else {
+}
+
+void wlc_phy_workarounds_nphy_rev1(struct brcms_phy *pi)
+{
+	static const u8 rfseq_rx2tx_events[] = {
+		NPHY_RFSEQ_CMD_NOP,
+		NPHY_RFSEQ_CMD_RXG_FBW,
+		NPHY_RFSEQ_CMD_TR_SWITCH,
+		NPHY_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_RFSEQ_CMD_TX_GAIN,
+		NPHY_RFSEQ_CMD_EXT_PA
+	};
+	u8 rfseq_rx2tx_dlys[] = { 8, 6, 6, 2, 4, 60, 1 };
+	static const u8 rfseq_tx2rx_events[] = {
+		NPHY_RFSEQ_CMD_NOP,
+		NPHY_RFSEQ_CMD_EXT_PA,
+		NPHY_RFSEQ_CMD_TX_GAIN,
+		NPHY_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_RFSEQ_CMD_TR_SWITCH,
+		NPHY_RFSEQ_CMD_RXG_FBW,
+		NPHY_RFSEQ_CMD_CLR_HIQ_DIS
+	};
+	static const u8 rfseq_tx2rx_dlys[] = { 8, 6, 2, 4, 4, 6, 1 };
+	s16 alpha0, alpha1, alpha2;
+	s16 beta0, beta1, beta2;
+	u16 regval;
 
 		if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD ||
 		    (pi->sh->boardtype == 0x8b)) {
@@ -17128,7 +17139,26 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			mod_phy_reg(pi, 0x221,
 				    NPHY_FORCESIG_DECODEGATEDCLKS,
 				    NPHY_FORCESIG_DECODEGATEDCLKS);
-	}
+}
+
+static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
+{
+	if (CHSPEC_IS5G(pi->radio_chanspec))
+		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 0);
+	else
+		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 1);
+
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+
+	or_phy_reg(pi, 0xb1, NPHY_IQFlip_ADC1 | NPHY_IQFlip_ADC2);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		wlc_phy_workarounds_nphy_rev7(pi);
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
+		wlc_phy_workarounds_nphy_rev3(pi);
+	else
+		wlc_phy_workarounds_nphy_rev1(pi);
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-- 
2.9.0
