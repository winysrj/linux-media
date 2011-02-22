Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab1BVCRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 21:17:48 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2Hl43016113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:17:47 -0500
Received: from pedra (vpn-224-79.phx2.redhat.com [10.3.224.79])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2HksT012926
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:17:47 -0500
Date: Mon, 21 Feb 2011 23:17:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] tuner: Remove remaining usages of T_DIGITAL_TV
Message-ID: <20110221231737.518c1cc9@pedra>
In-Reply-To: <cover.1298340861.git.mchehab@redhat.com>
References: <cover.1298340861.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A few places used T_DIGITAL_TV internally. Remove the usage of this
obsolete mode mask.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index d95f3b2..efcbc3e 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -933,7 +933,7 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 	 * that xc2028 will be in a safe state.
 	 * Maybe this might also be needed for DTV.
 	 */
-	if (new_mode == T_ANALOG_TV) {
+	if (new_mode == V4L2_TUNER_ANALOG_TV) {
 		rc = send_seq(priv, {0x00, 0x00});
 
 		/* Analog modes require offset = 0 */
@@ -1054,7 +1054,7 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
 		if (priv->ctrl.input1)
 			type |= INPUT1;
 		return generic_set_freq(fe, (625l * p->frequency) / 10,
-				T_RADIO, type, 0, 0);
+				V4L2_TUNER_RADIO, type, 0, 0);
 	}
 
 	/* if std is not defined, choose one */
@@ -1069,7 +1069,7 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
 	p->std |= parse_audio_std_option();
 
 	return generic_set_freq(fe, 62500l * p->frequency,
-				T_ANALOG_TV, type, p->std, 0);
+				V4L2_TUNER_ANALOG_TV, type, p->std, 0);
 }
 
 static int xc2028_set_params(struct dvb_frontend *fe,
@@ -1174,7 +1174,7 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 	}
 
 	return generic_set_freq(fe, p->frequency,
-				T_DIGITAL_TV, type, 0, demod);
+				V4L2_TUNER_DIGITAL_TV, type, 0, demod);
 }
 
 static int xc2028_sleep(struct dvb_frontend *fe)
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index f34d524..b2e351c 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2227,7 +2227,7 @@ em28xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
 	 */
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (res_locked(dev, EM28XX_RESOURCE_VIDEO))
+		if (res_get(dev, EM28XX_RESOURCE_VIDEO))
 			return -EBUSY;
 
 		return videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 455038b..22a2222 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -588,8 +588,6 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 	tun_setup.mode_mask = 0;
 	if (dev->caps.has_tuner)
 		tun_setup.mode_mask |= (T_ANALOG_TV | T_RADIO);
-	if (dev->caps.has_dvb)
-		tun_setup.mode_mask |= T_DIGITAL_TV;
 
 	switch (dev->tuner_type) {
 	case TUNER_XC2028:
diff --git a/include/media/tuner.h b/include/media/tuner.h
index 32dfd5f..963e334 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -161,7 +161,7 @@
 enum tuner_mode {
 	T_RADIO		= 1 << V4L2_TUNER_RADIO,
 	T_ANALOG_TV     = 1 << V4L2_TUNER_ANALOG_TV,
-	T_DIGITAL_TV    = 1 << V4L2_TUNER_DIGITAL_TV,
+	/* Don't need to map V4L2_TUNER_DIGITAL_TV, as tuner-core won't use it */
 };
 
 /* Older boards only had a single tuner device. Nowadays multiple tuner
-- 
1.7.1


