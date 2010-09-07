Return-path: <mchehab@pedra>
Received: from www.tglx.de ([62.245.132.106]:43941 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab0IGOd4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:56 -0400
Message-Id: <20100907125056.799770214@linutronix.de>
Date: Tue, 07 Sep 2010 14:33:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [patch 22/30] dvb: Convert "mutex" to semaphore
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline;
	filename=drivers-media-dvb-dvb-core-frontend-sema.patch
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org

---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- linux-2.6.orig/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ linux-2.6/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -702,7 +702,7 @@ static void dvb_frontend_stop(struct dvb
 
 	kthread_stop(fepriv->thread);
 
-	init_MUTEX (&fepriv->sem);
+	sema_init(&fepriv->sem, 1);
 	fepriv->state = FESTATE_IDLE;
 
 	/* paranoia check in case a signal arrived */
@@ -2061,7 +2061,7 @@ int dvb_register_frontend(struct dvb_ada
 	}
 	fepriv = fe->frontend_priv;
 
-	init_MUTEX (&fepriv->sem);
+	sema_init(&fepriv->sem, 1);
 	init_waitqueue_head (&fepriv->wait_queue);
 	init_waitqueue_head (&fepriv->events.wait_queue);
 	mutex_init(&fepriv->events.mtx);


