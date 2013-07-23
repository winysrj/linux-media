Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40835 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091Ab3GWWby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 18:31:54 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so9003081pbb.14
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 15:31:53 -0700 (PDT)
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Cc: Chris Lee <updatelee@gmail.com>
Subject: [PATCH] gp8psk: add DSS/DCII tuning, fix turbofec fec values, add returning actual tuned values after lock
Date: Tue, 23 Jul 2013 16:31:45 -0600
Message-Id: <1374618705-5155-1-git-send-email-updatelee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Revised patch, I seperated the DCII systems into their correct DCII system and 4x different modulations.

Chris Lee

---
 drivers/media/usb/dvb-usb/gp8psk-fe.c | 263 +++++++++++++++++++++++++---------
 drivers/media/usb/dvb-usb/gp8psk.h    |   2 +
 include/uapi/linux/dvb/frontend.h     |   6 +
 3 files changed, 201 insertions(+), 70 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index 67957dd..77ba995 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -53,7 +53,43 @@ static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
 
 static int gp8psk_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+	u8 buf[32];
+	int frequency;
+	int carrier_error;
+	int carrier_offset;
+	int rate_error;
+	int rate_offset;
+	int symbol_rate;
+
+	int fe_gp8psk_system_return[] = {
+		SYS_DVBS,
+		SYS_TURBO,
+		SYS_TURBO,
+		SYS_TURBO,
+		SYS_DCII,
+		SYS_DCII,
+		SYS_DCII,
+		SYS_DCII,
+		SYS_DSS,
+		SYS_UNDEFINED
+	};
+
+	int fe_gp8psk_modulation_return[] = {
+		QPSK,
+		QPSK,
+		PSK_8,
+		QAM_16,
+		C_QPSK,
+		I_QPSK,
+		Q_QPSK,
+		C_OQPSK,
+		QPSK,
+		QPSK,
+	};
+
 	gp8psk_fe_update_status(st);
 
 	if (st->lock)
@@ -61,10 +97,79 @@ static int gp8psk_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
 	else
 		*status = 0;
 
-	if (*status & FE_HAS_LOCK)
+	if (*status & FE_HAS_LOCK) {
+		gp8psk_usb_in_op(st->d, GET_SIGNAL_STAT, 0, 0, buf, 32);
+		frequency		= ((buf[11] << 24) + (buf[10] << 16) + (buf[9] << 8) + buf[8]) / 1000;
+		carrier_error	= ((buf[15] << 24) + (buf[14] << 16) + (buf[13] << 8) + buf[12]) / 1000;
+		carrier_offset	=  (buf[19] << 24) + (buf[18] << 16) + (buf[17] << 8) + buf[16];
+		rate_error		=  (buf[23] << 24) + (buf[22] << 16) + (buf[21] << 8) + buf[20];
+		rate_offset		=  (buf[27] << 24) + (buf[26] << 16) + (buf[25] << 8) + buf[24];
+		symbol_rate		=  (buf[31] << 24) + (buf[30] << 16) + (buf[29] << 8) + buf[28];
+
+		c->frequency		= frequency - carrier_error;
+		c->symbol_rate		= symbol_rate + rate_error;
+
+		switch (c->delivery_system) {
+		case SYS_DSS:
+		case SYS_DVBS:
+			c->delivery_system	= fe_gp8psk_system_return[buf[1]];
+			c->modulation		= fe_gp8psk_modulation_return[buf[1]];
+			switch (buf[2]) {
+			case 0:  c->fec_inner = FEC_1_2;  break;
+			case 1:  c->fec_inner = FEC_2_3;  break;
+			case 2:  c->fec_inner = FEC_3_4;  break;
+			case 3:  c->fec_inner = FEC_5_6;  break;
+			case 4:  c->fec_inner = FEC_6_7;  break;
+			case 5:  c->fec_inner = FEC_7_8;  break;
+			default: c->fec_inner = FEC_AUTO; break;
+			}
+			break;
+		case SYS_TURBO:
+			c->delivery_system	= fe_gp8psk_system_return[buf[1]];
+			c->modulation		= fe_gp8psk_modulation_return[buf[1]];
+			if (c->modulation == QPSK) {
+				switch (buf[2]) {
+				case 0:  c->fec_inner = FEC_7_8;  break;
+				case 1:  c->fec_inner = FEC_1_2;  break;
+				case 2:  c->fec_inner = FEC_3_4;  break;
+				case 3:  c->fec_inner = FEC_2_3;  break;
+				case 4:  c->fec_inner = FEC_5_6;  break;
+				default: c->fec_inner = FEC_AUTO; break;
+				}
+			} else {
+				switch (buf[2]) {
+				case 0:  c->fec_inner = FEC_2_3;  break;
+				case 1:  c->fec_inner = FEC_3_4;  break;
+				case 2:  c->fec_inner = FEC_3_4;  break;
+				case 3:  c->fec_inner = FEC_5_6;  break;
+				case 4:  c->fec_inner = FEC_8_9;  break;
+				default: c->fec_inner = FEC_AUTO; break;
+				}
+			}
+			break;
+		case SYS_DCII:
+			c->modulation		= fe_gp8psk_modulation_return[buf[1]];
+			switch (buf[2]) {
+			case 0:  c->fec_inner = FEC_5_11; break;
+			case 1:  c->fec_inner = FEC_1_2;  break;
+			case 2:  c->fec_inner = FEC_3_5;  break;
+			case 3:  c->fec_inner = FEC_2_3;  break;
+			case 4:  c->fec_inner = FEC_3_4;  break;
+			case 5:  c->fec_inner = FEC_4_5;  break;
+			case 6:  c->fec_inner = FEC_5_6;  break;
+			case 7:  c->fec_inner = FEC_7_8;  break;
+			default: c->fec_inner = FEC_AUTO; break;
+			}
+			break;
+		default:
+			c->fec_inner = FEC_AUTO;
+			break;
+		}
+
 		st->status_check_interval = 1000;
-	else
+	} else {
 		st->status_check_interval = 100;
+	}
 	return 0;
 }
 
@@ -121,93 +226,111 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
 	u32 freq = c->frequency * 1000;
 	int gp_product_id = le16_to_cpu(state->d->udev->descriptor.idProduct);
 
-	deb_fe("%s()\n", __func__);
+	info("%s() freq: %d, sr: %d", __func__, freq, c->symbol_rate);
 
+	cmd[0] =  c->symbol_rate        & 0xff;
+	cmd[1] = (c->symbol_rate >>  8) & 0xff;
+	cmd[2] = (c->symbol_rate >> 16) & 0xff;
+	cmd[3] = (c->symbol_rate >> 24) & 0xff;
 	cmd[4] = freq         & 0xff;
 	cmd[5] = (freq >> 8)  & 0xff;
 	cmd[6] = (freq >> 16) & 0xff;
 	cmd[7] = (freq >> 24) & 0xff;
 
-	/* backwards compatibility: DVB-S + 8-PSK were used for Turbo-FEC */
-	if (c->delivery_system == SYS_DVBS && c->modulation == PSK_8)
+	/* backwards compatibility: DVB-S2 used to be used for Turbo-FEC */
+	if (c->delivery_system == SYS_DVBS2)
 		c->delivery_system = SYS_TURBO;
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		if (c->modulation != QPSK) {
-			deb_fe("%s: unsupported modulation selected (%d)\n",
-				__func__, c->modulation);
-			return -EOPNOTSUPP;
-		}
+		info("%s: DVB-S delivery system selected w/fec %d", __func__, c->fec_inner);
 		c->fec_inner = FEC_AUTO;
-		break;
-	case SYS_DVBS2: /* kept for backwards compatibility */
-		deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
+		cmd[8] = ADV_MOD_DVB_QPSK;
+		cmd[9] = 5;
 		break;
 	case SYS_TURBO:
-		deb_fe("%s: Turbo-FEC delivery system selected\n", __func__);
+		info("%s: Turbo-FEC delivery system selected", __func__);
+		switch (c->modulation) {
+		case QPSK:
+			info("%s: modulation QPSK selected w/fec %d", __func__, c->fec_inner);
+			cmd[8] = ADV_MOD_TURBO_QPSK;
+			switch (c->fec_inner) {
+			case FEC_1_2:	cmd[9] = 1; break;
+			case FEC_2_3:	cmd[9] = 3; break;
+			case FEC_3_4:	cmd[9] = 2; break;
+			case FEC_5_6:	cmd[9] = 4; break;
+			default:		cmd[9] = 0; break;
+			}
+			break;
+		case PSK_8:
+			info("%s: modulation 8PSK selected w/fec %d", __func__, c->fec_inner);
+			cmd[8] = ADV_MOD_TURBO_8PSK;
+			switch (c->fec_inner) {
+			case FEC_2_3:	cmd[9] = 0; break;
+			case FEC_3_4:	cmd[9] = 1; break;
+			case FEC_3_5:	cmd[9] = 2; break;
+			case FEC_5_6:	cmd[9] = 3; break;
+			case FEC_8_9:	cmd[9] = 4; break;
+			default:		cmd[9] = 0; break;
+			}
+			break;
+		case QAM_16: /* QAM_16 is for compatibility with DN */
+			info("%s: modulation QAM_16 selected w/fec %d", __func__, c->fec_inner);
+			cmd[8] = ADV_MOD_TURBO_16QAM;
+			cmd[9] = 0;
+			break;
+		default: /* Unknown modulation */
+			info("%s: unsupported modulation selected (%d)",
+				__func__, c->modulation);
+			return -EOPNOTSUPP;
+		}
 		break;
-
-	default:
-		deb_fe("%s: unsupported delivery system selected (%d)\n",
-			__func__, c->delivery_system);
-		return -EOPNOTSUPP;
-	}
-
-	cmd[0] =  c->symbol_rate        & 0xff;
-	cmd[1] = (c->symbol_rate >>  8) & 0xff;
-	cmd[2] = (c->symbol_rate >> 16) & 0xff;
-	cmd[3] = (c->symbol_rate >> 24) & 0xff;
-	switch (c->modulation) {
-	case QPSK:
-		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
-			if (gp8psk_tuned_to_DCII(fe))
-				gp8psk_bcm4500_reload(state->d);
+	case SYS_DSS:
+		info("%s: DSS delivery system selected w/fec %d", __func__, c->fec_inner);
+		cmd[8] = ADV_MOD_DSS_QPSK;
 		switch (c->fec_inner) {
-		case FEC_1_2:
-			cmd[9] = 0; break;
-		case FEC_2_3:
-			cmd[9] = 1; break;
-		case FEC_3_4:
-			cmd[9] = 2; break;
-		case FEC_5_6:
-			cmd[9] = 3; break;
-		case FEC_7_8:
-			cmd[9] = 4; break;
-		case FEC_AUTO:
-			cmd[9] = 5; break;
-		default:
-			cmd[9] = 5; break;
+		case FEC_1_2:	cmd[9] = 0; break;
+		case FEC_2_3:	cmd[9] = 1; break;
+		case FEC_3_4:	cmd[9] = 2; break;
+		case FEC_5_6:	cmd[9] = 3; break;
+		case FEC_7_8:	cmd[9] = 4; break;
+		case FEC_AUTO:	cmd[9] = 5; break;
+		case FEC_6_7:	cmd[9] = 6; break;
+		default:		cmd[9] = 5; break;
 		}
-		if (c->delivery_system == SYS_TURBO)
-			cmd[8] = ADV_MOD_TURBO_QPSK;
-		else
-			cmd[8] = ADV_MOD_DVB_QPSK;
 		break;
-	case PSK_8: /* PSK_8 is for compatibility with DN */
-		cmd[8] = ADV_MOD_TURBO_8PSK;
-		switch (c->fec_inner) {
-		case FEC_2_3:
-			cmd[9] = 0; break;
-		case FEC_3_4:
-			cmd[9] = 1; break;
-		case FEC_3_5:
-			cmd[9] = 2; break;
-		case FEC_5_6:
-			cmd[9] = 3; break;
-		case FEC_8_9:
-			cmd[9] = 4; break;
+	case SYS_DCII:
+		info("%s: DCII delivery system selected w/fec %d", __func__, c->fec_inner);
+		switch (c->modulation) {
+		case C_QPSK:
+			cmd[8] = ADV_MOD_DCII_C_QPSK;
+			break;
+		case I_QPSK:
+			cmd[8] = ADV_MOD_DCII_I_QPSK;
+			break;
+		case Q_QPSK:
+			cmd[8] = ADV_MOD_DCII_Q_QPSK;
+			break;
+		case C_OQPSK:
 		default:
-			cmd[9] = 0; break;
+			cmd[8] = ADV_MOD_DCII_C_OQPSK;
+			break;
+		}		
+		switch (c->fec_inner) {
+		case FEC_5_11: cmd[9] = 0; break;
+		case FEC_1_2:  cmd[9] = 1; break;
+		case FEC_3_5:  cmd[9] = 2; break;
+		case FEC_2_3:  cmd[9] = 3; break;
+		case FEC_3_4:  cmd[9] = 4; break;
+		case FEC_4_5:  cmd[9] = 5; break;
+		case FEC_5_6:  cmd[9] = 6; break;
+		case FEC_7_8:  cmd[9] = 7; break;
+		case FEC_AUTO: cmd[9] = 8; break;
+		default:       cmd[9] = 8; break;
 		}
 		break;
-	case QAM_16: /* QAM_16 is for compatibility with DN */
-		cmd[8] = ADV_MOD_TURBO_16QAM;
-		cmd[9] = 0;
-		break;
-	default: /* Unknown modulation */
-		deb_fe("%s: unsupported modulation selected (%d)\n",
-			__func__, c->modulation);
+	default:
+		info("%s: unsupported delivery system selected (%d)", __func__, c->delivery_system);
 		return -EOPNOTSUPP;
 	}
 
@@ -326,7 +449,7 @@ success:
 
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
-	.delsys = { SYS_DVBS },
+	.delsys = { SYS_TURBO, SYS_DCII, SYS_DSS, SYS_DVBS },
 	.info = {
 		.name			= "Genpix DVB-S",
 		.frequency_min		= 800000,
diff --git a/drivers/media/usb/dvb-usb/gp8psk.h b/drivers/media/usb/dvb-usb/gp8psk.h
index ed32b9d..dbab86d 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.h
+++ b/drivers/media/usb/dvb-usb/gp8psk.h
@@ -52,6 +52,8 @@ extern int dvb_usb_gp8psk_debug;
 #define GET_SERIAL_NUMBER               0x93    /* in */
 #define USE_EXTRA_VOLT                  0x94
 #define GET_FPGA_VERS			0x95
+#define GET_SIGNAL_STAT			0x9A
+#define GET_BER_RATE			0x9B
 #define CW3K_INIT			0x9d
 
 /* PSK_configuration bits */
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c56d77c..78b4df9 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -165,6 +165,7 @@ typedef enum fe_code_rate {
 	FEC_3_5,
 	FEC_9_10,
 	FEC_2_5,
+	FEC_5_11,
 } fe_code_rate_t;
 
 
@@ -183,6 +184,10 @@ typedef enum fe_modulation {
 	APSK_32,
 	DQPSK,
 	QAM_4_NR,
+	C_QPSK,
+	I_QPSK,
+	Q_QPSK,
+	C_OQPSK,
 } fe_modulation_t;
 
 typedef enum fe_transmit_mode {
@@ -410,6 +415,7 @@ typedef enum fe_delivery_system {
 	SYS_DVBT2,
 	SYS_TURBO,
 	SYS_DVBC_ANNEX_C,
+	SYS_DCII,
 } fe_delivery_system_t;
 
 /* backward compatibility */
-- 
1.8.1.2

