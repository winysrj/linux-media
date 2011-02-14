Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1BNVJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:09:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL9cBD013594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:09:38 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG9012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:09:37 -0500
Date: Mon, 14 Feb 2011 19:03:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/14] [media] tuner-core: do the right thing for
 suspend/resume
Message-ID: <20110214190316.1afc0d8d@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Power down tuners at suspend. At resume, if the tuner is in standby,
calls set_mode, that will turn it on and set the latest frequencies.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index e6855a4..e6b63e9 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1121,9 +1121,13 @@ static int tuner_log_status(struct v4l2_subdev *sd)
 static int tuner_suspend(struct i2c_client *c, pm_message_t state)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
+	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
 	tuner_dbg("suspend\n");
-	/* FIXME: power down ??? */
+
+	if (!t->standby && analog_ops->standby)
+		analog_ops->standby(&t->fe);
+
 	return 0;
 }
 
@@ -1132,10 +1136,10 @@ static int tuner_resume(struct i2c_client *c)
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
 	tuner_dbg("resume\n");
-	if (V4L2_TUNER_RADIO == t->mode)
-		set_freq(c, t->radio_freq);
-	else
-		set_freq(c, t->tv_freq);
+
+	if (!t->standby)
+		set_mode_freq(c, t, t->type, 0);
+
 	return 0;
 }
 
-- 
1.7.1


