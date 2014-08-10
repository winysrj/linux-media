Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 13/18] [media] dvb-frontend: add core support for tuner suspend/resume
Date: Sat,  9 Aug 2014 21:47:19 -0300
Message-Id: <1407631644-11990-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While several tuners have some sort of suspend/resume
implementation, this is currently mangled with an optional
.sleep callback that it is also used to put the device on
low power mode.

Not all drivers implement it, as returning the driver from
low power may require to re-load the firmware, with takes
some time. Also, some drivers may delay it.

So, the more coherent is to add two new optional callbacks
that will let the tuners to directy implement suspend and
resume callbacks if they need.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 8 ++++++--
 drivers/media/dvb-core/dvb_frontend.h | 2 ++
 drivers/media/v4l2-core/tuner-core.c  | 8 ++++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c2a6a0a85813..a5810391af61 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2550,7 +2550,9 @@ int dvb_frontend_suspend(struct dvb_frontend *fe)
 	dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
 			fe->id);
 
-	if (fe->ops.tuner_ops.sleep)
+	if (fe->ops.tuner_ops.suspend)
+		ret = fe->ops.tuner_ops.suspend(fe);
+	else if (fe->ops.tuner_ops.sleep)
 		ret = fe->ops.tuner_ops.sleep(fe);
 
 	if (fe->ops.sleep)
@@ -2572,7 +2574,9 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
 	if (fe->ops.init)
 		ret = fe->ops.init(fe);
 
-	if (fe->ops.tuner_ops.init)
+	if (fe->ops.tuner_ops.resume)
+		ret = fe->ops.tuner_ops.resume(fe);
+	else if (fe->ops.tuner_ops.init)
 		ret = fe->ops.tuner_ops.init(fe);
 
 	fe->exit = DVB_FE_NO_EXIT;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index d398de4b6ef4..816269e5f706 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -201,6 +201,8 @@ struct dvb_tuner_ops {
 	int (*release)(struct dvb_frontend *fe);
 	int (*init)(struct dvb_frontend *fe);
 	int (*sleep)(struct dvb_frontend *fe);
+	int (*suspend)(struct dvb_frontend *fe);
+	int (*resume)(struct dvb_frontend *fe);
 
 	/** This is for simple PLLs - set all parameters in one go. */
 	int (*set_params)(struct dvb_frontend *fe);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 06c18ba16fa0..177023200737 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1260,7 +1260,9 @@ static int tuner_suspend(struct device *dev)
 
 	tuner_dbg("suspend\n");
 
-	if (!t->standby && analog_ops->standby)
+	if (t->fe.ops.tuner_ops.suspend)
+		t->fe.ops.tuner_ops.suspend(&t->fe);
+	else if (!t->standby && analog_ops->standby)
 		analog_ops->standby(&t->fe);
 
 	return 0;
@@ -1273,7 +1275,9 @@ static int tuner_resume(struct device *dev)
 
 	tuner_dbg("resume\n");
 
-	if (!t->standby)
+	if (t->fe.ops.tuner_ops.resume)
+		t->fe.ops.tuner_ops.resume(&t->fe);
+	else if (!t->standby)
 		if (set_mode(t, t->mode) == 0)
 			set_freq(t, 0);
 
-- 
1.9.3

