Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbaICUd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/46] [media] af9013: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:46 -0300
Message-Id: <a602b829a8aa7dd1073307ef6db3995e64e56622.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Also, instead of testing foo == false, just use the
simplified notation if(!foo).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index fdbed35c87fa..eb737cf29a36 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -936,7 +936,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	if (ret != 1)
 		goto err;
 
-	priv->i2c_gate_state = 0;
+	priv->i2c_gate_state = false;
 
 	return;
 err:
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 023e0f49c786..5bcf48bb4a71 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1432,7 +1432,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->pixelformat = formats[0].pixelformat;
 	s->buffersize = formats[0].buffersize;
 	s->num_formats = NUM_FORMATS;
-	if (rtl2832_sdr_emulated_fmt == false)
+	if (!rtl2832_sdr_emulated_fmt)
 		s->num_formats -= 1;
 
 	mutex_init(&s->v4l2_lock);
-- 
1.9.3

