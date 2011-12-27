Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab1L0BJt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:49 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19n60005566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:49 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 80/91] [media] siano: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:08 -0200
Message-Id: <1324948159-23709-81-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-80-git-send-email-mchehab@redhat.com>
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

