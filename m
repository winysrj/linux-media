Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9SMG024185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 38/94] [media] mb86a20s: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:35 -0200
Message-Id: <1325257711-12274-39-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Actually, this driver needs to fill/use the ISDB-T proprieties.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/mb86a20s.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 2dfea6c..a67d7ef 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -485,11 +485,16 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 }
 
-static int mb86a20s_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	int rc;
+#if 0
+	/*
+	 * FIXME: Properly implement the set frontend properties
+	 */
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+#endif
 
 	dprintk("\n");
 
@@ -521,15 +526,15 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe,
 }
 
 static int mb86a20s_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+				 struct dtv_frontend_properties *p)
 {
 
 	/* FIXME: For now, it does nothing */
 
-	fe->dtv_property_cache.bandwidth_hz = 6000000;
-	fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_AUTO;
-	fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_AUTO;
-	fe->dtv_property_cache.isdbt_partial_reception = 0;
+	p->bandwidth_hz = 6000000;
+	p->transmission_mode = TRANSMISSION_MODE_AUTO;
+	p->guard_interval = GUARD_INTERVAL_AUTO;
+	p->isdbt_partial_reception = 0;
 
 	return 0;
 }
@@ -545,7 +550,7 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 	dprintk("\n");
 
 	if (params != NULL)
-		rc = mb86a20s_set_frontend(fe, params);
+		rc = mb86a20s_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
 		mb86a20s_read_status(fe, status);
@@ -608,6 +613,7 @@ error:
 EXPORT_SYMBOL(mb86a20s_attach);
 
 static struct dvb_frontend_ops mb86a20s_ops = {
+	.delsys = { SYS_ISDBT },
 	/* Use dib8000 values per default */
 	.info = {
 		.name = "Fujitsu mb86A20s",
@@ -627,8 +633,8 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	.release = mb86a20s_release,
 
 	.init = mb86a20s_initfe,
-	.set_frontend_legacy = mb86a20s_set_frontend,
-	.get_frontend_legacy = mb86a20s_get_frontend,
+	.set_frontend = mb86a20s_set_frontend,
+	.get_frontend = mb86a20s_get_frontend,
 	.read_status = mb86a20s_read_status,
 	.read_signal_strength = mb86a20s_read_signal_strength,
 	.tune = mb86a20s_tune,
-- 
1.7.8.352.g876a6

