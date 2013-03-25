Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601Ab3CYM4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 08:56:06 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PCu67g009004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 08:56:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] tuner-core: Remove the now uneeded checks at fe_has_signal/get_afc
Date: Mon, 25 Mar 2013 09:55:58 -0300
Message-Id: <1364216159-12707-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364216159-12707-1-git-send-email-mchehab@redhat.com>
References: <201303251232.31456.hverkuil@xs4all.nl>
 <1364216159-12707-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that those functions are only used when the corresponding
function calls are defined, we don't need to check if those
function calls are present at the structure before using it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/tuner-core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 5e18f44..f1e8b40 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -222,8 +222,7 @@ static int fe_has_signal(struct dvb_frontend *fe)
 {
 	u16 strength = 0;
 
-	if (fe->ops.tuner_ops.get_rf_strength)
-		fe->ops.tuner_ops.get_rf_strength(fe, &strength);
+	fe->ops.tuner_ops.get_rf_strength(fe, &strength);
 
 	return strength;
 }
@@ -232,8 +231,7 @@ static int fe_get_afc(struct dvb_frontend *fe)
 {
 	s32 afc = 0;
 
-	if (fe->ops.tuner_ops.get_afc)
-		fe->ops.tuner_ops.get_afc(fe, &afc);
+	fe->ops.tuner_ops.get_afc(fe, &afc);
 
 	return afc;
 }
@@ -256,8 +254,6 @@ static void tuner_status(struct dvb_frontend *fe);
 static const struct analog_demod_ops tuner_analog_ops = {
 	.set_params     = fe_set_params,
 	.standby        = fe_standby,
-	.has_signal     = fe_has_signal,
-	.get_afc        = fe_get_afc,
 	.set_config     = fe_set_config,
 	.tuner_status   = tuner_status
 };
@@ -453,10 +449,10 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		memcpy(analog_ops, &tuner_analog_ops,
 		       sizeof(struct analog_demod_ops));
 
-		if (fe_tuner_ops->get_rf_strength == NULL)
-			analog_ops->has_signal = NULL;
-		if (fe_tuner_ops->get_afc == NULL)
-			analog_ops->get_afc = NULL;
+		if (fe_tuner_ops->get_rf_strength)
+			analog_ops->has_signal = fe_has_signal;
+		if (fe_tuner_ops->get_afc)
+			analog_ops->get_afc = fe_get_afc;
 
 	} else {
 		t->name = analog_ops->info.name;
-- 
1.8.1.4

