Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1BNVFd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:05:33 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL5W5B027628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:05:32 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG5012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:05:32 -0500
Date: Mon, 14 Feb 2011 19:03:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/14] [media] tuner-core: move some messages to the proper
 place
Message-ID: <20110214190313.72a4591a@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Move the frequency set debug printk's to the code that actually
are changing it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 912d8e8..f497f52 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -246,6 +246,9 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 			freq = tv_range[1] * 16;
 	}
 	params.frequency = freq;
+	tuner_dbg("tv freq set to %lu.%02lu\n",
+			freq / 16, freq % 16 * 100 / 16);
+	t->tv_freq = freq;
 
 	analog_ops->set_params(&t->fe, &params);
 }
@@ -281,6 +284,9 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 			freq = radio_range[1] * 16000;
 	}
 	params.frequency = freq;
+	tuner_dbg("radio freq set to %lu.%02lu\n",
+			freq / 16000, freq % 16000 * 100 / 16000);
+	t->radio_freq = freq;
 
 	analog_ops->set_params(&t->fe, &params);
 }
@@ -291,17 +297,11 @@ static void set_freq(struct i2c_client *c, unsigned long freq)
 
 	switch (t->mode) {
 	case V4L2_TUNER_RADIO:
-		tuner_dbg("radio freq set to %lu.%02lu\n",
-			  freq / 16000, freq % 16000 * 100 / 16000);
 		set_radio_freq(c, freq);
-		t->radio_freq = freq;
 		break;
 	case V4L2_TUNER_ANALOG_TV:
 	case V4L2_TUNER_DIGITAL_TV:
-		tuner_dbg("tv freq set to %lu.%02lu\n",
-			  freq / 16, freq % 16 * 100 / 16);
 		set_tv_freq(c, freq);
-		t->tv_freq = freq;
 		break;
 	default:
 		tuner_dbg("freq set: unknown mode: 0x%04x!\n",t->mode);
-- 
1.7.1


