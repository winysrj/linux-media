Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44700 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab0JDS0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 14:26:40 -0400
Date: Mon, 4 Oct 2010 20:25:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] V4L/DVB: firedtv: support for PSK8 for S2 devices. To
 watch HD.
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Tommy Jonsson <quazzie2@gmail.com>, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net
In-Reply-To: <AANLkTikQLd1_thyADU8AMjOATFQoZaJfko3Sn-qtNgQR@mail.gmail.com>
Message-ID: <tkrat.85246f2f7084d010@s5r6.in-berlin.de>
References: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
 <4C90B4FB.2050401@s5r6.in-berlin.de>
 <AANLkTikQLd1_thyADU8AMjOATFQoZaJfko3Sn-qtNgQR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Date: Sun, 12 Sep 2010 21:03:45 +0200
From: Tommy Jonsson <quazzie2@gmail.com>

This is the first i have ever developed for linux, cant really wrap my
head around how to submit this..
Hope im sending this correctly, diff made with 'hg diff' from latest
"hg clone http://linuxtv.org/hg/v4l-dvb"

It adds support for tuning with PSK8 modulation, pilot and rolloff
with the S2 versions of firedtv.

Signed-off-by: Tommy Jonsson <quazzie2@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (trivial simplification)
---
Update: resend with whitespace preserved, fe pointer does not have to be
put into function parameter lists, copyright notice removed (authorship
of smaller changes like this is tracked in the git changelog)

 drivers/media/dvb/firewire/firedtv-avc.c |   30 +++++++++++++++++--
 drivers/media/dvb/firewire/firedtv-fe.c  |   36 ++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 6 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -24,6 +24,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
+#include <dvb_frontend.h>
+
 #include "firedtv.h"
 
 #define FCP_COMMAND_REGISTER		0xfffff0000b00ULL
@@ -368,10 +370,30 @@ static int avc_tuner_tuneqpsk(struct fir
 		c->operand[12] = 0;
 
 	if (fdtv->type == FIREDTV_DVB_S2) {
-		c->operand[13] = 0x1;
-		c->operand[14] = 0xff;
-		c->operand[15] = 0xff;
-
+ 		if (fdtv->fe.dtv_property_cache.delivery_system == SYS_DVBS2) {
+			switch (fdtv->fe.dtv_property_cache.modulation) {
+			case QAM_16:		c->operand[13] = 0x1; break;
+			case QPSK:		c->operand[13] = 0x2; break;
+			case PSK_8:		c->operand[13] = 0x3; break;
+			default:		c->operand[13] = 0x2; break;
+			}
+ 			switch (fdtv->fe.dtv_property_cache.rolloff) {
+			case ROLLOFF_AUTO:	c->operand[14] = 0x2; break;
+			case ROLLOFF_35:	c->operand[14] = 0x2; break;
+			case ROLLOFF_20:	c->operand[14] = 0x0; break;
+			case ROLLOFF_25:	c->operand[14] = 0x1; break;
+			/* case ROLLOFF_NONE:	c->operand[14] = 0xff; break; */
+			}
+			switch (fdtv->fe.dtv_property_cache.pilot) {
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
Index: b/drivers/media/dvb/firewire/firedtv-fe.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-fe.c
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -155,6 +155,16 @@ static int fdtv_get_frontend(struct dvb_
 	return -EOPNOTSUPP;
 }
 
+static int fdtv_get_property(struct dvb_frontend *fe, struct dtv_property *tvp)
+{
+	return 0;
+}
+
+static int fdtv_set_property(struct dvb_frontend *fe, struct dtv_property *tvp)
+{
+	return 0;
+}
+
 void fdtv_frontend_init(struct firedtv *fdtv)
 {
 	struct dvb_frontend_ops *ops = &fdtv->fe.ops;
@@ -166,6 +176,9 @@ void fdtv_frontend_init(struct firedtv *
 	ops->set_frontend		= fdtv_set_frontend;
 	ops->get_frontend		= fdtv_get_frontend;
 
+	ops->get_property		= fdtv_get_property;
+	ops->set_property		= fdtv_set_property;
+
 	ops->read_status		= fdtv_read_status;
 	ops->read_ber			= fdtv_read_ber;
 	ops->read_signal_strength	= fdtv_read_signal_strength;
@@ -179,7 +192,6 @@ void fdtv_frontend_init(struct firedtv *
 
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
-	case FIREDTV_DVB_S2:
 		fi->type		= FE_QPSK;
 
 		fi->frequency_min	= 950000;
@@ -188,7 +200,7 @@ void fdtv_frontend_init(struct firedtv *
 		fi->symbol_rate_min	= 1000000;
 		fi->symbol_rate_max	= 40000000;
 
-		fi->caps 		= FE_CAN_INVERSION_AUTO	|
+		fi->caps		= FE_CAN_INVERSION_AUTO |
 					  FE_CAN_FEC_1_2	|
 					  FE_CAN_FEC_2_3	|
 					  FE_CAN_FEC_3_4	|
@@ -198,6 +210,26 @@ void fdtv_frontend_init(struct firedtv *
 					  FE_CAN_QPSK;
 		break;
 
+	case FIREDTV_DVB_S2:
+		fi->type		= FE_QPSK;
+
+		fi->frequency_min	= 950000;
+		fi->frequency_max	= 2150000;
+		fi->frequency_stepsize	= 125;
+		fi->symbol_rate_min	= 1000000;
+		fi->symbol_rate_max	= 40000000;
+
+		fi->caps		= FE_CAN_INVERSION_AUTO |
+					  FE_CAN_FEC_1_2        |
+					  FE_CAN_FEC_2_3        |
+					  FE_CAN_FEC_3_4        |
+					  FE_CAN_FEC_5_6        |
+					  FE_CAN_FEC_7_8        |
+					  FE_CAN_FEC_AUTO       |
+					  FE_CAN_QPSK           |
+					  FE_CAN_2G_MODULATION;
+		break;
+
 	case FIREDTV_DVB_C:
 		fi->type		= FE_QAM;
 


-- 
Stefan Richter
-=====-==-=- =-=- --=--
http://arcgraph.de/sr/

