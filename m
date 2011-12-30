Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Wst009173
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 83/94] [media] dvb-core: remove get|set_frontend_legacy
Date: Fri, 30 Dec 2011 13:08:20 -0200
Message-Id: <1325257711-12274-84-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all drivers were converted, we can get rid of those
emulation calls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   24 ++++--------------------
 drivers/media/dvb/dvb-core/dvb_frontend.h |    2 --
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 1eefb91..5bb6c1d 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -145,7 +145,7 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 
 static bool has_get_frontend(struct dvb_frontend *fe)
 {
-	return fe->ops.get_frontend || fe->ops.get_frontend_legacy;
+	return fe->ops.get_frontend;
 }
 
 static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
@@ -361,8 +361,6 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 		fepriv->parameters_in.inversion = fepriv->inversion;
 	if (fe->ops.set_frontend)
 		fe_set_err = fe->ops.set_frontend(fe);
-	else if (fe->ops.set_frontend_legacy)
-		fe_set_err = fe->ops.set_frontend_legacy(fe, &fepriv->parameters_in);
 	fepriv->parameters_out = fepriv->parameters_in;
 	if (fe_set_err < 0) {
 		fepriv->state = FESTATE_ERROR;
@@ -394,9 +392,6 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 		if (fepriv->state & FESTATE_RETUNE) {
 			if (fe->ops.set_frontend)
 				retval = fe->ops.set_frontend(fe);
-			else if (fe->ops.set_frontend_legacy)
-				retval = fe->ops.set_frontend_legacy(fe,
-							&fepriv->parameters_in);
 			fepriv->parameters_out = fepriv->parameters_in;
 			if (retval < 0)
 				fepriv->state = FESTATE_ERROR;
@@ -1271,7 +1266,6 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 	const struct dtv_frontend_properties *cache = &fe->dtv_property_cache;
 	struct dtv_frontend_properties tmp_cache;
 	struct dvb_frontend_parameters tmp_out;
-	bool fill_cache = (c != NULL);
 	bool fill_params = (p_out != NULL);
 	int r;
 
@@ -1283,7 +1277,6 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 	else
 		memcpy(c, cache, sizeof(*c));
 
-	/* Then try the DVBv5 one */
 	if (fe->ops.get_frontend) {
 		r = fe->ops.get_frontend(fe, c);
 		if (unlikely(r < 0))
@@ -1293,17 +1286,8 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 		return 0;
 	}
 
-	/* As no DVBv5 call exists, use the DVBv3 one */
-	if (fe->ops.get_frontend_legacy) {
-		r = fe->ops.get_frontend_legacy(fe, p_out);
-		if (unlikely(r < 0))
-			return r;
-		if (fill_cache)
-			dtv_property_cache_sync(fe, c, p_out);
-		return 0;
-	}
-
-	return -EOPNOTSUPP;
+	/* As everything is in cache, this is always supported */
+	return 0;
 }
 
 static int dvb_frontend_ioctl_legacy(struct file *file,
@@ -1758,7 +1742,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 
 		/*
 		 * Fills the cache out struct with the cache contents, plus
-		 * the data retrieved from get_frontend/get_frontend_legacy.
+		 * the data retrieved from get_frontend.
 		 */
 		dtv_get_frontend(fe, &cache_out, NULL);
 		for (i = 0; i < tvps->num; i++) {
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 06ec17a..23456b3 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -282,11 +282,9 @@ struct dvb_frontend_ops {
 	enum dvbfe_algo (*get_frontend_algo)(struct dvb_frontend *fe);
 
 	/* these two are only used for the swzigzag code */
-	int (*set_frontend_legacy)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
 	int (*set_frontend)(struct dvb_frontend* fe);
 	int (*get_tune_settings)(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* settings);
 
-	int (*get_frontend_legacy)(struct dvb_frontend *fe, struct dvb_frontend_parameters *params);
 	int (*get_frontend)(struct dvb_frontend *fe, struct dtv_frontend_properties *props);
 
 	int (*read_status)(struct dvb_frontend* fe, fe_status_t* status);
-- 
1.7.8.352.g876a6

