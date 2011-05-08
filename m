Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52925 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab1EHXNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:22 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 1/8] DVB: return meaningful error codes in dvb_frontend
Date: Sun,  8 May 2011 23:03:34 +0000
Message-Id: <1304895821-21642-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

- Return values should not be ORed. Abort early instead.
- Return -EINVAL instead of -1.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index d04ef09..be0f631 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1327,12 +1327,12 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		tvp->u.data = fe->dtv_property_cache.dvbt2_plp_id;
 		break;
 	default:
-		r = -1;
+		return -EINVAL;
 	}
 
 	dtv_property_dump(tvp);
 
-	return r;
+	return 0;
 }
 
 static int dtv_property_process_set(struct dvb_frontend *fe,
@@ -1344,11 +1344,11 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	dtv_property_dump(tvp);
 
 	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property)
+	if (fe->ops.set_property) {
 		r = fe->ops.set_property(fe, tvp);
-
-	if (r < 0)
-		return r;
+		if (r < 0)
+			return r;
+	}
 
 	switch(tvp->cmd) {
 	case DTV_CLEAR:
@@ -1367,7 +1367,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		dprintk("%s() Finalised property cache\n", __func__);
 		dtv_property_cache_submit(fe);
 
-		r |= dvb_frontend_ioctl_legacy(file, FE_SET_FRONTEND,
+		r = dvb_frontend_ioctl_legacy(file, FE_SET_FRONTEND,
 			&fepriv->parameters);
 		break;
 	case DTV_FREQUENCY:
@@ -1485,7 +1485,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		fe->dtv_property_cache.dvbt2_plp_id = tvp->u.data;
 		break;
 	default:
-		r = -1;
+		return -EINVAL;
 	}
 
 	return r;
@@ -1559,8 +1559,10 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_set(fe, tvp + i, file);
-			err |= (tvp + i)->result;
+			err = dtv_property_process_set(fe, tvp + i, file);
+			if (err < 0)
+				goto out;
+			(tvp + i)->result = err;
 		}
 
 		if(fe->dtv_property_cache.state == DTV_TUNE)
@@ -1591,8 +1593,10 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_get(fe, tvp + i, file);
-			err |= (tvp + i)->result;
+			err = dtv_property_process_get(fe, tvp + i, file);
+			if (err < 0)
+				goto out;
+			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user(tvps->props, tvp, tvps->num * sizeof(struct dtv_property))) {
-- 
1.7.2.5

