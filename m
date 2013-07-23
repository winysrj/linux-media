Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55908 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330Ab3GWQLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 12:11:34 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so8273110pdi.16
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 09:11:33 -0700 (PDT)
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Cc: Chris Lee <updatelee@gmail.com>
Subject: [PATCH] gp8psk: add DCII and DSS tuning to set_frontend, fix fec tuning values for everything else
Date: Tue, 23 Jul 2013 10:11:26 -0600
Message-Id: <1374595886-25048-1-git-send-email-updatelee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fix: DVB-S QPSK and TURBO QPSK have different fec tuning values
add: DSS
add: DCII 

Signed-off-by: Chris Lee <updatelee@gmail.com>

---
 drivers/media/usb/dvb-usb/gp8psk-fe.c | 180 ++++++++++++++++++++++------------
 1 file changed, 116 insertions(+), 64 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index 4e61c48..4175cf0 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -235,93 +235,145 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
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
+		info("%s: DVB-S delivery system selected w/fec %d", __func__, c->fec_inner);
+		c->fec_inner = FEC_AUTO;
+		cmd[8] = ADV_MOD_DVB_QPSK;
+		cmd[9] = 5;
+		break;
+	case SYS_TURBO:
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
 				__func__, c->modulation);
 			return -EOPNOTSUPP;
 		}
-		c->fec_inner = FEC_AUTO;
 		break;
-	case SYS_DVBS2: /* kept for backwards compatibility */
-		deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
+	case SYS_DSS:
+		info("%s: DSS delivery system selected w/fec %d", __func__, c->fec_inner);
+		cmd[8] = ADV_MOD_DSS_QPSK;
+		switch (c->fec_inner) {
+		case FEC_1_2:	cmd[9] = 0; break;
+		case FEC_2_3:	cmd[9] = 1; break;
+		case FEC_3_4:	cmd[9] = 2; break;
+		case FEC_5_6:	cmd[9] = 3; break;
+		case FEC_7_8:	cmd[9] = 4; break;
+		case FEC_AUTO:	cmd[9] = 5; break;
+		case FEC_6_7:	cmd[9] = 6; break;
+		default:		cmd[9] = 5; break;
+		}
 		break;
-	case SYS_TURBO:
-		deb_fe("%s: Turbo-FEC delivery system selected\n", __func__);
+	case SYS_DCII_C_QPSK:
+		info("%s: DCII_C_QPSK delivery system selected w/fec %d", __func__, c->fec_inner);
+		cmd[8] = ADV_MOD_DCII_C_QPSK;
+		switch (c->fec_inner) {
+		/* 5/11 FEC is cmd[9] = 0 but not added to the API */
+		case FEC_1_2:  cmd[9] = 1; break;
+		case FEC_3_5:  cmd[9] = 2; break;
+		case FEC_2_3:  cmd[9] = 3; break;
+		case FEC_3_4:  cmd[9] = 4; break;
+		case FEC_4_5:  cmd[9] = 5; break;
+		case FEC_5_6:  cmd[9] = 6; break;
+		case FEC_7_8:  cmd[9] = 7; break;
+		case FEC_AUTO: cmd[9] = 8; break;
+		default:       cmd[9] = 8; break;
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
+	case SYS_DCII_I_QPSK:
+		info("%s: DCII_I_QPSK delivery system selected w/fec %d", __func__, cmd[9]);
+		cmd[8] = ADV_MOD_DCII_I_QPSK;
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
+		/* 5/11 FEC is cmd[9] = 0 but not added to the API */
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
-		if (c->delivery_system == SYS_TURBO)
-			cmd[8] = ADV_MOD_TURBO_QPSK;
-		else
-			cmd[8] = ADV_MOD_DVB_QPSK;
 		break;
-	case PSK_8: /* PSK_8 is for compatibility with DN */
-		cmd[8] = ADV_MOD_TURBO_8PSK;
+	case SYS_DCII_Q_QPSK:
+		info("%s: DCII_Q_QPSK delivery system selected w/fec %d", __func__, cmd[9]);
+		cmd[8] = ADV_MOD_DCII_Q_QPSK;
 		switch (c->fec_inner) {
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
-		default:
-			cmd[9] = 0; break;
+		/* 5/11 FEC is cmd[9] = 0 but not added to the API */
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
+	case SYS_DCII_C_OQPSK:
+		info("%s: DCII_C_OQPSK delivery system selected w/fec %d", __func__, cmd[9]);
+		cmd[8] = ADV_MOD_DCII_C_OQPSK;
+		switch (c->fec_inner) {
+		/* 5/11 FEC is cmd[9] = 0 but not added to the API */
+		case FEC_1_2:  cmd[9] = 1; break;
+		case FEC_3_5:  cmd[9] = 2; break;
+		case FEC_2_3:  cmd[9] = 3; break;
+		case FEC_3_4:  cmd[9] = 4; break;
+		case FEC_4_5:  cmd[9] = 5; break;
+		case FEC_5_6:  cmd[9] = 6; break;
+		case FEC_7_8:  cmd[9] = 7; break;
+		case FEC_AUTO: cmd[9] = 8; break;
+		default:       cmd[9] = 8; break;
+		}
 		break;
-	default: /* Unknown modulation */
-		deb_fe("%s: unsupported modulation selected (%d)\n",
-			__func__, c->modulation);
+	default:
+		info("%s: unsupported delivery system selected (%d)", __func__, c->delivery_system);
 		return -EOPNOTSUPP;
 	}
 
-- 
1.8.1.2

