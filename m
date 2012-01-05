Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2AEStK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 13:49:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05InA6x009474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 13:49:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb_frontend: improve documentation on set_delivery_system()
Date: Thu,  5 Jan 2012 16:49:01 -0200
Message-Id: <1325789341-16976-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this patch change some things, the updated fields there are
used just on printk, so it shouldn't cause any functional changes.

Yet, this routine is a little complex, so explain a little more
how it works.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 128f677..0e079a1 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1440,9 +1440,13 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	if (desired_system == SYS_UNDEFINED) {
 		/*
 		 * A DVBv3 call doesn't know what's the desired system.
-		 * So, don't change the current delivery system. Instead,
-		 * find the closest DVBv3 system that matches the delivery
-		 * system.
+		 * Also, DVBv3 applications don't know that ops.info->type
+		 * could be changed, and they simply dies when it doesn't
+		 * match.
+		 * So, don't change the current delivery system, as it
+		 * may be trying to do the wrong thing, like setting an
+		 * ISDB-T frontend as DVB-T. Instead, find the closest
+		 * DVBv3 system that matches the delivery system.
 		 */
 		if (is_dvbv3_delsys(c->delivery_system)) {
 			dprintk("%s() Using delivery system to %d\n",
@@ -1452,27 +1456,29 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 		type = dvbv3_type(c->delivery_system);
 		switch (type) {
 		case DVBV3_QPSK:
-			desired_system = FE_QPSK;
+			desired_system = SYS_DVBS;
 			break;
 		case DVBV3_QAM:
-			desired_system = FE_QAM;
+			desired_system = SYS_DVBC_ANNEX_A;
 			break;
 		case DVBV3_ATSC:
-			desired_system = FE_ATSC;
+			desired_system = SYS_ATSC;
 			break;
 		case DVBV3_OFDM:
-			desired_system = FE_OFDM;
+			desired_system = SYS_DVBT;
 			break;
 		default:
 			dprintk("%s(): This frontend doesn't support DVBv3 calls\n",
 				__func__);
 			return -EINVAL;
 		}
-		delsys = c->delivery_system;
 	} else {
 		/*
-		 * Check if the desired delivery system is supported
+		 * This is a DVBv5 call. So, it likely knows the supported
+		 * delivery systems.
 		 */
+
+		/* Check if the desired delivery system is supported */
 		ncaps = 0;
 		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
 			if (fe->ops.delsys[ncaps] == desired_system) {
@@ -1518,6 +1524,9 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	}
 
 	/*
+	 * The DVBv3 or DVBv5 call is requesting a different system. So,
+	 * emulation is needed.
+	 *
 	 * Emulate newer delivery systems like ISDBT, DVBT and DMBTH
 	 * for older DVBv5 applications. The emulation will try to use
 	 * the auto mode for most things, and will assume that the desired
-- 
1.7.7.5

