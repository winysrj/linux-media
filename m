Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1L0BJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:35 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19Z9B032623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 83/91] [media] dvb-core: remove get|set_frontend_legacy
Date: Mon, 26 Dec 2011 23:09:11 -0200
Message-Id: <1324948159-23709-84-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-83-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
 <1324948159-23709-77-git-send-email-mchehab@redhat.com>
 <1324948159-23709-78-git-send-email-mchehab@redhat.com>
 <1324948159-23709-79-git-send-email-mchehab@redhat.com>
 <1324948159-23709-80-git-send-email-mchehab@redhat.com>
 <1324948159-23709-81-git-send-email-mchehab@redhat.com>
 <1324948159-23709-82-git-send-email-mchehab@redhat.com>
 <1324948159-23709-83-git-send-email-mchehab@redhat.com>
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

