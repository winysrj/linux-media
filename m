Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0115.outbound.protection.outlook.com ([104.47.37.115]:2544
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751368AbdDNCgI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 22:36:08 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v2 11/15] [media] cxd2880: Add DVB-T2 control functions for the driver
Date: Fri, 14 Apr 2017 11:38:43 +0900
Message-ID: <20170414023843.17957-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Provide definitions, interfaces and functions needed for DVB-T2
of the Sony CXD2880 DVB-T2/T tuner + demodulator driver.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 .../media/dvb-frontends/cxd2880/cxd2880_dvbt2.h    |  402 ++++++
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c   | 1309 ++++++++++++++++++++
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h   |   82 ++
 3 files changed, 1793 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
new file mode 100644
index 000000000000..1870398cba9d
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
@@ -0,0 +1,402 @@
+/*
+ * cxd2880_dvbt2.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T2 related definitions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef CXD2880_DVBT2_H
+#define CXD2880_DVBT2_H
+
+#include "cxd2880_common.h"
+
+enum cxd2880_dvbt2_profile {
+	CXD2880_DVBT2_PROFILE_BASE,
+	CXD2880_DVBT2_PROFILE_LITE,
+	CXD2880_DVBT2_PROFILE_ANY
+};
+
+enum cxd2880_dvbt2_version {
+	CXD2880_DVBT2_V111,
+	CXD2880_DVBT2_V121,
+	CXD2880_DVBT2_V131
+};
+
+enum cxd2880_dvbt2_s1 {
+	CXD2880_DVBT2_S1_BASE_SISO = 0x00,
+	CXD2880_DVBT2_S1_BASE_MISO = 0x01,
+	CXD2880_DVBT2_S1_NON_DVBT2 = 0x02,
+	CXD2880_DVBT2_S1_LITE_SISO = 0x03,
+	CXD2880_DVBT2_S1_LITE_MISO = 0x04,
+	CXD2880_DVBT2_S1_RSVD3 = 0x05,
+	CXD2880_DVBT2_S1_RSVD4 = 0x06,
+	CXD2880_DVBT2_S1_RSVD5 = 0x07,
+	CXD2880_DVBT2_S1_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_base_s2 {
+	CXD2880_DVBT2_BASE_S2_M2K_G_ANY = 0x00,
+	CXD2880_DVBT2_BASE_S2_M8K_G_DVBT = 0x01,
+	CXD2880_DVBT2_BASE_S2_M4K_G_ANY = 0x02,
+	CXD2880_DVBT2_BASE_S2_M1K_G_ANY = 0x03,
+	CXD2880_DVBT2_BASE_S2_M16K_G_ANY = 0x04,
+	CXD2880_DVBT2_BASE_S2_M32K_G_DVBT = 0x05,
+	CXD2880_DVBT2_BASE_S2_M8K_G_DVBT2 = 0x06,
+	CXD2880_DVBT2_BASE_S2_M32K_G_DVBT2 = 0x07,
+	CXD2880_DVBT2_BASE_S2_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_lite_s2 {
+	CXD2880_DVBT2_LITE_S2_M2K_G_ANY = 0x00,
+	CXD2880_DVBT2_LITE_S2_M8K_G_DVBT = 0x01,
+	CXD2880_DVBT2_LITE_S2_M4K_G_ANY = 0x02,
+	CXD2880_DVBT2_LITE_S2_M16K_G_DVBT2 = 0x03,
+	CXD2880_DVBT2_LITE_S2_M16K_G_DVBT = 0x04,
+	CXD2880_DVBT2_LITE_S2_RSVD1 = 0x05,
+	CXD2880_DVBT2_LITE_S2_M8K_G_DVBT2 = 0x06,
+	CXD2880_DVBT2_LITE_S2_RSVD2 = 0x07,
+	CXD2880_DVBT2_LITE_S2_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_guard {
+	CXD2880_DVBT2_G1_32 = 0x00,
+	CXD2880_DVBT2_G1_16 = 0x01,
+	CXD2880_DVBT2_G1_8 = 0x02,
+	CXD2880_DVBT2_G1_4 = 0x03,
+	CXD2880_DVBT2_G1_128 = 0x04,
+	CXD2880_DVBT2_G19_128 = 0x05,
+	CXD2880_DVBT2_G19_256 = 0x06,
+	CXD2880_DVBT2_G_RSVD1 = 0x07,
+	CXD2880_DVBT2_G_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_mode {
+	CXD2880_DVBT2_M2K = 0x00,
+	CXD2880_DVBT2_M8K = 0x01,
+	CXD2880_DVBT2_M4K = 0x02,
+	CXD2880_DVBT2_M1K = 0x03,
+	CXD2880_DVBT2_M16K = 0x04,
+	CXD2880_DVBT2_M32K = 0x05,
+	CXD2880_DVBT2_M_RSVD1 = 0x06,
+	CXD2880_DVBT2_M_RSVD2 = 0x07
+};
+
+enum cxd2880_dvbt2_bw {
+	CXD2880_DVBT2_BW_8 = 0x00,
+	CXD2880_DVBT2_BW_7 = 0x01,
+	CXD2880_DVBT2_BW_6 = 0x02,
+	CXD2880_DVBT2_BW_5 = 0x03,
+	CXD2880_DVBT2_BW_10 = 0x04,
+	CXD2880_DVBT2_BW_1_7 = 0x05,
+	CXD2880_DVBT2_BW_RSVD1 = 0x06,
+	CXD2880_DVBT2_BW_RSVD2 = 0x07,
+	CXD2880_DVBT2_BW_RSVD3 = 0x08,
+	CXD2880_DVBT2_BW_RSVD4 = 0x09,
+	CXD2880_DVBT2_BW_RSVD5 = 0x0A,
+	CXD2880_DVBT2_BW_RSVD6 = 0x0B,
+	CXD2880_DVBT2_BW_RSVD7 = 0x0C,
+	CXD2880_DVBT2_BW_RSVD8 = 0x0D,
+	CXD2880_DVBT2_BW_RSVD9 = 0x0E,
+	CXD2880_DVBT2_BW_RSVD10 = 0x0F,
+	CXD2880_DVBT2_BW_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_l1pre_type {
+	CXD2880_DVBT2_L1PRE_TYPE_TS = 0x00,
+	CXD2880_DVBT2_L1PRE_TYPE_GS = 0x01,
+	CXD2880_DVBT2_L1PRE_TYPE_TS_GS = 0x02,
+	CXD2880_DVBT2_L1PRE_TYPE_RESERVED = 0x03,
+	CXD2880_DVBT2_L1PRE_TYPE_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_papr {
+	CXD2880_DVBT2_PAPR_0 = 0x00,
+	CXD2880_DVBT2_PAPR_1 = 0x01,
+	CXD2880_DVBT2_PAPR_2 = 0x02,
+	CXD2880_DVBT2_PAPR_3 = 0x03,
+	CXD2880_DVBT2_PAPR_RSVD1 = 0x04,
+	CXD2880_DVBT2_PAPR_RSVD2 = 0x05,
+	CXD2880_DVBT2_PAPR_RSVD3 = 0x06,
+	CXD2880_DVBT2_PAPR_RSVD4 = 0x07,
+	CXD2880_DVBT2_PAPR_RSVD5 = 0x08,
+	CXD2880_DVBT2_PAPR_RSVD6 = 0x09,
+	CXD2880_DVBT2_PAPR_RSVD7 = 0x0A,
+	CXD2880_DVBT2_PAPR_RSVD8 = 0x0B,
+	CXD2880_DVBT2_PAPR_RSVD9 = 0x0C,
+	CXD2880_DVBT2_PAPR_RSVD10 = 0x0D,
+	CXD2880_DVBT2_PAPR_RSVD11 = 0x0E,
+	CXD2880_DVBT2_PAPR_RSVD12 = 0x0F,
+	CXD2880_DVBT2_PAPR_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_l1post_constell {
+	CXD2880_DVBT2_L1POST_BPSK = 0x00,
+	CXD2880_DVBT2_L1POST_QPSK = 0x01,
+	CXD2880_DVBT2_L1POST_QAM16 = 0x02,
+	CXD2880_DVBT2_L1POST_QAM64 = 0x03,
+	CXD2880_DVBT2_L1POST_C_RSVD1 = 0x04,
+	CXD2880_DVBT2_L1POST_C_RSVD2 = 0x05,
+	CXD2880_DVBT2_L1POST_C_RSVD3 = 0x06,
+	CXD2880_DVBT2_L1POST_C_RSVD4 = 0x07,
+	CXD2880_DVBT2_L1POST_C_RSVD5 = 0x08,
+	CXD2880_DVBT2_L1POST_C_RSVD6 = 0x09,
+	CXD2880_DVBT2_L1POST_C_RSVD7 = 0x0A,
+	CXD2880_DVBT2_L1POST_C_RSVD8 = 0x0B,
+	CXD2880_DVBT2_L1POST_C_RSVD9 = 0x0C,
+	CXD2880_DVBT2_L1POST_C_RSVD10 = 0x0D,
+	CXD2880_DVBT2_L1POST_C_RSVD11 = 0x0E,
+	CXD2880_DVBT2_L1POST_C_RSVD12 = 0x0F,
+	CXD2880_DVBT2_L1POST_CONSTELL_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_l1post_cr {
+	CXD2880_DVBT2_L1POST_R1_2 = 0x00,
+	CXD2880_DVBT2_L1POST_R_RSVD1 = 0x01,
+	CXD2880_DVBT2_L1POST_R_RSVD2 = 0x02,
+	CXD2880_DVBT2_L1POST_R_RSVD3 = 0x03,
+	CXD2880_DVBT2_L1POST_R_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_l1post_fec_type {
+	CXD2880_DVBT2_L1POST_FEC_LDPC16K = 0x00,
+	CXD2880_DVBT2_L1POST_FEC_RSVD1 = 0x01,
+	CXD2880_DVBT2_L1POST_FEC_RSVD2 = 0x02,
+	CXD2880_DVBT2_L1POST_FEC_RSVD3 = 0x03,
+	CXD2880_DVBT2_L1POST_FEC_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_pp {
+	CXD2880_DVBT2_PP1 = 0x00,
+	CXD2880_DVBT2_PP2 = 0x01,
+	CXD2880_DVBT2_PP3 = 0x02,
+	CXD2880_DVBT2_PP4 = 0x03,
+	CXD2880_DVBT2_PP5 = 0x04,
+	CXD2880_DVBT2_PP6 = 0x05,
+	CXD2880_DVBT2_PP7 = 0x06,
+	CXD2880_DVBT2_PP8 = 0x07,
+	CXD2880_DVBT2_PP_RSVD1 = 0x08,
+	CXD2880_DVBT2_PP_RSVD2 = 0x09,
+	CXD2880_DVBT2_PP_RSVD3 = 0x0A,
+	CXD2880_DVBT2_PP_RSVD4 = 0x0B,
+	CXD2880_DVBT2_PP_RSVD5 = 0x0C,
+	CXD2880_DVBT2_PP_RSVD6 = 0x0D,
+	CXD2880_DVBT2_PP_RSVD7 = 0x0E,
+	CXD2880_DVBT2_PP_RSVD8 = 0x0F,
+	CXD2880_DVBT2_PP_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_code_rate {
+	CXD2880_DVBT2_R1_2 = 0x00,
+	CXD2880_DVBT2_R3_5 = 0x01,
+	CXD2880_DVBT2_R2_3 = 0x02,
+	CXD2880_DVBT2_R3_4 = 0x03,
+	CXD2880_DVBT2_R4_5 = 0x04,
+	CXD2880_DVBT2_R5_6 = 0x05,
+	CXD2880_DVBT2_R1_3 = 0x06,
+	CXD2880_DVBT2_R2_5 = 0x07,
+	CXD2880_DVBT2_PLP_CR_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_constell {
+	CXD2880_DVBT2_QPSK = 0x00,
+	CXD2880_DVBT2_QAM16 = 0x01,
+	CXD2880_DVBT2_QAM64 = 0x02,
+	CXD2880_DVBT2_QAM256 = 0x03,
+	CXD2880_DVBT2_CON_RSVD1 = 0x04,
+	CXD2880_DVBT2_CON_RSVD2 = 0x05,
+	CXD2880_DVBT2_CON_RSVD3 = 0x06,
+	CXD2880_DVBT2_CON_RSVD4 = 0x07,
+	CXD2880_DVBT2_CONSTELL_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_type {
+	CXD2880_DVBT2_PLP_TYPE_COMMON = 0x00,
+	CXD2880_DVBT2_PLP_TYPE_DATA1 = 0x01,
+	CXD2880_DVBT2_PLP_TYPE_DATA2 = 0x02,
+	CXD2880_DVBT2_PLP_TYPE_RSVD1 = 0x03,
+	CXD2880_DVBT2_PLP_TYPE_RSVD2 = 0x04,
+	CXD2880_DVBT2_PLP_TYPE_RSVD3 = 0x05,
+	CXD2880_DVBT2_PLP_TYPE_RSVD4 = 0x06,
+	CXD2880_DVBT2_PLP_TYPE_RSVD5 = 0x07,
+	CXD2880_DVBT2_PLP_TYPE_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_payload {
+	CXD2880_DVBT2_PLP_PAYLOAD_GFPS = 0x00,
+	CXD2880_DVBT2_PLP_PAYLOAD_GCS = 0x01,
+	CXD2880_DVBT2_PLP_PAYLOAD_GSE = 0x02,
+	CXD2880_DVBT2_PLP_PAYLOAD_TS = 0x03,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD1 = 0x04,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD2 = 0x05,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD3 = 0x06,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD4 = 0x07,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD5 = 0x08,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD6 = 0x09,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD7 = 0x0A,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD8 = 0x0B,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD9 = 0x0C,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD10 = 0x0D,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD11 = 0x0E,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD12 = 0x0F,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD13 = 0x10,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD14 = 0x11,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD15 = 0x12,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD16 = 0x13,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD17 = 0x14,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD18 = 0x15,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD19 = 0x16,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD20 = 0x17,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD21 = 0x18,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD22 = 0x19,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD23 = 0x1A,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD24 = 0x1B,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD25 = 0x1C,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD26 = 0x1D,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD27 = 0x1E,
+	CXD2880_DVBT2_PLP_PAYLOAD_RSVD28 = 0x1F,
+	CXD2880_DVBT2_PLP_PAYLOAD_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_fec {
+	CXD2880_DVBT2_FEC_LDPC_16K = 0x00,
+	CXD2880_DVBT2_FEC_LDPC_64K = 0x01,
+	CXD2880_DVBT2_FEC_RSVD1 = 0x02,
+	CXD2880_DVBT2_FEC_RSVD2 = 0x03,
+	CXD2880_DVBT2_FEC_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_mode {
+	CXD2880_DVBT2_PLP_MODE_NOTSPECIFIED = 0x00,
+	CXD2880_DVBT2_PLP_MODE_NM = 0x01,
+	CXD2880_DVBT2_PLP_MODE_HEM = 0x02,
+	CXD2880_DVBT2_PLP_MODE_RESERVED = 0x03,
+	CXD2880_DVBT2_PLP_MODE_UNKNOWN = 0xFF
+};
+
+enum cxd2880_dvbt2_plp_btype {
+	CXD2880_DVBT2_PLP_COMMON,
+	CXD2880_DVBT2_PLP_DATA
+};
+
+enum cxd2880_dvbt2_stream {
+	CXD2880_DVBT2_STREAM_GENERIC_PACKETIZED = 0x00,
+	CXD2880_DVBT2_STREAM_GENERIC_CONTINUOUS = 0x01,
+	CXD2880_DVBT2_STREAM_GENERIC_ENCAPSULATED = 0x02,
+	CXD2880_DVBT2_STREAM_TRANSPORT = 0x03,
+	CXD2880_DVBT2_STREAM_UNKNOWN = 0xFF
+};
+
+struct cxd2880_dvbt2_l1pre {
+	enum cxd2880_dvbt2_l1pre_type type;
+	u8 bw_ext;
+	enum cxd2880_dvbt2_s1 s1;
+	u8 s2;
+	u8 mixed;
+	enum cxd2880_dvbt2_mode fft_mode;
+	u8 l1_rep;
+	enum cxd2880_dvbt2_guard gi;
+	enum cxd2880_dvbt2_papr papr;
+	enum cxd2880_dvbt2_l1post_constell mod;
+	enum cxd2880_dvbt2_l1post_cr cr;
+	enum cxd2880_dvbt2_l1post_fec_type fec;
+	u32 l1_post_size;
+	u32 l1_post_info_size;
+	enum cxd2880_dvbt2_pp pp;
+	u8 tx_id_availability;
+	u16 cell_id;
+	u16 network_id;
+	u16 sys_id;
+	u8 num_frames;
+	u16 num_symbols;
+	u8 regen;
+	u8 post_ext;
+	u8 num_rf_freqs;
+	u8 rf_idx;
+	enum cxd2880_dvbt2_version t2_version;
+	u8 l1_post_scrambled;
+	u8 t2_base_lite;
+	u32 crc32;
+};
+
+struct cxd2880_dvbt2_plp {
+	u8 id;
+	enum cxd2880_dvbt2_plp_type type;
+	enum cxd2880_dvbt2_plp_payload payload;
+	u8 ff;
+	u8 first_rf_idx;
+	u8 first_frm_idx;
+	u8 group_id;
+	enum cxd2880_dvbt2_plp_constell constell;
+	enum cxd2880_dvbt2_plp_code_rate plp_cr;
+	u8 rot;
+	enum cxd2880_dvbt2_plp_fec fec;
+	u16 num_blocks_max;
+	u8 frm_int;
+	u8 til_len;
+	u8 til_type;
+	u8 in_band_a_flag;
+	u8 in_band_b_flag;
+	u16 rsvd;
+	enum cxd2880_dvbt2_plp_mode plp_mode;
+	u8 static_flag;
+	u8 static_padding_flag;
+};
+
+struct cxd2880_dvbt2_l1post {
+	u16 sub_slices_per_frame;
+	u8 num_plps;
+	u8 num_aux;
+	u8 aux_cfg_rfu;
+	u8 rf_idx;
+	u32 freq;
+	u8 fef_type;
+	u32 fef_length;
+	u8 fef_intvl;
+};
+
+struct cxd2880_dvbt2_ofdm {
+	u8 mixed;
+	u8 is_miso;
+	enum cxd2880_dvbt2_mode mode;
+	enum cxd2880_dvbt2_guard gi;
+	enum cxd2880_dvbt2_pp pp;
+	u8 bw_ext;
+	enum cxd2880_dvbt2_papr papr;
+	u16 num_symbols;
+};
+
+struct cxd2880_dvbt2_bbheader {
+	enum cxd2880_dvbt2_stream stream_input;
+	u8 is_single_input_stream;
+	u8 is_constant_coding_modulation;
+	u8 issy_indicator;
+	u8 null_packet_deletion;
+	u8 ext;
+	u8 input_stream_identifier;
+	u16 user_packet_length;
+	u16 data_field_length;
+	u8 sync_byte;
+	u32 issy;
+	enum cxd2880_dvbt2_plp_mode plp_mode;
+};
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
new file mode 100644
index 000000000000..bdad65b7298a
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
@@ -0,0 +1,1309 @@
+/*
+ * cxd2880_tnrdmd_dvbt2.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * control functions for DVB-T2
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "cxd2880_tnrdmd_dvbt2.h"
+#include "cxd2880_tnrdmd_dvbt2_mon.h"
+
+static enum cxd2880_ret x_tune_dvbt2_demod_setting(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum cxd2880_dtv_bandwidth
+						   bandwidth,
+						   enum cxd2880_tnrdmd_clockmode
+						   clk_mode)
+{
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_SYS, 0x31,
+				   0x02) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x04) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x5D,
+				   0x0B) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_SUB) {
+		u8 data[2] = { 0x01, 0x01 };
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0xCE, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		u8 data[14] = { 0x07, 0x06, 0x01, 0xF0,
+			0x00, 0x00, 0x04, 0xB0, 0x00, 0x00, 0x09, 0x9C, 0x0E,
+			    0x4C
+		};
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x20) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x8A,
+					   data[0]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x90,
+					   data[1]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x25) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0xF0, &data[2],
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x2A) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xDC,
+					   data[4]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xDE,
+					   data[5]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x2D) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x73, &data[6],
+					    4) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x8F, &data[10],
+					    4) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		u8 data_a_1[9] = { 0x52, 0x49, 0x2C, 0x51,
+			0x51, 0x3D, 0x15, 0x29, 0x0C
+		};
+		u8 data_b_1[9] = { 0x5D, 0x55, 0x32, 0x5C,
+			0x5C, 0x45, 0x17, 0x2E, 0x0D
+		};
+		u8 data_c_1[9] = { 0x60, 0x00, 0x34, 0x5E,
+			0x5E, 0x47, 0x18, 0x2F, 0x0E
+		};
+
+		u8 data_a_2[13] = { 0x04, 0xE7, 0x94, 0x92,
+			0x09, 0xCF, 0x7E, 0xD0, 0x49, 0xCD, 0xCD, 0x1F, 0x5B
+		};
+		u8 data_b_2[13] = { 0x05, 0x90, 0x27, 0x55,
+			0x0B, 0x20, 0x8F, 0xD6, 0xEA, 0xC8, 0xC8, 0x23, 0x91
+		};
+		u8 data_c_2[13] = { 0x05, 0xB8, 0xD8, 0x00,
+			0x0B, 0x72, 0x93, 0xF3, 0x00, 0xCD, 0xCD, 0x24, 0x95
+		};
+
+		u8 data_a_3[5] = { 0x0B, 0x6A, 0xC9, 0x03,
+			0x33
+		};
+		u8 data_b_3[5] = { 0x01, 0x02, 0xE4, 0x03,
+			0x39
+		};
+		u8 data_c_3[5] = { 0x01, 0x02, 0xEB, 0x03,
+			0x3B
+		};
+
+		u8 *data_1 = NULL;
+		u8 *data_2 = NULL;
+		u8 *data_3 = NULL;
+
+		switch (clk_mode) {
+		case CXD2880_TNRDMD_CLOCKMODE_A:
+			data_1 = data_a_1;
+			data_2 = data_a_2;
+			data_3 = data_a_3;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_B:
+			data_1 = data_b_1;
+			data_2 = data_b_2;
+			data_3 = data_b_3;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_C:
+			data_1 = data_c_1;
+			data_2 = data_c_2;
+			data_3 = data_c_3;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x04) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x1D,
+					    &data_1[0], 3) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x22,
+					   data_1[3]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x24,
+					   data_1[4]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x26,
+					   data_1[5]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x29,
+					    &data_1[6], 2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x2D,
+					   data_1[8]) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_SUB) {
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x2E,
+						    &data_2[0],
+						    6) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x35,
+						    &data_2[6],
+						    7) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x3C,
+					    &data_3[0], 2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x56,
+					    &data_3[2], 3) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	switch (bandwidth) {
+	case CXD2880_DTV_BW_8_MHZ:
+
+		{
+			u8 data_ac[6] = { 0x15, 0x00, 0x00, 0x00,
+				0x00, 0x00
+			};
+			u8 data_b[6] = { 0x14, 0x6A, 0xAA, 0xAA,
+				0xAB, 0x00
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_ac;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x10,
+						    data,
+						    6) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data_a[2] = { 0x19, 0xD2 };
+			u8 data_bc[2] = { 0x3F, 0xFF };
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_bc;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x19,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data_a[2] = { 0x06, 0x2A };
+			u8 data_b[2] = { 0x06, 0x29 };
+			u8 data_c[2] = { 0x06, 0x28 };
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x1B,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[9] = { 0x28, 0x00, 0x50, 0x00,
+				0x60, 0x00, 0x00, 0x90, 0x00
+			};
+			u8 data_b[9] = { 0x2D, 0x5E, 0x5A, 0xBD,
+				0x6C, 0xE3, 0x00, 0xA3, 0x55
+			};
+			u8 data_c[9] = { 0x2E, 0xAA, 0x5D, 0x55,
+				0x70, 0x00, 0x00, 0xA8, 0x00
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x4B,
+						    data,
+						    9) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_7_MHZ:
+
+		{
+			u8 data_ac[6] = { 0x18, 0x00, 0x00, 0x00,
+				0x00, 0x00
+			};
+			u8 data_b[6] = { 0x17, 0x55, 0x55, 0x55,
+				0x55, 0x00
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_ac;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x10,
+						    data,
+						    6) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x02) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data[2] = { 0x3F, 0xFF };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x19,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data_a[2] = { 0x06, 0x23 };
+			u8 data_b[2] = { 0x06, 0x22 };
+			u8 data_c[2] = { 0x06, 0x21 };
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x1B,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[9] = { 0x2D, 0xB6, 0x5B, 0x6D,
+				0x6D, 0xB6, 0x00, 0xA4, 0x92
+			};
+			u8 data_b[9] = { 0x33, 0xDA, 0x67, 0xB4,
+				0x7C, 0x71, 0x00, 0xBA, 0xAA
+			};
+			u8 data_c[9] = { 0x35, 0x55, 0x6A, 0xAA,
+				0x80, 0x00, 0x00, 0xC0, 0x00
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x4B,
+						    data,
+						    9) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_6_MHZ:
+
+		{
+			u8 data_ac[6] = { 0x1C, 0x00, 0x00, 0x00,
+				0x00, 0x00
+			};
+			u8 data_b[6] = { 0x1B, 0x38, 0xE3, 0x8E,
+				0x39, 0x00
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_ac;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x10,
+						    data,
+						    6) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x04) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data[2] = { 0x3F, 0xFF };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x19,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data_a[2] = { 0x06, 0x1C };
+			u8 data_b[2] = { 0x06, 0x1B };
+			u8 data_c[2] = { 0x06, 0x1A };
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x1B,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[9] = { 0x35, 0x55, 0x6A, 0xAA,
+				0x80, 0x00, 0x00, 0xC0, 0x00
+			};
+			u8 data_b[9] = { 0x3C, 0x7E, 0x78, 0xFC,
+				0x91, 0x2F, 0x00, 0xD9, 0xC7
+			};
+			u8 data_c[9] = { 0x3E, 0x38, 0x7C, 0x71,
+				0x95, 0x55, 0x00, 0xDF, 0xFF
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x4B,
+						    data,
+						    9) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_5_MHZ:
+
+		{
+			u8 data_ac[6] = { 0x21, 0x99, 0x99, 0x99,
+				0x9A, 0x00
+			};
+			u8 data_b[6] = { 0x20, 0xAA, 0xAA, 0xAA,
+				0xAB, 0x00
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_ac;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x10,
+						    data,
+						    6) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x06) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data[2] = { 0x3F, 0xFF };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x19,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data_a[2] = { 0x06, 0x15 };
+			u8 data_b[2] = { 0x06, 0x15 };
+			u8 data_c[2] = { 0x06, 0x14 };
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x1B,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[9] = { 0x40, 0x00, 0x6A, 0xAA,
+				0x80, 0x00, 0x00, 0xE6, 0x66
+			};
+			u8 data_b[9] = { 0x48, 0x97, 0x78, 0xFC,
+				0x91, 0x2F, 0x01, 0x05, 0x55
+			};
+			u8 data_c[9] = { 0x4A, 0xAA, 0x7C, 0x71,
+				0x95, 0x55, 0x01, 0x0C, 0xCC
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x4B,
+						    data,
+						    9) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_1_7_MHZ:
+
+		{
+			u8 data_a[6] = { 0x68, 0x0F, 0xA2, 0x32,
+				0xCF, 0x03
+			};
+			u8 data_c[6] = { 0x68, 0x0F, 0xA2, 0x32,
+				0xCF, 0x03
+			};
+			u8 data_b[6] = { 0x65, 0x2B, 0xA4, 0xCD,
+				0xD8, 0x03
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x10,
+						    data,
+						    6) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x03) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data[2] = { 0x3F, 0xFF };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x19,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data_a[2] = { 0x06, 0x0C };
+			u8 data_b[2] = { 0x06, 0x0C };
+			u8 data_c[2] = { 0x06, 0x0B };
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x1B,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[9] = { 0x40, 0x00, 0x6A, 0xAA,
+				0x80, 0x00, 0x02, 0xC9, 0x8F
+			};
+			u8 data_b[9] = { 0x48, 0x97, 0x78, 0xFC,
+				0x91, 0x2F, 0x03, 0x29, 0x5D
+			};
+			u8 data_c[9] = { 0x4A, 0xAA, 0x7C, 0x71,
+				0x95, 0x55, 0x03, 0x40, 0x7D
+			};
+			u8 *data = NULL;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+				data = data_a;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = data_b;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = data_c;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x4B,
+						    data,
+						    9) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	default:
+		return CXD2880_RESULT_ERROR_SW_STATE;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xFD,
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret x_sleep_dvbt2_demod_setting(struct cxd2880_tnrdmd
+						    *tnr_dmd)
+{
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		u8 data[] = { 0, 1, 0, 2,
+			0, 4, 0, 8, 0, 16, 0, 32
+		};
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x1D) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x47, data,
+					    12) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret dvbt2_set_profile(struct cxd2880_tnrdmd *tnr_dmd,
+					  enum cxd2880_dvbt2_profile profile)
+{
+	u8 t2_mode_tune_mode = 0;
+	u8 seq_not2_dtime = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	{
+		u8 dtime1 = 0;
+		u8 dtime2 = 0;
+
+		switch (tnr_dmd->clk_mode) {
+		case CXD2880_TNRDMD_CLOCKMODE_A:
+			dtime1 = 0x27;
+			dtime2 = 0x0C;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_B:
+			dtime1 = 0x2C;
+			dtime2 = 0x0D;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_C:
+			dtime1 = 0x2E;
+			dtime2 = 0x0E;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+
+		switch (profile) {
+		case CXD2880_DVBT2_PROFILE_BASE:
+			t2_mode_tune_mode = 0x01;
+			seq_not2_dtime = dtime2;
+			break;
+
+		case CXD2880_DVBT2_PROFILE_LITE:
+			t2_mode_tune_mode = 0x05;
+			seq_not2_dtime = dtime1;
+			break;
+
+		case CXD2880_DVBT2_PROFILE_ANY:
+			t2_mode_tune_mode = 0x00;
+			seq_not2_dtime = dtime1;
+			break;
+
+		default:
+			return CXD2880_RESULT_ERROR_ARG;
+		}
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x2E) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10,
+				   t2_mode_tune_mode) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x04) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x2C,
+				   seq_not2_dtime) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_tune1(struct cxd2880_tnrdmd *tnr_dmd,
+					    struct cxd2880_dvbt2_tune_param
+					    *tune_param)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!tune_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP) &&
+	    (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if ((tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) &&
+	    (tune_param->profile == CXD2880_DVBT2_PROFILE_ANY))
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+
+	ret =
+	    cxd2880_tnrdmd_common_tune_setting1(tnr_dmd, CXD2880_DTV_SYS_DVBT2,
+						tune_param->center_freq_khz,
+						tune_param->bandwidth, 0, 0);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    x_tune_dvbt2_demod_setting(tnr_dmd, tune_param->bandwidth,
+				       tnr_dmd->clk_mode);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret =
+		    x_tune_dvbt2_demod_setting(tnr_dmd->diver_sub,
+					       tune_param->bandwidth,
+					       tnr_dmd->diver_sub->clk_mode);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = dvbt2_set_profile(tnr_dmd, tune_param->profile);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret =
+		    dvbt2_set_profile(tnr_dmd->diver_sub, tune_param->profile);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	if (tune_param->data_plp_id == CXD2880_DVBT2_TUNE_PARAM_PLPID_AUTO) {
+		ret = cxd2880_tnrdmd_dvbt2_set_plp_cfg(tnr_dmd, 1, 0);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	} else {
+		ret =
+		    cxd2880_tnrdmd_dvbt2_set_plp_cfg(tnr_dmd, 0,
+					     (u8)(tune_param->data_plp_id));
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_tune2(struct cxd2880_tnrdmd *tnr_dmd,
+					    struct cxd2880_dvbt2_tune_param
+					    *tune_param)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!tune_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP) &&
+	    (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 en_fef_intmtnt_ctrl = 1;
+
+		switch (tune_param->profile) {
+		case CXD2880_DVBT2_PROFILE_BASE:
+			en_fef_intmtnt_ctrl = tnr_dmd->en_fef_intmtnt_base;
+			break;
+		case CXD2880_DVBT2_PROFILE_LITE:
+			en_fef_intmtnt_ctrl = tnr_dmd->en_fef_intmtnt_lite;
+			break;
+		case CXD2880_DVBT2_PROFILE_ANY:
+			if (tnr_dmd->en_fef_intmtnt_base &&
+			    tnr_dmd->en_fef_intmtnt_lite)
+				en_fef_intmtnt_ctrl = 1;
+			else
+				en_fef_intmtnt_ctrl = 0;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_ARG;
+		}
+
+		ret =
+		    cxd2880_tnrdmd_common_tune_setting2(tnr_dmd,
+							CXD2880_DTV_SYS_DVBT2,
+							en_fef_intmtnt_ctrl);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	tnr_dmd->state = CXD2880_TNRDMD_STATE_ACTIVE;
+	tnr_dmd->frequency_khz = tune_param->center_freq_khz;
+	tnr_dmd->sys = CXD2880_DTV_SYS_DVBT2;
+	tnr_dmd->bandwidth = tune_param->bandwidth;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		tnr_dmd->diver_sub->state = CXD2880_TNRDMD_STATE_ACTIVE;
+		tnr_dmd->diver_sub->frequency_khz = tune_param->center_freq_khz;
+		tnr_dmd->diver_sub->sys = CXD2880_DTV_SYS_DVBT2;
+		tnr_dmd->diver_sub->bandwidth = tune_param->bandwidth;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_sleep_setting(struct cxd2880_tnrdmd
+						    *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP) &&
+	    (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = x_sleep_dvbt2_demod_setting(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = x_sleep_dvbt2_demod_setting(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_check_demod_lock(struct cxd2880_tnrdmd
+					       *tnr_dmd,
+					       enum
+					       cxd2880_tnrdmd_lock_result
+					       *lock)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	u8 sync_stat = 0;
+	u8 ts_lock = 0;
+	u8 unlock_detected = 0;
+	u8 unlock_detected_sub = 0;
+
+	if ((!tnr_dmd) || (!lock))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_stat, &ts_lock,
+					       &unlock_detected);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
+		if (sync_stat == 6)
+			*lock = CXD2880_TNRDMD_LOCK_RESULT_LOCKED;
+		else if (unlock_detected)
+			*lock = CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED;
+		else
+			*lock = CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+
+		return ret;
+	}
+
+	if (sync_stat == 6) {
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_LOCKED;
+		return ret;
+	}
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub(tnr_dmd, &sync_stat,
+						   &unlock_detected_sub);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (sync_stat == 6)
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_LOCKED;
+	else if (unlock_detected && unlock_detected_sub)
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED;
+	else
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_check_ts_lock(struct cxd2880_tnrdmd
+						    *tnr_dmd,
+						    enum
+						    cxd2880_tnrdmd_lock_result
+						    *lock)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	u8 sync_stat = 0;
+	u8 ts_lock = 0;
+	u8 unlock_detected = 0;
+	u8 unlock_detected_sub = 0;
+
+	if ((!tnr_dmd) || (!lock))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_stat, &ts_lock,
+					       &unlock_detected);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
+		if (ts_lock)
+			*lock = CXD2880_TNRDMD_LOCK_RESULT_LOCKED;
+		else if (unlock_detected)
+			*lock = CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED;
+		else
+			*lock = CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+
+		return ret;
+	}
+
+	if (ts_lock) {
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_LOCKED;
+		return ret;
+	} else if (!unlock_detected) {
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+		return ret;
+	}
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub(tnr_dmd, &sync_stat,
+						   &unlock_detected_sub);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (unlock_detected && unlock_detected_sub)
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED;
+	else
+		*lock = CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_set_plp_cfg(struct cxd2880_tnrdmd
+						  *tnr_dmd, u8 auto_plp,
+						  u8 plp_id)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP) &&
+	    (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x23) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (!auto_plp) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xAF,
+					   plp_id) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xAD,
+				   auto_plp ? 0x00 : 0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_diver_fef_setting(struct cxd2880_tnrdmd
+							*tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE)
+		return CXD2880_RESULT_OK;
+
+	{
+		struct cxd2880_dvbt2_ofdm ofdm;
+
+		ret = cxd2880_tnrdmd_dvbt2_mon_ofdm(tnr_dmd, &ofdm);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (!ofdm.mixed)
+			return CXD2880_RESULT_OK;
+	}
+
+	{
+		u8 data[] = { 0, 8, 0, 16,
+			0, 32, 0, 64, 0, 128, 1, 0
+		};
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x1D) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x47, data,
+					    12) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_check_l1post_valid(struct cxd2880_tnrdmd
+							 *tnr_dmd,
+							 u8 *l1_post_valid)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	u8 data;
+
+	if ((!tnr_dmd) || (!l1_post_valid))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP) &&
+	    (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x86, &data,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*l1_post_valid = data & 0x01;
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
new file mode 100644
index 000000000000..8735280f0143
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
@@ -0,0 +1,82 @@
+/*
+ * cxd2880_tnrdmd_dvbt2.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * control interface for DVB-T2
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef CXD2880_TNRDMD_DVBT2_H
+#define CXD2880_TNRDMD_DVBT2_H
+
+#include "cxd2880_common.h"
+#include "cxd2880_tnrdmd.h"
+
+enum cxd2880_tnrdmd_dvbt2_tune_info {
+	CXD2880_TNRDMD_DVBT2_TUNE_INFO_OK,
+	CXD2880_TNRDMD_DVBT2_TUNE_INFO_INVALID_PLP_ID
+};
+
+struct cxd2880_dvbt2_tune_param {
+	u32 center_freq_khz;
+	enum cxd2880_dtv_bandwidth bandwidth;
+	u16 data_plp_id;
+	enum cxd2880_dvbt2_profile profile;
+	enum cxd2880_tnrdmd_dvbt2_tune_info tune_info;
+};
+
+#define CXD2880_DVBT2_TUNE_PARAM_PLPID_AUTO  0xFFFF
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_tune1(struct cxd2880_tnrdmd *tnr_dmd,
+					    struct cxd2880_dvbt2_tune_param
+					    *tune_param);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_tune2(struct cxd2880_tnrdmd *tnr_dmd,
+					    struct cxd2880_dvbt2_tune_param
+					    *tune_param);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_sleep_setting(struct cxd2880_tnrdmd
+						    *tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_check_demod_lock(struct cxd2880_tnrdmd
+					       *tnr_dmd,
+					       enum
+					       cxd2880_tnrdmd_lock_result
+					       *lock);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_check_ts_lock(struct cxd2880_tnrdmd
+						    *tnr_dmd,
+						    enum
+						    cxd2880_tnrdmd_lock_result
+						    *lock);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_set_plp_cfg(struct cxd2880_tnrdmd
+						  *tnr_dmd, u8 auto_plp,
+						  u8 plp_id);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_diver_fef_setting(struct cxd2880_tnrdmd
+							*tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_check_l1post_valid(struct cxd2880_tnrdmd
+							 *tnr_dmd,
+							 u8 *l1_post_valid);
+
+#endif
-- 
2.11.0
