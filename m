Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:36440 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1HDPkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 11:40:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id 139EA3153478
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:27 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id EW4nbBiJ-0Ff for <linux-media@vger.kernel.org>;
	Thu,  4 Aug 2011 17:33:20 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 49E5F3153479
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:19 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] DVB: dvb_frontend: update locking in dvb_frontend_{add,get_event}
Date: Thu,  4 Aug 2011 15:33:15 +0000
Message-Id: <1312471995-26292-4-git-send-email-obi@linuxtv.org>
In-Reply-To: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
References: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- dvb_frontend_add_event:
  - fepriv->parameters_out isn't protected by events->mtx, so
    move the call to fe->ops.get_frontend out of the locked area.
  - move the assignment of e->status into the locked area.

- dvb_frontend_get_event:
  - use direct assignment instead of memcpy.

- dvb_frontend_add_event and dvb_frontend_get_event:
  - use mutex_lock instead of mutex_lock_interruptible, because
    all code paths protected by this mutex won't block.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4102311..d02c32e 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -149,30 +149,25 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	dprintk ("%s\n", __func__);
 
-	if (mutex_lock_interruptible (&events->mtx))
-		return;
+	if ((status & FE_HAS_LOCK) && fe->ops.get_frontend)
+		fe->ops.get_frontend(fe, &fepriv->parameters_out);
 
-	wp = (events->eventw + 1) % MAX_EVENT;
+	mutex_lock(&events->mtx);
 
+	wp = (events->eventw + 1) % MAX_EVENT;
 	if (wp == events->eventr) {
 		events->overflow = 1;
 		events->eventr = (events->eventr + 1) % MAX_EVENT;
 	}
 
 	e = &events->events[events->eventw];
-
-	if (status & FE_HAS_LOCK)
-		if (fe->ops.get_frontend)
-			fe->ops.get_frontend(fe, &fepriv->parameters_out);
-
+	e->status = status;
 	e->parameters = fepriv->parameters_out;
 
 	events->eventw = wp;
 
 	mutex_unlock(&events->mtx);
 
-	e->status = status;
-
 	wake_up_interruptible (&events->wait_queue);
 }
 
@@ -207,14 +202,9 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 			return ret;
 	}
 
-	if (mutex_lock_interruptible (&events->mtx))
-		return -ERESTARTSYS;
-
-	memcpy (event, &events->events[events->eventr],
-		sizeof(struct dvb_frontend_event));
-
+	mutex_lock(&events->mtx);
+	*event = events->events[events->eventr];
 	events->eventr = (events->eventr + 1) % MAX_EVENT;
-
 	mutex_unlock(&events->mtx);
 
 	return 0;
-- 
1.7.2.5

