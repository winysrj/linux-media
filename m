Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56349 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2HOCVs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6] dvb_core: export function to perform retune
Date: Wed, 15 Aug 2012 05:21:04 +0300
Message-Id: <1344997269-20338-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344997269-20338-1-git-send-email-crope@iki.fi>
References: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to retune when resume from suspend.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 9 +++++++++
 drivers/media/dvb-core/dvb_frontend.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 12e5eb1..5fb19ea 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -307,6 +307,15 @@ void dvb_frontend_reinitialise(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(dvb_frontend_reinitialise);
 
+void dvb_frontend_retune(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+
+	fepriv->state = FESTATE_RETUNE;
+	dvb_frontend_wakeup(fe);
+}
+EXPORT_SYMBOL(dvb_frontend_retune);
+
 static void dvb_frontend_swzigzag_update_delay(struct dvb_frontend_private *fepriv, int locked)
 {
 	int q2;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index de410cc..58f6b4c 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -418,6 +418,7 @@ extern int dvb_unregister_frontend(struct dvb_frontend *fe);
 extern void dvb_frontend_detach(struct dvb_frontend *fe);
 
 extern void dvb_frontend_reinitialise(struct dvb_frontend *fe);
+extern void dvb_frontend_retune(struct dvb_frontend *fe);
 
 extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
 extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
-- 
1.7.11.2

