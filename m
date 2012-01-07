Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2AGHqT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 02:46:19 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q077kIAU020372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 7 Jan 2012 02:46:18 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC] [media] dvb: remove bogus modulation check
Date: Sat,  7 Jan 2012 05:46:13 -0200
Message-Id: <1325922373-469-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code is wrong as I should have coded it as SYS_DVBC, instead of
SYS_DVBS & friends. Anyway, this check has other problems

1) it does some "magic" by assuming that all QAM modulations are below
  QAM_AUTO;

2) it checks modulation parameters only for one delivery system.
   Or the core should check invalid parameters for all delivery
   systems, or it should let the frontend drivers do it;

3) frontend drivers should already be checking for invalid parameters
   (most of them do it, anyway);

4) not all modulations are mapped at fe->ops.info.caps, so it is not
   even possible to check for the valid modulations inside the core
   for some delivery systems;

5) The core check is incomplete anyway: it only checks for a few
   parameters. If moved into the core other parameters like bandwidth
   and fec should also be checked;

6) 2nd gen DVB-C uses OFDM. So, that test would fail for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 0e079a1..a904793 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -897,29 +897,6 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
 		break;
 	}
 
-	/*
-	 * check for supported modulation
-	 *
-	 * This is currently hacky. Also, it only works for DVB-S & friends,
-	 * and not all modulations has FE_CAN flags
-	 */
-	switch (c->delivery_system) {
-	case SYS_DVBS:
-	case SYS_DVBS2:
-	case SYS_TURBO:
-		if ((c->modulation > QAM_AUTO ||
-		    !((1 << (c->modulation + 10)) & fe->ops.info.caps))) {
-			printk(KERN_WARNING
-			       "DVB: adapter %i frontend %i modulation %u not supported\n",
-			       fe->dvb->num, fe->id, c->modulation);
-			return -EINVAL;
-		}
-		break;
-	default:
-		/* FIXME: it makes sense to validate othere delsys here */
-		break;
-	}
-
 	return 0;
 }
 
-- 
1.7.7.5

