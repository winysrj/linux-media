Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33160
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752195AbdI0Vk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH v2 06/37] media: dvb_frontend: get rid of set_property() callback
Date: Wed, 27 Sep 2017 18:40:07 -0300
Message-Id: <950e76137e5c6ff9c91a075f7080e0e30d443833.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all clients of set_property() were removed, get rid
of this callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 7 -------
 drivers/media/dvb-core/dvb_frontend.h | 5 -----
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 5d00e46d9432..8abe4f541a36 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1766,13 +1766,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property) {
-		r = fe->ops.set_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
 	dtv_property_dump(fe, true, tvp);
 
 	switch(tvp->cmd) {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 4d05846f2c1c..852b91ba49d2 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -401,11 +401,8 @@ struct dtv_frontend_properties;
  * @search:		callback function used on some custom algo search algos.
  * @tuner_ops:		pointer to struct dvb_tuner_ops
  * @analog_ops:		pointer to struct analog_demod_ops
- * @set_property:	callback function to allow the frontend to validade
- *			incoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
-
 	struct dvb_frontend_info info;
 
 	u8 delsys[MAX_DELSYS];
@@ -464,8 +461,6 @@ struct dvb_frontend_ops {
 
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
-
-	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #ifdef __DVB_CORE__
-- 
2.13.5
