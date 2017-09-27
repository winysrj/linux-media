Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33148
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752169AbdI0Vkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 05/37] media: dvb_frontend: get rid of get_property() callback
Date: Wed, 27 Sep 2017 18:40:06 -0300
Message-Id: <c8eed49c975b63ab8e3c534ee743764a7f999b94.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only lg2160 implement gets_property, but there's no need for that,
as no other driver calls this callback, as get_frontend() does the
same, and set_frontend() also calls lg2160 get_frontend().

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb-core/dvb_frontend.c |  9 +--------
 drivers/media/dvb-core/dvb_frontend.h |  3 ---
 drivers/media/dvb-frontends/lg2160.c  | 14 --------------
 3 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 9139d01ba7ed..5d00e46d9432 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1325,7 +1325,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
-	int r, ncaps;
+	int ncaps;
 
 	switch(tvp->cmd) {
 	case DTV_ENUM_DELSYS:
@@ -1536,13 +1536,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	/* Allow the frontend to override outgoing properties */
-	if (fe->ops.get_property) {
-		r = fe->ops.get_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
 	dtv_property_dump(fe, false, tvp);
 
 	return 0;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 907a05bde162..4d05846f2c1c 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -403,8 +403,6 @@ struct dtv_frontend_properties;
  * @analog_ops:		pointer to struct analog_demod_ops
  * @set_property:	callback function to allow the frontend to validade
  *			incoming properties. Should not be used on new drivers.
- * @get_property:	callback function to allow the frontend to override
- *			outcoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
 
@@ -468,7 +466,6 @@ struct dvb_frontend_ops {
 	struct analog_demod_ops analog_ops;
 
 	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
-	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #ifdef __DVB_CORE__
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index 5798079add10..9854096839ae 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1048,16 +1048,6 @@ static int lg216x_get_frontend(struct dvb_frontend *fe,
 	return ret;
 }
 
-static int lg216x_get_property(struct dvb_frontend *fe,
-			       struct dtv_property *tvp)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	return (DTV_ATSCMH_FIC_VER == tvp->cmd) ?
-		lg216x_get_frontend(fe, c) : 0;
-}
-
-
 static int lg2160_set_frontend(struct dvb_frontend *fe)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
@@ -1368,8 +1358,6 @@ static const struct dvb_frontend_ops lg2160_ops = {
 	.init                 = lg216x_init,
 	.sleep                = lg216x_sleep,
 #endif
-	.get_property         = lg216x_get_property,
-
 	.set_frontend         = lg2160_set_frontend,
 	.get_frontend         = lg216x_get_frontend,
 	.get_tune_settings    = lg216x_get_tune_settings,
@@ -1396,8 +1384,6 @@ static const struct dvb_frontend_ops lg2161_ops = {
 	.init                 = lg216x_init,
 	.sleep                = lg216x_sleep,
 #endif
-	.get_property         = lg216x_get_property,
-
 	.set_frontend         = lg2160_set_frontend,
 	.get_frontend         = lg216x_get_frontend,
 	.get_tune_settings    = lg216x_get_tune_settings,
-- 
2.13.5
