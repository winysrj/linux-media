Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2DRNpU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 09:45:20 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3IDjJFE026270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 09:45:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb_frontend: Fix a regression when switching back to DVB-S
Date: Wed, 18 Apr 2012 10:45:11 -0300
Message-Id: <1334756711-25322-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some softwares (Kaffeine and likely xine) that uses a
DVBv5 call to switch to DVB-S2, but expects that a DVBv3 call to
switch back to DVB-S. Well, this is not right, as a DVBv3 call
doesn't know anything about delivery systems.

However, as, by accident, this used to work, we need to restore its
behavior, in order to avoid regressions with those softwares.

Reported on this Fedora 16 bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=812895

Reported-by: Dieter Roever <Dieter.Roever@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4555baa..bb582fd 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1443,6 +1443,28 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 				__func__);
 			return -EINVAL;
 		}
+		/*
+		 * Get a delivery system that is compatible with DVBv3
+		 * NOTE: in order for this to work with softwares like Kaffeine that
+		 *	uses a DVBv5 call for DVB-S2 and a DVBv3 call to go back to
+		 *	DVB-S, drivers that support both should put the SYS_DVBS entry
+		 *	before the SYS_DVBS2, otherwise it won't switch back to DVB-S.
+		 *	The real fix is that userspace applications should not use DVBv3
+		 *	and not trust on calling FE_SET_FRONTEND to switch the delivery
+		 *	system.
+		 */
+		ncaps = 0;
+		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+			if (fe->ops.delsys[ncaps] == desired_system) {
+				delsys = desired_system;
+				break;
+			}
+			ncaps++;
+		}
+		if (delsys == SYS_UNDEFINED) {
+			dprintk("%s() Couldn't find a delivery system that matches %d\n",
+				__func__, desired_system);
+		}
 	} else {
 		/*
 		 * This is a DVBv5 call. So, it likely knows the supported
@@ -1491,9 +1513,10 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 				__func__);
 			return -EINVAL;
 		}
-		c->delivery_system = delsys;
 	}
 
+	c->delivery_system = delsys;
+
 	/*
 	 * The DVBv3 or DVBv5 call is requesting a different system. So,
 	 * emulation is needed.
-- 
1.7.8

