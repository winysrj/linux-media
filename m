Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49888
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751225AbdIOJLI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:11:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 5/5] media: dvb_frontend: get rid of set_property() callback
Date: Fri, 15 Sep 2017 06:11:01 -0300
Message-Id: <e62a34ca2d5ef94b041e723892b6c5c36d466fbe.1505466580.git.mchehab@s-opensource.com>
In-Reply-To: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
References: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
In-Reply-To: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
References: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all clients of set_property() were removed, get rid
of this callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 7 -------
 drivers/media/dvb-core/dvb_frontend.h | 2 --
 2 files changed, 9 deletions(-)

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
index 4d05846f2c1c..a50f8216ab76 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -401,8 +401,6 @@ struct dtv_frontend_properties;
  * @search:		callback function used on some custom algo search algos.
  * @tuner_ops:		pointer to struct dvb_tuner_ops
  * @analog_ops:		pointer to struct analog_demod_ops
- * @set_property:	callback function to allow the frontend to validade
- *			incoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
 
-- 
2.13.5
