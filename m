Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0122.outbound.protection.outlook.com ([104.47.38.122]:19812
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753253AbdCGBpB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 20:45:01 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [RFC PATCH 4/5] media: Add suppurt for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Tue, 7 Mar 2017 10:10:22 +0900
Message-ID: <1488849022-8569-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the driver for Sony CXD2880 DVB-T2/T tuner + demodulator.

Regarding this third Beta Release, the status is:
- Tested on Raspberry Pi 3.
- The DVB-API operates under dvbv5 tools.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h |   91 +
 .../media/dvb-frontends/cxd2880/cxd2880_dvbt2.h    |  402 ++++
 .../dvb-frontends/cxd2880/cxd2880_integ_dvbt.c     |  197 ++
 .../dvb-frontends/cxd2880/cxd2880_integ_dvbt.h     |   58 +
 .../dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c    |  311 +++
 .../dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h    |   64 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c    | 1074 +++++++++
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h    |   62 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c   | 1312 ++++++++++
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h   |   82 +
 .../cxd2880/cxd2880_tnrdmd_dvbt2_mon.c             | 2545 ++++++++++++++++++++
 .../cxd2880/cxd2880_tnrdmd_dvbt2_mon.h             |  170 ++
 .../cxd2880/cxd2880_tnrdmd_dvbt_mon.c              | 1192 +++++++++
 .../cxd2880/cxd2880_tnrdmd_dvbt_mon.h              |  106 +
 14 files changed, 7666 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
new file mode 100644
index 0000000..97916f2
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
@@ -0,0 +1,91 @@
+/*
+ * cxd2880_dvbt.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T related definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_DVBT_H
+#define CXD2880_DVBT_H
+
+#include "cxd2880_common.h"
+
+enum cxd2880_dvbt_constellation {
+	CXD2880_DVBT_CONSTELLATION_QPSK,
+	CXD2880_DVBT_CONSTELLATION_16QAM,
+	CXD2880_DVBT_CONSTELLATION_64QAM,
+	CXD2880_DVBT_CONSTELLATION_RESERVED_3
+};
+
+enum cxd2880_dvbt_hierarchy {
+	CXD2880_DVBT_HIERARCHY_NON,
+	CXD2880_DVBT_HIERARCHY_1,
+	CXD2880_DVBT_HIERARCHY_2,
+	CXD2880_DVBT_HIERARCHY_4
+};
+
+enum cxd2880_dvbt_coderate {
+	CXD2880_DVBT_CODERATE_1_2,
+	CXD2880_DVBT_CODERATE_2_3,
+	CXD2880_DVBT_CODERATE_3_4,
+	CXD2880_DVBT_CODERATE_5_6,
+	CXD2880_DVBT_CODERATE_7_8,
+	CXD2880_DVBT_CODERATE_RESERVED_5,
+	CXD2880_DVBT_CODERATE_RESERVED_6,
+	CXD2880_DVBT_CODERATE_RESERVED_7
+};
+
+enum cxd2880_dvbt_guard {
+	CXD2880_DVBT_GUARD_1_32,
+	CXD2880_DVBT_GUARD_1_16,
+	CXD2880_DVBT_GUARD_1_8,
+	CXD2880_DVBT_GUARD_1_4
+};
+
+enum cxd2880_dvbt_mode {
+	CXD2880_DVBT_MODE_2K,
+	CXD2880_DVBT_MODE_8K,
+	CXD2880_DVBT_MODE_RESERVED_2,
+	CXD2880_DVBT_MODE_RESERVED_3
+};
+
+enum cxd2880_dvbt_profile {
+	CXD2880_DVBT_PROFILE_HP = 0,
+	CXD2880_DVBT_PROFILE_LP
+};
+
+struct cxd2880_dvbt_tpsinfo {
+	enum cxd2880_dvbt_constellation constellation;
+	enum cxd2880_dvbt_hierarchy hierarchy;
+	enum cxd2880_dvbt_coderate rate_hp;
+	enum cxd2880_dvbt_coderate rate_lp;
+	enum cxd2880_dvbt_guard guard;
+	enum cxd2880_dvbt_mode mode;
+	u8 fnum;
+	u8 length_indicator;
+	u16 cell_id;
+	u8 cell_id_ok;
+	u8 reserved_even;
+	u8 reserved_odd;
+};
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
new file mode 100644
index 0000000..e3cadd8
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
@@ -0,0 +1,402 @@
+/*
+ * cxd2880_dvbt2.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T2 related definitions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
new file mode 100644
index 0000000..f18c2be
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
@@ -0,0 +1,197 @@
+/*
+ * cxd2880_integ_dvbt.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer functions for DVB-T
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_tnrdmd_dvbt.h"
+#include "cxd2880_integ_dvbt.h"
+
+static enum cxd2880_ret dvbt_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_integ_dvbt_tune(struct cxd2880_tnrdmd *tnr_dmd,
+					 struct cxd2880_dvbt_tune_param
+					 *tune_param)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!tune_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	cxd2880_atomic_set(&(tnr_dmd->cancel), 0);
+
+	if ((tune_param->bandwidth != CXD2880_DTV_BW_5_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_6_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_7_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_8_MHZ)) {
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+	}
+
+	ret = cxd2880_tnrdmd_dvbt_tune1(tnr_dmd, tune_param);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	CXD2880_SLEEP(CXD2880_TNRDMD_WAIT_AGC_STABLE);
+
+	ret = cxd2880_tnrdmd_dvbt_tune2(tnr_dmd, tune_param);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt_wait_demod_lock(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_integ_dvbt_wait_ts_lock(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	enum cxd2880_tnrdmd_lock_result lock =
+	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+	struct cxd2880_stopwatch timer;
+	u8 continue_wait = 1;
+	u32 elapsed = 0;
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
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	for (;;) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (elapsed >= CXD2880_DVBT_WAIT_TS_LOCK)
+			continue_wait = 0;
+
+		ret = cxd2880_tnrdmd_dvbt_check_ts_lock(tnr_dmd, &lock);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		switch (lock) {
+		case CXD2880_TNRDMD_LOCK_RESULT_LOCKED:
+			return CXD2880_RESULT_OK;
+
+		case CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED:
+			return CXD2880_RESULT_ERROR_UNLOCK;
+
+		default:
+			break;
+		}
+
+		ret = cxd2880_integ_check_cancellation(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (continue_wait) {
+			ret =
+			    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_DVBT_WAIT_LOCK_INTVL);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		} else {
+			ret = CXD2880_RESULT_ERROR_TIMEOUT;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	enum cxd2880_tnrdmd_lock_result lock =
+	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+	struct cxd2880_stopwatch timer;
+	u8 continue_wait = 1;
+	u32 elapsed = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	for (;;) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (elapsed >= CXD2880_DVBT_WAIT_DMD_LOCK)
+			continue_wait = 0;
+
+		ret = cxd2880_tnrdmd_dvbt_check_demod_lock(tnr_dmd, &lock);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		switch (lock) {
+		case CXD2880_TNRDMD_LOCK_RESULT_LOCKED:
+			return CXD2880_RESULT_OK;
+
+		case CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED:
+			return CXD2880_RESULT_ERROR_UNLOCK;
+
+		default:
+			break;
+		}
+
+		ret = cxd2880_integ_check_cancellation(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (continue_wait) {
+			ret =
+			    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_DVBT_WAIT_LOCK_INTVL);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		} else {
+			ret = CXD2880_RESULT_ERROR_TIMEOUT;
+			break;
+		}
+	}
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
new file mode 100644
index 0000000..c3f9936
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
@@ -0,0 +1,58 @@
+/*
+ * cxd2880_integ_dvbt.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer interface for DVB-T
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_INTEG_DVBT_H
+#define CXD2880_INTEG_DVBT_H
+
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_dvbt.h"
+#include "cxd2880_integ.h"
+
+#define CXD2880_DVBT_WAIT_DMD_LOCK	   1000
+#define CXD2880_DVBT_WAIT_TS_LOCK	      1000
+#define CXD2880_DVBT_WAIT_LOCK_INTVL	10
+
+struct cxd2880_integ_dvbt_scan_param {
+	u32 start_frequency_khz;
+	u32 end_frequency_khz;
+	u32 step_frequency_khz;
+	enum cxd2880_dtv_bandwidth bandwidth;
+};
+
+struct cxd2880_integ_dvbt_scan_result {
+	u32 center_freq_khz;
+	enum cxd2880_ret tune_result;
+	struct cxd2880_dvbt_tune_param dvbt_tune_param;
+};
+
+enum cxd2880_ret cxd2880_integ_dvbt_tune(struct cxd2880_tnrdmd *tnr_dmd,
+					 struct cxd2880_dvbt_tune_param
+					 *tune_param);
+
+enum cxd2880_ret cxd2880_integ_dvbt_wait_ts_lock(struct cxd2880_tnrdmd
+						 *tnr_dmd);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
new file mode 100644
index 0000000..53ba331
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
@@ -0,0 +1,311 @@
+/*
+ * cxd2880_integ_dvbt2.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer functions for DVB-T2
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_integ_dvbt2.h"
+
+static enum cxd2880_ret dvbt2_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd,
+					      enum cxd2880_dvbt2_profile
+					      profile);
+
+static enum cxd2880_ret dvbt2_wait_l1_post_lock(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_integ_dvbt2_tune(struct cxd2880_tnrdmd *tnr_dmd,
+					  struct cxd2880_dvbt2_tune_param
+					  *tune_param)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!tune_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	cxd2880_atomic_set(&(tnr_dmd->cancel), 0);
+
+	if ((tune_param->bandwidth != CXD2880_DTV_BW_1_7_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_5_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_6_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_7_MHZ)
+	    && (tune_param->bandwidth != CXD2880_DTV_BW_8_MHZ)) {
+		return CXD2880_RESULT_ERROR_NOSUPPORT;
+	}
+
+	if ((tune_param->profile != CXD2880_DVBT2_PROFILE_BASE)
+	    && (tune_param->profile != CXD2880_DVBT2_PROFILE_LITE))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_dvbt2_tune1(tnr_dmd, tune_param);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	CXD2880_SLEEP(CXD2880_TNRDMD_WAIT_AGC_STABLE);
+
+	ret = cxd2880_tnrdmd_dvbt2_tune2(tnr_dmd, tune_param);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt2_wait_demod_lock(tnr_dmd, tune_param->profile);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = cxd2880_tnrdmd_dvbt2_diver_fef_setting(tnr_dmd);
+	if (ret == CXD2880_RESULT_ERROR_HW_STATE)
+		return CXD2880_RESULT_ERROR_UNLOCK;
+	else if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt2_wait_l1_post_lock(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	{
+		u8 plp_not_found;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_data_plp_error(tnr_dmd,
+							    &plp_not_found);
+		if (ret == CXD2880_RESULT_ERROR_HW_STATE)
+			return CXD2880_RESULT_ERROR_UNLOCK;
+		else if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (plp_not_found) {
+			ret = CXD2880_RESULT_OK_CONFIRM;
+			tune_param->tune_info =
+			    CXD2880_TNRDMD_DVBT2_TUNE_INFO_INVALID_PLP_ID;
+		} else {
+			tune_param->tune_info =
+			    CXD2880_TNRDMD_DVBT2_TUNE_INFO_OK;
+		}
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_integ_dvbt2_wait_ts_lock(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dvbt2_profile
+						  profile)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	enum cxd2880_tnrdmd_lock_result lock =
+	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+	u16 timeout = 0;
+	struct cxd2880_stopwatch timer;
+	u8 continue_wait = 1;
+	u32 elapsed = 0;
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
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (profile == CXD2880_DVBT2_PROFILE_BASE)
+		timeout = CXD2880_DVBT2_BASE_WAIT_TS_LOCK;
+	else if (profile == CXD2880_DVBT2_PROFILE_LITE)
+		timeout = CXD2880_DVBT2_LITE_WAIT_TS_LOCK;
+	else
+		return CXD2880_RESULT_ERROR_ARG;
+
+	for (;;) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (elapsed >= timeout)
+			continue_wait = 0;
+
+		ret = cxd2880_tnrdmd_dvbt2_check_ts_lock(tnr_dmd, &lock);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		switch (lock) {
+		case CXD2880_TNRDMD_LOCK_RESULT_LOCKED:
+			return CXD2880_RESULT_OK;
+
+		case CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED:
+			return CXD2880_RESULT_ERROR_UNLOCK;
+
+		default:
+			break;
+		}
+
+		ret = cxd2880_integ_check_cancellation(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (continue_wait) {
+			ret =
+			    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_DVBT2_WAIT_LOCK_INTVL);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		} else {
+			ret = CXD2880_RESULT_ERROR_TIMEOUT;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt2_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd,
+					      enum cxd2880_dvbt2_profile
+					      profile)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	enum cxd2880_tnrdmd_lock_result lock =
+	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
+	u16 timeout = 0;
+	struct cxd2880_stopwatch timer;
+	u8 continue_wait = 1;
+	u32 elapsed = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (profile == CXD2880_DVBT2_PROFILE_BASE)
+		timeout = CXD2880_DVBT2_BASE_WAIT_DMD_LOCK;
+	else if ((profile == CXD2880_DVBT2_PROFILE_LITE)
+		 || (profile == CXD2880_DVBT2_PROFILE_ANY))
+		timeout = CXD2880_DVBT2_LITE_WAIT_DMD_LOCK;
+	else
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	for (;;) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (elapsed >= timeout)
+			continue_wait = 0;
+
+		ret = cxd2880_tnrdmd_dvbt2_check_demod_lock(tnr_dmd, &lock);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		switch (lock) {
+		case CXD2880_TNRDMD_LOCK_RESULT_LOCKED:
+			return CXD2880_RESULT_OK;
+
+		case CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED:
+			return CXD2880_RESULT_ERROR_UNLOCK;
+
+		default:
+			break;
+		}
+
+		ret = cxd2880_integ_check_cancellation(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (continue_wait) {
+			ret =
+			    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_DVBT2_WAIT_LOCK_INTVL);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		} else {
+			ret = CXD2880_RESULT_ERROR_TIMEOUT;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt2_wait_l1_post_lock(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_stopwatch timer;
+	u8 continue_wait = 1;
+	u32 elapsed = 0;
+	u8 l1_post_valid;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	for (;;) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (elapsed >= CXD2880_DVBT2_L1POST_TIMEOUT)
+			continue_wait = 0;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_check_l1post_valid(tnr_dmd,
+							    &l1_post_valid);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (l1_post_valid)
+			return CXD2880_RESULT_OK;
+
+		ret = cxd2880_integ_check_cancellation(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (continue_wait) {
+			ret =
+			    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_DVBT2_WAIT_LOCK_INTVL);
+			if (ret != CXD2880_RESULT_OK)
+				return ret;
+		} else {
+			ret = CXD2880_RESULT_ERROR_TIMEOUT;
+			break;
+		}
+	}
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
new file mode 100644
index 0000000..8a5a7d6
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
@@ -0,0 +1,64 @@
+/*
+ * cxd2880_integ_dvbt2.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer interface for DVB-T2
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_INTEG_DVBT2_H
+#define CXD2880_INTEG_DVBT2_H
+
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_dvbt2.h"
+#include "cxd2880_integ.h"
+
+#define CXD2880_DVBT2_BASE_WAIT_DMD_LOCK     3500
+#define CXD2880_DVBT2_BASE_WAIT_TS_LOCK	1500
+#define CXD2880_DVBT2_LITE_WAIT_DMD_LOCK     5000
+#define CXD2880_DVBT2_LITE_WAIT_TS_LOCK	2300
+#define CXD2880_DVBT2_WAIT_LOCK_INTVL       10
+#define CXD2880_DVBT2_L1POST_TIMEOUT	   500
+
+struct cxd2880_integ_dvbt2_scan_param {
+	u32 start_frequency_khz;
+	u32 end_frequency_khz;
+	u32 step_frequency_khz;
+	enum cxd2880_dtv_bandwidth bandwidth;
+	enum cxd2880_dvbt2_profile t2_profile;
+};
+
+struct cxd2880_integ_dvbt2_scan_result {
+	u32 center_freq_khz;
+	enum cxd2880_ret tune_result;
+	struct cxd2880_dvbt2_tune_param dvbt2_tune_param;
+};
+
+enum cxd2880_ret cxd2880_integ_dvbt2_tune(struct cxd2880_tnrdmd *tnr_dmd,
+					  struct cxd2880_dvbt2_tune_param
+					  *tune_param);
+
+enum cxd2880_ret cxd2880_integ_dvbt2_wait_ts_lock(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dvbt2_profile
+						  profile);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
new file mode 100644
index 0000000..9046051
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
@@ -0,0 +1,1074 @@
+/*
+ * cxd2880_tnrdmd_dvbt.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * control functions for DVB-T
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_tnrdmd_dvbt.h"
+#include "cxd2880_tnrdmd_dvbt_mon.h"
+
+static enum cxd2880_ret x_tune_dvbt_demod_setting(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dtv_bandwidth
+						  bandwidth,
+						  enum cxd2880_tnrdmd_clockmode
+						  clk_mode)
+{
+
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
+				   0x01) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data_a[2] = { 0x52, 0x49 };
+		u8 data_b[2] = { 0x5D, 0x55 };
+		u8 data_c[2] = { 0x60, 0x00 };
+		u8 *data = NULL;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x04) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		switch (clk_mode) {
+		case CXD2880_TNRDMD_CLOCKMODE_A:
+			data = data_a;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_B:
+			data = data_b;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_C:
+			data = data_c;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x65, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x5D,
+				   0x07) != CXD2880_RESULT_OK)
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
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x04) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x5C,
+				   0xFB) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xA4,
+				   0x03) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x14) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xB0,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x25) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data[2] = { 0x01, 0xF0 };
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0xF0, data,
+					    2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if ((tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+	    || (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x12) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x44,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x11) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x87,
+					   0xD2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_SUB) {
+		u8 data_a[3] = { 0x73, 0xCA, 0x49 };
+		u8 data_b[3] = { 0xC8, 0x13, 0xAA };
+		u8 data_c[3] = { 0xDC, 0x6C, 0x00 };
+		u8 *data = NULL;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x04) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		switch (clk_mode) {
+		case CXD2880_TNRDMD_CLOCKMODE_A:
+			data = data_a;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_B:
+			data = data_b;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_C:
+			data = data_c;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+
+		if (tnr_dmd->io->write_regs(tnr_dmd->io,
+					    CXD2880_IO_TGT_DMD, 0x68, data,
+					    3) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x04) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	switch (bandwidth) {
+	case CXD2880_DTV_BW_8_MHZ:
+
+		{
+			u8 data_ac[5] = { 0x15, 0x00, 0x00, 0x00,
+				0x00
+			};
+			u8 data_b[5] = { 0x14, 0x6A, 0xAA, 0xAA,
+				0xAA
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
+						    CXD2880_IO_TGT_DMD, 0x60,
+						    data,
+						    5) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x00) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data_a[2] = { 0x01, 0x28 };
+			u8 data_b[2] = { 0x11, 0x44 };
+			u8 data_c[2] = { 0x15, 0x28 };
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
+						    CXD2880_IO_TGT_DMD, 0x7D,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data = 0;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = 0x35;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = 0x34;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x71,
+						   data) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[5] = { 0x30, 0x00, 0x00, 0x90,
+				0x00
+			};
+			u8 data_b[5] = { 0x36, 0x71, 0x00, 0xA3,
+				0x55
+			};
+			u8 data_c[5] = { 0x38, 0x00, 0x00, 0xA8,
+				0x00
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
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x51,
+						    &data[2],
+						    3) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data[4] = { 0xB3, 0x00, 0x01, 0x02 };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x72,
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x6B,
+						    &data[2],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_7_MHZ:
+
+		{
+			u8 data_ac[5] = { 0x18, 0x00, 0x00, 0x00,
+				0x00
+			};
+			u8 data_b[5] = { 0x17, 0x55, 0x55, 0x55,
+				0x55
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
+						    CXD2880_IO_TGT_DMD, 0x60,
+						    data,
+						    5) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x02) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data_a[2] = { 0x12, 0x4C };
+			u8 data_b[2] = { 0x1F, 0x15 };
+			u8 data_c[2] = { 0x1F, 0xF8 };
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
+						    CXD2880_IO_TGT_DMD, 0x7D,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data = 0;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = 0x2F;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = 0x2E;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x71,
+						   data) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[5] = { 0x36, 0xDB, 0x00, 0xA4,
+				0x92
+			};
+			u8 data_b[5] = { 0x3E, 0x38, 0x00, 0xBA,
+				0xAA
+			};
+			u8 data_c[5] = { 0x40, 0x00, 0x00, 0xC0,
+				0x00
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
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x51,
+						    &data[2],
+						    3) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data[4] = { 0xB8, 0x00, 0x00, 0x03 };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x72,
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x6B,
+						    &data[2],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_6_MHZ:
+
+		{
+			u8 data_ac[5] = { 0x1C, 0x00, 0x00, 0x00,
+				0x00
+			};
+			u8 data_b[5] = { 0x1B, 0x38, 0xE3, 0x8E,
+				0x38
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
+						    CXD2880_IO_TGT_DMD, 0x60,
+						    data,
+						    5) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x04) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data_a[2] = { 0x1F, 0xF8 };
+			u8 data_b[2] = { 0x24, 0x43 };
+			u8 data_c[2] = { 0x25, 0x4C };
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
+						    CXD2880_IO_TGT_DMD, 0x7D,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data = 0;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = 0x29;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = 0x2A;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x71,
+						   data) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[5] = { 0x40, 0x00, 0x00, 0xC0,
+				0x00
+			};
+			u8 data_b[5] = { 0x48, 0x97, 0x00, 0xD9,
+				0xC7
+			};
+			u8 data_c[5] = { 0x4A, 0xAA, 0x00, 0xDF,
+				0xFF
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
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x51,
+						    &data[2],
+						    3) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data[4] = { 0xBE, 0xAB, 0x00, 0x03 };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x72,
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x6B,
+						    &data[2],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+		break;
+
+	case CXD2880_DTV_BW_5_MHZ:
+
+		{
+			u8 data_ac[5] = { 0x21, 0x99, 0x99, 0x99,
+				0x99
+			};
+			u8 data_b[5] = { 0x20, 0xAA, 0xAA, 0xAA,
+				0xAA
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
+						    CXD2880_IO_TGT_DMD, 0x60,
+						    data,
+						    5) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x4A,
+					   0x06) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		{
+			u8 data_a[2] = { 0x26, 0x5D };
+			u8 data_b[2] = { 0x2B, 0x84 };
+			u8 data_c[2] = { 0x2C, 0xC2 };
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
+						    CXD2880_IO_TGT_DMD, 0x7D,
+						    data,
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data = 0;
+
+			switch (clk_mode) {
+			case CXD2880_TNRDMD_CLOCKMODE_A:
+			case CXD2880_TNRDMD_CLOCKMODE_B:
+				data = 0x24;
+				break;
+			case CXD2880_TNRDMD_CLOCKMODE_C:
+				data = 0x23;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_SW_STATE;
+			}
+
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x71,
+						   data) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+			u8 data_a[5] = { 0x4C, 0xCC, 0x00, 0xE6,
+				0x66
+			};
+			u8 data_b[5] = { 0x57, 0x1C, 0x01, 0x05,
+				0x55
+			};
+			u8 data_c[5] = { 0x59, 0x99, 0x01, 0x0C,
+				0xCC
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
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x51,
+						    &data[2],
+						    3) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+		}
+
+		{
+			u8 data[4] = { 0xC8, 0x01, 0x00, 0x03 };
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x72,
+						    &data[0],
+						    2) != CXD2880_RESULT_OK)
+				return CXD2880_RESULT_ERROR_IO;
+
+			if (tnr_dmd->io->write_regs(tnr_dmd->io,
+						    CXD2880_IO_TGT_DMD, 0x6B,
+						    &data[2],
+						    2) != CXD2880_RESULT_OK)
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
+static enum cxd2880_ret x_sleep_dvbt_demod_setting(struct cxd2880_tnrdmd
+						   *tnr_dmd)
+{
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x04) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x5C,
+				   0xD8) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xA4,
+				   0x00) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB) {
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x11) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x87,
+					   0x04) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret dvbt_set_profile(struct cxd2880_tnrdmd *tnr_dmd,
+					 enum cxd2880_dvbt_profile profile)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x67,
+				   (profile ==
+				    CXD2880_DVBT_PROFILE_HP) ? 0x00 : 0x01) !=
+	    CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_tune1(struct cxd2880_tnrdmd *tnr_dmd,
+					   struct cxd2880_dvbt_tune_param
+					   *tune_param)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!tune_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret =
+	    cxd2880_tnrdmd_common_tune_setting1(tnr_dmd, CXD2880_DTV_SYS_DVBT,
+						tune_param->center_freq_khz,
+						tune_param->bandwidth, 0, 0);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    x_tune_dvbt_demod_setting(tnr_dmd, tune_param->bandwidth,
+				      tnr_dmd->clk_mode);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret =
+		    x_tune_dvbt_demod_setting(tnr_dmd->diver_sub,
+					      tune_param->bandwidth,
+					      tnr_dmd->diver_sub->clk_mode);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = dvbt_set_profile(tnr_dmd, tune_param->profile);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_tune2(struct cxd2880_tnrdmd *tnr_dmd,
+					   struct cxd2880_dvbt_tune_param
+					   *tune_param)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!tune_param))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret =
+	    cxd2880_tnrdmd_common_tune_setting2(tnr_dmd, CXD2880_DTV_SYS_DVBT,
+						0);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	tnr_dmd->state = CXD2880_TNRDMD_STATE_ACTIVE;
+	tnr_dmd->frequency_khz = tune_param->center_freq_khz;
+	tnr_dmd->sys = CXD2880_DTV_SYS_DVBT;
+	tnr_dmd->bandwidth = tune_param->bandwidth;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		tnr_dmd->diver_sub->state = CXD2880_TNRDMD_STATE_ACTIVE;
+		tnr_dmd->diver_sub->frequency_khz = tune_param->center_freq_khz;
+		tnr_dmd->diver_sub->sys = CXD2880_DTV_SYS_DVBT;
+		tnr_dmd->diver_sub->bandwidth = tune_param->bandwidth;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_sleep_setting(struct cxd2880_tnrdmd
+						   *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = x_sleep_dvbt_demod_setting(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN) {
+		ret = x_sleep_dvbt_demod_setting(tnr_dmd->diver_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_check_demod_lock(struct cxd2880_tnrdmd
+						      *tnr_dmd,
+						      enum
+						      cxd2880_tnrdmd_lock_result
+						      *lock)
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
+	    cxd2880_tnrdmd_dvbt_mon_sync_stat(tnr_dmd, &sync_stat, &ts_lock,
+					      &unlock_detected);
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
+	    cxd2880_tnrdmd_dvbt_mon_sync_stat_sub(tnr_dmd, &sync_stat,
+						  &unlock_detected_sub);
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
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_check_ts_lock(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum
+						   cxd2880_tnrdmd_lock_result
+						   *lock)
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
+	    cxd2880_tnrdmd_dvbt_mon_sync_stat(tnr_dmd, &sync_stat, &ts_lock,
+					      &unlock_detected);
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
+	    cxd2880_tnrdmd_dvbt_mon_sync_stat_sub(tnr_dmd, &sync_stat,
+						  &unlock_detected_sub);
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
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
new file mode 100644
index 0000000..e3cc92a
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
@@ -0,0 +1,62 @@
+/*
+ * cxd2880_tnrdmd_dvbt.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * control interface for DVB-T
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_TNRDMD_DVBT_H
+#define CXD2880_TNRDMD_DVBT_H
+
+#include "cxd2880_common.h"
+#include "cxd2880_tnrdmd.h"
+
+struct cxd2880_dvbt_tune_param {
+	u32 center_freq_khz;
+	enum cxd2880_dtv_bandwidth bandwidth;
+	enum cxd2880_dvbt_profile profile;
+};
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_tune1(struct cxd2880_tnrdmd *tnr_dmd,
+					   struct cxd2880_dvbt_tune_param
+					   *tune_param);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_tune2(struct cxd2880_tnrdmd *tnr_dmd,
+					   struct cxd2880_dvbt_tune_param
+					   *tune_param);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_sleep_setting(struct cxd2880_tnrdmd
+						   *tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_check_demod_lock(struct cxd2880_tnrdmd
+						      *tnr_dmd,
+						      enum
+						      cxd2880_tnrdmd_lock_result
+						      *lock);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_check_ts_lock(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum
+						   cxd2880_tnrdmd_lock_result
+						   *lock);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
new file mode 100644
index 0000000..d5083dd
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
@@ -0,0 +1,1312 @@
+/*
+ * cxd2880_tnrdmd_dvbt2.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * control functions for DVB-T2
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+
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
+
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
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if ((tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+	    && (tune_param->profile == CXD2880_DVBT2_PROFILE_ANY))
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
+					     (u8) (tune_param->data_plp_id));
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
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
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
+			if (tnr_dmd->en_fef_intmtnt_base
+			    && tnr_dmd->en_fef_intmtnt_lite)
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
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
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
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x23) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (!auto_plp) {
+
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
+	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP)
+	    && (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
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
index 0000000..3a400fd
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
@@ -0,0 +1,82 @@
+/*
+ * cxd2880_tnrdmd_dvbt2.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * control interface for DVB-T2
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
new file mode 100644
index 0000000..094cf89
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
@@ -0,0 +1,2545 @@
+/*
+ * cxd2880_tnrdmd_dvbt2_mon.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T2 monitor functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_tnrdmd_dvbt2.h"
+#include "cxd2880_tnrdmd_dvbt2_mon.h"
+#include "cxd2880_math.h"
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sync_stat(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 *sync_stat,
+						    u8 *ts_lock_stat,
+						    u8 *unlock_detected)
+{
+
+	if ((!tnr_dmd) || (!sync_stat) || (!ts_lock_stat) || (!unlock_detected))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x10, &data,
+					   sizeof(data)) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		*sync_stat = data & 0x07;
+		*ts_lock_stat = ((data & 0x20) ? 1 : 0);
+		*unlock_detected = ((data & 0x10) ? 1 : 0);
+	}
+
+	if (*sync_stat == 0x07)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub(struct cxd2880_tnrdmd
+							*tnr_dmd,
+							u8 *sync_stat,
+							u8 *unlock_detected)
+{
+	u8 ts_lock_stat = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!sync_stat) || (!unlock_detected))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd->diver_sub, sync_stat,
+					       &ts_lock_stat, unlock_detected);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_carrier_offset(struct cxd2880_tnrdmd
+							 *tnr_dmd, int *offset)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!offset))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[4];
+		u32 ctl_val = 0;
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (sync_state != 6) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x30, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		ctl_val =
+		    ((data[0] & 0x0F) << 24) | (data[1] << 16) | (data[2] << 8)
+		    | (data[3]);
+		*offset = cxd2880_convert2s_complement(ctl_val, 28);
+
+		switch (tnr_dmd->bandwidth) {
+		case CXD2880_DTV_BW_1_7_MHZ:
+			*offset = -1 * ((*offset) / 582);
+			break;
+		case CXD2880_DTV_BW_5_MHZ:
+		case CXD2880_DTV_BW_6_MHZ:
+		case CXD2880_DTV_BW_7_MHZ:
+		case CXD2880_DTV_BW_8_MHZ:
+			*offset =
+			    -1 * ((*offset) * (u8) tnr_dmd->bandwidth / 940);
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_carrier_offset_sub(struct
+							     cxd2880_tnrdmd
+							     *tnr_dmd,
+							     int *offset)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!offset))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_carrier_offset(tnr_dmd->diver_sub, offset);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_l1_pre(struct cxd2880_tnrdmd *tnr_dmd,
+						 struct cxd2880_dvbt2_l1pre
+						 *l1_pre)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!l1_pre))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[37];
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+		u8 version = 0;
+		enum cxd2880_dvbt2_profile profile;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return ret;
+		}
+
+		if (sync_state < 5) {
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+				ret =
+				    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub
+				    (tnr_dmd, &sync_state, &unlock_detected);
+				if (ret != CXD2880_RESULT_OK) {
+					slvt_unfreeze_reg(tnr_dmd);
+					return ret;
+				}
+
+				if (sync_state < 5) {
+					slvt_unfreeze_reg(tnr_dmd);
+					return CXD2880_RESULT_ERROR_HW_STATE;
+				}
+			} else {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_HW_STATE;
+			}
+		}
+
+		ret = cxd2880_tnrdmd_dvbt2_mon_profile(tnr_dmd, &profile);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return ret;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x61, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+		slvt_unfreeze_reg(tnr_dmd);
+
+		l1_pre->type = (enum cxd2880_dvbt2_l1pre_type)data[0];
+		l1_pre->bw_ext = data[1] & 0x01;
+		l1_pre->s1 = (enum cxd2880_dvbt2_s1)(data[2] & 0x07);
+		l1_pre->s2 = data[3] & 0x0F;
+		l1_pre->l1_rep = data[4] & 0x01;
+		l1_pre->gi = (enum cxd2880_dvbt2_guard)(data[5] & 0x07);
+		l1_pre->papr = (enum cxd2880_dvbt2_papr)(data[6] & 0x0F);
+		l1_pre->mod =
+		    (enum cxd2880_dvbt2_l1post_constell)(data[7] & 0x0F);
+		l1_pre->cr = (enum cxd2880_dvbt2_l1post_cr)(data[8] & 0x03);
+		l1_pre->fec =
+		    (enum cxd2880_dvbt2_l1post_fec_type)(data[9] & 0x03);
+		l1_pre->l1_post_size = (data[10] & 0x03) << 16;
+		l1_pre->l1_post_size |= (data[11]) << 8;
+		l1_pre->l1_post_size |= (data[12]);
+		l1_pre->l1_post_info_size = (data[13] & 0x03) << 16;
+		l1_pre->l1_post_info_size |= (data[14]) << 8;
+		l1_pre->l1_post_info_size |= (data[15]);
+		l1_pre->pp = (enum cxd2880_dvbt2_pp)(data[16] & 0x0F);
+		l1_pre->tx_id_availability = data[17];
+		l1_pre->cell_id = (data[18] << 8);
+		l1_pre->cell_id |= (data[19]);
+		l1_pre->network_id = (data[20] << 8);
+		l1_pre->network_id |= (data[21]);
+		l1_pre->sys_id = (data[22] << 8);
+		l1_pre->sys_id |= (data[23]);
+		l1_pre->num_frames = data[24];
+		l1_pre->num_symbols = (data[25] & 0x0F) << 8;
+		l1_pre->num_symbols |= data[26];
+		l1_pre->regen = data[27] & 0x07;
+		l1_pre->post_ext = data[28] & 0x01;
+		l1_pre->num_rf_freqs = data[29] & 0x07;
+		l1_pre->rf_idx = data[30] & 0x07;
+		version = (data[31] & 0x03) << 2;
+		version |= (data[32] & 0xC0) >> 6;
+		l1_pre->t2_version = (enum cxd2880_dvbt2_version)version;
+		l1_pre->l1_post_scrambled = (data[32] & 0x20) >> 5;
+		l1_pre->t2_base_lite = (data[32] & 0x10) >> 4;
+		l1_pre->crc32 = (data[33] << 24);
+		l1_pre->crc32 |= (data[34] << 16);
+		l1_pre->crc32 |= (data[35] << 8);
+		l1_pre->crc32 |= data[36];
+
+		if (profile == CXD2880_DVBT2_PROFILE_BASE) {
+			switch ((l1_pre->s2 >> 1)) {
+			case CXD2880_DVBT2_BASE_S2_M1K_G_ANY:
+				l1_pre->fft_mode = CXD2880_DVBT2_M1K;
+				break;
+			case CXD2880_DVBT2_BASE_S2_M2K_G_ANY:
+				l1_pre->fft_mode = CXD2880_DVBT2_M2K;
+				break;
+			case CXD2880_DVBT2_BASE_S2_M4K_G_ANY:
+				l1_pre->fft_mode = CXD2880_DVBT2_M4K;
+				break;
+			case CXD2880_DVBT2_BASE_S2_M8K_G_DVBT:
+			case CXD2880_DVBT2_BASE_S2_M8K_G_DVBT2:
+				l1_pre->fft_mode = CXD2880_DVBT2_M8K;
+				break;
+			case CXD2880_DVBT2_BASE_S2_M16K_G_ANY:
+				l1_pre->fft_mode = CXD2880_DVBT2_M16K;
+				break;
+			case CXD2880_DVBT2_BASE_S2_M32K_G_DVBT:
+			case CXD2880_DVBT2_BASE_S2_M32K_G_DVBT2:
+				l1_pre->fft_mode = CXD2880_DVBT2_M32K;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_HW_STATE;
+			}
+		} else if (profile == CXD2880_DVBT2_PROFILE_LITE) {
+			switch ((l1_pre->s2 >> 1)) {
+			case CXD2880_DVBT2_LITE_S2_M2K_G_ANY:
+				l1_pre->fft_mode = CXD2880_DVBT2_M2K;
+				break;
+			case CXD2880_DVBT2_LITE_S2_M4K_G_ANY:
+				l1_pre->fft_mode = CXD2880_DVBT2_M4K;
+				break;
+			case CXD2880_DVBT2_LITE_S2_M8K_G_DVBT:
+			case CXD2880_DVBT2_LITE_S2_M8K_G_DVBT2:
+				l1_pre->fft_mode = CXD2880_DVBT2_M8K;
+				break;
+			case CXD2880_DVBT2_LITE_S2_M16K_G_DVBT:
+			case CXD2880_DVBT2_LITE_S2_M16K_G_DVBT2:
+				l1_pre->fft_mode = CXD2880_DVBT2_M16K;
+				break;
+			default:
+				return CXD2880_RESULT_ERROR_HW_STATE;
+			}
+		} else {
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		l1_pre->mixed = l1_pre->s2 & 0x01;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_version(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dvbt2_version
+						  *ver)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u8 version = 0;
+
+	if ((!tnr_dmd) || (!ver))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[2];
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (sync_state < 5) {
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+				ret =
+				    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub
+				    (tnr_dmd, &sync_state, &unlock_detected);
+				if (ret != CXD2880_RESULT_OK) {
+					slvt_unfreeze_reg(tnr_dmd);
+					return ret;
+				}
+
+				if (sync_state < 5) {
+					slvt_unfreeze_reg(tnr_dmd);
+					return CXD2880_RESULT_ERROR_HW_STATE;
+				}
+			} else {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_HW_STATE;
+			}
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x80, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		version = ((data[0] & 0x03) << 2);
+		version |= ((data[1] & 0xC0) >> 6);
+		*ver = (enum cxd2880_dvbt2_version)version;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ofdm(struct cxd2880_tnrdmd *tnr_dmd,
+					       struct cxd2880_dvbt2_ofdm *ofdm)
+{
+
+	if ((!tnr_dmd) || (!ofdm))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[5];
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+		enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (sync_state != 6) {
+			slvt_unfreeze_reg(tnr_dmd);
+
+			ret = CXD2880_RESULT_ERROR_HW_STATE;
+
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN)
+				ret =
+				    cxd2880_tnrdmd_dvbt2_mon_ofdm(
+					tnr_dmd->diver_sub, ofdm);
+
+			return ret;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x1D, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		ofdm->mixed = ((data[0] & 0x20) ? 1 : 0);
+		ofdm->is_miso = ((data[0] & 0x10) >> 4);
+		ofdm->mode = (enum cxd2880_dvbt2_mode)(data[0] & 0x07);
+		ofdm->gi = (enum cxd2880_dvbt2_guard)((data[1] & 0x70) >> 4);
+		ofdm->pp = (enum cxd2880_dvbt2_pp)(data[1] & 0x07);
+		ofdm->bw_ext = (data[2] & 0x10) >> 4;
+		ofdm->papr = (enum cxd2880_dvbt2_papr)(data[2] & 0x0F);
+		ofdm->num_symbols = (data[3] << 8) | data[4];
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_data_plps(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 *plp_ids,
+						    u8 *num_plps)
+{
+
+	if ((!tnr_dmd) || (!num_plps))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 l1_post_ok = 0;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x86,
+					   &l1_post_ok,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!(l1_post_ok & 0x01)) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xC1, num_plps,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (*num_plps == 0) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_OTHER;
+		}
+
+		if (!plp_ids) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_OK;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xC2, plp_ids,
+					   ((*num_plps >
+					     62) ? 62 : *num_plps)) !=
+		    CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (*num_plps > 62) {
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x00,
+						   0x0C) != CXD2880_RESULT_OK) {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_IO;
+			}
+
+			if (tnr_dmd->io->read_regs(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x10,
+						   plp_ids + 62,
+						   *num_plps - 62) !=
+			    CXD2880_RESULT_OK) {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_IO;
+			}
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+	}
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_active_plp(struct cxd2880_tnrdmd
+						     *tnr_dmd,
+						     enum
+						     cxd2880_dvbt2_plp_btype
+						     type,
+						     struct cxd2880_dvbt2_plp
+						     *plp_info)
+{
+
+	if ((!tnr_dmd) || (!plp_info))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[20];
+		u8 addr = 0;
+		u8 index = 0;
+		u8 l1_post_ok = 0;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x86,
+					   &l1_post_ok,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!l1_post_ok) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (type == CXD2880_DVBT2_PLP_COMMON)
+			addr = 0xA9;
+		else
+			addr = 0x96;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, addr, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		if ((type == CXD2880_DVBT2_PLP_COMMON) && (data[13] == 0))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		plp_info->id = data[index++];
+		plp_info->type =
+		    (enum cxd2880_dvbt2_plp_type)(data[index++] & 0x07);
+		plp_info->payload =
+		    (enum cxd2880_dvbt2_plp_payload)(data[index++] & 0x1F);
+		plp_info->ff = data[index++] & 0x01;
+		plp_info->first_rf_idx = data[index++] & 0x07;
+		plp_info->first_frm_idx = data[index++];
+		plp_info->group_id = data[index++];
+		plp_info->plp_cr =
+		    (enum cxd2880_dvbt2_plp_code_rate)(data[index++] & 0x07);
+		plp_info->constell =
+		    (enum cxd2880_dvbt2_plp_constell)(data[index++] & 0x07);
+		plp_info->rot = data[index++] & 0x01;
+		plp_info->fec =
+		    (enum cxd2880_dvbt2_plp_fec)(data[index++] & 0x03);
+		plp_info->num_blocks_max = (u16) ((data[index++] & 0x03)) << 8;
+		plp_info->num_blocks_max |= data[index++];
+		plp_info->frm_int = data[index++];
+		plp_info->til_len = data[index++];
+		plp_info->til_type = data[index++] & 0x01;
+
+		plp_info->in_band_a_flag = data[index++] & 0x01;
+		plp_info->rsvd = data[index++] << 8;
+		plp_info->rsvd |= data[index++];
+
+		plp_info->in_band_b_flag =
+		    (u8) ((plp_info->rsvd & 0x8000) >> 15);
+		plp_info->plp_mode =
+		    (enum cxd2880_dvbt2_plp_mode)((plp_info->rsvd & 0x000C) >>
+						  2);
+		plp_info->static_flag = (u8) ((plp_info->rsvd & 0x0002) >> 1);
+		plp_info->static_padding_flag = (u8) (plp_info->rsvd & 0x0001);
+		plp_info->rsvd = (u16) ((plp_info->rsvd & 0x7FF0) >> 4);
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_data_plp_error(struct cxd2880_tnrdmd
+							 *tnr_dmd,
+							 u8 *plp_error)
+{
+
+	if ((!tnr_dmd) || (!plp_error))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x86, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if ((data & 0x01) == 0x00) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xC0, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		*plp_error = data & 0x01;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_l1_change(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 *l1_change)
+{
+
+	if ((!tnr_dmd) || (!l1_change))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data;
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+		enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (sync_state < 5) {
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
+				ret =
+				    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub
+				    (tnr_dmd, &sync_state, &unlock_detected);
+				if (ret != CXD2880_RESULT_OK) {
+					slvt_unfreeze_reg(tnr_dmd);
+					return ret;
+				}
+
+				if (sync_state < 5) {
+					slvt_unfreeze_reg(tnr_dmd);
+					return CXD2880_RESULT_ERROR_HW_STATE;
+				}
+			} else {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_HW_STATE;
+			}
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x5F, &data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		*l1_change = data & 0x01;
+		if (*l1_change) {
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x00,
+						   0x22) != CXD2880_RESULT_OK) {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_IO;
+			}
+
+			if (tnr_dmd->io->write_reg(tnr_dmd->io,
+						   CXD2880_IO_TGT_DMD, 0x16,
+						   0x01) != CXD2880_RESULT_OK) {
+				slvt_unfreeze_reg(tnr_dmd);
+				return CXD2880_RESULT_ERROR_IO;
+			}
+		}
+		slvt_unfreeze_reg(tnr_dmd);
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_l1_post(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  struct cxd2880_dvbt2_l1post
+						  *l1_post)
+{
+
+	if ((!tnr_dmd) || (!l1_post))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[16];
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x86, data,
+					   sizeof(data)) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (!(data[0] & 0x01))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		l1_post->sub_slices_per_frame = (data[1] & 0x7F) << 8;
+		l1_post->sub_slices_per_frame |= data[2];
+		l1_post->num_plps = data[3];
+		l1_post->num_aux = data[4] & 0x0F;
+		l1_post->aux_cfg_rfu = data[5];
+		l1_post->rf_idx = data[6] & 0x07;
+		l1_post->freq = data[7] << 24;
+		l1_post->freq |= data[8] << 16;
+		l1_post->freq |= data[9] << 8;
+		l1_post->freq |= data[10];
+		l1_post->fef_type = data[11] & 0x0F;
+		l1_post->fef_length = data[12] << 16;
+		l1_post->fef_length |= data[13] << 8;
+		l1_post->fef_length |= data[14];
+		l1_post->fef_intvl = data[15];
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_bbheader(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum cxd2880_dvbt2_plp_btype
+						   type,
+						   struct cxd2880_dvbt2_bbheader
+						   *bbheader)
+{
+
+	if ((!tnr_dmd) || (!bbheader))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		enum cxd2880_ret ret = CXD2880_RESULT_OK;
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return ret;
+		}
+
+		if (!ts_lock) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (type == CXD2880_DVBT2_PLP_COMMON) {
+		u8 l1_post_ok;
+		u8 data;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x86,
+					   &l1_post_ok,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!(l1_post_ok & 0x01)) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xB6, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (data == 0) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+	}
+
+	{
+		u8 data[14];
+		u8 addr = 0;
+
+		if (type == CXD2880_DVBT2_PLP_COMMON)
+			addr = 0x51;
+		else
+			addr = 0x42;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, addr, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		bbheader->stream_input =
+		    (enum cxd2880_dvbt2_stream)((data[0] >> 6) & 0x03);
+		bbheader->is_single_input_stream = (u8) ((data[0] >> 5) & 0x01);
+		bbheader->is_constant_coding_modulation =
+		    (u8) ((data[0] >> 4) & 0x01);
+		bbheader->issy_indicator = (u8) ((data[0] >> 3) & 0x01);
+		bbheader->null_packet_deletion = (u8) ((data[0] >> 2) & 0x01);
+		bbheader->ext = (u8) (data[0] & 0x03);
+
+		bbheader->input_stream_identifier = data[1];
+		bbheader->plp_mode =
+		    (data[3] & 0x01) ? CXD2880_DVBT2_PLP_MODE_HEM :
+		    CXD2880_DVBT2_PLP_MODE_NM;
+		bbheader->data_field_length = (u16) ((data[4] << 8) | data[5]);
+
+		if (bbheader->plp_mode == CXD2880_DVBT2_PLP_MODE_NM) {
+			bbheader->user_packet_length =
+			    (u16) ((data[6] << 8) | data[7]);
+			bbheader->sync_byte = data[8];
+			bbheader->issy = 0;
+		} else {
+			bbheader->user_packet_length = 0;
+			bbheader->sync_byte = 0;
+			bbheader->issy =
+			    (u32) ((data[11] << 16) | (data[12] << 8) |
+				   data[13]);
+		}
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_in_bandb_ts_rate(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum
+						   cxd2880_dvbt2_plp_btype
+						   type,
+						   u32 *ts_rate_bps)
+{
+
+	if ((!tnr_dmd) || (!ts_rate_bps))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		enum cxd2880_ret ret = CXD2880_RESULT_OK;
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return ret;
+		}
+
+		if (!ts_lock) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		u8 l1_post_ok = 0;
+		u8 addr = 0;
+		u8 data = 0;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x86,
+					   &l1_post_ok,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!(l1_post_ok & 0x01)) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (type == CXD2880_DVBT2_PLP_COMMON)
+			addr = 0xBA;
+		else
+			addr = 0xA7;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, addr, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if ((data & 0x80) == 0x00) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x25) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+		u8 data[4];
+		u8 addr = 0;
+
+		if (type == CXD2880_DVBT2_PLP_COMMON)
+			addr = 0xA6;
+		else
+			addr = 0xAA;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, addr, &data[0],
+					   4) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		*ts_rate_bps =
+		    (u32) (((data[0] & 0x07) << 24) | (data[1] << 16) |
+			   (data[2] << 8) | data[3]);
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(struct cxd2880_tnrdmd
+						 *tnr_dmd,
+						 enum
+						 cxd2880_tnrdmd_spectrum_sense
+						 *sense)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u8 sync_state = 0;
+	u8 ts_lock = 0;
+	u8 early_unlock = 0;
+
+	if ((!tnr_dmd) || (!sense))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state, &ts_lock,
+					       &early_unlock);
+	if (ret != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return ret;
+	}
+
+	if (sync_state != 6) {
+		slvt_unfreeze_reg(tnr_dmd);
+
+		ret = CXD2880_RESULT_ERROR_HW_STATE;
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+			ret =
+			    cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(
+				tnr_dmd->diver_sub, sense);
+
+		return ret;
+	}
+
+	{
+		u8 data = 0;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x2F, &data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		*sense =
+		    (data & 0x01) ? CXD2880_TNRDMD_SPECTRUM_INV :
+		    CXD2880_TNRDMD_SPECTRUM_NORMAL;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret dvbt2_read_snr_reg(struct cxd2880_tnrdmd *tnr_dmd,
+					   u16 *reg_value)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!reg_value))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	{
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+		u8 data[2];
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (sync_state != 6) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x13, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		*reg_value = (data[0] << 8) | data[1];
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt2_calc_snr(struct cxd2880_tnrdmd *tnr_dmd,
+				       u32 reg_value, int *snr)
+{
+
+	if ((!tnr_dmd) || (!snr))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (reg_value == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (reg_value > 10876)
+		reg_value = 10876;
+
+	*snr =
+	    10 * 10 * ((int)cxd2880_math_log10(reg_value) -
+		       (int)cxd2880_math_log10(12600 - reg_value));
+	*snr += 32000;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
+					      int *snr)
+{
+	u16 reg_value = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!snr))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	*snr = -1000 * 1000;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
+		ret = dvbt2_read_snr_reg(tnr_dmd, &reg_value);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret = dvbt2_calc_snr(tnr_dmd, reg_value, snr);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	} else {
+		int snr_main = 0;
+		int snr_sub = 0;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_snr_diver(tnr_dmd, snr, &snr_main,
+						       &snr_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_snr_diver(struct cxd2880_tnrdmd
+						    *tnr_dmd, int *snr,
+						    int *snr_main, int *snr_sub)
+{
+	u16 reg_value = 0;
+	u32 reg_value_sum = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!snr) || (!snr_main) || (!snr_sub))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	*snr = -1000 * 1000;
+	*snr_main = -1000 * 1000;
+	*snr_sub = -1000 * 1000;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = dvbt2_read_snr_reg(tnr_dmd, &reg_value);
+	if (ret == CXD2880_RESULT_OK) {
+		ret = dvbt2_calc_snr(tnr_dmd, reg_value, snr_main);
+		if (ret != CXD2880_RESULT_OK)
+			reg_value = 0;
+	} else if (ret == CXD2880_RESULT_ERROR_HW_STATE) {
+		reg_value = 0;
+	} else {
+		return ret;
+	}
+
+	reg_value_sum += reg_value;
+
+	ret = dvbt2_read_snr_reg(tnr_dmd->diver_sub, &reg_value);
+	if (ret == CXD2880_RESULT_OK) {
+		ret = dvbt2_calc_snr(tnr_dmd->diver_sub, reg_value, snr_sub);
+		if (ret != CXD2880_RESULT_OK)
+			reg_value = 0;
+	} else if (ret == CXD2880_RESULT_ERROR_HW_STATE) {
+		reg_value = 0;
+	} else {
+		return ret;
+	}
+
+	reg_value_sum += reg_value;
+
+	ret = dvbt2_calc_snr(tnr_dmd, reg_value_sum, snr);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_pre_ldpcber(struct cxd2880_tnrdmd
+						      *tnr_dmd, u32 *ber)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u32 bit_error = 0;
+	u32 period_exp = 0;
+	u32 n_ldpc = 0;
+
+	if ((!tnr_dmd) || (!ber))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	{
+
+		u8 data[5];
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x3C, data,
+					   sizeof(data)) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!(data[0] & 0x01)) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		bit_error =
+		    ((data[1] & 0x0F) << 24) | (data[2] << 16) | (data[3] << 8)
+		    | data[4];
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xA0, data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (((enum cxd2880_dvbt2_plp_fec)(data[0] & 0x03)) ==
+		    CXD2880_DVBT2_FEC_LDPC_16K)
+			n_ldpc = 16200;
+		else
+			n_ldpc = 64800;
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x20) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x6F, data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		period_exp = data[0] & 0x0F;
+	}
+
+	if (bit_error > ((1U << period_exp) * n_ldpc))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		if (period_exp >= 4) {
+
+			div = (1U << (period_exp - 4)) * (n_ldpc / 200);
+
+			Q = (bit_error * 5) / div;
+			R = (bit_error * 5) % div;
+
+			R *= 625;
+			Q = Q * 625 + R / div;
+			R = R % div;
+		} else {
+
+			div = (1U << period_exp) * (n_ldpc / 200);
+
+			Q = (bit_error * 10) / div;
+			R = (bit_error * 10) % div;
+
+			R *= 5000;
+			Q = Q * 5000 + R / div;
+			R = R % div;
+		}
+
+		if (div / 2 <= R)
+			*ber = Q + 1;
+		else
+			*ber = Q;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_post_bchfer(struct cxd2880_tnrdmd
+						      *tnr_dmd, u32 *fer)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u32 fec_error = 0;
+	u32 period = 0;
+
+	if ((!tnr_dmd) || (!fer))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data[2];
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x1B, data,
+					   2) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (!(data[0] & 0x80))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		fec_error = ((data[0] & 0x7F) << 8) | (data[1]);
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x20) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x72, data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		period = (1 << (data[0] & 0x0F));
+	}
+
+	if ((period == 0) || (fec_error > period))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		div = period;
+
+		Q = (fec_error * 1000) / div;
+		R = (fec_error * 1000) % div;
+
+		R *= 1000;
+		Q = Q * 1000 + R / div;
+		R = R % div;
+
+		if ((div != 1) && (div / 2 <= R))
+			*fer = Q + 1;
+		else
+			*fer = Q;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_pre_bchber(struct cxd2880_tnrdmd
+						     *tnr_dmd, u32 *ber)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u32 bit_error = 0;
+	u32 period_exp = 0;
+	u32 n_bch = 0;
+
+	if ((!tnr_dmd) || (!ber))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[3];
+		enum cxd2880_dvbt2_plp_fec plp_fec_type =
+		    CXD2880_DVBT2_FEC_LDPC_16K;
+		enum cxd2880_dvbt2_plp_code_rate plp_cr = CXD2880_DVBT2_R1_2;
+
+		static const u16 n_bch_bits_lookup[2][8] = {
+			{7200, 9720, 10800, 11880, 12600, 13320, 5400, 6480},
+			{32400, 38880, 43200, 48600, 51840, 54000, 21600, 25920}
+		};
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x15, data,
+					   3) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!(data[0] & 0x40)) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		bit_error = ((data[0] & 0x3F) << 16) | (data[1] << 8) | data[2];
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x9D, data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		plp_cr = (enum cxd2880_dvbt2_plp_code_rate)(data[0] & 0x07);
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xA0, data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		plp_fec_type = (enum cxd2880_dvbt2_plp_fec)(data[0] & 0x03);
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x20) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x72, data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		period_exp = data[0] & 0x0F;
+
+		if ((plp_fec_type > CXD2880_DVBT2_FEC_LDPC_64K)
+		    || (plp_cr > CXD2880_DVBT2_R2_5))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		n_bch = n_bch_bits_lookup[plp_fec_type][plp_cr];
+	}
+
+	if (bit_error > ((1U << period_exp) * n_bch))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		if (period_exp >= 6) {
+
+			div = (1U << (period_exp - 6)) * (n_bch / 40);
+
+			Q = (bit_error * 625) / div;
+			R = (bit_error * 625) % div;
+
+			R *= 625;
+			Q = Q * 625 + R / div;
+			R = R % div;
+		} else {
+
+			div = (1U << period_exp) * (n_bch / 40);
+
+			Q = (bit_error * 1000) / div;
+			R = (bit_error * 1000) % div;
+
+			R *= 25000;
+			Q = Q * 25000 + R / div;
+			R = R % div;
+		}
+
+		if (div / 2 <= R)
+			*ber = Q + 1;
+		else
+			*ber = Q;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_packet_error_number(struct
+							      cxd2880_tnrdmd
+							      *tnr_dmd,
+							      u32 *pen)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	u8 data[3];
+
+	if ((!tnr_dmd) || (!pen))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x39, data,
+				   sizeof(data)) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (!(data[0] & 0x01))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	*pen = ((data[1] << 8) | data[2]);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sampling_offset(struct cxd2880_tnrdmd
+							  *tnr_dmd, int *ppm)
+{
+
+	if ((!tnr_dmd) || (!ppm))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 ctl_val_reg[5];
+		u8 nominal_rate_reg[5];
+		u32 trl_ctl_val = 0;
+		u32 trcg_nominal_rate = 0;
+		int num;
+		int den;
+		enum cxd2880_ret ret = CXD2880_RESULT_OK;
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+		s8 diff_upper = 0;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (sync_state != 6) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x34,
+					   ctl_val_reg,
+					   sizeof(ctl_val_reg)) !=
+		    CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x04) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x10,
+					   nominal_rate_reg,
+					   sizeof(nominal_rate_reg)) !=
+		    CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		diff_upper =
+		    (ctl_val_reg[0] & 0x7F) - (nominal_rate_reg[0] & 0x7F);
+
+		if ((diff_upper < -1) || (diff_upper > 1))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		trl_ctl_val = ctl_val_reg[1] << 24;
+		trl_ctl_val |= ctl_val_reg[2] << 16;
+		trl_ctl_val |= ctl_val_reg[3] << 8;
+		trl_ctl_val |= ctl_val_reg[4];
+
+		trcg_nominal_rate = nominal_rate_reg[1] << 24;
+		trcg_nominal_rate |= nominal_rate_reg[2] << 16;
+		trcg_nominal_rate |= nominal_rate_reg[3] << 8;
+		trcg_nominal_rate |= nominal_rate_reg[4];
+
+		trl_ctl_val >>= 1;
+		trcg_nominal_rate >>= 1;
+
+		if (diff_upper == 1)
+			num =
+			    (int)((trl_ctl_val + 0x80000000u) -
+				  trcg_nominal_rate);
+		else if (diff_upper == -1)
+			num =
+			    -(int)((trcg_nominal_rate + 0x80000000u) -
+				   trl_ctl_val);
+		else
+			num = (int)(trl_ctl_val - trcg_nominal_rate);
+
+		den = (nominal_rate_reg[0] & 0x7F) << 24;
+		den |= nominal_rate_reg[1] << 16;
+		den |= nominal_rate_reg[2] << 8;
+		den |= nominal_rate_reg[3];
+		den = (den + (390625 / 2)) / 390625;
+
+		den >>= 1;
+
+		if (num >= 0)
+			*ppm = (num + (den / 2)) / den;
+		else
+			*ppm = (num - (den / 2)) / den;
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sampling_offset_sub(struct
+							      cxd2880_tnrdmd
+							      *tnr_dmd,
+							      int *ppm)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ppm))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_dvbt2_mon_sampling_offset(tnr_dmd->diver_sub, ppm);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_quality(struct cxd2880_tnrdmd
+						  *tnr_dmd, u8 *quality)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	int snr = 0;
+	int snr_rel = 0;
+	u32 ber = 0;
+	u32 ber_sqi = 0;
+	enum cxd2880_dvbt2_plp_constell qam;
+	enum cxd2880_dvbt2_plp_code_rate code_rate;
+
+	static const int snr_nordig_p1_db_1000[4][8] = {
+		{3500, 4700, 5600, 6600, 7200, 7700, 1300, 2200},
+		{8700, 10100, 11400, 12500, 13300, 13800, 6000, 7200},
+		{13000, 14800, 16200, 17700, 18700, 19400, 9800, 11100},
+		{17000, 19400, 20800, 22900, 24300, 25100, 13200, 14800},
+	};
+
+	if ((!tnr_dmd) || (!quality))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_tnrdmd_dvbt2_mon_pre_bchber(tnr_dmd, &ber);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = cxd2880_tnrdmd_dvbt2_mon_snr(tnr_dmd, &snr);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_qam(tnr_dmd, CXD2880_DVBT2_PLP_DATA, &qam);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_code_rate(tnr_dmd, CXD2880_DVBT2_PLP_DATA,
+					       &code_rate);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if ((code_rate > CXD2880_DVBT2_R2_5) || (qam > CXD2880_DVBT2_QAM256))
+		return CXD2880_RESULT_ERROR_OTHER;
+
+	if (ber > 100000)
+		ber_sqi = 0;
+	else if (ber >= 100)
+		ber_sqi = 6667;
+	else
+		ber_sqi = 16667;
+
+	snr_rel = snr - snr_nordig_p1_db_1000[qam][code_rate];
+
+	if (snr_rel < -3000) {
+		*quality = 0;
+	} else if (snr_rel <= 3000) {
+		u32 temp_sqi =
+		    (((snr_rel + 3000) * ber_sqi) + 500000) / 1000000;
+		*quality = (temp_sqi > 100) ? 100 : (u8) temp_sqi;
+	} else {
+		*quality = 100;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ts_rate(struct cxd2880_tnrdmd
+						  *tnr_dmd, u32 *ts_rate_kbps)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u32 rd_smooth_dp = 0;
+	u32 ep_ck_nume = 0;
+	u32 ep_ck_deno = 0;
+	u8 issy_on_data = 0;
+
+	if ((!tnr_dmd) || (!ts_rate_kbps))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 data[12];
+		u8 sync_state = 0;
+		u8 ts_lock = 0;
+		u8 unlock_detected = 0;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
+						       &ts_lock,
+						       &unlock_detected);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (!ts_lock) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x23, data,
+					   12) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		rd_smooth_dp = (u32) ((data[0] & 0x1F) << 24);
+		rd_smooth_dp |= (u32) (data[1] << 16);
+		rd_smooth_dp |= (u32) (data[2] << 8);
+		rd_smooth_dp |= (u32) data[3];
+
+		if (rd_smooth_dp < 214958) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		ep_ck_nume = (u32) ((data[4] & 0x3F) << 24);
+		ep_ck_nume |= (u32) (data[5] << 16);
+		ep_ck_nume |= (u32) (data[6] << 8);
+		ep_ck_nume |= (u32) data[7];
+
+		ep_ck_deno = (u32) ((data[8] & 0x3F) << 24);
+		ep_ck_deno |= (u32) (data[9] << 16);
+		ep_ck_deno |= (u32) (data[10] << 8);
+		ep_ck_deno |= (u32) data[11];
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x41, data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		issy_on_data = data[0] & 0x01;
+
+		slvt_unfreeze_reg(tnr_dmd);
+	}
+
+	if (issy_on_data) {
+		if ((ep_ck_deno == 0) || (ep_ck_nume == 0)
+		    || (ep_ck_deno >= ep_ck_nume))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	{
+		u32 ick_x100;
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		switch (tnr_dmd->clk_mode) {
+		case CXD2880_TNRDMD_CLOCKMODE_A:
+			ick_x100 = 8228;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_B:
+			ick_x100 = 9330;
+			break;
+		case CXD2880_TNRDMD_CLOCKMODE_C:
+			ick_x100 = 9600;
+			break;
+		default:
+			return CXD2880_RESULT_ERROR_SW_STATE;
+		}
+
+		div = rd_smooth_dp;
+
+		Q = ick_x100 * 262144U / div;
+		R = ick_x100 * 262144U % div;
+
+		R *= 5U;
+		Q = Q * 5 + R / div;
+		R = R % div;
+
+		R *= 2U;
+		Q = Q * 2 + R / div;
+		R = R % div;
+
+		if (div / 2 <= R)
+			*ts_rate_kbps = Q + 1;
+		else
+			*ts_rate_kbps = Q;
+	}
+
+	if (issy_on_data) {
+
+		u32 diff = ep_ck_nume - ep_ck_deno;
+
+		while (diff > 0x7FFF) {
+			diff >>= 1;
+			ep_ck_nume >>= 1;
+		}
+
+		*ts_rate_kbps -=
+		    (*ts_rate_kbps * diff + ep_ck_nume / 2) / ep_ck_nume;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
+					      u32 *per)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	u32 packet_error = 0;
+	u32 period = 0;
+
+	if (!tnr_dmd || !per)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 rdata[3];
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0B) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x18, rdata,
+					   3) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if ((rdata[0] & 0x01) == 0)
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		packet_error = (rdata[1] << 8) | rdata[2];
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x24) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xDC, rdata,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		period = 1U << (rdata[0] & 0x0F);
+	}
+
+	if ((period == 0) || (packet_error > period))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		div = period;
+
+		Q = (packet_error * 1000) / div;
+		R = (packet_error * 1000) % div;
+
+		R *= 1000;
+		Q = Q * 1000 + R / div;
+		R = R % div;
+
+		if ((div != 1) && (div / 2 <= R))
+			*per = Q + 1;
+		else
+			*per = Q;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_qam(struct cxd2880_tnrdmd *tnr_dmd,
+					      enum cxd2880_dvbt2_plp_btype type,
+					      enum cxd2880_dvbt2_plp_constell
+					      *qam)
+{
+	u8 data;
+	u8 l1_post_ok = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!qam))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x86, &l1_post_ok,
+				   1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (!(l1_post_ok & 0x01)) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	if (type == CXD2880_DVBT2_PLP_COMMON) {
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xB6, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (data == 0) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xB1, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+	} else {
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x9E, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	*qam = (enum cxd2880_dvbt2_plp_constell)(data & 0x07);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_code_rate(struct cxd2880_tnrdmd
+						    *tnr_dmd,
+						    enum cxd2880_dvbt2_plp_btype
+						    type,
+						    enum
+						    cxd2880_dvbt2_plp_code_rate
+						    *code_rate)
+{
+	u8 data;
+	u8 l1_post_ok = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!code_rate))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x86, &l1_post_ok,
+				   1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (!(l1_post_ok & 0x01)) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	if (type == CXD2880_DVBT2_PLP_COMMON) {
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xB6, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (data == 0) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_HW_STATE;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0xB0, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+	} else {
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x9D, &data,
+					   1) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	*code_rate = (enum cxd2880_dvbt2_plp_code_rate)(data & 0x07);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_profile(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dvbt2_profile
+						  *profile)
+{
+
+	if ((!tnr_dmd) || (!profile))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0B) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	{
+		u8 data;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x22, &data,
+					   sizeof(data)) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (data & 0x02) {
+			if (data & 0x01)
+				*profile = CXD2880_DVBT2_PROFILE_LITE;
+			else
+				*profile = CXD2880_DVBT2_PROFILE_BASE;
+		} else {
+			enum cxd2880_ret ret = CXD2880_RESULT_ERROR_HW_STATE;
+
+			if (tnr_dmd->diver_mode ==
+			    CXD2880_TNRDMD_DIVERMODE_MAIN)
+				ret =
+				    cxd2880_tnrdmd_dvbt2_mon_profile(
+					tnr_dmd->diver_sub, profile);
+
+			return ret;
+		}
+	}
+
+	return CXD2880_RESULT_OK;
+}
+
+static enum cxd2880_ret dvbt2_calc_sdi(struct cxd2880_tnrdmd *tnr_dmd,
+				       int rf_lvl, u8 *ssi)
+{
+	enum cxd2880_dvbt2_plp_constell qam;
+	enum cxd2880_dvbt2_plp_code_rate code_rate;
+	int prel;
+	int temp_ssi = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	static const int ref_dbm_1000[4][8] = {
+		{-96000, -95000, -94000, -93000, -92000, -92000, -98000,
+		 -97000},
+		{-91000, -89000, -88000, -87000, -86000, -86000, -93000,
+		 -92000},
+		{-86000, -85000, -83000, -82000, -81000, -80000, -89000,
+		 -88000},
+		{-82000, -80000, -78000, -76000, -75000, -74000, -86000,
+		 -84000},
+	};
+
+	if ((!tnr_dmd) || (!ssi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_qam(tnr_dmd, CXD2880_DVBT2_PLP_DATA, &qam);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt2_mon_code_rate(tnr_dmd, CXD2880_DVBT2_PLP_DATA,
+					       &code_rate);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if ((code_rate > CXD2880_DVBT2_R2_5) || (qam > CXD2880_DVBT2_QAM256))
+		return CXD2880_RESULT_ERROR_OTHER;
+
+	prel = rf_lvl - ref_dbm_1000[qam][code_rate];
+
+	if (prel < -15000)
+		temp_ssi = 0;
+	else if (prel < 0)
+		temp_ssi = ((2 * (prel + 15000)) + 1500) / 3000;
+	else if (prel < 20000)
+		temp_ssi = (((4 * prel) + 500) / 1000) + 10;
+	else if (prel < 35000)
+		temp_ssi = (((2 * (prel - 20000)) + 1500) / 3000) + 90;
+	else
+		temp_ssi = 100;
+
+	*ssi = (temp_ssi > 100) ? 100 : (u8) temp_ssi;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
+					      u8 *ssi)
+{
+	int rf_lvl = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ssi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd, &rf_lvl);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt2_calc_sdi(tnr_dmd, rf_lvl, ssi);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ssi_sub(struct cxd2880_tnrdmd
+						  *tnr_dmd, u8 *ssi)
+{
+	int rf_lvl = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ssi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd->diver_sub, &rf_lvl);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt2_calc_sdi(tnr_dmd, rf_lvl, ssi);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
new file mode 100644
index 0000000..7434d69
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
@@ -0,0 +1,170 @@
+/*
+ * cxd2880_tnrdmd_dvbt2_mon.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T2 monitor interface
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_TNRDMD_DVBT2_MON_H
+#define CXD2880_TNRDMD_DVBT2_MON_H
+
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_dvbt2.h"
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sync_stat(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 *sync_stat,
+						    u8 *ts_lock_stat,
+						    u8 *unlock_detected);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub(struct cxd2880_tnrdmd
+							*tnr_dmd,
+							u8 *sync_stat,
+							u8 *unlock_detected);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_carrier_offset(struct cxd2880_tnrdmd
+							 *tnr_dmd, int *offset);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_carrier_offset_sub(struct
+							     cxd2880_tnrdmd
+							     *tnr_dmd,
+							     int *offset);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_l1_pre(struct cxd2880_tnrdmd *tnr_dmd,
+						 struct cxd2880_dvbt2_l1pre
+						 *l1_pre);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_version(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dvbt2_version
+						  *ver);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ofdm(struct cxd2880_tnrdmd *tnr_dmd,
+					       struct cxd2880_dvbt2_ofdm *ofdm);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_data_plps(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 *plp_ids,
+						    u8 *num_plps);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_active_plp(struct cxd2880_tnrdmd
+						     *tnr_dmd,
+						     enum
+						     cxd2880_dvbt2_plp_btype
+						     type,
+						     struct cxd2880_dvbt2_plp
+						     *plp_info);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_data_plp_error(struct cxd2880_tnrdmd
+							 *tnr_dmd,
+							 u8 *plp_error);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_l1_change(struct cxd2880_tnrdmd
+						    *tnr_dmd, u8 *l1_change);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_l1_post(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  struct cxd2880_dvbt2_l1post
+						  *l1_post);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_bbheader(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum cxd2880_dvbt2_plp_btype
+						   type,
+						   struct cxd2880_dvbt2_bbheader
+						   *bbheader);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_in_bandb_ts_rate(struct cxd2880_tnrdmd
+						   *tnr_dmd,
+						   enum
+						   cxd2880_dvbt2_plp_btype
+						   type,
+						   u32 *ts_rate_bps);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(struct cxd2880_tnrdmd
+						 *tnr_dmd,
+						 enum
+						 cxd2880_tnrdmd_spectrum_sense
+						 *sense);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
+					      int *snr);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_snr_diver(struct cxd2880_tnrdmd
+						    *tnr_dmd, int *snr,
+						    int *snr_main,
+						    int *snr_sub);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_pre_ldpcber(struct cxd2880_tnrdmd
+						      *tnr_dmd, u32 *ber);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_post_bchfer(struct cxd2880_tnrdmd
+						      *tnr_dmd, u32 *fer);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_pre_bchber(struct cxd2880_tnrdmd
+						     *tnr_dmd, u32 *ber);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_packet_error_number(struct
+							      cxd2880_tnrdmd
+							      *tnr_dmd,
+							      u32 *pen);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sampling_offset(struct cxd2880_tnrdmd
+							  *tnr_dmd, int *ppm);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_sampling_offset_sub(struct
+							      cxd2880_tnrdmd
+							      *tnr_dmd,
+							      int *ppm);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ts_rate(struct cxd2880_tnrdmd
+						  *tnr_dmd, u32 *ts_rate_kbps);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_quality(struct cxd2880_tnrdmd
+						  *tnr_dmd, u8 *quality);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
+					      u32 *per);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_qam(struct cxd2880_tnrdmd *tnr_dmd,
+					      enum cxd2880_dvbt2_plp_btype type,
+					      enum cxd2880_dvbt2_plp_constell
+					      *qam);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_code_rate(struct cxd2880_tnrdmd
+						    *tnr_dmd,
+						    enum cxd2880_dvbt2_plp_btype
+						    type,
+						    enum
+						    cxd2880_dvbt2_plp_code_rate
+						    *code_rate);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_profile(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  enum cxd2880_dvbt2_profile
+						  *profile);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
+					      u8 *ssi);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt2_mon_ssi_sub(struct cxd2880_tnrdmd
+						  *tnr_dmd, u8 *ssi);
+
+#endif
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
new file mode 100644
index 0000000..7c7fc30
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
@@ -0,0 +1,1192 @@
+/*
+ * cxd2880_tnrdmd_dvbt_mon.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T monitor functions
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_tnrdmd_dvbt.h"
+#include "cxd2880_tnrdmd_dvbt_mon.h"
+#include "cxd2880_math.h"
+
+static enum cxd2880_ret is_tps_locked(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sync_stat(struct cxd2880_tnrdmd
+						   *tnr_dmd, u8 *sync_stat,
+						   u8 *ts_lock_stat,
+						   u8 *unlock_detected)
+{
+	u8 rdata = 0x00;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!sync_stat) || (!ts_lock_stat) || (!unlock_detected))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x10, &rdata,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	*unlock_detected = (u8) ((rdata & 0x10) ? 1 : 0);
+	*sync_stat = (u8) (rdata & 0x07);
+	*ts_lock_stat = (u8) ((rdata & 0x20) ? 1 : 0);
+
+	if (*sync_stat == 0x07)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sync_stat_sub(struct cxd2880_tnrdmd
+						       *tnr_dmd, u8 *sync_stat,
+						       u8 *unlock_detected)
+{
+	u8 ts_lock_stat = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!sync_stat) || (!unlock_detected))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt_mon_sync_stat(tnr_dmd->diver_sub, sync_stat,
+					      &ts_lock_stat, unlock_detected);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_mode_guard(struct cxd2880_tnrdmd
+						    *tnr_dmd,
+						    enum cxd2880_dvbt_mode
+						    *mode,
+						    enum cxd2880_dvbt_guard
+						    *guard)
+{
+	u8 rdata = 0x00;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!mode) || (!guard))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret = is_tps_locked(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+			ret =
+			    cxd2880_tnrdmd_dvbt_mon_mode_guard(
+					tnr_dmd->diver_sub, mode, guard);
+
+		return ret;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x1B, &rdata,
+				   1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	*mode = (enum cxd2880_dvbt_mode)((rdata >> 2) & 0x03);
+	*guard = (enum cxd2880_dvbt_guard)(rdata & 0x03);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_carrier_offset(struct cxd2880_tnrdmd
+							*tnr_dmd, int *offset)
+{
+	u8 rdata[4];
+	u32 ctl_val = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!offset))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret = is_tps_locked(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return ret;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x1D, rdata,
+				   4) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	ctl_val =
+	    ((rdata[0] & 0x1F) << 24) | (rdata[1] << 16) | (rdata[2] << 8) |
+	    (rdata[3]);
+	*offset = cxd2880_convert2s_complement(ctl_val, 29);
+	*offset = -1 * ((*offset) * (u8) tnr_dmd->bandwidth / 235);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_carrier_offset_sub(struct
+							    cxd2880_tnrdmd
+							    *tnr_dmd,
+							    int *offset)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!offset))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt_mon_carrier_offset(tnr_dmd->diver_sub, offset);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_pre_viterbiber(struct cxd2880_tnrdmd
+							*tnr_dmd, u32 *ber)
+{
+	u8 rdata[2];
+	u32 bit_error = 0;
+	u32 period = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ber))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x10) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x39, rdata,
+				   1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if ((rdata[0] & 0x01) == 0) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_HW_STATE;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x22, rdata,
+				   2) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	bit_error = (rdata[0] << 8) | rdata[1];
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x6F, rdata,
+				   1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	period = ((rdata[0] & 0x07) == 0) ? 256 : (0x1000 << (rdata[0] & 0x07));
+
+	if ((period == 0) || (bit_error > period))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		div = period / 128;
+
+		Q = (bit_error * 3125) / div;
+		R = (bit_error * 3125) % div;
+
+		R *= 25;
+		Q = Q * 25 + R / div;
+		R = R % div;
+
+		if (div / 2 <= R)
+			*ber = Q + 1;
+		else
+			*ber = Q;
+	}
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_pre_rsber(struct cxd2880_tnrdmd
+						   *tnr_dmd, u32 *ber)
+{
+	u8 rdata[3];
+	u32 bit_error = 0;
+	u32 period_exp = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ber))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x15, rdata,
+				   3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if ((rdata[0] & 0x40) == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	bit_error = ((rdata[0] & 0x3F) << 16) | (rdata[1] << 8) | rdata[2];
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x60, rdata,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	period_exp = (rdata[0] & 0x1F);
+
+	if ((period_exp <= 11) && (bit_error > (1U << period_exp) * 204 * 8))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		if (period_exp <= 8)
+			div = (1U << period_exp) * 51;
+		else
+			div = (1U << 8) * 51;
+
+		Q = (bit_error * 250) / div;
+		R = (bit_error * 250) % div;
+
+		R *= 1250;
+		Q = Q * 1250 + R / div;
+		R = R % div;
+
+		if (period_exp > 8) {
+			*ber =
+			    (Q + (1 << (period_exp - 9))) >> (period_exp - 8);
+		} else {
+			if (div / 2 <= R)
+				*ber = Q + 1;
+			else
+				*ber = Q;
+		}
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_tps_info(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  struct cxd2880_dvbt_tpsinfo
+						  *info)
+{
+	u8 rdata[7];
+	u8 cell_id_ok = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!info))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret = is_tps_locked(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+			ret =
+			    cxd2880_tnrdmd_dvbt_mon_tps_info(tnr_dmd->diver_sub,
+							     info);
+
+		return ret;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x29, rdata,
+				   7) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x11) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0xD5, &cell_id_ok,
+				   1) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	info->constellation =
+	    (enum cxd2880_dvbt_constellation)((rdata[0] >> 6) & 0x03);
+	info->hierarchy = (enum cxd2880_dvbt_hierarchy)((rdata[0] >> 3) & 0x07);
+	info->rate_hp = (enum cxd2880_dvbt_coderate)(rdata[0] & 0x07);
+	info->rate_lp = (enum cxd2880_dvbt_coderate)((rdata[1] >> 5) & 0x07);
+	info->guard = (enum cxd2880_dvbt_guard)((rdata[1] >> 3) & 0x03);
+	info->mode = (enum cxd2880_dvbt_mode)((rdata[1] >> 1) & 0x03);
+	info->fnum = (rdata[2] >> 6) & 0x03;
+	info->length_indicator = rdata[2] & 0x3F;
+	info->cell_id = (u16) ((rdata[3] << 8) | rdata[4]);
+	info->reserved_even = rdata[5] & 0x3F;
+	info->reserved_odd = rdata[6] & 0x3F;
+
+	info->cell_id_ok = cell_id_ok & 0x01;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_packet_error_number(struct
+							     cxd2880_tnrdmd
+							     *tnr_dmd,
+							     u32 *pen)
+{
+	u8 rdata[3];
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!pen))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x26, rdata,
+				   3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (!(rdata[0] & 0x01))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	*pen = (rdata[1] << 8) | rdata[2];
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_spectrum_sense(struct cxd2880_tnrdmd
+						*tnr_dmd,
+						enum
+						cxd2880_tnrdmd_spectrum_sense
+						*sense)
+{
+	u8 data = 0;
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!sense))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret = is_tps_locked(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+
+		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
+			ret =
+				cxd2880_tnrdmd_dvbt_mon_spectrum_sense(
+					tnr_dmd->diver_sub, sense);
+
+		return ret;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x1C, &data,
+				   sizeof(data)) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	*sense =
+	    (data & 0x01) ? CXD2880_TNRDMD_SPECTRUM_INV :
+	    CXD2880_TNRDMD_SPECTRUM_NORMAL;
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt_read_snr_reg(struct cxd2880_tnrdmd *tnr_dmd,
+					  u16 *reg_value)
+{
+	u8 rdata[2];
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!reg_value))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	ret = is_tps_locked(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return ret;
+	}
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x13, rdata,
+				   2) != CXD2880_RESULT_OK) {
+		slvt_unfreeze_reg(tnr_dmd);
+		return CXD2880_RESULT_ERROR_IO;
+	}
+
+	slvt_unfreeze_reg(tnr_dmd);
+
+	*reg_value = (rdata[0] << 8) | rdata[1];
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt_calc_snr(struct cxd2880_tnrdmd *tnr_dmd,
+				      u32 reg_value, int *snr)
+{
+
+	if ((!tnr_dmd) || (!snr))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (reg_value == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	if (reg_value > 4996)
+		reg_value = 4996;
+
+	*snr =
+	    10 * 10 * ((int)cxd2880_math_log10(reg_value) -
+		       (int)cxd2880_math_log10(5350 - reg_value));
+	*snr += 28500;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
+					     int *snr)
+{
+	u16 reg_value = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!snr))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	*snr = -1000 * 1000;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
+		ret = dvbt_read_snr_reg(tnr_dmd, &reg_value);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret = dvbt_calc_snr(tnr_dmd, reg_value, snr);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	} else {
+		int snr_main = 0;
+		int snr_sub = 0;
+
+		ret =
+		    cxd2880_tnrdmd_dvbt_mon_snr_diver(tnr_dmd, snr, &snr_main,
+						      &snr_sub);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_snr_diver(struct cxd2880_tnrdmd
+						   *tnr_dmd, int *snr,
+						   int *snr_main, int *snr_sub)
+{
+	u16 reg_value = 0;
+	u32 reg_value_sum = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!snr) || (!snr_main) || (!snr_sub))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	*snr = -1000 * 1000;
+	*snr_main = -1000 * 1000;
+	*snr_sub = -1000 * 1000;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = dvbt_read_snr_reg(tnr_dmd, &reg_value);
+	if (ret == CXD2880_RESULT_OK) {
+		ret = dvbt_calc_snr(tnr_dmd, reg_value, snr_main);
+		if (ret != CXD2880_RESULT_OK)
+			reg_value = 0;
+	} else if (ret == CXD2880_RESULT_ERROR_HW_STATE) {
+		reg_value = 0;
+	} else {
+		return ret;
+	}
+
+	reg_value_sum += reg_value;
+
+	ret = dvbt_read_snr_reg(tnr_dmd->diver_sub, &reg_value);
+	if (ret == CXD2880_RESULT_OK) {
+		ret = dvbt_calc_snr(tnr_dmd->diver_sub, reg_value, snr_sub);
+		if (ret != CXD2880_RESULT_OK)
+			reg_value = 0;
+	} else if (ret == CXD2880_RESULT_ERROR_HW_STATE) {
+		reg_value = 0;
+	} else {
+		return ret;
+	}
+
+	reg_value_sum += reg_value;
+
+	ret = dvbt_calc_snr(tnr_dmd, reg_value_sum, snr);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sampling_offset(struct cxd2880_tnrdmd
+							 *tnr_dmd, int *ppm)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ppm))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	{
+		u8 ctl_val_reg[5];
+		u8 nominal_rate_reg[5];
+		u32 trl_ctl_val = 0;
+		u32 trcg_nominal_rate = 0;
+		int num;
+		int den;
+		s8 diff_upper = 0;
+
+		if (slvt_freeze_reg(tnr_dmd) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		ret = is_tps_locked(tnr_dmd);
+		if (ret != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return ret;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x0D) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x21,
+					   ctl_val_reg,
+					   sizeof(ctl_val_reg)) !=
+		    CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x04) != CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x60,
+					   nominal_rate_reg,
+					   sizeof(nominal_rate_reg)) !=
+		    CXD2880_RESULT_OK) {
+			slvt_unfreeze_reg(tnr_dmd);
+			return CXD2880_RESULT_ERROR_IO;
+		}
+
+		slvt_unfreeze_reg(tnr_dmd);
+
+		diff_upper =
+		    (ctl_val_reg[0] & 0x7F) - (nominal_rate_reg[0] & 0x7F);
+
+		if ((diff_upper < -1) || (diff_upper > 1))
+			return CXD2880_RESULT_ERROR_HW_STATE;
+
+		trl_ctl_val = ctl_val_reg[1] << 24;
+		trl_ctl_val |= ctl_val_reg[2] << 16;
+		trl_ctl_val |= ctl_val_reg[3] << 8;
+		trl_ctl_val |= ctl_val_reg[4];
+
+		trcg_nominal_rate = nominal_rate_reg[1] << 24;
+		trcg_nominal_rate |= nominal_rate_reg[2] << 16;
+		trcg_nominal_rate |= nominal_rate_reg[3] << 8;
+		trcg_nominal_rate |= nominal_rate_reg[4];
+
+		trl_ctl_val >>= 1;
+		trcg_nominal_rate >>= 1;
+
+		if (diff_upper == 1)
+			num =
+			    (int)((trl_ctl_val + 0x80000000u) -
+				  trcg_nominal_rate);
+		else if (diff_upper == -1)
+			num =
+			    -(int)((trcg_nominal_rate + 0x80000000u) -
+				   trl_ctl_val);
+		else
+			num = (int)(trl_ctl_val - trcg_nominal_rate);
+
+		den = (nominal_rate_reg[0] & 0x7F) << 24;
+		den |= nominal_rate_reg[1] << 16;
+		den |= nominal_rate_reg[2] << 8;
+		den |= nominal_rate_reg[3];
+		den = (den + (390625 / 2)) / 390625;
+
+		den >>= 1;
+
+		if (num >= 0)
+			*ppm = (num + (den / 2)) / den;
+		else
+			*ppm = (num - (den / 2)) / den;
+	}
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sampling_offset_sub(struct
+							     cxd2880_tnrdmd
+							     *tnr_dmd, int *ppm)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ppm))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_dvbt_mon_sampling_offset(tnr_dmd->diver_sub, ppm);
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_quality(struct cxd2880_tnrdmd *tnr_dmd,
+						 u8 *quality)
+{
+	struct cxd2880_dvbt_tpsinfo tps;
+	enum cxd2880_dvbt_profile profile = CXD2880_DVBT_PROFILE_HP;
+	u32 ber = 0;
+	int sn = 0;
+	int sn_rel = 0;
+	int ber_sqi = 0;
+
+	static const int nordig_non_hdvbt_db_1000[3][5] = {
+		{5100, 6900, 7900, 8900, 9700},
+		{10800, 13100, 14600, 15600, 16000},
+		{16500, 18700, 20200, 21600, 22500}
+	};
+
+	static const int nordig_hier_hp_dvbt_db_1000[3][2][5] = {
+		{
+		 {9100, 12000, 13600, 15000, 16600},
+		 {10900, 14100, 15700, 19400, 20600}
+		 },
+		{
+		 {6800, 9100, 10400, 11900, 12700},
+		 {8500, 11000, 12800, 15000, 16000}
+		 },
+		{
+		 {5800, 7900, 9100, 10300, 12100},
+		 {8000, 9300, 11600, 13000, 12900}
+		}
+	};
+
+	static const int nordig_hier_lp_dvbt_db_1000[3][2][5] = {
+		{
+		 {12500, 14300, 15300, 16300, 16900},
+		 {16700, 19100, 20900, 22500, 23700}
+		 },
+		{
+		 {15000, 17200, 18400, 19100, 20100},
+		 {18500, 21200, 23600, 24700, 25900}
+		 },
+		{
+		 {19500, 21400, 22500, 23700, 24700},
+		 {21900, 24200, 25600, 26900, 27800}
+		}
+	};
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!quality))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(tnr_dmd, &tps);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (tps.hierarchy != CXD2880_DVBT_HIERARCHY_NON) {
+		u8 data = 0;
+
+		if (tnr_dmd->io->write_reg(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x00,
+					   0x10) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		if (tnr_dmd->io->read_regs(tnr_dmd->io,
+					   CXD2880_IO_TGT_DMD, 0x67, &data,
+					   1) != CXD2880_RESULT_OK)
+			return CXD2880_RESULT_ERROR_IO;
+
+		profile =
+		    ((data & 0x01) ==
+		     0x01) ? CXD2880_DVBT_PROFILE_LP : CXD2880_DVBT_PROFILE_HP;
+	}
+
+	ret = cxd2880_tnrdmd_dvbt_mon_pre_rsber(tnr_dmd, &ber);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = cxd2880_tnrdmd_dvbt_mon_snr(tnr_dmd, &sn);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if ((tps.constellation >= CXD2880_DVBT_CONSTELLATION_RESERVED_3) ||
+	    (tps.rate_hp >= CXD2880_DVBT_CODERATE_RESERVED_5) ||
+	    (tps.rate_lp >= CXD2880_DVBT_CODERATE_RESERVED_5) ||
+	    (tps.hierarchy > CXD2880_DVBT_HIERARCHY_4)) {
+		return CXD2880_RESULT_ERROR_OTHER;
+	}
+
+	if ((tps.hierarchy != CXD2880_DVBT_HIERARCHY_NON)
+	    && (tps.constellation == CXD2880_DVBT_CONSTELLATION_QPSK))
+		return CXD2880_RESULT_ERROR_OTHER;
+
+	if (tps.hierarchy == CXD2880_DVBT_HIERARCHY_NON)
+		sn_rel =
+		    sn -
+		    nordig_non_hdvbt_db_1000[tps.constellation][tps.rate_hp];
+	else if (profile == CXD2880_DVBT_PROFILE_LP)
+		sn_rel =
+		    sn - nordig_hier_lp_dvbt_db_1000[(int)tps.hierarchy -
+						     1][(int)tps.constellation -
+							1][tps.rate_lp];
+	else
+		sn_rel =
+		    sn - nordig_hier_hp_dvbt_db_1000[(int)tps.hierarchy -
+						     1][(int)tps.constellation -
+							1][tps.rate_hp];
+
+	if (ber > 10000) {
+		ber_sqi = 0;
+	} else if (ber > 1) {
+
+		ber_sqi = (int)(10 * cxd2880_math_log10(ber));
+		ber_sqi = 20 * (7 * 1000 - (ber_sqi)) - 40 * 1000;
+	} else {
+		ber_sqi = 100 * 1000;
+	}
+
+	if (sn_rel < -7 * 1000) {
+		*quality = 0;
+	} else if (sn_rel < 3 * 1000) {
+		int tmp_sqi = (((sn_rel - (3 * 1000)) / 10) + 1000);
+		*quality =
+		    (u8) (((tmp_sqi * ber_sqi) +
+			   (1000000 / 2)) / (1000000)) & 0xFF;
+	} else {
+		*quality = (u8) ((ber_sqi + 500) / 1000);
+	}
+
+	if (*quality > 100)
+		*quality = 100;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
+					     u32 *per)
+{
+	u32 packet_error = 0;
+	u32 period = 0;
+	u8 rdata[3];
+
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!per))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x0D) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x18, rdata,
+				   3) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if ((rdata[0] & 0x01) == 0)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	packet_error = (rdata[1] << 8) | rdata[2];
+
+	if (tnr_dmd->io->write_reg(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x00,
+				   0x10) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	if (tnr_dmd->io->read_regs(tnr_dmd->io,
+				   CXD2880_IO_TGT_DMD, 0x5C, rdata,
+				   1) != CXD2880_RESULT_OK)
+		return CXD2880_RESULT_ERROR_IO;
+
+	period = 1U << (rdata[0] & 0x0F);
+
+	if ((period == 0) || (packet_error > period))
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	{
+		u32 div = 0;
+		u32 Q = 0;
+		u32 R = 0;
+
+		div = period;
+
+		Q = (packet_error * 1000) / div;
+		R = (packet_error * 1000) % div;
+
+		R *= 1000;
+		Q = Q * 1000 + R / div;
+		R = R % div;
+
+		if ((div != 1) && (div / 2 <= R))
+			*per = Q + 1;
+		else
+			*per = Q;
+	}
+
+	return ret;
+}
+
+static enum cxd2880_ret dvbt_calc_ssi(struct cxd2880_tnrdmd *tnr_dmd,
+				      int rf_lvl, u8 *ssi)
+{
+	struct cxd2880_dvbt_tpsinfo tps;
+	int prel;
+	int temp_ssi = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	static const int ref_dbm_1000[3][5] = {
+		{-93000, -91000, -90000, -89000, -88000},
+		{-87000, -85000, -84000, -83000, -82000},
+		{-82000, -80000, -78000, -77000, -76000},
+	};
+
+	if ((!tnr_dmd) || (!ssi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(tnr_dmd, &tps);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if ((tps.constellation >= CXD2880_DVBT_CONSTELLATION_RESERVED_3)
+	    || (tps.rate_hp >= CXD2880_DVBT_CODERATE_RESERVED_5))
+		return CXD2880_RESULT_ERROR_OTHER;
+
+	prel = rf_lvl - ref_dbm_1000[tps.constellation][tps.rate_hp];
+
+	if (prel < -15000)
+		temp_ssi = 0;
+	else if (prel < 0)
+		temp_ssi = ((2 * (prel + 15000)) + 1500) / 3000;
+	else if (prel < 20000)
+		temp_ssi = (((4 * prel) + 500) / 1000) + 10;
+	else if (prel < 35000)
+		temp_ssi = (((2 * (prel - 20000)) + 1500) / 3000) + 90;
+	else
+		temp_ssi = 100;
+
+	*ssi = (temp_ssi > 100) ? 100 : (u8) temp_ssi;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
+					     u8 *ssi)
+{
+	int rf_lvl = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ssi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd, &rf_lvl);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt_calc_ssi(tnr_dmd, rf_lvl, ssi);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_ssi_sub(struct cxd2880_tnrdmd *tnr_dmd,
+						 u8 *ssi)
+{
+	int rf_lvl = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if ((!tnr_dmd) || (!ssi))
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
+		return CXD2880_RESULT_ERROR_SW_STATE;
+
+	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd->diver_sub, &rf_lvl);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = dvbt_calc_ssi(tnr_dmd, rf_lvl, ssi);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return ret;
+}
+
+static enum cxd2880_ret is_tps_locked(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	u8 sync = 0;
+	u8 tslock = 0;
+	u8 early_unlock = 0;
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret =
+	    cxd2880_tnrdmd_dvbt_mon_sync_stat(tnr_dmd, &sync, &tslock,
+					      &early_unlock);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	if (sync != 6)
+		return CXD2880_RESULT_ERROR_HW_STATE;
+
+	return CXD2880_RESULT_OK;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
new file mode 100644
index 0000000..d45673d
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
@@ -0,0 +1,106 @@
+/*
+ * cxd2880_tnrdmd_dvbt_mon.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * DVB-T monitor interface
+ *
+ * Copyright (C) 2016 Sony Semiconductor Solutions Corporation
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
+#ifndef CXD2880_TNRDMD_DVBT_MON_H
+#define CXD2880_TNRDMD_DVBT_MON_H
+
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_dvbt.h"
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sync_stat(struct cxd2880_tnrdmd
+						   *tnr_dmd, u8 *sync_stat,
+						   u8 *ts_lock_stat,
+						   u8 *unlock_detected);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sync_stat_sub(struct cxd2880_tnrdmd
+						       *tnr_dmd, u8 *sync_stat,
+						       u8 *unlock_detected);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_mode_guard(struct cxd2880_tnrdmd
+						    *tnr_dmd,
+						    enum cxd2880_dvbt_mode
+						    *mode,
+						    enum cxd2880_dvbt_guard
+						    *guard);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_carrier_offset(struct cxd2880_tnrdmd
+							*tnr_dmd, int *offset);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_carrier_offset_sub(struct
+							    cxd2880_tnrdmd
+							    *tnr_dmd,
+							    int *offset);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_pre_viterbiber(struct cxd2880_tnrdmd
+							*tnr_dmd, u32 *ber);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_pre_rsber(struct cxd2880_tnrdmd
+						   *tnr_dmd, u32 *ber);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_tps_info(struct cxd2880_tnrdmd
+						  *tnr_dmd,
+						  struct cxd2880_dvbt_tpsinfo
+						  *info);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_packet_error_number(struct
+							     cxd2880_tnrdmd
+							     *tnr_dmd,
+							     u32 *pen);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_spectrum_sense(struct cxd2880_tnrdmd
+						*tnr_dmd,
+						enum
+						cxd2880_tnrdmd_spectrum_sense
+						*sense);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
+					     int *snr);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_snr_diver(struct cxd2880_tnrdmd
+						   *tnr_dmd, int *snr,
+						   int *snr_main, int *snr_sub);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sampling_offset(struct cxd2880_tnrdmd
+							 *tnr_dmd, int *ppm);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_sampling_offset_sub(struct
+							     cxd2880_tnrdmd
+							     *tnr_dmd,
+							     int *ppm);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_quality(struct cxd2880_tnrdmd *tnr_dmd,
+						 u8 *quality);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
+					     u32 *per);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
+					     u8 *ssi);
+
+enum cxd2880_ret cxd2880_tnrdmd_dvbt_mon_ssi_sub(struct cxd2880_tnrdmd *tnr_dmd,
+						 u8 *ssi);
+
+#endif
-- 
1.7.9.5
