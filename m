Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab1L0BJm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:42 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19f77015678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 42/91] [media] sp8870: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:30 -0200
Message-Id: <1324948159-23709-43-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-42-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/sp8870.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index d49e48c..bad1832 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -168,13 +168,13 @@ static int sp8870_read_data_valid_signal(struct sp8870_state* state)
 	return (sp8870_readreg(state, 0x0D02) > 0);
 }
 
-static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
+static int configure_reg0xc05 (struct dtv_frontend_properties *p, u16 *reg0xc05)
 {
 	int known_parameters = 1;
 
 	*reg0xc05 = 0x000;
 
-	switch (p->u.ofdm.constellation) {
+	switch (p->modulation) {
 	case QPSK:
 		break;
 	case QAM_16:
@@ -190,7 +190,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		return -EINVAL;
 	};
 
-	switch (p->u.ofdm.hierarchy_information) {
+	switch (p->hierarchy) {
 	case HIERARCHY_NONE:
 		break;
 	case HIERARCHY_1:
@@ -209,7 +209,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		return -EINVAL;
 	};
 
-	switch (p->u.ofdm.code_rate_HP) {
+	switch (p->code_rate_HP) {
 	case FEC_1_2:
 		break;
 	case FEC_2_3:
@@ -245,9 +245,9 @@ static int sp8870_wake_up(struct sp8870_state* state)
 	return sp8870_writereg(state, 0xC18, 0x00D);
 }
 
-static int sp8870_set_frontend_parameters (struct dvb_frontend* fe,
-					   struct dvb_frontend_parameters *p)
+static int sp8870_set_frontend_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct sp8870_state* state = fe->demodulator_priv;
 	int  err;
 	u16 reg0xc05;
@@ -277,15 +277,15 @@ static int sp8870_set_frontend_parameters (struct dvb_frontend* fe,
 	sp8870_writereg(state, 0x030A, 0x0000);
 
 	// filter for 6/7/8 Mhz channel
-	if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
+	if (p->bandwidth_hz == 6000000)
 		sp8870_writereg(state, 0x0311, 0x0002);
-	else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
+	else if (p->bandwidth_hz == 7000000)
 		sp8870_writereg(state, 0x0311, 0x0001);
 	else
 		sp8870_writereg(state, 0x0311, 0x0000);
 
 	// scan order: 2k first = 0x0000, 8k first = 0x0001
-	if (p->u.ofdm.transmission_mode == TRANSMISSION_MODE_2K)
+	if (p->transmission_mode == TRANSMISSION_MODE_2K)
 		sp8870_writereg(state, 0x0338, 0x0000);
 	else
 		sp8870_writereg(state, 0x0338, 0x0001);
@@ -459,8 +459,9 @@ static int lockups;
 /* only for debugging: counter for channel switches */
 static int switches;
 
-static int sp8870_set_frontend (struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int sp8870_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct sp8870_state* state = fe->demodulator_priv;
 
 	/*
@@ -479,7 +480,7 @@ static int sp8870_set_frontend (struct dvb_frontend* fe, struct dvb_frontend_par
 
 	for (trials = 1; trials <= MAXTRIALS; trials++) {
 
-		if ((err = sp8870_set_frontend_parameters(fe, p)))
+		if ((err = sp8870_set_frontend_parameters(fe)))
 			return err;
 
 		for (check_count = 0; check_count < MAXCHECKS; check_count++) {
@@ -579,7 +580,7 @@ error:
 }
 
 static struct dvb_frontend_ops sp8870_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Spase SP8870 DVB-T",
 		.type			= FE_OFDM,
@@ -600,7 +601,7 @@ static struct dvb_frontend_ops sp8870_ops = {
 	.sleep = sp8870_sleep,
 	.i2c_gate_ctrl = sp8870_i2c_gate_ctrl,
 
-	.set_frontend_legacy = sp8870_set_frontend,
+	.set_frontend = sp8870_set_frontend,
 	.get_tune_settings = sp8870_get_tune_settings,
 
 	.read_status = sp8870_read_status,
-- 
1.7.8.352.g876a6

