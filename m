Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:36441 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1HDPkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 11:40:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id 25FBC3153477
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:26 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id XyuOmJHJnMGQ for <linux-media@vger.kernel.org>;
	Thu,  4 Aug 2011 17:33:19 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 385523153478
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:18 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] DVB: dvb_frontend: clear stale events on FE_SET_FRONTEND
Date: Thu,  4 Aug 2011 15:33:14 +0000
Message-Id: <1312471995-26292-3-git-send-email-obi@linuxtv.org>
In-Reply-To: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
References: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Old events aren't very useful, so clear them before adding
  the first event after an attempt to tune.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 45ea843..4102311 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -220,6 +220,16 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 	return 0;
 }
 
+static void dvb_frontend_clear_events(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dvb_fe_events *events = &fepriv->events;
+
+	mutex_lock(&events->mtx);
+	events->eventr = events->eventw;
+	mutex_unlock(&events->mtx);
+}
+
 static void dvb_frontend_init(struct dvb_frontend *fe)
 {
 	dprintk ("DVB: initialising adapter %i frontend %i (%s)...\n",
@@ -1891,6 +1901,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		/* Request the search algorithm to search */
 		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 
+		dvb_frontend_clear_events(fe);
 		dvb_frontend_add_event(fe, 0);
 		dvb_frontend_wakeup(fe);
 		fepriv->status = 0;
-- 
1.7.2.5

