Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab2AQS5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:57:15 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0HIvFC8024246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 13:57:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] dvb_frontend: Don't call get_frontend() if idle
Date: Tue, 17 Jan 2012 16:57:09 -0200
Message-Id: <1326826629-29961-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326826629-29961-4-git-send-email-mchehab@redhat.com>
References: <1326826629-29961-1-git-send-email-mchehab@redhat.com>
 <1326826629-29961-2-git-send-email-mchehab@redhat.com>
 <1326826629-29961-3-git-send-email-mchehab@redhat.com>
 <1326826629-29961-4-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the frontend is in idle state, don't call get_frontend.

Calling get_frontend() when the device is not tuned may
result in wrong parameters to be returned to the
userspace.

I was tempted to not call get_frontend() at all, except
inside the dvb frontend thread, but this won't work for
all cases. The ISDB-T specs (ABNT NBR 15601 and ARIB
STD-B31) allow the broadcaster to dynamically change the
channel specs at runtime. That means that an ISDB-T optimized
application may want/need to monitor the TMCC tables, decoded
at the frontends via get_frontend call.

So, let's do the simpler change here.

Eventually, the logic could be changed to work only if
the device is tuned and has lock, but, even so, the
lock is also standard-dependent. For ISDB-T, the right
lock to wait is that the demod has TMCC lock. So, drivers
may need to implement some logic to detect if the get_frontend
info was retrieved or not.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index f5fa7aa..2998f38 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1744,6 +1744,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 
@@ -1810,9 +1811,14 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 
 		/*
 		 * Fills the cache out struct with the cache contents, plus
-		 * the data retrieved from get_frontend.
+		 * the data retrieved from get_frontend, if the frontend
+		 * is not idle. Otherwise, returns the cached content
 		 */
-		dtv_get_frontend(fe, NULL);
+		if (fepriv->state != FESTATE_IDLE) {
+			err = dtv_get_frontend(fe, NULL);
+			if (err < 0)
+				goto out;
+		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, c, tvp + i, file);
 			if (err < 0)
-- 
1.7.8

