Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9TgE015912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 47/94] [media] s921: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:44 -0200
Message-Id: <1325257711-12274-48-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/s921.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb/frontends/s921.c
index 5e8f2a8..4c452f4 100644
--- a/drivers/media/dvb/frontends/s921.c
+++ b/drivers/media/dvb/frontends/s921.c
@@ -262,9 +262,9 @@ static int s921_i2c_readreg(struct s921_state *state, u8 i2c_addr, u8 reg)
 	s921_i2c_writeregdata(state, state->config->demod_address, \
 	regdata, ARRAY_SIZE(regdata))
 
-static int s921_pll_tune(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int s921_pll_tune(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s921_state *state = fe->demodulator_priv;
 	int band, rc, i;
 	unsigned long f_offset;
@@ -414,9 +414,9 @@ static int s921_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 }
 
-static int s921_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int s921_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s921_state *state = fe->demodulator_priv;
 	int rc;
 
@@ -424,7 +424,7 @@ static int s921_set_frontend(struct dvb_frontend *fe,
 
 	/* FIXME: We don't know how to use non-auto mode */
 
-	rc = s921_pll_tune(fe, p);
+	rc = s921_pll_tune(fe);
 	if (rc < 0)
 		return rc;
 
@@ -434,7 +434,7 @@ static int s921_set_frontend(struct dvb_frontend *fe,
 }
 
 static int s921_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+	struct dtv_frontend_properties *p)
 {
 	struct s921_state *state = fe->demodulator_priv;
 
@@ -455,7 +455,7 @@ static int s921_tune(struct dvb_frontend *fe,
 	dprintk("\n");
 
 	if (params != NULL)
-		rc = s921_set_frontend(fe, params);
+		rc = s921_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
 		s921_read_status(fe, status);
@@ -510,6 +510,7 @@ rcor:
 EXPORT_SYMBOL(s921_attach);
 
 static struct dvb_frontend_ops s921_ops = {
+	.delsys = { SYS_ISDBT },
 	/* Use dib8000 values per default */
 	.info = {
 		.name = "Sharp S921",
@@ -534,8 +535,8 @@ static struct dvb_frontend_ops s921_ops = {
 	.release = s921_release,
 
 	.init = s921_initfe,
-	.set_frontend_legacy = s921_set_frontend,
-	.get_frontend_legacy = s921_get_frontend,
+	.set_frontend = s921_set_frontend,
+	.get_frontend = s921_get_frontend,
 	.read_status = s921_read_status,
 	.read_signal_strength = s921_read_signal_strength,
 	.tune = s921_tune,
-- 
1.7.8.352.g876a6

