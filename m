Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaCCKIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:01 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 70/79] [media] drx-j: Allow userspace control of LNA
Date: Mon,  3 Mar 2014 07:07:04 -0300
Message-Id: <1393841233-24840-71-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just disabling the LNA every time, allow to control it from
userspace.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 41 +++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 7a28c20d2594..f48f320d7bf3 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -20683,6 +20683,46 @@ static int drx39xxj_init(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int drx39xxj_set_lna(struct dvb_frontend *fe)
+{
+	int result;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
+	struct drxuio_cfg uio_cfg;
+	struct drxuio_data uio_data;
+
+	if (c->lna) {
+		if (!ext_attr->has_lna) {
+			pr_err("LNA is not supported on this device!\n");
+			return -EINVAL;
+
+		}
+	}
+
+	/* Turn off the LNA */
+	uio_cfg.uio = DRX_UIO1;
+	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
+	/* Configure user-I/O #3: enable read/write */
+	result = ctrl_set_uio_cfg(demod, &uio_cfg);
+	if (result) {
+		pr_err("Failed to setup LNA GPIO!\n");
+		return result;
+	}
+
+	uio_data.uio = DRX_UIO1;
+	uio_data.value = c->lna;
+	result = ctrl_uio_write(demod, &uio_data);
+	if (result != 0) {
+		pr_err("Failed to %sable LNA!\n",
+		       c->lna ? "en" : "dis");
+		return result;
+	}
+
+	return 0;
+}
+
 static int drx39xxj_get_tune_settings(struct dvb_frontend *fe,
 				      struct dvb_frontend_tune_settings *tune)
 {
@@ -20824,6 +20864,7 @@ static struct dvb_frontend_ops drx39xxj_ops = {
 	.read_snr = drx39xxj_read_snr,
 	.read_ucblocks = drx39xxj_read_ucblocks,
 	.release = drx39xxj_release,
+	.set_lna = drx39xxj_set_lna,
 };
 
 MODULE_DESCRIPTION("Micronas DRX39xxj Frontend");
-- 
1.8.5.3

