Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34764 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 11:55:22 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp1so4222815pab.21
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 08:55:22 -0700 (PDT)
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Cc: Chris Lee <updatelee@gmail.com>
Subject: [PATCH 4/4] gp8psk: update gp8psk_fe_read_status to return actual tuned values, correct fec/sr/freq etc
Date: Tue, 23 Jul 2013 09:55:07 -0600
Message-Id: <1374594907-15478-1-git-send-email-updatelee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/usb/dvb-usb/gp8psk-fe.c | 111 +++++++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb/gp8psk.h    |   1 +
 include/uapi/linux/dvb/frontend.h     |   1 +
 3 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index fcdf82c..4e61c48 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -53,7 +53,42 @@ static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
 
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
+		SYS_DCII_C_QPSK,
+		SYS_DCII_I_QPSK,
+		SYS_DCII_Q_QPSK,
+		SYS_DCII_C_OQPSK,
+		SYS_DSS,
+		SYS_UNDEFINED
+	};
+
+	int fe_gp8psk_modulation_return[] = {
+		QPSK,
+		QPSK,
+		PSK_8,
+		QAM_16,
+		QPSK,
+		QPSK,
+		QPSK,
+		QPSK,
+		QPSK,
+	};
+
 	gp8psk_fe_update_status(st);
 
 	if (st->lock)
@@ -61,10 +96,82 @@ static int gp8psk_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
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
+		case SYS_DCII_C_QPSK:
+		case SYS_DCII_I_QPSK:
+		case SYS_DCII_Q_QPSK:
+		case SYS_DCII_C_OQPSK:
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
 
diff --git a/drivers/media/usb/dvb-usb/gp8psk.h b/drivers/media/usb/dvb-usb/gp8psk.h
index ff6bb3c..dbab86d 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.h
+++ b/drivers/media/usb/dvb-usb/gp8psk.h
@@ -52,6 +52,7 @@ extern int dvb_usb_gp8psk_debug;
 #define GET_SERIAL_NUMBER               0x93    /* in */
 #define USE_EXTRA_VOLT                  0x94
 #define GET_FPGA_VERS			0x95
+#define GET_SIGNAL_STAT			0x9A
 #define GET_BER_RATE			0x9B
 #define CW3K_INIT			0x9d
 
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index ada08a8..f123671 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -165,6 +165,7 @@ typedef enum fe_code_rate {
 	FEC_3_5,
 	FEC_9_10,
 	FEC_2_5,
+	FEC_5_11,
 } fe_code_rate_t;
 
 
-- 
1.8.1.2

