Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1LRAhL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:37:11 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0bAJa026932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:37:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/7] [media] drx-k: report the supported delivery systems
Date: Sat, 17 Dec 2011 22:36:58 -0200
Message-Id: <1324168621-21506-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324168621-21506-4-git-send-email-mchehab@redhat.com>
References: <1324168621-21506-1-git-send-email-mchehab@redhat.com>
 <1324168621-21506-2-git-send-email-mchehab@redhat.com>
 <1324168621-21506-3-git-send-email-mchehab@redhat.com>
 <1324168621-21506-4-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
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

