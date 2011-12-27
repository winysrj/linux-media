Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1L0BJl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:41 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19eSH032655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 47/91] [media] s921: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:35 -0200
Message-Id: <1324948159-23709-48-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-47-git-send-email-mchehab@redhat.com>
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

