Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3DUTAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:45 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0ivw016017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:44 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 09/10] [media] tuner-core: add support to get the tuner frequency range
Date: Sun, 21 Apr 2013 16:00:38 -0300
Message-Id: <1366570839-662-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For SDR, the tuner range is different than TV or radio
ranges. Only the actual tuner driver knows what's the
range supported by the device. So, call the tuner to
get it, if the tuner supports. Otherwise, keep the TV
range, as is it broader than the radio one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 2 ++
 drivers/media/v4l2-core/tuner-core.c  | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 371b6ca..74a50e6 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -215,6 +215,8 @@ struct dvb_tuner_ops {
 	int (*get_frequency)(struct dvb_frontend *fe, u32 *frequency);
 	int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
 	int (*get_if_frequency)(struct dvb_frontend *fe, u32 *frequency);
+	int (*get_tuner_freq_range)(struct dvb_frontend *fe,
+				    u32 *min_freq, u32 *max_freq);
 
 #define TUNER_STATUS_LOCKED 1
 #define TUNER_STATUS_STEREO 2
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index abdcda4..28bbcad 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -460,6 +460,13 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		t->tv_range[i] = tv_range[i] * 16;
 	}
 
+	if (fe_tuner_ops->get_tuner_freq_range) {
+		u32 min, max;
+		fe_tuner_ops->get_tuner_freq_range(&t->fe, &min, &max);
+		t->sdr_range[0] = min / 16;
+		t->sdr_range[1] = max / 16;
+	}
+
 	tuner_dbg("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
 		  c->adapter->name, c->driver->driver.name, c->addr << 1, type,
 		  t->mode_mask);
-- 
1.8.1.4

