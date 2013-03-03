Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab3CCP67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:58:59 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23FwxmP014135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:58:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/11] [media] mb86a20s: Always reset the frontend with set_frontend
Date: Sun,  3 Mar 2013 12:58:47 -0300
Message-Id: <1362326331-17541-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Always init the frontend when set_frontend is called. The rationale
is: it was noticed that, on some devices, it fails to lock with a
different channel. It seems that some other registers need to be
restored to its initial state, when the channel changes.

As it is better to reset everything, even wasting a few more
miliseconds than to loose channel lock, let's change the logic
to always reset.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index c552300..1589662 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1854,18 +1854,9 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	fe->ops.tuner_ops.set_params(fe);
 
-	if (fe->ops.tuner_ops.get_if_frequency) {
+	if (fe->ops.tuner_ops.get_if_frequency)
 		fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
 
-		/*
-		 * If the IF frequency changed, re-initialize the
-		 * frontend. This is needed by some drivers like tda18271,
-		 * that only sets the IF after receiving a set_params() call
-		 */
-		if (if_freq != state->if_freq)
-			state->need_init = true;
-	}
-
 	/*
 	 * Make it more reliable: if, for some reason, the initial
 	 * device initialization doesn't happen, initialize it when
@@ -1877,9 +1868,13 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	 * So, this hack is needed, in order to make Kworld SBTVD to work.
 	 *
 	 * It is also needed to change the IF after the initial init.
+	 *
+	 * HACK: Always init the frontend when set_frontend is called:
+	 * it was noticed that, on some devices, it fails to lock on a
+	 * different channel. So, it is better to reset everything, even
+	 * wasting some time, than to loose channel lock.
 	 */
-	if (state->need_init)
-		mb86a20s_initfe(fe);
+	mb86a20s_initfe(fe);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
-- 
1.8.1.4

