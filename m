Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49513 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752554AbdIVVay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:30:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <mmarek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, kasan-dev@googlegroups.com,
        linux-kbuild@vger.kernel.org, Jakub Jelinek <jakub@gcc.gnu.org>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <marxin@gcc.gnu.org>
Subject: [PATCH v4 3/9] brcmsmac: reindent split functions
Date: Fri, 22 Sep 2017 23:29:14 +0200
Message-Id: <20170922212930.620249-4-arnd@arndb.de>
In-Reply-To: <20170922212930.620249-1-arnd@arndb.de>
References: <20170922212930.620249-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the previous commit I left the indentation alone to help reviewing
the patch, this one now runs the three new functions through 'indent -kr -8'
with some manual fixups to avoid silliness.

No changes other than whitespace are intended here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        | 1507 +++++++++-----------
 1 file changed, 697 insertions(+), 810 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index ed409a80f3d2..763e8ba6b178 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -16074,7 +16074,8 @@ static void wlc_phy_workarounds_nphy_rev7(struct brcms_phy *pi)
 		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
 		NPHY_REV3_RFSEQ_CMD_END
 	};
-	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] =
+		{ 8, 6, 6, 4, 4, 16, 43, 1, 1 };
 	static const u16 rfseq_rx2tx_dacbufpu_rev7[] = { 0x10f, 0x10f };
 	u32 leg_data_weights;
 	u8 chan_freq_range = 0;
@@ -16114,526 +16115,452 @@ static void wlc_phy_workarounds_nphy_rev7(struct brcms_phy *pi)
 	int coreNum;
 
 
-		if (NREV_IS(pi->pubpi.phy_rev, 7)) {
-			mod_phy_reg(pi, 0x221, (0x1 << 4), (1 << 4));
-
-			mod_phy_reg(pi, 0x160, (0x7f << 0), (32 << 0));
-			mod_phy_reg(pi, 0x160, (0x7f << 8), (39 << 8));
-			mod_phy_reg(pi, 0x161, (0x7f << 0), (46 << 0));
-			mod_phy_reg(pi, 0x161, (0x7f << 8), (51 << 8));
-			mod_phy_reg(pi, 0x162, (0x7f << 0), (55 << 0));
-			mod_phy_reg(pi, 0x162, (0x7f << 8), (58 << 8));
-			mod_phy_reg(pi, 0x163, (0x7f << 0), (60 << 0));
-			mod_phy_reg(pi, 0x163, (0x7f << 8), (62 << 8));
-			mod_phy_reg(pi, 0x164, (0x7f << 0), (62 << 0));
-			mod_phy_reg(pi, 0x164, (0x7f << 8), (63 << 8));
-			mod_phy_reg(pi, 0x165, (0x7f << 0), (63 << 0));
-			mod_phy_reg(pi, 0x165, (0x7f << 8), (64 << 8));
-			mod_phy_reg(pi, 0x166, (0x7f << 0), (64 << 0));
-			mod_phy_reg(pi, 0x166, (0x7f << 8), (64 << 8));
-			mod_phy_reg(pi, 0x167, (0x7f << 0), (64 << 0));
-			mod_phy_reg(pi, 0x167, (0x7f << 8), (64 << 8));
-		}
-
-		if (NREV_LE(pi->pubpi.phy_rev, 8)) {
-			write_phy_reg(pi, 0x23f, 0x1b0);
-			write_phy_reg(pi, 0x240, 0x1b0);
-		}
+	if (NREV_IS(pi->pubpi.phy_rev, 7)) {
+		mod_phy_reg(pi, 0x221, (0x1 << 4), (1 << 4));
+
+		mod_phy_reg(pi, 0x160, (0x7f << 0), (32 << 0));
+		mod_phy_reg(pi, 0x160, (0x7f << 8), (39 << 8));
+		mod_phy_reg(pi, 0x161, (0x7f << 0), (46 << 0));
+		mod_phy_reg(pi, 0x161, (0x7f << 8), (51 << 8));
+		mod_phy_reg(pi, 0x162, (0x7f << 0), (55 << 0));
+		mod_phy_reg(pi, 0x162, (0x7f << 8), (58 << 8));
+		mod_phy_reg(pi, 0x163, (0x7f << 0), (60 << 0));
+		mod_phy_reg(pi, 0x163, (0x7f << 8), (62 << 8));
+		mod_phy_reg(pi, 0x164, (0x7f << 0), (62 << 0));
+		mod_phy_reg(pi, 0x164, (0x7f << 8), (63 << 8));
+		mod_phy_reg(pi, 0x165, (0x7f << 0), (63 << 0));
+		mod_phy_reg(pi, 0x165, (0x7f << 8), (64 << 8));
+		mod_phy_reg(pi, 0x166, (0x7f << 0), (64 << 0));
+		mod_phy_reg(pi, 0x166, (0x7f << 8), (64 << 8));
+		mod_phy_reg(pi, 0x167, (0x7f << 0), (64 << 0));
+		mod_phy_reg(pi, 0x167, (0x7f << 8), (64 << 8));
+	}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 8))
-			mod_phy_reg(pi, 0xbd, (0xff << 0), (114 << 0));
+	if (NREV_LE(pi->pubpi.phy_rev, 8)) {
+		write_phy_reg(pi, 0x23f, 0x1b0);
+		write_phy_reg(pi, 0x240, 0x1b0);
+	}
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
-					 &dac_control);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
-					 &dac_control);
+	if (NREV_GE(pi->pubpi.phy_rev, 8))
+		mod_phy_reg(pi, 0xbd, (0xff << 0), (114 << 0));
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					1, 0, 32, &leg_data_weights);
-		leg_data_weights = leg_data_weights & 0xffffff;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 0, 32, &leg_data_weights);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
+				 &dac_control);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
+				 &dac_control);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-					 2, 0x15e, 16,
-					 rfseq_rx2tx_dacbufpu_rev7);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x16e, 16,
-					 rfseq_rx2tx_dacbufpu_rev7);
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				1, 0, 32, &leg_data_weights);
+	leg_data_weights = leg_data_weights & 0xffffff;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				 1, 0, 32, &leg_data_weights);
 
-		if (PHY_IPA(pi))
-			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
-					       rfseq_rx2tx_events_rev3_ipa,
-					       rfseq_rx2tx_dlys_rev3_ipa,
-					       ARRAY_SIZE(rfseq_rx2tx_events_rev3_ipa));
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
+				 2, 0x15e, 16, rfseq_rx2tx_dacbufpu_rev7);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x16e, 16,
+				 rfseq_rx2tx_dacbufpu_rev7);
 
-		mod_phy_reg(pi, 0x299, (0x3 << 14), (0x1 << 14));
-		mod_phy_reg(pi, 0x29d, (0x3 << 14), (0x1 << 14));
+	if (PHY_IPA(pi))
+		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
+				       rfseq_rx2tx_events_rev3_ipa,
+				       rfseq_rx2tx_dlys_rev3_ipa,
+				       ARRAY_SIZE
+				       (rfseq_rx2tx_events_rev3_ipa));
 
-		tx_lpf_bw_ofdm_20mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x154);
-		tx_lpf_bw_ofdm_40mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x159);
-		tx_lpf_bw_11b = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x152);
+	mod_phy_reg(pi, 0x299, (0x3 << 14), (0x1 << 14));
+	mod_phy_reg(pi, 0x29d, (0x3 << 14), (0x1 << 14));
 
-		if (PHY_IPA(pi)) {
+	tx_lpf_bw_ofdm_20mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x154);
+	tx_lpf_bw_ofdm_40mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x159);
+	tx_lpf_bw_11b = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x152);
 
-			if (((pi->pubpi.radiorev == 5)
-			     && (CHSPEC_IS40(pi->radio_chanspec) == 1))
-			    || (pi->pubpi.radiorev == 7)
-			    || (pi->pubpi.radiorev == 8)) {
+	if (PHY_IPA(pi)) {
 
-				rccal_bcap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_BCAP_VAL);
-				rccal_scap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_SCAP_VAL);
+		if (((pi->pubpi.radiorev == 5)
+		     && (CHSPEC_IS40(pi->radio_chanspec) == 1))
+		    || (pi->pubpi.radiorev == 7)
+		    || (pi->pubpi.radiorev == 8)) {
 
-				rccal_tx20_11b_bcap = rccal_bcap_val;
-				rccal_tx20_11b_scap = rccal_scap_val;
+			rccal_bcap_val =
+			    read_radio_reg(pi, RADIO_2057_RCCAL_BCAP_VAL);
+			rccal_scap_val =
+			    read_radio_reg(pi, RADIO_2057_RCCAL_SCAP_VAL);
 
-				if ((pi->pubpi.radiorev == 5) &&
-				    (CHSPEC_IS40(pi->radio_chanspec) == 1)) {
+			rccal_tx20_11b_bcap = rccal_bcap_val;
+			rccal_tx20_11b_scap = rccal_scap_val;
 
-					rccal_tx20_11n_bcap = rccal_bcap_val;
-					rccal_tx20_11n_scap = rccal_scap_val;
-					rccal_tx40_11n_bcap = 0xc;
-					rccal_tx40_11n_scap = 0xc;
+			if ((pi->pubpi.radiorev == 5) &&
+			    (CHSPEC_IS40(pi->radio_chanspec) == 1)) {
 
-					rccal_ovrd = true;
+				rccal_tx20_11n_bcap = rccal_bcap_val;
+				rccal_tx20_11n_scap = rccal_scap_val;
+				rccal_tx40_11n_bcap = 0xc;
+				rccal_tx40_11n_scap = 0xc;
 
-				} else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8)) {
+				rccal_ovrd = true;
 
-					tx_lpf_bw_ofdm_20mhz = 4;
-					tx_lpf_bw_11b = 1;
+			} else if ((pi->pubpi.radiorev == 7)
+				   || (pi->pubpi.radiorev == 8)) {
 
-					if (CHSPEC_IS2G(pi->radio_chanspec)) {
-						rccal_tx20_11n_bcap = 0xc;
-						rccal_tx20_11n_scap = 0xc;
-						rccal_tx40_11n_bcap = 0xa;
-						rccal_tx40_11n_scap = 0xa;
-					} else {
-						rccal_tx20_11n_bcap = 0x14;
-						rccal_tx20_11n_scap = 0x14;
-						rccal_tx40_11n_bcap = 0xf;
-						rccal_tx40_11n_scap = 0xf;
-					}
+				tx_lpf_bw_ofdm_20mhz = 4;
+				tx_lpf_bw_11b = 1;
 
-					rccal_ovrd = true;
+				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+					rccal_tx20_11n_bcap = 0xc;
+					rccal_tx20_11n_scap = 0xc;
+					rccal_tx40_11n_bcap = 0xa;
+					rccal_tx40_11n_scap = 0xa;
+				} else {
+					rccal_tx20_11n_bcap = 0x14;
+					rccal_tx20_11n_scap = 0x14;
+					rccal_tx40_11n_bcap = 0xf;
+					rccal_tx40_11n_scap = 0xf;
 				}
+
+				rccal_ovrd = true;
 			}
+		}
 
-		} else {
+	} else {
 
-			if (pi->pubpi.radiorev == 5) {
+		if (pi->pubpi.radiorev == 5) {
 
-				tx_lpf_bw_ofdm_20mhz = 1;
-				tx_lpf_bw_ofdm_40mhz = 3;
+			tx_lpf_bw_ofdm_20mhz = 1;
+			tx_lpf_bw_ofdm_40mhz = 3;
 
-				rccal_bcap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_BCAP_VAL);
-				rccal_scap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_SCAP_VAL);
+			rccal_bcap_val =
+			    read_radio_reg(pi, RADIO_2057_RCCAL_BCAP_VAL);
+			rccal_scap_val =
+			    read_radio_reg(pi, RADIO_2057_RCCAL_SCAP_VAL);
 
-				rccal_tx20_11b_bcap = rccal_bcap_val;
-				rccal_tx20_11b_scap = rccal_scap_val;
+			rccal_tx20_11b_bcap = rccal_bcap_val;
+			rccal_tx20_11b_scap = rccal_scap_val;
 
-				rccal_tx20_11n_bcap = 0x13;
-				rccal_tx20_11n_scap = 0x11;
-				rccal_tx40_11n_bcap = 0x13;
-				rccal_tx40_11n_scap = 0x11;
+			rccal_tx20_11n_bcap = 0x13;
+			rccal_tx20_11n_scap = 0x11;
+			rccal_tx40_11n_bcap = 0x13;
+			rccal_tx40_11n_scap = 0x11;
 
-				rccal_ovrd = true;
-			}
+			rccal_ovrd = true;
 		}
+	}
 
-		if (rccal_ovrd) {
-
-			rx2tx_lpf_rc_lut_tx20_11b =
-				(rccal_tx20_11b_bcap << 8) |
-				(rccal_tx20_11b_scap << 3) |
-				tx_lpf_bw_11b;
-			rx2tx_lpf_rc_lut_tx20_11n =
-				(rccal_tx20_11n_bcap << 8) |
-				(rccal_tx20_11n_scap << 3) |
-				tx_lpf_bw_ofdm_20mhz;
-			rx2tx_lpf_rc_lut_tx40_11n =
-				(rccal_tx40_11n_bcap << 8) |
-				(rccal_tx40_11n_scap << 3) |
-				tx_lpf_bw_ofdm_40mhz;
+	if (rccal_ovrd) {
 
-			for (coreNum = 0; coreNum <= 1; coreNum++) {
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x152 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx20_11b);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x153 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx20_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x154 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx20_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x155 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x156 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x157 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x158 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x159 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-			}
+		rx2tx_lpf_rc_lut_tx20_11b =
+		    (rccal_tx20_11b_bcap << 8) |
+		    (rccal_tx20_11b_scap << 3) | tx_lpf_bw_11b;
+		rx2tx_lpf_rc_lut_tx20_11n =
+		    (rccal_tx20_11n_bcap << 8) |
+		    (rccal_tx20_11n_scap << 3) | tx_lpf_bw_ofdm_20mhz;
+		rx2tx_lpf_rc_lut_tx40_11n =
+		    (rccal_tx40_11n_bcap << 8) |
+		    (rccal_tx40_11n_scap << 3) | tx_lpf_bw_ofdm_40mhz;
 
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 4),
-				1, 0x3, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		for (coreNum = 0; coreNum <= 1; coreNum++) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x152 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx20_11b);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x153 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx20_11n);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x154 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx20_11n);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x155 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx40_11n);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x156 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx40_11n);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x157 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx40_11n);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x158 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx40_11n);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+						 0x159 + coreNum * 0x10, 16,
+						 &rx2tx_lpf_rc_lut_tx40_11n);
 		}
 
-		write_phy_reg(pi, 0x32f, 0x3);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), 1, 0x3, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+	}
 
-		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2),
-				1, 0x3, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	write_phy_reg(pi, 0x32f, 0x3);
 
-		if ((pi->pubpi.radiorev == 3) || (pi->pubpi.radiorev == 4) ||
-		    (pi->pubpi.radiorev == 6)) {
-			if ((pi->sh->sromrev >= 8)
-			    && (pi->sh->boardflags2 & BFL2_IPALVLSHIFT_3P3))
-				ipalvlshift_3p3_war_en = 1;
-
-			if (ipalvlshift_3p3_war_en) {
-				write_radio_reg(pi, RADIO_2057_GPAIO_CONFIG,
-						0x5);
-				write_radio_reg(pi, RADIO_2057_GPAIO_SEL1,
-						0x30);
-				write_radio_reg(pi, RADIO_2057_GPAIO_SEL0, 0x0);
-				or_radio_reg(pi,
-					     RADIO_2057_RXTXBIAS_CONFIG_CORE0,
-					     0x1);
-				or_radio_reg(pi,
-					     RADIO_2057_RXTXBIAS_CONFIG_CORE1,
-					     0x1);
-
-				ipa2g_mainbias = 0x1f;
-
-				ipa2g_casconv = 0x6f;
-
-				ipa2g_biasfilt = 0xaa;
-			} else {
+	if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 1, 0x3, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
-				ipa2g_mainbias = 0x2b;
+	if ((pi->pubpi.radiorev == 3) || (pi->pubpi.radiorev == 4) ||
+	    (pi->pubpi.radiorev == 6)) {
+		if ((pi->sh->sromrev >= 8)
+		    && (pi->sh->boardflags2 & BFL2_IPALVLSHIFT_3P3))
+			ipalvlshift_3p3_war_en = 1;
 
-				ipa2g_casconv = 0x7f;
+		if (ipalvlshift_3p3_war_en) {
+			write_radio_reg(pi, RADIO_2057_GPAIO_CONFIG, 0x5);
+			write_radio_reg(pi, RADIO_2057_GPAIO_SEL1, 0x30);
+			write_radio_reg(pi, RADIO_2057_GPAIO_SEL0, 0x0);
+			or_radio_reg(pi, RADIO_2057_RXTXBIAS_CONFIG_CORE0, 0x1);
+			or_radio_reg(pi, RADIO_2057_RXTXBIAS_CONFIG_CORE1, 0x1);
 
-				ipa2g_biasfilt = 0xee;
-			}
+			ipa2g_mainbias = 0x1f;
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				for (coreNum = 0; coreNum <= 1; coreNum++) {
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum, IPA2G_IMAIN,
-							 ipa2g_mainbias);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum, IPA2G_CASCONV,
-							 ipa2g_casconv);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum,
-							 IPA2G_BIAS_FILTER,
-							 ipa2g_biasfilt);
-				}
-			}
-		}
+			ipa2g_casconv = 0x6f;
 
-		if (PHY_IPA(pi)) {
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				if ((pi->pubpi.radiorev == 3)
-				    || (pi->pubpi.radiorev == 4)
-				    || (pi->pubpi.radiorev == 6))
-					txgm_idac_bleed = 0x7f;
+			ipa2g_biasfilt = 0xaa;
+		} else {
 
-				for (coreNum = 0; coreNum <= 1; coreNum++) {
-					if (txgm_idac_bleed != 0)
-						WRITE_RADIO_REG4(
-							pi, RADIO_2057,
-							CORE, coreNum,
-							TXGM_IDAC_BLEED,
-							txgm_idac_bleed);
-				}
+			ipa2g_mainbias = 0x2b;
 
-				if (pi->pubpi.radiorev == 5) {
-
-					for (coreNum = 0; coreNum <= 1;
-					     coreNum++) {
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 IPA2G_CASCONV,
-								 0x13);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 IPA2G_IMAIN,
-								 0x1f);
-						WRITE_RADIO_REG4(
-							pi, RADIO_2057,
-							CORE, coreNum,
-							IPA2G_BIAS_FILTER,
-							0xee);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 PAD2G_IDACS,
-								 0x8a);
-						WRITE_RADIO_REG4(
-							pi, RADIO_2057,
-							CORE, coreNum,
-							PAD_BIAS_FILTER_BWS,
-							0x3e);
-					}
+			ipa2g_casconv = 0x7f;
 
-				} else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8)) {
+			ipa2g_biasfilt = 0xee;
+		}
 
-					if (CHSPEC_IS40(pi->radio_chanspec) ==
-					    0) {
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 0,
-								 IPA2G_IMAIN,
-								 0x14);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 1,
-								 IPA2G_IMAIN,
-								 0x12);
-					} else {
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 0,
-								 IPA2G_IMAIN,
-								 0x16);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 1,
-								 IPA2G_IMAIN,
-								 0x16);
-					}
-				}
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			for (coreNum = 0; coreNum <= 1; coreNum++) {
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+						 coreNum, IPA2G_IMAIN,
+						 ipa2g_mainbias);
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+						 coreNum, IPA2G_CASCONV,
+						 ipa2g_casconv);
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+						 coreNum,
+						 IPA2G_BIAS_FILTER,
+						 ipa2g_biasfilt);
+			}
+		}
+	}
 
-			} else {
-				freq = CHAN5G_FREQ(CHSPEC_CHANNEL(
-							pi->radio_chanspec));
-				if (((freq >= 5180) && (freq <= 5230))
-				    || ((freq >= 5745) && (freq <= 5805))) {
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 0, IPA5G_BIAS_FILTER,
-							 0xff);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 1, IPA5G_BIAS_FILTER,
-							 0xff);
-				}
+	if (PHY_IPA(pi)) {
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if ((pi->pubpi.radiorev == 3)
+			    || (pi->pubpi.radiorev == 4)
+			    || (pi->pubpi.radiorev == 6))
+				txgm_idac_bleed = 0x7f;
+
+			for (coreNum = 0; coreNum <= 1; coreNum++) {
+				if (txgm_idac_bleed != 0)
+					WRITE_RADIO_REG4(pi, RADIO_2057,
+							 CORE, coreNum,
+							 TXGM_IDAC_BLEED,
+							 txgm_idac_bleed);
 			}
-		} else {
 
-			if (pi->pubpi.radiorev != 5) {
+			if (pi->pubpi.radiorev == 5) {
 				for (coreNum = 0; coreNum <= 1; coreNum++) {
+					WRITE_RADIO_REG4(pi, RADIO_2057,
+							 CORE, coreNum,
+							 IPA2G_CASCONV,
+							 0x13);
+					WRITE_RADIO_REG4(pi, RADIO_2057,
+							 CORE, coreNum,
+							 IPA2G_IMAIN,
+							 0x1f);
+					WRITE_RADIO_REG4(pi, RADIO_2057,
+							 CORE, coreNum,
+							 IPA2G_BIAS_FILTER,
+							 0xee);
+					WRITE_RADIO_REG4(pi, RADIO_2057,
+							 CORE, coreNum,
+							 PAD2G_IDACS,
+							 0x8a);
+					WRITE_RADIO_REG4(pi, RADIO_2057,
+							 CORE, coreNum,
+							 PAD_BIAS_FILTER_BWS,
+							 0x3e);
+				}
+			} else if ((pi->pubpi.radiorev == 7) ||
+				   (pi->pubpi.radiorev == 8)) {
+
+				if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 0, IPA2G_IMAIN, 0x14);
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 1, IPA2G_IMAIN, 0x12);
+				} else {
 					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum,
-							 TXMIX2G_TUNE_BOOST_PU,
-							 0x61);
+							 0, IPA2G_IMAIN, 0x16);
 					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum,
-							 TXGM_IDAC_BLEED, 0x70);
+							 1, IPA2G_IMAIN, 0x16);
 				}
 			}
-		}
 
-		if (pi->pubpi.radiorev == 4) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x05, 16,
-						 &afectrl_adc_ctrl1_rev7);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x15, 16,
-						 &afectrl_adc_ctrl1_rev7);
+		} else {
+			freq =
+			    CHAN5G_FREQ(CHSPEC_CHANNEL
+					(pi->radio_chanspec));
+			if (((freq >= 5180) && (freq <= 5230))
+			    || ((freq >= 5745) && (freq <= 5805))) {
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+						 0, IPA5G_BIAS_FILTER, 0xff);
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+						 1, IPA5G_BIAS_FILTER, 0xff);
+			}
+		}
+	} else {
 
+		if (pi->pubpi.radiorev != 5) {
 			for (coreNum = 0; coreNum <= 1; coreNum++) {
 				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 AFE_VCM_CAL_MASTER, 0x0);
-				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 AFE_SET_VCM_I, 0x3f);
+						 TXMIX2G_TUNE_BOOST_PU, 0x61);
 				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 AFE_SET_VCM_Q, 0x3f);
+						 TXGM_IDAC_BLEED, 0x70);
 			}
-		} else {
-			mod_phy_reg(pi, 0xa6, (0x1 << 2), (0x1 << 2));
-			mod_phy_reg(pi, 0x8f, (0x1 << 2), (0x1 << 2));
-			mod_phy_reg(pi, 0xa7, (0x1 << 2), (0x1 << 2));
-			mod_phy_reg(pi, 0xa5, (0x1 << 2), (0x1 << 2));
-
-			mod_phy_reg(pi, 0xa6, (0x1 << 0), 0);
-			mod_phy_reg(pi, 0x8f, (0x1 << 0), (0x1 << 0));
-			mod_phy_reg(pi, 0xa7, (0x1 << 0), 0);
-			mod_phy_reg(pi, 0xa5, (0x1 << 0), (0x1 << 0));
-
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x05, 16,
-						 &afectrl_adc_ctrl2_rev7);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x15, 16,
-						 &afectrl_adc_ctrl2_rev7);
-
-			mod_phy_reg(pi, 0xa6, (0x1 << 2), 0);
-			mod_phy_reg(pi, 0x8f, (0x1 << 2), 0);
-			mod_phy_reg(pi, 0xa7, (0x1 << 2), 0);
-			mod_phy_reg(pi, 0xa5, (0x1 << 2), 0);
 		}
+	}
 
-		write_phy_reg(pi, 0x6a, 0x2);
+	if (pi->pubpi.radiorev == 4) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x05, 16,
+					 &afectrl_adc_ctrl1_rev7);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x15, 16,
+					 &afectrl_adc_ctrl1_rev7);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 256, 32,
-					 &min_nvar_offset_6mbps);
+		for (coreNum = 0; coreNum <= 1; coreNum++) {
+			WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+					 AFE_VCM_CAL_MASTER, 0x0);
+			WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+					 AFE_SET_VCM_I, 0x3f);
+			WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+					 AFE_SET_VCM_Q, 0x3f);
+		}
+	} else {
+		mod_phy_reg(pi, 0xa6, (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, 0x8f, (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, 0xa7, (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, 0xa5, (0x1 << 2), (0x1 << 2));
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x138, 16,
-					 &rfseq_pktgn_lpf_hpc_rev7);
+		mod_phy_reg(pi, 0xa6, (0x1 << 0), 0);
+		mod_phy_reg(pi, 0x8f, (0x1 << 0), (0x1 << 0));
+		mod_phy_reg(pi, 0xa7, (0x1 << 0), 0);
+		mod_phy_reg(pi, 0xa5, (0x1 << 0), (0x1 << 0));
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x141, 16,
-					 &rfseq_pktgn_lpf_h_hpc_rev7);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x05, 16,
+					 &afectrl_adc_ctrl2_rev7);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x15, 16,
+					 &afectrl_adc_ctrl2_rev7);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 3, 0x133, 16,
-					 &rfseq_htpktgn_lpf_hpc_rev7);
+		mod_phy_reg(pi, 0xa6, (0x1 << 2), 0);
+		mod_phy_reg(pi, 0x8f, (0x1 << 2), 0);
+		mod_phy_reg(pi, 0xa7, (0x1 << 2), 0);
+		mod_phy_reg(pi, 0xa5, (0x1 << 2), 0);
+	}
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x146, 16,
-					 &rfseq_cckpktgn_lpf_hpc_rev7);
+	write_phy_reg(pi, 0x6a, 0x2);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x123, 16,
-					 &rfseq_tx2rx_lpf_h_hpc_rev7);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 256, 32,
+				 &min_nvar_offset_6mbps);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x12A, 16,
-					 &rfseq_rx2tx_lpf_h_hpc_rev7);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x138, 16,
+				 &rfseq_pktgn_lpf_hpc_rev7);
 
-		if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
-		} else {
-			min_nvar_val = noise_var_tbl_rev7[3];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x141, 16,
+				 &rfseq_pktgn_lpf_h_hpc_rev7);
 
-			min_nvar_val = noise_var_tbl_rev7[127];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
-		}
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 3, 0x133, 16,
+				 &rfseq_htpktgn_lpf_hpc_rev7);
 
-		wlc_phy_workarounds_nphy_gainctrl(pi);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x146, 16,
+				 &rfseq_cckpktgn_lpf_hpc_rev7);
 
-		pdetrange =
-			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-			pdetrange : pi->srom_fem2g.pdetrange;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x123, 16,
+				 &rfseq_tx2rx_lpf_h_hpc_rev7);
 
-		if (pdetrange == 0) {
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x70;
-				aux_adc_vmid_rev7_core1[3] = 0x70;
-				aux_adc_gain_rev7[3] = 2;
-			} else {
-				aux_adc_vmid_rev7_core0[3] = 0x80;
-				aux_adc_vmid_rev7_core1[3] = 0x80;
-				aux_adc_gain_rev7[3] = 3;
-			}
-		} else if (pdetrange == 1) {
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x7c;
-				aux_adc_vmid_rev7_core1[3] = 0x7c;
-				aux_adc_gain_rev7[3] = 2;
-			} else {
-				aux_adc_vmid_rev7_core0[3] = 0x8c;
-				aux_adc_vmid_rev7_core1[3] = 0x8c;
-				aux_adc_gain_rev7[3] = 1;
-			}
-		} else if (pdetrange == 2) {
-			if (pi->pubpi.radioid == BCM2057_ID) {
-				if ((pi->pubpi.radiorev == 5)
-				    || (pi->pubpi.radiorev == 7)
-				    || (pi->pubpi.radiorev == 8)) {
-					if (chan_freq_range ==
-					    WL_CHAN_FREQ_RANGE_2G) {
-						aux_adc_vmid_rev7_core0[3] =
-							0x8c;
-						aux_adc_vmid_rev7_core1[3] =
-							0x8c;
-						aux_adc_gain_rev7[3] = 0;
-					} else {
-						aux_adc_vmid_rev7_core0[3] =
-							0x96;
-						aux_adc_vmid_rev7_core1[3] =
-							0x96;
-						aux_adc_gain_rev7[3] = 0;
-					}
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x12A, 16,
+				 &rfseq_rx2tx_lpf_h_hpc_rev7);
+
+	if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+					 32, &min_nvar_val);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+					 127, 32, &min_nvar_val);
+	} else {
+		min_nvar_val = noise_var_tbl_rev7[3];
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+					 32, &min_nvar_val);
+
+		min_nvar_val = noise_var_tbl_rev7[127];
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+					 127, 32, &min_nvar_val);
+	}
+
+	wlc_phy_workarounds_nphy_gainctrl(pi);
+
+	pdetrange = (CHSPEC_IS5G(pi->radio_chanspec)) ?
+		    pi->srom_fem5g.pdetrange : pi->srom_fem2g.pdetrange;
+
+	if (pdetrange == 0) {
+		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
+		if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+			aux_adc_vmid_rev7_core0[3] = 0x70;
+			aux_adc_vmid_rev7_core1[3] = 0x70;
+			aux_adc_gain_rev7[3] = 2;
+		} else {
+			aux_adc_vmid_rev7_core0[3] = 0x80;
+			aux_adc_vmid_rev7_core1[3] = 0x80;
+			aux_adc_gain_rev7[3] = 3;
+		}
+	} else if (pdetrange == 1) {
+		if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+			aux_adc_vmid_rev7_core0[3] = 0x7c;
+			aux_adc_vmid_rev7_core1[3] = 0x7c;
+			aux_adc_gain_rev7[3] = 2;
+		} else {
+			aux_adc_vmid_rev7_core0[3] = 0x8c;
+			aux_adc_vmid_rev7_core1[3] = 0x8c;
+			aux_adc_gain_rev7[3] = 1;
+		}
+	} else if (pdetrange == 2) {
+		if (pi->pubpi.radioid == BCM2057_ID) {
+			if ((pi->pubpi.radiorev == 5)
+			    || (pi->pubpi.radiorev == 7)
+			    || (pi->pubpi.radiorev == 8)) {
+				if (chan_freq_range ==
+				    WL_CHAN_FREQ_RANGE_2G) {
+					aux_adc_vmid_rev7_core0[3] = 0x8c;
+					aux_adc_vmid_rev7_core1[3] = 0x8c;
+					aux_adc_gain_rev7[3] = 0;
+				} else {
+					aux_adc_vmid_rev7_core0[3] = 0x96;
+					aux_adc_vmid_rev7_core1[3] = 0x96;
+					aux_adc_gain_rev7[3] = 0;
 				}
 			}
+		}
 
-		} else if (pdetrange == 3) {
-			if (chan_freq_range == WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x89;
-				aux_adc_vmid_rev7_core1[3] = 0x89;
-				aux_adc_gain_rev7[3] = 0;
-			}
+	} else if (pdetrange == 3) {
+		if (chan_freq_range == WL_CHAN_FREQ_RANGE_2G) {
+			aux_adc_vmid_rev7_core0[3] = 0x89;
+			aux_adc_vmid_rev7_core1[3] = 0x89;
+			aux_adc_gain_rev7[3] = 0;
+		}
 
-		} else if (pdetrange == 5) {
+	} else if (pdetrange == 5) {
 
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x80;
-				aux_adc_vmid_rev7_core1[3] = 0x80;
-				aux_adc_gain_rev7[3] = 3;
-			} else {
-				aux_adc_vmid_rev7_core0[3] = 0x70;
-				aux_adc_vmid_rev7_core1[3] = 0x70;
-				aux_adc_gain_rev7[3] = 2;
-			}
+		if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+			aux_adc_vmid_rev7_core0[3] = 0x80;
+			aux_adc_vmid_rev7_core1[3] = 0x80;
+			aux_adc_gain_rev7[3] = 3;
+		} else {
+			aux_adc_vmid_rev7_core0[3] = 0x70;
+			aux_adc_vmid_rev7_core1[3] = 0x70;
+			aux_adc_gain_rev7[3] = 2;
 		}
+	}
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x08, 16,
-					 &aux_adc_vmid_rev7_core0);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x18, 16,
-					 &aux_adc_vmid_rev7_core1);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x0c, 16,
-					 &aux_adc_gain_rev7);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x1c, 16,
-					 &aux_adc_gain_rev7);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x08, 16,
+				 &aux_adc_vmid_rev7_core0);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x18, 16,
+				 &aux_adc_vmid_rev7_core1);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x0c, 16,
+				 &aux_adc_gain_rev7);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x1c, 16,
+				 &aux_adc_gain_rev7);
 }
 
 static void wlc_phy_workarounds_nphy_rev3(struct brcms_phy *pi)
@@ -16672,7 +16599,8 @@ static void wlc_phy_workarounds_nphy_rev3(struct brcms_phy *pi)
 		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
 		NPHY_REV3_RFSEQ_CMD_END
 	};
-	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] =
+	    { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
 	s16 alpha0, alpha1, alpha2;
 	s16 beta0, beta1, beta2;
 	u32 leg_data_weights, ht_data_weights, nss1_data_weights,
@@ -16691,330 +16619,290 @@ static void wlc_phy_workarounds_nphy_rev3(struct brcms_phy *pi)
 	u8 pdetrange;
 	u8 triso;
 
-		write_phy_reg(pi, 0x23f, 0x1f8);
-		write_phy_reg(pi, 0x240, 0x1f8);
-
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					1, 0, 32, &leg_data_weights);
-		leg_data_weights = leg_data_weights & 0xffffff;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 0, 32, &leg_data_weights);
-
-		alpha0 = 293;
-		alpha1 = 435;
-		alpha2 = 261;
-		beta0 = 366;
-		beta1 = 205;
-		beta2 = 32;
-		write_phy_reg(pi, 0x145, alpha0);
-		write_phy_reg(pi, 0x146, alpha1);
-		write_phy_reg(pi, 0x147, alpha2);
-		write_phy_reg(pi, 0x148, beta0);
-		write_phy_reg(pi, 0x149, beta1);
-		write_phy_reg(pi, 0x14a, beta2);
-
-		write_phy_reg(pi, 0x38, 0xC);
-		write_phy_reg(pi, 0x2ae, 0xC);
-
-		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX,
-				       rfseq_tx2rx_events_rev3,
-				       rfseq_tx2rx_dlys_rev3,
-				       ARRAY_SIZE(rfseq_tx2rx_events_rev3));
-
-		if (PHY_IPA(pi))
-			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
-					       rfseq_rx2tx_events_rev3_ipa,
-					       rfseq_rx2tx_dlys_rev3_ipa,
-					       ARRAY_SIZE(rfseq_rx2tx_events_rev3_ipa));
-
-		if ((pi->sh->hw_phyrxchain != 0x3) &&
-		    (pi->sh->hw_phyrxchain != pi->sh->hw_phytxchain)) {
-
-			if (PHY_IPA(pi)) {
-				rfseq_rx2tx_dlys_rev3[5] = 59;
-				rfseq_rx2tx_dlys_rev3[6] = 1;
-				rfseq_rx2tx_events_rev3[7] =
-					NPHY_REV3_RFSEQ_CMD_END;
-			}
-
-			wlc_phy_set_rfseq_nphy(
-				pi, NPHY_RFSEQ_RX2TX,
-				rfseq_rx2tx_events_rev3,
-				rfseq_rx2tx_dlys_rev3,
-				ARRAY_SIZE(rfseq_rx2tx_events_rev3));
-		}
+	write_phy_reg(pi, 0x23f, 0x1f8);
+	write_phy_reg(pi, 0x240, 0x1f8);
+
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				1, 0, 32, &leg_data_weights);
+	leg_data_weights = leg_data_weights & 0xffffff;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				 1, 0, 32, &leg_data_weights);
+
+	alpha0 = 293;
+	alpha1 = 435;
+	alpha2 = 261;
+	beta0 = 366;
+	beta1 = 205;
+	beta2 = 32;
+	write_phy_reg(pi, 0x145, alpha0);
+	write_phy_reg(pi, 0x146, alpha1);
+	write_phy_reg(pi, 0x147, alpha2);
+	write_phy_reg(pi, 0x148, beta0);
+	write_phy_reg(pi, 0x149, beta1);
+	write_phy_reg(pi, 0x14a, beta2);
+
+	write_phy_reg(pi, 0x38, 0xC);
+	write_phy_reg(pi, 0x2ae, 0xC);
+
+	wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX,
+			       rfseq_tx2rx_events_rev3,
+			       rfseq_tx2rx_dlys_rev3,
+			       ARRAY_SIZE(rfseq_tx2rx_events_rev3));
 
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			write_phy_reg(pi, 0x6a, 0x2);
-		else
-			write_phy_reg(pi, 0x6a, 0x9c40);
-
-		mod_phy_reg(pi, 0x294, (0xf << 8), (7 << 8));
+	if (PHY_IPA(pi))
+		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
+				       rfseq_rx2tx_events_rev3_ipa,
+				       rfseq_rx2tx_dlys_rev3_ipa,
+				       ARRAY_SIZE (rfseq_rx2tx_events_rev3_ipa));
 
-		if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
-		} else {
-			min_nvar_val = noise_var_tbl_rev3[3];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
+	if ((pi->sh->hw_phyrxchain != 0x3) &&
+	    (pi->sh->hw_phyrxchain != pi->sh->hw_phytxchain)) {
 
-			min_nvar_val = noise_var_tbl_rev3[127];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
+		if (PHY_IPA(pi)) {
+			rfseq_rx2tx_dlys_rev3[5] = 59;
+			rfseq_rx2tx_dlys_rev3[6] = 1;
+			rfseq_rx2tx_events_rev3[7] = NPHY_REV3_RFSEQ_CMD_END;
 		}
 
-		wlc_phy_workarounds_nphy_gainctrl(pi);
+		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
+				       rfseq_rx2tx_events_rev3,
+				       rfseq_rx2tx_dlys_rev3,
+				       ARRAY_SIZE (rfseq_rx2tx_events_rev3));
+	}
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
-					 &dac_control);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
-					 &dac_control);
+	if (CHSPEC_IS2G(pi->radio_chanspec))
+		write_phy_reg(pi, 0x6a, 0x2);
+	else
+		write_phy_reg(pi, 0x6a, 0x9c40);
 
-		pdetrange =
-			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-			pdetrange : pi->srom_fem2g.pdetrange;
+	mod_phy_reg(pi, 0x294, (0xf << 8), (7 << 8));
 
-		if (pdetrange == 0) {
-			if (NREV_GE(pi->pubpi.phy_rev, 4)) {
-				aux_adc_vmid = aux_adc_vmid_rev4;
-				aux_adc_gain = aux_adc_gain_rev4;
-			} else {
-				aux_adc_vmid = aux_adc_vmid_rev3;
-				aux_adc_gain = aux_adc_gain_rev3;
-			}
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				switch (chan_freq_range) {
-				case WL_CHAN_FREQ_RANGE_5GL:
-					aux_adc_vmid[3] = 0x89;
-					aux_adc_gain[3] = 0;
-					break;
-				case WL_CHAN_FREQ_RANGE_5GM:
-					aux_adc_vmid[3] = 0x89;
-					aux_adc_gain[3] = 0;
-					break;
-				case WL_CHAN_FREQ_RANGE_5GH:
-					aux_adc_vmid[3] = 0x89;
-					aux_adc_gain[3] = 0;
-					break;
-				default:
-					break;
-				}
-			}
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, aux_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, aux_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, aux_adc_gain);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, aux_adc_gain);
-		} else if (pdetrange == 1) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, sk_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, sk_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, sk_adc_gain);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, sk_adc_gain);
-		} else if (pdetrange == 2) {
+	if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+					 32, &min_nvar_val);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+					 127, 32, &min_nvar_val);
+	} else {
+		min_nvar_val = noise_var_tbl_rev3[3];
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+					 32, &min_nvar_val);
 
-			u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x74 };
-			u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x04 };
+		min_nvar_val = noise_var_tbl_rev3[127];
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+					 127, 32, &min_nvar_val);
+	}
 
-			if (NREV_GE(pi->pubpi.phy_rev, 6)) {
-				chan_freq_range =
-					wlc_phy_get_chan_freq_range_nphy(pi, 0);
-				if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-					bcm_adc_vmid[3] = 0x8e;
-					bcm_adc_gain[3] = 0x03;
-				} else {
-					bcm_adc_vmid[3] = 0x94;
-					bcm_adc_gain[3] = 0x03;
-				}
-			} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
-				bcm_adc_vmid[3] = 0x84;
-				bcm_adc_gain[3] = 0x02;
-			}
+	wlc_phy_workarounds_nphy_gainctrl(pi);
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, bcm_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, bcm_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, bcm_adc_gain);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, bcm_adc_gain);
-		} else if (pdetrange == 3) {
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if ((NREV_GE(pi->pubpi.phy_rev, 4))
-			    && (chan_freq_range == WL_CHAN_FREQ_RANGE_2G)) {
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
+				 &dac_control);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
+				 &dac_control);
 
-				u16 auxadc_vmid[] = {
-					0xa2, 0xb4, 0xb4, 0x270
-				};
-				u16 auxadc_gain[] = {
-					0x02, 0x02, 0x02, 0x00
-				};
+	pdetrange = (CHSPEC_IS5G(pi->radio_chanspec)) ?
+			pi->srom_fem5g.pdetrange : pi->srom_fem2g.pdetrange;
 
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x08, 16, auxadc_vmid);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x18, 16, auxadc_vmid);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x0c, 16, auxadc_gain);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x1c, 16, auxadc_gain);
+	if (pdetrange == 0) {
+		if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+			aux_adc_vmid = aux_adc_vmid_rev4;
+			aux_adc_gain = aux_adc_gain_rev4;
+		} else {
+			aux_adc_vmid = aux_adc_vmid_rev3;
+			aux_adc_gain = aux_adc_gain_rev3;
+		}
+		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
+		if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+			switch (chan_freq_range) {
+			case WL_CHAN_FREQ_RANGE_5GL:
+				aux_adc_vmid[3] = 0x89;
+				aux_adc_gain[3] = 0;
+				break;
+			case WL_CHAN_FREQ_RANGE_5GM:
+				aux_adc_vmid[3] = 0x89;
+				aux_adc_gain[3] = 0;
+				break;
+			case WL_CHAN_FREQ_RANGE_5GH:
+				aux_adc_vmid[3] = 0x89;
+				aux_adc_gain[3] = 0;
+				break;
+			default:
+				break;
 			}
-		} else if ((pdetrange == 4) || (pdetrange == 5)) {
-			u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x0 };
-			u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x0 };
-			u16 Vmid[2], Av[2];
+		}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x08, 16, aux_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x18, 16, aux_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x0c, 16, aux_adc_gain);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x1c, 16, aux_adc_gain);
+	} else if (pdetrange == 1) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x08, 16, sk_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x18, 16, sk_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x0c, 16, sk_adc_gain);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x1c, 16, sk_adc_gain);
+	} else if (pdetrange == 2) {
+
+		u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x74 };
+		u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x04 };
 
+		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
 			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
+			    wlc_phy_get_chan_freq_range_nphy(pi, 0);
 			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				Vmid[0] = (pdetrange == 4) ? 0x8e : 0x89;
-				Vmid[1] = (pdetrange == 4) ? 0x96 : 0x89;
-				Av[0] = (pdetrange == 4) ? 2 : 0;
-				Av[1] = (pdetrange == 4) ? 2 : 0;
+				bcm_adc_vmid[3] = 0x8e;
+				bcm_adc_gain[3] = 0x03;
 			} else {
-				Vmid[0] = (pdetrange == 4) ? 0x89 : 0x74;
-				Vmid[1] = (pdetrange == 4) ? 0x8b : 0x70;
-				Av[0] = (pdetrange == 4) ? 2 : 0;
-				Av[1] = (pdetrange == 4) ? 2 : 0;
+				bcm_adc_vmid[3] = 0x94;
+				bcm_adc_gain[3] = 0x03;
 			}
+		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
+			bcm_adc_vmid[3] = 0x84;
+			bcm_adc_gain[3] = 0x02;
+		}
+
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x08, 16, bcm_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x18, 16, bcm_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x0c, 16, bcm_adc_gain);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x1c, 16, bcm_adc_gain);
+	} else if (pdetrange == 3) {
+		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
+		if ((NREV_GE(pi->pubpi.phy_rev, 4)) &&
+		    (chan_freq_range == WL_CHAN_FREQ_RANGE_2G)) {
+			u16 auxadc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x270 };
+			u16 auxadc_gain[] = { 0x02, 0x02, 0x02, 0x00 };
 
-			bcm_adc_vmid[3] = Vmid[0];
-			bcm_adc_gain[3] = Av[0];
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, bcm_adc_vmid);
+						 0x08, 16, auxadc_vmid);
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, bcm_adc_gain);
-
-			bcm_adc_vmid[3] = Vmid[1];
-			bcm_adc_gain[3] = Av[1];
+						 0x18, 16, auxadc_vmid);
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, bcm_adc_vmid);
+						 0x0c, 16, auxadc_gain);
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, bcm_adc_gain);
+						 0x1c, 16, auxadc_gain);
 		}
+	} else if ((pdetrange == 4) || (pdetrange == 5)) {
+		u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x0 };
+		u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x0 };
+		u16 Vmid[2], Av[2];
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX0),
-				0x0);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX1),
-				0x0);
+		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
+		if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+			Vmid[0] = (pdetrange == 4) ? 0x8e : 0x89;
+			Vmid[1] = (pdetrange == 4) ? 0x96 : 0x89;
+			Av[0] = (pdetrange == 4) ? 2 : 0;
+			Av[1] = (pdetrange == 4) ? 2 : 0;
+		} else {
+			Vmid[0] = (pdetrange == 4) ? 0x89 : 0x74;
+			Vmid[1] = (pdetrange == 4) ? 0x8b : 0x70;
+			Av[0] = (pdetrange == 4) ? 2 : 0;
+			Av[1] = (pdetrange == 4) ? 2 : 0;
+		}
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX0),
-				0x6);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX1),
-				0x6);
+		bcm_adc_vmid[3] = Vmid[0];
+		bcm_adc_gain[3] = Av[0];
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x08, 16, bcm_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x0c, 16, bcm_adc_gain);
+
+		bcm_adc_vmid[3] = Vmid[1];
+		bcm_adc_gain[3] = Av[1];
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x18, 16, bcm_adc_vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+					 0x1c, 16, bcm_adc_gain);
+	}
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX0),
-				0x7);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX1),
-				0x7);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX0), 0x0);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX1), 0x0);
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX0),
-				0x88);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX1),
-				0x88);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX0), 0x6);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX1), 0x6);
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX0),
-				0x0);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX1),
-				0x0);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX0), 0x7);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX1), 0x7);
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX0),
-				0x0);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX1),
-				0x0);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX0), 0x88);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX1), 0x88);
 
-		triso =
-			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-			triso : pi->srom_fem2g.triso;
-		if (triso == 7) {
-			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
-			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
-		}
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX0), 0x0);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX1), 0x0);
 
-		wlc_phy_war_txchain_upd_nphy(pi, pi->sh->hw_phytxchain);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX0), 0x0);
+	write_radio_reg(pi, (RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX1), 0x0);
 
-		if (((pi->sh->boardflags2 & BFL2_APLL_WAR) &&
-		     (CHSPEC_IS5G(pi->radio_chanspec))) ||
-		    (((pi->sh->boardflags2 & BFL2_GPLL_WAR) ||
-		      (pi->sh->boardflags2 & BFL2_GPLL_WAR2)) &&
-		     (CHSPEC_IS2G(pi->radio_chanspec)))) {
-			nss1_data_weights = 0x00088888;
-			ht_data_weights = 0x00088888;
-			stbc_data_weights = 0x00088888;
-		} else {
-			nss1_data_weights = 0x88888888;
-			ht_data_weights = 0x88888888;
-			stbc_data_weights = 0x88888888;
-		}
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 1, 32, &nss1_data_weights);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 2, 32, &ht_data_weights);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 3, 32, &stbc_data_weights);
-
-		if (NREV_IS(pi->pubpi.phy_rev, 4)) {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(pi,
-						RADIO_2056_TX_GMBB_IDAC |
-						RADIO_2056_TX0, 0x70);
-				write_radio_reg(pi,
-						RADIO_2056_TX_GMBB_IDAC |
-						RADIO_2056_TX1, 0x70);
-			}
-		}
+	triso = (CHSPEC_IS5G(pi->radio_chanspec)) ?
+		 pi->srom_fem5g.triso : pi->srom_fem2g.triso;
+	if (triso == 7) {
+		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
+		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
+	}
 
-		if (!pi->edcrs_threshold_lock) {
-			write_phy_reg(pi, 0x224, 0x3eb);
-			write_phy_reg(pi, 0x225, 0x3eb);
-			write_phy_reg(pi, 0x226, 0x341);
-			write_phy_reg(pi, 0x227, 0x341);
-			write_phy_reg(pi, 0x228, 0x42b);
-			write_phy_reg(pi, 0x229, 0x42b);
-			write_phy_reg(pi, 0x22a, 0x381);
-			write_phy_reg(pi, 0x22b, 0x381);
-			write_phy_reg(pi, 0x22c, 0x42b);
-			write_phy_reg(pi, 0x22d, 0x42b);
-			write_phy_reg(pi, 0x22e, 0x381);
-			write_phy_reg(pi, 0x22f, 0x381);
+	wlc_phy_war_txchain_upd_nphy(pi, pi->sh->hw_phytxchain);
+
+	if (((pi->sh->boardflags2 & BFL2_APLL_WAR) &&
+	     (CHSPEC_IS5G(pi->radio_chanspec))) ||
+	    (((pi->sh->boardflags2 & BFL2_GPLL_WAR) ||
+	      (pi->sh->boardflags2 & BFL2_GPLL_WAR2)) &&
+	     (CHSPEC_IS2G(pi->radio_chanspec)))) {
+		nss1_data_weights = 0x00088888;
+		ht_data_weights = 0x00088888;
+		stbc_data_weights = 0x00088888;
+	} else {
+		nss1_data_weights = 0x88888888;
+		ht_data_weights = 0x88888888;
+		stbc_data_weights = 0x88888888;
+	}
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				 1, 1, 32, &nss1_data_weights);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				 1, 2, 32, &ht_data_weights);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+				 1, 3, 32, &stbc_data_weights);
+
+	if (NREV_IS(pi->pubpi.phy_rev, 4)) {
+		if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			write_radio_reg(pi,
+					RADIO_2056_TX_GMBB_IDAC |
+					RADIO_2056_TX0, 0x70);
+			write_radio_reg(pi,
+					RADIO_2056_TX_GMBB_IDAC |
+					RADIO_2056_TX1, 0x70);
 		}
+	}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+	if (!pi->edcrs_threshold_lock) {
+		write_phy_reg(pi, 0x224, 0x3eb);
+		write_phy_reg(pi, 0x225, 0x3eb);
+		write_phy_reg(pi, 0x226, 0x341);
+		write_phy_reg(pi, 0x227, 0x341);
+		write_phy_reg(pi, 0x228, 0x42b);
+		write_phy_reg(pi, 0x229, 0x42b);
+		write_phy_reg(pi, 0x22a, 0x381);
+		write_phy_reg(pi, 0x22b, 0x381);
+		write_phy_reg(pi, 0x22c, 0x42b);
+		write_phy_reg(pi, 0x22d, 0x42b);
+		write_phy_reg(pi, 0x22e, 0x381);
+		write_phy_reg(pi, 0x22f, 0x381);
+	}
 
-			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK)
-				wlapi_bmac_mhf(pi->sh->physhim, MHF4,
-					      MHF4_BPHY_TXCORE0,
-					      MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
-		}
+	if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+
+		if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK)
+			wlapi_bmac_mhf(pi->sh->physhim, MHF4,
+				       MHF4_BPHY_TXCORE0,
+				       MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
+	}
 }
 
 void wlc_phy_workarounds_nphy_rev1(struct brcms_phy *pi)
@@ -17043,102 +16931,101 @@ void wlc_phy_workarounds_nphy_rev1(struct brcms_phy *pi)
 	s16 beta0, beta1, beta2;
 	u16 regval;
 
-		if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD ||
-		    (pi->sh->boardtype == 0x8b)) {
-			uint i;
-			u8 war_dlys[] = { 1, 6, 6, 2, 4, 20, 1 };
-			for (i = 0; i < ARRAY_SIZE(rfseq_rx2tx_dlys); i++)
-				rfseq_rx2tx_dlys[i] = war_dlys[i];
-		}
+	if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD ||
+	    (pi->sh->boardtype == 0x8b)) {
+		uint i;
+		u8 war_dlys[] = { 1, 6, 6, 2, 4, 20, 1 };
+		for (i = 0; i < ARRAY_SIZE(rfseq_rx2tx_dlys); i++)
+			rfseq_rx2tx_dlys[i] = war_dlys[i];
+	}
 
-		if (CHSPEC_IS5G(pi->radio_chanspec) && pi->phy_5g_pwrgain) {
-			and_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0xf7);
-			and_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0xf7);
-		} else {
-			or_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0x8);
-			or_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0x8);
-		}
+	if (CHSPEC_IS5G(pi->radio_chanspec) && pi->phy_5g_pwrgain) {
+		and_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0xf7);
+		and_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0xf7);
+	} else {
+		or_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0x8);
+		or_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0x8);
+	}
 
-		regval = 0x000a;
-		wlc_phy_table_write_nphy(pi, 8, 1, 0, 16, &regval);
-		wlc_phy_table_write_nphy(pi, 8, 1, 0x10, 16, &regval);
+	regval = 0x000a;
+	wlc_phy_table_write_nphy(pi, 8, 1, 0, 16, &regval);
+	wlc_phy_table_write_nphy(pi, 8, 1, 0x10, 16, &regval);
 
-		if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-			regval = 0xcdaa;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x02, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x12, 16, &regval);
-		}
+	if (NREV_LT(pi->pubpi.phy_rev, 3)) {
+		regval = 0xcdaa;
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x02, 16, &regval);
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x12, 16, &regval);
+	}
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-			regval = 0x0000;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x08, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x18, 16, &regval);
+	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+		regval = 0x0000;
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x08, 16, &regval);
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x18, 16, &regval);
 
-			regval = 0x7aab;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x07, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x17, 16, &regval);
+		regval = 0x7aab;
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x07, 16, &regval);
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x17, 16, &regval);
 
-			regval = 0x0800;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x06, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x16, 16, &regval);
-		}
+		regval = 0x0800;
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x06, 16, &regval);
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x16, 16, &regval);
+	}
 
-		write_phy_reg(pi, 0xf8, 0x02d8);
-		write_phy_reg(pi, 0xf9, 0x0301);
-		write_phy_reg(pi, 0xfa, 0x02d8);
-		write_phy_reg(pi, 0xfb, 0x0301);
+	write_phy_reg(pi, 0xf8, 0x02d8);
+	write_phy_reg(pi, 0xf9, 0x0301);
+	write_phy_reg(pi, 0xfa, 0x02d8);
+	write_phy_reg(pi, 0xfb, 0x0301);
 
-		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX, rfseq_rx2tx_events,
-				       rfseq_rx2tx_dlys,
-				       ARRAY_SIZE(rfseq_rx2tx_events));
+	wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX, rfseq_rx2tx_events,
+			       rfseq_rx2tx_dlys,
+			       ARRAY_SIZE(rfseq_rx2tx_events));
 
-		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX, rfseq_tx2rx_events,
-				       rfseq_tx2rx_dlys,
-				       ARRAY_SIZE(rfseq_tx2rx_events));
+	wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX, rfseq_tx2rx_events,
+			       rfseq_tx2rx_dlys,
+			       ARRAY_SIZE(rfseq_tx2rx_events));
 
-		wlc_phy_workarounds_nphy_gainctrl(pi);
+	wlc_phy_workarounds_nphy_gainctrl(pi);
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
 
-			if (read_phy_reg(pi, 0xa0) & NPHY_MLenable)
-				wlapi_bmac_mhf(pi->sh->physhim, MHF3,
-					       MHF3_NPHY_MLADV_WAR,
-					       MHF3_NPHY_MLADV_WAR,
-					       BRCM_BAND_ALL);
+		if (read_phy_reg(pi, 0xa0) & NPHY_MLenable)
+			wlapi_bmac_mhf(pi->sh->physhim, MHF3,
+				       MHF3_NPHY_MLADV_WAR,
+				       MHF3_NPHY_MLADV_WAR, BRCM_BAND_ALL);
 
-		} else if (NREV_IS(pi->pubpi.phy_rev, 2)) {
-			write_phy_reg(pi, 0x1e3, 0x0);
-			write_phy_reg(pi, 0x1e4, 0x0);
-		}
+	} else if (NREV_IS(pi->pubpi.phy_rev, 2)) {
+		write_phy_reg(pi, 0x1e3, 0x0);
+		write_phy_reg(pi, 0x1e4, 0x0);
+	}
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2))
-			mod_phy_reg(pi, 0x90, (0x1 << 7), 0);
-
-		alpha0 = 293;
-		alpha1 = 435;
-		alpha2 = 261;
-		beta0 = 366;
-		beta1 = 205;
-		beta2 = 32;
-		write_phy_reg(pi, 0x145, alpha0);
-		write_phy_reg(pi, 0x146, alpha1);
-		write_phy_reg(pi, 0x147, alpha2);
-		write_phy_reg(pi, 0x148, beta0);
-		write_phy_reg(pi, 0x149, beta1);
-		write_phy_reg(pi, 0x14a, beta2);
-
-		if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-			mod_phy_reg(pi, 0x142, (0xf << 12), 0);
-
-			write_phy_reg(pi, 0x192, 0xb5);
-			write_phy_reg(pi, 0x193, 0xa4);
-			write_phy_reg(pi, 0x194, 0x0);
-		}
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
+		mod_phy_reg(pi, 0x90, (0x1 << 7), 0);
+
+	alpha0 = 293;
+	alpha1 = 435;
+	alpha2 = 261;
+	beta0 = 366;
+	beta1 = 205;
+	beta2 = 32;
+	write_phy_reg(pi, 0x145, alpha0);
+	write_phy_reg(pi, 0x146, alpha1);
+	write_phy_reg(pi, 0x147, alpha2);
+	write_phy_reg(pi, 0x148, beta0);
+	write_phy_reg(pi, 0x149, beta1);
+	write_phy_reg(pi, 0x14a, beta2);
+
+	if (NREV_LT(pi->pubpi.phy_rev, 3)) {
+		mod_phy_reg(pi, 0x142, (0xf << 12), 0);
+
+		write_phy_reg(pi, 0x192, 0xb5);
+		write_phy_reg(pi, 0x193, 0xa4);
+		write_phy_reg(pi, 0x194, 0x0);
+	}
 
-		if (NREV_IS(pi->pubpi.phy_rev, 2))
-			mod_phy_reg(pi, 0x221,
-				    NPHY_FORCESIG_DECODEGATEDCLKS,
-				    NPHY_FORCESIG_DECODEGATEDCLKS);
+	if (NREV_IS(pi->pubpi.phy_rev, 2))
+		mod_phy_reg(pi, 0x221,
+			    NPHY_FORCESIG_DECODEGATEDCLKS,
+			    NPHY_FORCESIG_DECODEGATEDCLKS);
 }
 
 static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
-- 
2.9.0
