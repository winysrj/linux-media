Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab2AEPiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 10:38:00 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05Fc04K003008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 10:38:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] [media] dvb_frontend: Update ops.info.type earlier
Date: Thu,  5 Jan 2012 13:37:52 -0200
Message-Id: <1325777872-14696-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ops.info.type should be updated before copying it into the
memory buffer that will be returned to userspace.

Also add some debug messages to help tracking such issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index cd3c0f6..1e1265e 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1551,6 +1551,8 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 			}
 		}
 	}
+	dprintk("change delivery system on cache to %d\n", c->delivery_system);
+
 	return 0;
 }
 
@@ -1965,9 +1967,6 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	switch (cmd) {
 	case FE_GET_INFO: {
 		struct dvb_frontend_info* info = parg;
-		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
-		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
-
 		/*
 		 * Associate the 4 delivery systems supported by DVBv3
 		 * API with their DVBv5 counterpart. For the other standards,
@@ -1998,6 +1997,11 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			       __func__, c->delivery_system);
 			fe->ops.info.type = FE_OFDM;
 		}
+		dprintk("current delivery system on cache: %d, V3 type: %d\n",
+			c->delivery_system, fe->ops.info.type);
+
+		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
+		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
 
 		/* Force the CAN_INVERSION_AUTO bit on. If the frontend doesn't
 		 * do it, it is done for it. */
-- 
1.7.7.5

