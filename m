Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab1L0BJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:34 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19YbM015636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 38/91] [media] mb86a20s: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:26 -0200
Message-Id: <1324948159-23709-39-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-38-git-send-email-mchehab@redhat.com>
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

