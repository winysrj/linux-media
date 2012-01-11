Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab2AKBon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 20:44:43 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B1ihXt007433
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 20:44:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] [PATCH] don't reset the delivery system on DTV_CLEAR
Date: Tue, 10 Jan 2012 23:44:30 -0200
Message-Id: <1326246270-29272-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a DVBv3 application may be relying on the delivery system,
don't reset it at DTV_CLEAR. For DVBv5 applications, the
delivery system should be set anyway.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index a904793..b15db4f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -909,7 +909,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 
 	c->state = DTV_CLEAR;
 
-	c->delivery_system = fe->ops.delsys[0];
 	dprintk("%s() Clearing cache for delivery system %d\n", __func__,
 		c->delivery_system);
 
@@ -2377,6 +2376,8 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	 * Initialize the cache to the proper values according with the
 	 * first supported delivery system (ops->delsys[0])
 	 */
+
+        fe->dtv_property_cache.delivery_system = fe->ops.delsys[0];
 	dvb_frontend_clear_cache(fe);
 
 	mutex_unlock(&frontend_mutex);
-- 
1.7.7.5

