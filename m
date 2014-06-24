Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:38566 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbaFXX5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 19:57:54 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, olebowle@gmx.com,
	ttmesterr@gmail.com, dheitmueller@kernellabs.com,
	cb.xiong@samsung.com, yongjun_wei@trendmicro.com.cn,
	hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	crope@iki.fi, wade_farnsworth@mentor.com, ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH 2/4] media: dvb-fe changes to use tuner token
Date: Tue, 24 Jun 2014 17:57:29 -0600
Message-Id: <610ef2cd4bbb8a6ccbf16d78f2a0088b5b2d8b23.1403652043.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1403652043.git.shuah.kh@samsung.com>
References: <cover.1403652043.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1403652043.git.shuah.kh@samsung.com>
References: <cover.1403652043.git.shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new field tuner_tkn to struct dvb_frontend. Drivers can
create tuner token using devm_token_create() and initialize
the tuner_tkn when frontend is registered with the dvb-core.
This change enables drivers to provide a token devres for tuner
access control.

Change dvb_frontend to lock tuner token for exclusive access to
tuner function for digital TV function use. When Tuner token is
present, dvb_frontend_start() calls devm_token_lock() to lock
the token. If token is busy, -EBUSY is returned to the user-space.
Tuner token is unlocked if kdvb adapter fe kthread fails to start.
This token is held in use as long as the kdvb adapter fe kthread
is running. Tuner token is unlocked in dvb_frontend_thread() when
kdvb adapter fe thread exits.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   21 +++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |    1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6cc2631..37d3a4e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -41,6 +41,7 @@
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
 #include <asm/processor.h>
+#include <linux/token_devres.h>
 
 #include "dvb_frontend.h"
 #include "dvbdev.h"
@@ -747,6 +748,11 @@ restart:
 	if (semheld)
 		up(&fepriv->sem);
 	dvb_frontend_wakeup(fe);
+
+	if (fe->tuner_tkn) {
+		devm_token_unlock(fe->dvb->device, fe->tuner_tkn);
+		dev_info(fe->dvb->device, "dvb: Tuner is unlocked\n");
+	}
 	return 0;
 }
 
@@ -840,6 +846,17 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	fepriv->state = FESTATE_IDLE;
 	fepriv->exit = DVB_FE_NO_EXIT;
 	fepriv->thread = NULL;
+
+	if (fe->tuner_tkn) {
+		ret = devm_token_lock(fe->dvb->device, fe->tuner_tkn);
+		if (ret) {
+			dev_info(fe->dvb->device,
+				"dvb: Tuner is busy %d\n", ret);
+			return ret;
+		}
+		dev_info(fe->dvb->device, "dvb: Tuner is locked\n");
+	}
+
 	mb();
 
 	fe_thread = kthread_run(dvb_frontend_thread, fe,
@@ -850,6 +867,10 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 				"dvb_frontend_start: failed to start kthread (%d)\n",
 				ret);
 		up(&fepriv->sem);
+		if (fe->tuner_tkn) {
+			devm_token_unlock(fe->dvb->device, fe->tuner_tkn);
+			dev_info(fe->dvb->device, "dvb: Tuner is unlocked\n");
+		}
 		return ret;
 	}
 	fepriv->thread = fe_thread;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 371b6ca..c9ba5fd 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -418,6 +418,7 @@ struct dvb_frontend {
 #define DVB_FRONTEND_COMPONENT_DEMOD 1
 	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
 	int id;
+	char *tuner_tkn;
 };
 
 extern int dvb_register_frontend(struct dvb_adapter *dvb,
-- 
1.7.10.4

