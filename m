Return-path: <mchehab@localhost.localdomain>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0ILTDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 15:03:46 -0400
Received: by vws3 with SMTP id 3so4101564vws.19
        for <linux-media@vger.kernel.org>; Sun, 12 Sep 2010 12:03:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Sep 2010 21:03:45 +0200
Message-ID: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
Subject: [PATCH] firedtv driver: support for PSK8 for S2 devices. To watch HD.
From: Tommy Jonsson <quazzie2@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

This is the first i have ever developed for linux, cant really wrap my
head around how to submit this..
Hope im sending this correctly, diff made with 'hg diff' from latest
"hg clone http://linuxtv.org/hg/v4l-dvb"

It adds support for tuning with PSK8 modulation, pilot and rolloff
with the S2 versions of firedtv.

Signed-off-by: Tommy Jonsson <quazzie2@gmail.com>



diff -r 6e0befab696a linux/drivers/media/dvb/firewire/firedtv-avc.c
--- a/linux/drivers/media/dvb/firewire/firedtv-avc.c	Fri Sep 03
00:28:05 2010 -0300
+++ b/linux/drivers/media/dvb/firewire/firedtv-avc.c	Sun Sep 12
06:52:02 2010 +0200
@@ -4,6 +4,7 @@
  * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
  * Copyright (C) 2008 Ben Backx <ben@bbackx.com>
  * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ * Copyright (C) 2010 Tommy Jonsson <quazzie2@gmail.com>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -318,7 +319,7 @@
  * tuning command for setting the relative LNB frequency
  * (not supported by the AVC standard)
  */
-static int avc_tuner_tuneqpsk(struct firedtv *fdtv,
+static int avc_tuner_tuneqpsk(struct dvb_frontend *fe, struct firedtv *fdtv,
 			      struct dvb_frontend_parameters *params)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
@@ -368,10 +369,30 @@
 		c->operand[12] = 0;

 	if (fdtv->type == FIREDTV_DVB_S2) {
-		c->operand[13] = 0x1;
-		c->operand[14] = 0xff;
-		c->operand[15] = 0xff;
-
+ 		if (fe->dtv_property_cache.delivery_system == SYS_DVBS2) {
+			switch (fe->dtv_property_cache.modulation) {
+			case QAM_16:		c->operand[13] = 0x1; break;
+			case QPSK:		c->operand[13] = 0x2; break;
+			case PSK_8:		c->operand[13] = 0x3; break;
+			default:		c->operand[13] = 0x2; break;
+			}
+ 			switch (fe->dtv_property_cache.rolloff) {
+			case ROLLOFF_AUTO:	c->operand[14] = 0x2; break;
+			case ROLLOFF_35:	c->operand[14] = 0x2; break;
+			case ROLLOFF_20:	c->operand[14] = 0x0; break;
+			case ROLLOFF_25:	c->operand[14] = 0x1; break;
+			/* case ROLLOFF_NONE:	c->operand[14] = 0xff; break; */
+			}
+			switch (fe->dtv_property_cache.pilot) {
+			case PILOT_AUTO:	c->operand[15] = 0x0; break;
+			case PILOT_OFF:		c->operand[15] = 0x0; break;
+			case PILOT_ON:		c->operand[15] = 0x1; break;
+			}
+		} else {
+			c->operand[13] = 0x1;  /* auto modulation */
+			c->operand[14] = 0xff; /* disable rolloff */
+			c->operand[15] = 0xff; /* disable pilot */
+		}
 		return 16;
 	} else {
 		return 13;
@@ -548,7 +569,7 @@
 	return 17 + add_pid_filter(fdtv, &c->operand[17]);
 }

-int avc_tuner_dsd(struct firedtv *fdtv,
+int avc_tuner_dsd(struct dvb_frontend *fe, struct firedtv *fdtv,
 		  struct dvb_frontend_parameters *params)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
@@ -561,7 +582,7 @@

 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
-	case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fdtv, params); break;
+	case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fe, fdtv, params); break;
 	case FIREDTV_DVB_C: pos = avc_tuner_dsd_dvb_c(fdtv, params); break;
 	case FIREDTV_DVB_T: pos = avc_tuner_dsd_dvb_t(fdtv, params); break;
 	default:
diff -r 6e0befab696a linux/drivers/media/dvb/firewire/firedtv-fe.c
--- a/linux/drivers/media/dvb/firewire/firedtv-fe.c	Fri Sep 03
00:28:05 2010 -0300
+++ b/linux/drivers/media/dvb/firewire/firedtv-fe.c	Sun Sep 12
06:52:02 2010 +0200
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
  * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ * Copyright (C) 2010 Tommy Jonsson <quazzie2@gmail.com>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -146,7 +147,7 @@
 {
 	struct firedtv *fdtv = fe->sec_priv;

-	return avc_tuner_dsd(fdtv, params);
+	return avc_tuner_dsd(fe, fdtv, params);
 }

 static int fdtv_get_frontend(struct dvb_frontend *fe,
@@ -155,6 +156,17 @@
 	return -EOPNOTSUPP;
 }

+static int fdtv_get_property(struct dvb_frontend *fe,
+                             struct dtv_property *tvp)
+{
+	return 0;
+}
+static int fdtv_set_property(struct dvb_frontend *fe,
+                             struct dtv_property *tvp)
+{
+	return 0;
+}
+
 void fdtv_frontend_init(struct firedtv *fdtv)
 {
 	struct dvb_frontend_ops *ops = &fdtv->fe.ops;
@@ -166,6 +178,9 @@
 	ops->set_frontend		= fdtv_set_frontend;
 	ops->get_frontend		= fdtv_get_frontend;

+	ops->get_property		= fdtv_get_property;
+	ops->set_property		= fdtv_set_property;
+
 	ops->read_status		= fdtv_read_status;
 	ops->read_ber			= fdtv_read_ber;
 	ops->read_signal_strength	= fdtv_read_signal_strength;
@@ -179,6 +194,24 @@

 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
+		fi->type		= FE_QPSK;
+
+		fi->frequency_min	= 950000;
+		fi->frequency_max	= 2150000;
+		fi->frequency_stepsize	= 125;
+		fi->symbol_rate_min	= 1000000;
+		fi->symbol_rate_max	= 40000000;
+
+		fi->caps		= FE_CAN_INVERSION_AUTO |
+					  FE_CAN_FEC_1_2	|
+					  FE_CAN_FEC_2_3	|
+					  FE_CAN_FEC_3_4	|
+					  FE_CAN_FEC_5_6	|
+					  FE_CAN_FEC_7_8	|
+					  FE_CAN_FEC_AUTO	|
+					  FE_CAN_QPSK;
+		break;
+
 	case FIREDTV_DVB_S2:
 		fi->type		= FE_QPSK;

@@ -188,14 +221,15 @@
 		fi->symbol_rate_min	= 1000000;
 		fi->symbol_rate_max	= 40000000;

-		fi->caps 		= FE_CAN_INVERSION_AUTO	|
-					  FE_CAN_FEC_1_2	|
-					  FE_CAN_FEC_2_3	|
-					  FE_CAN_FEC_3_4	|
-					  FE_CAN_FEC_5_6	|
-					  FE_CAN_FEC_7_8	|
-					  FE_CAN_FEC_AUTO	|
-					  FE_CAN_QPSK;
+		fi->caps		= FE_CAN_INVERSION_AUTO |
+					  FE_CAN_FEC_1_2        |
+					  FE_CAN_FEC_2_3        |
+					  FE_CAN_FEC_3_4        |
+					  FE_CAN_FEC_5_6        |
+					  FE_CAN_FEC_7_8        |
+					  FE_CAN_FEC_AUTO       |
+					  FE_CAN_QPSK           |
+					  FE_CAN_2G_MODULATION;
 		break;

 	case FIREDTV_DVB_C:
diff -r 6e0befab696a linux/drivers/media/dvb/firewire/firedtv.h
--- a/linux/drivers/media/dvb/firewire/firedtv.h	Fri Sep 03 00:28:05 2010 -0300
+++ b/linux/drivers/media/dvb/firewire/firedtv.h	Sun Sep 12 06:52:02 2010 +0200
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2004 Andreas Monitzer <andy@monitzer.com>
  * Copyright (C) 2008 Henrik Kurelid <henrik@kurelid.se>
+ * Copyright (C) 2010 Tommy Jonsson <quazzie2@gmail.com>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -131,7 +132,7 @@
 int avc_recv(struct firedtv *fdtv, void *data, size_t length);
 int avc_tuner_status(struct firedtv *fdtv, struct firedtv_tuner_status *stat);
 struct dvb_frontend_parameters;
-int avc_tuner_dsd(struct firedtv *fdtv, struct
dvb_frontend_parameters *params);
+int avc_tuner_dsd(struct dvb_frontend *fe, struct firedtv *fdtv,
struct dvb_frontend_parameters *params);
 int avc_tuner_set_pids(struct firedtv *fdtv, unsigned char pidc, u16 pid[]);
 int avc_tuner_get_ts(struct firedtv *fdtv);
 int avc_identify_subunit(struct firedtv *fdtv);
