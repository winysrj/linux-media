Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab1L0BJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:39 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19dW4032643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 67/91] [media] tda8083: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:55 -0200
Message-Id: <1324948159-23709-68-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-67-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda8083.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 7ff2946..88a22d3 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -315,8 +315,9 @@ static int tda8083_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda8083_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int tda8083_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda8083_state* state = fe->demodulator_priv;
 
 	if (fe->ops.tuner_ops.set_params) {
@@ -325,8 +326,8 @@ static int tda8083_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	}
 
 	tda8083_set_inversion (state, p->inversion);
-	tda8083_set_fec (state, p->u.qpsk.fec_inner);
-	tda8083_set_symbolrate (state, p->u.qpsk.symbol_rate);
+	tda8083_set_fec (state, p->fec_inner);
+	tda8083_set_symbolrate (state, p->symbol_rate);
 
 	tda8083_writereg (state, 0x00, 0x3c);
 	tda8083_writereg (state, 0x00, 0x04);
@@ -334,7 +335,7 @@ static int tda8083_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	return 0;
 }
 
-static int tda8083_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int tda8083_get_frontend(struct dvb_frontend* fe, struct dtv_frontend_properties *p)
 {
 	struct tda8083_state* state = fe->demodulator_priv;
 
@@ -342,8 +343,8 @@ static int tda8083_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	/*p->frequency = ???;*/
 	p->inversion = (tda8083_readreg (state, 0x0e) & 0x80) ?
 			INVERSION_ON : INVERSION_OFF;
-	p->u.qpsk.fec_inner = tda8083_get_fec (state);
-	/*p->u.qpsk.symbol_rate = tda8083_get_symbolrate (state);*/
+	p->fec_inner = tda8083_get_fec (state);
+	/*p->symbol_rate = tda8083_get_symbolrate (state);*/
 
 	return 0;
 }
@@ -438,7 +439,7 @@ error:
 }
 
 static struct dvb_frontend_ops tda8083_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Philips TDA8083 DVB-S",
 		.type			= FE_QPSK,
@@ -461,8 +462,8 @@ static struct dvb_frontend_ops tda8083_ops = {
 	.init = tda8083_init,
 	.sleep = tda8083_sleep,
 
-	.set_frontend_legacy = tda8083_set_frontend,
-	.get_frontend_legacy = tda8083_get_frontend,
+	.set_frontend = tda8083_set_frontend,
+	.get_frontend = tda8083_get_frontend,
 
 	.read_status = tda8083_read_status,
 	.read_signal_strength = tda8083_read_signal_strength,
-- 
1.7.8.352.g876a6

