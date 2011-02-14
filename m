Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1BNVEc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:04:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL4VZ8012196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:04:31 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG4012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:04:31 -0500
Date: Mon, 14 Feb 2011 19:03:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/14] [media] tuner-core: remove the legacy is_stereo()
 call
Message-ID: <20110214190312.1809b836@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Nobody is using this legacy call. Just remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index f9f19be..3b86050 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -239,7 +239,6 @@ struct analog_demod_ops {
 	void (*set_params)(struct dvb_frontend *fe,
 			   struct analog_parameters *params);
 	int  (*has_signal)(struct dvb_frontend *fe);
-	int  (*is_stereo)(struct dvb_frontend *fe);
 	int  (*get_afc)(struct dvb_frontend *fe);
 	void (*tuner_status)(struct dvb_frontend *fe);
 	void (*standby)(struct dvb_frontend *fe);
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 6041c7d..912d8e8 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -682,9 +682,6 @@ static void tuner_status(struct dvb_frontend *fe)
 	if (analog_ops->has_signal)
 		tuner_info("Signal strength: %d\n",
 			   analog_ops->has_signal(fe));
-	if (analog_ops->is_stereo)
-		tuner_info("Stereo:          %s\n",
-			   analog_ops->is_stereo(fe) ? "yes" : "no");
 }
 
 /* ---------------------------------------------------------------------- */
@@ -861,13 +858,6 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 			(tuner_status & TUNER_STATUS_STEREO) ?
 			V4L2_TUNER_SUB_STEREO :
 			V4L2_TUNER_SUB_MONO;
-	} else {
-		if (analog_ops->is_stereo) {
-			vt->rxsubchans =
-				analog_ops->is_stereo(&t->fe) ?
-				V4L2_TUNER_SUB_STEREO :
-				V4L2_TUNER_SUB_MONO;
-		}
 	}
 	if (analog_ops->has_signal)
 		vt->signal = analog_ops->has_signal(&t->fe);
-- 
1.7.1


