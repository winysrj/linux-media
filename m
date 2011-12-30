Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9VVY009162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 80/94] [media] siano: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:17 -0200
Message-Id: <1325257711-12274-81-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/siano/smsdvb.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index df08d6a..71ee9fa 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -50,7 +50,7 @@ struct smsdvb_client_t {
 	struct completion       tune_done;
 
 	/* todo: save freq/band instead whole struct */
-	struct dvb_frontend_parameters fe_params;
+	struct dtv_frontend_properties fe_params;
 
 	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
 	int event_fe_state;
@@ -591,8 +591,7 @@ static int smsdvb_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe,
-				    struct dvb_frontend_parameters *p)
+static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
@@ -658,8 +657,7 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe,
 					   &client->tune_done);
 }
 
-static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe,
-				     struct dvb_frontend_parameters *p)
+static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
@@ -723,8 +721,7 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe,
 					   &client->tune_done);
 }
 
-static int smsdvb_set_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *fep)
+static int smsdvb_set_frontend(struct dvb_frontend *fe)
 {
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
@@ -733,17 +730,17 @@ static int smsdvb_set_frontend(struct dvb_frontend *fe,
 	switch (smscore_get_device_mode(coredev)) {
 	case DEVICE_MODE_DVBT:
 	case DEVICE_MODE_DVBT_BDA:
-		return smsdvb_dvbt_set_frontend(fe, fep);
+		return smsdvb_dvbt_set_frontend(fe);
 	case DEVICE_MODE_ISDBT:
 	case DEVICE_MODE_ISDBT_BDA:
-		return smsdvb_isdbt_set_frontend(fe, fep);
+		return smsdvb_isdbt_set_frontend(fe);
 	default:
 		return -EINVAL;
 	}
 }
 
 static int smsdvb_get_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *fep)
+			      struct dtv_frontend_properties *fep)
 {
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
@@ -752,7 +749,7 @@ static int smsdvb_get_frontend(struct dvb_frontend *fe,
 
 	/* todo: */
 	memcpy(fep, &client->fe_params,
-	       sizeof(struct dvb_frontend_parameters));
+	       sizeof(struct dtv_frontend_properties));
 
 	return 0;
 }
@@ -805,8 +802,8 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
 
 	.release = smsdvb_release,
 
-	.set_frontend_legacy = smsdvb_set_frontend,
-	.get_frontend_legacy = smsdvb_get_frontend,
+	.set_frontend = smsdvb_set_frontend,
+	.get_frontend = smsdvb_get_frontend,
 	.get_tune_settings = smsdvb_get_tune_settings,
 
 	.read_status = smsdvb_read_status,
@@ -873,6 +870,17 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	memcpy(&client->frontend.ops, &smsdvb_fe_ops,
 	       sizeof(struct dvb_frontend_ops));
 
+	switch (smscore_get_device_mode(coredev)) {
+	case DEVICE_MODE_DVBT:
+	case DEVICE_MODE_DVBT_BDA:
+		smsdvb_fe_ops.delsys[0] = SYS_DVBT;
+		break;
+	case DEVICE_MODE_ISDBT:
+	case DEVICE_MODE_ISDBT_BDA:
+		smsdvb_fe_ops.delsys[0] = SYS_ISDBT;
+		break;
+	}
+
 	rc = dvb_register_frontend(&client->adapter, &client->frontend);
 	if (rc < 0) {
 		sms_err("frontend registration failed %d", rc);
-- 
1.7.8.352.g876a6

