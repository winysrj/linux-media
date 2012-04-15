Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53543 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2DOPxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Apr 2012 11:53:31 -0400
Received: by dake40 with SMTP id e40so5866938dak.11
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2012 08:53:30 -0700 (PDT)
Date: Sun, 15 Apr 2012 23:53:34 +0800
From: "=?utf-8?B?bmliYmxlLm1heA==?=" <nibble.max@gmail.com>
To: "=?utf-8?B?TWF1cm8gQ2FydmFsaG8gQ2hlaGFi?=" <mchehab@redhat.com>
Cc: "=?utf-8?B?bGludXgtbWVkaWE=?=" <linux-media@vger.kernel.org>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>
Subject: =?utf-8?B?W1BBVENIIDMvNl0gbTg4ZHMzMTAzLCBkdmJza3kgZHZiLXMyIGN4MjM4ODMgcGNpIGNhcmQu?=
Message-ID: <201204152353319848816@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbsky dvb-s2 pci based on montage m88ds3103 demodulator.

Signed-off-by: Max nibble <nibble.max@gmail.com>
---
 drivers/media/video/cx88/Kconfig      |    1 +
 drivers/media/video/cx88/cx88-cards.c |   22 +++++++++
 drivers/media/video/cx88/cx88-dvb.c   |   85 +++++++++++++++++++++++++++++++++
 drivers/media/video/cx88/cx88-input.c |    4 ++
 drivers/media/video/cx88/cx88.h       |    1 +
 5 files changed, 113 insertions(+)

diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 3598dc0..0daef63 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -57,6 +57,7 @@ config VIDEO_CX88_DVB
 	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	select DVB_M88DS3103 if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index cbd5d11..059b22d 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -2309,6 +2309,18 @@ static const struct cx88_board cx88_boards[] = {
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_BST_PS8312] = {
+		.name           = "Bestunar PS8312 DVB-S/S2",
+		.tuner_type     = UNSET,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = {{
+			.type   = CX88_VMUX_DVB,
+			.vmux   = 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2813,6 +2825,10 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x1822,
 		.subdevice = 0x0023,
 		.card      = CX88_BOARD_TWINHAN_VP1027_DVBS,
+	}, {
+		.subvendor = 0x14f1,
+		.subdevice = 0x8312,
+		.card      = CX88_BOARD_BST_PS8312,
 	},
 };
 
@@ -3547,6 +3563,12 @@ static void cx88_card_setup(struct cx88_core *core)
 		cx_write(MO_SRST_IO, 1);
 		msleep(100);
 		break;
+	case  CX88_BOARD_BST_PS8312:
+		cx_write(MO_GP1_IO, 0x808000);
+		msleep(100);
+		cx_write(MO_GP1_IO, 0x808080);
+		msleep(100);		
+		break;	
 	} /*end switch() */
 
 
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 003937c..5e19ef3 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -54,6 +54,7 @@
 #include "stv0288.h"
 #include "stb6000.h"
 #include "cx24116.h"
+#include "m88ds3103.h"
 #include "stv0900.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
@@ -458,6 +459,56 @@ static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,
 		return core->prev_set_voltage(fe, voltage);
 	return 0;
 }
+/*CX88_BOARD_BST_PS8312*/
+static int bst_dvbs_set_voltage(struct dvb_frontend *fe,
+				      fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	cx_write(MO_GP1_IO, 0x111111);
+	switch (voltage) {
+		case SEC_VOLTAGE_13:
+			cx_write(MO_GP1_IO, 0x020200);
+			break;
+		case SEC_VOLTAGE_18:
+			cx_write(MO_GP1_IO, 0x020202);
+			break;
+		case SEC_VOLTAGE_OFF:
+			cx_write(MO_GP1_IO, 0x111100);
+			break;
+	}
+
+	if (core->prev_set_voltage)
+		return core->prev_set_voltage(fe, voltage);
+	return 0;
+}
+
+static int bst_dvbs_set_voltage_v2(struct dvb_frontend *fe,
+				      fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	cx_write(MO_GP1_IO, 0x111101);
+	switch (voltage) {
+		case SEC_VOLTAGE_13:
+			cx_write(MO_GP1_IO, 0x020200);
+			break;
+		case SEC_VOLTAGE_18:
+
+			cx_write(MO_GP1_IO, 0x020202);
+			break;
+		case SEC_VOLTAGE_OFF:
+
+			cx_write(MO_GP1_IO, 0x111110);
+			break;
+	}
+
+	if (core->prev_set_voltage)
+		return core->prev_set_voltage(fe, voltage);
+	return 0;
+}
 
 static int vp1027_set_voltage(struct dvb_frontend *fe,
 				    fe_sec_voltage_t voltage)
@@ -700,6 +751,11 @@ static struct ds3000_config tevii_ds3000_config = {
 	.set_ts_params = ds3000_set_ts_param,
 };
 
+static struct m88ds3103_config dvbsky_ds3103_config = {
+	.demod_address = 0x68,
+	.set_ts_params = ds3000_set_ts_param,
+};
+
 static const struct stv0900_config prof_7301_stv0900_config = {
 	.demod_address = 0x6a,
 /*	demod_mode = 0,*/
@@ -1470,6 +1526,35 @@ static int dvb_register(struct cx8802_dev *dev)
 			fe0->dvb.frontend->ops.set_voltage =
 							tevii_dvbs_set_voltage;
 		break;
+	case CX88_BOARD_BST_PS8312:
+		fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
+						&dvbsky_ds3103_config,
+						&core->i2c_adap);
+		if (fe0->dvb.frontend != NULL){
+			int ret;
+			u8 b0[] = { 0x60 };
+			u8 b1[2] = { 0 };
+			struct i2c_msg msg[] = {
+				{
+				.addr = 0x50,
+				.flags = 0,
+				.buf = b0,
+				.len = 1
+				}, {
+				.addr = 0x50,
+				.flags = I2C_M_RD,
+				.buf = b1,
+				.len = 2
+				}
+			};
+			ret = i2c_transfer(&core->i2c_adap, msg, 2);
+			printk("PS8312: config = %02x, %02x", b1[0],b1[1]);
+			if(b1[0] == 0xaa)
+				fe0->dvb.frontend->ops.set_voltage = bst_dvbs_set_voltage_v2;
+			else			
+				fe0->dvb.frontend->ops.set_voltage = bst_dvbs_set_voltage;
+		}
+		break;
 	case CX88_BOARD_OMICOM_SS4_PCI:
 	case CX88_BOARD_TBS_8920:
 	case CX88_BOARD_PROF_7300:
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index ebf448c..f698103 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -419,6 +419,10 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		rc_type          = RC_TYPE_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
+	case CX88_BOARD_BST_PS8312: 
+		ir_codes         = RC_MAP_DVBSKY;
+		ir->sampling     = 0xff00; /* address */
+		break;	
 	}
 
 	if (!ir_codes) {
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index c9659de..a988f14 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -246,6 +246,7 @@ extern const struct sram_channel const cx88_sram_channels[];
 #define CX88_BOARD_WINFAST_DTV1800H_XC4000 88
 #define CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36 89
 #define CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43 90
+#define CX88_BOARD_BST_PS8312              91
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
-- 
1.7.9.5

