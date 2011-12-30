Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9VnI026584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 67/94] [media] tda8083: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:04 -0200
Message-Id: <1325257711-12274-68-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
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

