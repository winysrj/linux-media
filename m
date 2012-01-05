Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2AEBN0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:13:26 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q051DPnI031665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:13:25 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] Don't test for ops->info.type inside drivers
Date: Wed,  4 Jan 2012 23:13:16 -0200
Message-Id: <1325725996-20145-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now, ops->info.type is handled inside the dvb_frontend
core, only for DVBv3 calls, and according with the
delivery system. So, drivers should not care or use it,
otherwise, it may have issues with DVBv5 calls.

The drivers that were still using it were detected via
this small temporary hack:

--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -29,13 +29,16 @@
 #include <linux/types.h>

 typedef enum fe_type {
+#if defined(__DVB_CORE__) || !defined (__KERNEL__)
        FE_QPSK,
        FE_QAM,
        FE_OFDM,
        FE_ATSC
+#else
+FE_FOOO
+#endif
 } fe_type_t;

-
 typedef enum fe_caps {
        FE_IS_STUPID                    = 0,
        FE_CAN_INVERSION_AUTO           = 0x1,

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda827x.c   |    7 ++++++-
 drivers/media/dvb/firewire/firedtv-fe.c |    6 +-----
 drivers/staging/media/as102/as102_fe.c  |    1 -
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/tuners/tda827x.c b/drivers/media/common/tuners/tda827x.c
index e180def..a0d1762 100644
--- a/drivers/media/common/tuners/tda827x.c
+++ b/drivers/media/common/tuners/tda827x.c
@@ -540,9 +540,14 @@ static int tda827xa_set_params(struct dvb_frontend *fe)
 	}
 	tuner_freq = c->frequency;
 
-	if (fe->ops.info.type == FE_QAM) {
+	switch (c->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
 		dprintk("%s select tda827xa_dvbc\n", __func__);
 		frequency_map = tda827xa_dvbc;
+		break;
+	default:
+		break;
 	}
 
 	i = 0;
diff --git a/drivers/media/dvb/firewire/firedtv-fe.c b/drivers/media/dvb/firewire/firedtv-fe.c
index 39f5caa..6fe9793 100644
--- a/drivers/media/dvb/firewire/firedtv-fe.c
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -173,7 +173,6 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
 		ops->delsys[0]		= SYS_DVBS;
-		fi->type		= FE_QPSK;
 
 		fi->frequency_min	= 950000;
 		fi->frequency_max	= 2150000;
@@ -193,8 +192,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 
 	case FIREDTV_DVB_S2:
 		ops->delsys[0]		= SYS_DVBS;
-		ops->delsys[1]		= SYS_DVBS;
-		fi->type		= FE_QPSK;
+		ops->delsys[1]		= SYS_DVBS2;
 
 		fi->frequency_min	= 950000;
 		fi->frequency_max	= 2150000;
@@ -215,7 +213,6 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 
 	case FIREDTV_DVB_C:
 		ops->delsys[0]		= SYS_DVBC_ANNEX_A;
-		fi->type		= FE_QAM;
 
 		fi->frequency_min	= 47000000;
 		fi->frequency_max	= 866000000;
@@ -234,7 +231,6 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 
 	case FIREDTV_DVB_T:
 		ops->delsys[0]		= SYS_DVBT;
-		fi->type		= FE_OFDM;
 
 		fi->frequency_min	= 49000000;
 		fi->frequency_max	= 861000000;
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 06bfe84..bdc5a38 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -282,7 +282,6 @@ static struct dvb_frontend_ops as102_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Unknown AS102 device",
-		.type			= FE_OFDM,
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
 		.frequency_stepsize	= 166667,
-- 
1.7.7.5

