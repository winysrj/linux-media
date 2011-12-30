Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9QOv024155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 11/94] [media] cx24116: report delivery system and cleanups
Date: Fri, 30 Dec 2011 13:07:08 -0200
Message-Id: <1325257711-12274-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is one of the first drivers using DVBv5. It relies only
on DVBv5 way, but still it contains some stub for unused
methods. Remove them, add the delivery system and do some
trivial cleanups.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/cx24116.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index 445ae88..f24819a 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -1212,25 +1212,10 @@ static int cx24116_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int cx24116_set_property(struct dvb_frontend *fe,
-	struct dtv_property *tvp)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
-static int cx24116_get_property(struct dvb_frontend *fe,
-	struct dtv_property *tvp)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
 /* dvb-core told us to tune, the tv property cache will be complete,
  * it's safe for is to pull values and use them for tuning purposes.
  */
-static int cx24116_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int cx24116_set_frontend(struct dvb_frontend *fe)
 {
 	struct cx24116_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1458,9 +1443,17 @@ tuned:  /* Set/Reset B/W */
 static int cx24116_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters *params,
 	unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
 {
+	/*
+	 * It is safe to discard "params" here, as the DVB core will sync
+	 * fe->dtv_property_cache with fepriv->parameters_in, where the
+	 * DVBv3 params are stored. The only practical usage for it indicate
+	 * that re-tuning is needed, e. g. (fepriv->state & FESTATE_RETUNE) is
+	 * true.
+	 */
+
 	*delay = HZ / 5;
 	if (params) {
-		int ret = cx24116_set_frontend(fe, params);
+		int ret = cx24116_set_frontend(fe);
 		if (ret)
 			return ret;
 	}
@@ -1473,7 +1466,7 @@ static int cx24116_get_algo(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops cx24116_ops = {
-
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24116/CX24118",
 		.type = FE_QPSK,
@@ -1507,9 +1500,7 @@ static struct dvb_frontend_ops cx24116_ops = {
 	.get_frontend_algo = cx24116_get_algo,
 	.tune = cx24116_tune,
 
-	.set_property = cx24116_set_property,
-	.get_property = cx24116_get_property,
-	.set_frontend_legacy = cx24116_set_frontend,
+	.set_frontend = cx24116_set_frontend,
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Conexant cx24116/cx24118 hardware");
-- 
1.7.8.352.g876a6

