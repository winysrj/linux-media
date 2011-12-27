Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab1L0BJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:46 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19iVu005528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 60/91] [media] tda10071: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:48 -0200
Message-Id: <1324948159-23709-61-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-60-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda10071.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/frontends/tda10071.c
index e9e00ea..68dcce6 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -636,8 +636,7 @@ error:
 	return ret;
 }
 
-static int tda10071_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int tda10071_set_frontend(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
 	struct tda10071_cmd cmd;
@@ -778,7 +777,7 @@ error:
 }
 
 static int tda10071_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+	struct dtv_frontend_properties *p)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1217,6 +1216,7 @@ error:
 EXPORT_SYMBOL(tda10071_attach);
 
 static struct dvb_frontend_ops tda10071_ops = {
+	.delsys = { SYS_DVBT, SYS_DVBT2 },
 	.info = {
 		.name = "NXP TDA10071",
 		.type = FE_QPSK,
@@ -1247,8 +1247,8 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.init = tda10071_init,
 	.sleep = tda10071_sleep,
 
-	.set_frontend_legacy = tda10071_set_frontend,
-	.get_frontend_legacy = tda10071_get_frontend,
+	.set_frontend = tda10071_set_frontend,
+	.get_frontend = tda10071_get_frontend,
 
 	.read_status = tda10071_read_status,
 	.read_snr = tda10071_read_snr,
-- 
1.7.8.352.g876a6

