Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1LRAV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:21:26 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0LQwI023875
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:21:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/6] [media] drx-k: report the supported delivery systems
Date: Sat, 17 Dec 2011 22:21:10 -0200
Message-Id: <1324167673-20787-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324167673-20787-3-git-send-email-mchehab@redhat.com>
References: <1324167673-20787-1-git-send-email-mchehab@redhat.com>
 <1324167673-20787-2-git-send-email-mchehab@redhat.com>
 <1324167673-20787-3-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index a2c8196..d795898 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6364,6 +6364,32 @@ static int drxk_t_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int drxk_c_get_property(struct dvb_frontend *fe, struct dtv_property *p)
+{
+	switch (p->cmd) {
+	case DTV_ENUM_DELSYS:
+		p->u.buffer.data[0] = SYS_DVBC_ANNEX_A;
+		p->u.buffer.data[1] = SYS_DVBC_ANNEX_C;
+		p->u.buffer.len = 2;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+static int drxk_t_get_property(struct dvb_frontend *fe, struct dtv_property *p)
+{
+	switch (p->cmd) {
+	case DTV_ENUM_DELSYS:
+		p->u.buffer.data[0] = SYS_DVBT;
+		p->u.buffer.len = 1;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 static struct dvb_frontend_ops drxk_c_ops = {
 	.info = {
 		 .name = "DRXK DVB-C",
@@ -6382,6 +6408,7 @@ static struct dvb_frontend_ops drxk_c_ops = {
 
 	.set_frontend = drxk_set_parameters,
 	.get_frontend = drxk_c_get_frontend,
+	.get_property = drxk_c_get_property,
 	.get_tune_settings = drxk_c_get_tune_settings,
 
 	.read_status = drxk_read_status,
@@ -6414,6 +6441,7 @@ static struct dvb_frontend_ops drxk_t_ops = {
 
 	.set_frontend = drxk_set_parameters,
 	.get_frontend = drxk_t_get_frontend,
+	.get_property = drxk_t_get_property,
 
 	.read_status = drxk_read_status,
 	.read_ber = drxk_read_ber,
-- 
1.7.8

