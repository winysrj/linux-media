Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59598 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753597AbeDLPYU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH 05/17] dvb_frontend: fix locking issues at dvb_frontend_get_event()
Date: Thu, 12 Apr 2018 11:23:57 -0400
Message-Id: <1eeff5a276fec1b5eab19baa184f5a3e96b7b2cc.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/dvb-core/dvb_frontend.c:314 dvb_frontend_get_event() warn: inconsistent returns 'sem:&fepriv->sem'.
	  Locked on:   line 288
	               line 295
	               line 306
	               line 314
	  Unlocked on: line 303

The lock implementation for get event is wrong, as, if an
interrupt occurs, down_interruptible() will fail, and the
routine will call up() twice when userspace calls the ioctl
again.

The bad code is there since when Linux migrated to git, in
2005.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index e33414975065..a4ada1ccf0df 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -275,8 +275,20 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe,
 	wake_up_interruptible (&events->wait_queue);
 }
 
+static int dvb_frontend_test_event(struct dvb_frontend_private *fepriv,
+				   struct dvb_fe_events *events)
+{
+	int ret;
+
+	up(&fepriv->sem);
+	ret = events->eventw != events->eventr;
+	down(&fepriv->sem);
+
+	return ret;
+}
+
 static int dvb_frontend_get_event(struct dvb_frontend *fe,
-			    struct dvb_frontend_event *event, int flags)
+			          struct dvb_frontend_event *event, int flags)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
@@ -294,13 +306,8 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 		if (flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
 
-		up(&fepriv->sem);
-
-		ret = wait_event_interruptible (events->wait_queue,
-						events->eventw != events->eventr);
-
-		if (down_interruptible (&fepriv->sem))
-			return -ERESTARTSYS;
+		ret = wait_event_interruptible(events->wait_queue,
+					       dvb_frontend_test_event(fepriv, events));
 
 		if (ret < 0)
 			return ret;
-- 
2.14.3
