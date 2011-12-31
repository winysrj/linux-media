Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1LaMj4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:39:56 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVCdtKh028443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 07:39:56 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb: Add ops.delsys to the remaining frontends
Date: Sat, 31 Dec 2011 10:39:49 -0200
Message-Id: <1325335189-31016-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few drivers don't have .delsys. Add it, in order to allow
future patches for dvb_frontend.c to not use info.type.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/s5h1432.c  |    2 +-
 drivers/media/dvb/frontends/stv0297.c  |    2 +-
 drivers/media/dvb/frontends/tda10048.c |    2 +-
 drivers/media/dvb/pt1/va1j5jf8007s.c   |    1 +
 drivers/media/dvb/pt1/va1j5jf8007t.c   |    1 +
 5 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
index 3a9050f..baa3aae 100644
--- a/drivers/media/dvb/frontends/s5h1432.c
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -375,7 +375,7 @@ error:
 EXPORT_SYMBOL(s5h1432_attach);
 
 static struct dvb_frontend_ops s5h1432_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "Samsung s5h1432 DVB-T Frontend",
 		 .type = FE_OFDM,
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index dd0a190..8f74762 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -690,7 +690,7 @@ error:
 }
 
 static struct dvb_frontend_ops stv0297_ops = {
-
+	.delsys = { SYS_DVBC },
 	.info = {
 		 .name = "ST STV0297 DVB-C",
 		 .type = FE_QAM,
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 99bf0c0..57711cb 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -1157,7 +1157,7 @@ error:
 EXPORT_SYMBOL(tda10048_attach);
 
 static struct dvb_frontend_ops tda10048_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "NXP TDA10048HN DVB-T",
 		.type			= FE_OFDM,
diff --git a/drivers/media/dvb/pt1/va1j5jf8007s.c b/drivers/media/dvb/pt1/va1j5jf8007s.c
index 78344e3..ef74440 100644
--- a/drivers/media/dvb/pt1/va1j5jf8007s.c
+++ b/drivers/media/dvb/pt1/va1j5jf8007s.c
@@ -579,6 +579,7 @@ static void va1j5jf8007s_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops va1j5jf8007s_ops = {
+	.delsys = { SYS_ISDBS },
 	.info = {
 		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-S",
 		.type = FE_QPSK,
diff --git a/drivers/media/dvb/pt1/va1j5jf8007t.c b/drivers/media/dvb/pt1/va1j5jf8007t.c
index c642820..6eeabc8 100644
--- a/drivers/media/dvb/pt1/va1j5jf8007t.c
+++ b/drivers/media/dvb/pt1/va1j5jf8007t.c
@@ -428,6 +428,7 @@ static void va1j5jf8007t_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops va1j5jf8007t_ops = {
+	.delsys = { SYS_ISDBT },
 	.info = {
 		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-T",
 		.type = FE_OFDM,
-- 
1.7.8.352.g876a6

