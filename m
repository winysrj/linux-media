Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37203 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbeFWPga (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:30 -0400
Received: by mail-wm0-f68.google.com with SMTP id r125-v6so5601489wmg.2
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:29 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 12/19] [media] ddbridge/mci: extend mci_command and mci_result structs
Date: Sat, 23 Jun 2018 17:36:08 +0200
Message-Id: <20180623153615.27630-13-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Recent FPGA firmware reports more data and values in sent command
responses. Adjust the mci_command and mci_result structs including it's
unions to match these changes and add a few comments explaining things.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.h | 74 +++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 2e74f0544717..5e0c9e88b6fc 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -90,16 +90,30 @@ struct mci_command {
 	union {
 		u32 command_word;
 		struct {
-			u8 command;
-			u8 tuner;
-			u8 demod;
-			u8 output;
+			u8  command;
+			u8  tuner;
+			u8  demod;
+			u8  output;
 		};
 	};
 	union {
 		u32 params[31];
 		struct {
+			/*
+			 * Bit 0: DVB-S Enabled
+			 * Bit 1: DVB-S2 Enabled
+			 * Bit 7: InputStreamID
+			 */
 			u8  flags;
+			/*
+			 * Bit 0: QPSK,
+			 * Bit 1: 8PSK/8APSK
+			 * Bit 2: 16APSK
+			 * Bit 3: 32APSK
+			 * Bit 4: 64APSK
+			 * Bit 5: 128APSK
+			 * Bit 6: 256APSK
+			 */
 			u8  s2_modulation_mask;
 			u8  rsvd1;
 			u8  retry;
@@ -108,7 +122,36 @@ struct mci_command {
 			u8  input_stream_id;
 			u8  rsvd2[3];
 			u32 scrambling_sequence_index;
+			u32 frequency_range;
 		} dvbs2_search;
+
+		struct {
+			u8  tap;
+			u8  rsvd;
+			u16 point;
+		} get_iq_symbol;
+
+		struct {
+			/*
+			 * Bit 0: 0=VTM/1=SCAN
+			 * Bit 1: Set Gain
+			 */
+			u8  flags;
+			u8  roll_off;
+			u8  rsvd1;
+			u8  rsvd2;
+			u32 frequency;
+			u32 symbol_rate; /* Only in VTM mode */
+			u16 gain;
+		} sx8_start_iq;
+
+		struct {
+			/*
+			 * Bit 1:0 = STVVGLNA Gain.
+			 *   0 = AGC, 1 = 0dB, 2 = Minimum, 3 = Maximum
+			 */
+			u8  flags;
+		} sx8_input_enable;
 	};
 };
 
@@ -116,34 +159,49 @@ struct mci_result {
 	union {
 		u32 status_word;
 		struct {
-			u8 status;
-			u8 rsvd;
+			u8  status;
+			u8  mode;
 			u16 time;
 		};
 	};
 	union {
 		u32 result[27];
 		struct {
+			/* 1 = DVB-S, 2 = DVB-S2X */
 			u8  standard;
 			/* puncture rate for DVB-S */
 			u8  pls_code;
-			/* 7-6: rolloff, 5-2: rsrvd, 1:short, 0:pilots */
+			/* 2-0: rolloff */
 			u8  roll_off;
 			u8  rsvd;
+			/* actual frequency in Hz */
 			u32 frequency;
+			/* actual symbolrate in Hz */
 			u32 symbol_rate;
+			/* channel power in dBm x 100 */
 			s16 channel_power;
+			/* band power in dBm x 100 */
 			s16 band_power;
+			/*
+			 * SNR in dB x 100
+			 * Note: negative values are valid in DVB-S2
+			 */
 			s16 signal_to_noise;
 			s16 rsvd2;
+			/*
+			 * Counter for packet errors
+			 * (set to 0 on start command)
+			 */
 			u32 packet_errors;
+			/* Bit error rate: PreRS in DVB-S, PreBCH in DVB-S2X */
 			u32 ber_numerator;
 			u32 ber_denominator;
 		} dvbs2_signal_info;
+
 		struct {
 			s16 i;
 			s16 q;
-		} dvbs2_signal_iq;
+		} iq_symbol;
 	};
 	u32 version[4];
 };
-- 
2.16.4
