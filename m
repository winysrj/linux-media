Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaCCLLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 06:11:31 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 46/79] [media] drx-j: Allow standard selection
Date: Mon,  3 Mar 2014 07:06:40 -0300
Message-Id: <1393841233-24840-47-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ClearQAM is currently not working. Add support for it too.
Unlikely other ATSC tuners, though, this device will not
auto-detect between ATSC and ClearQAM. So, the delivery
system should be properly set.

Also, this frontend seems to also support DVB-C annex A/C. Add
experimental support for them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c | 29 +++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index f0f14ed95958..7a7a4a87fe25 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -188,7 +188,8 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	struct drx_channel channel;
 	int result;
 	struct drxuio_data uio_data;
-	struct drx_channel def_channel = { /* frequency      */ 0,
+	static const struct drx_channel def_channel = {
+		/* frequency      */ 0,
 		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
 		/* mirror         */ DRX_MIRROR_NO,
 		/* constellation  */ DRX_CONSTELLATION_AUTO,
@@ -204,6 +205,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 		/* carrier        */ DRX_CARRIER_UNKNOWN,
 		/* frame mode     */ DRX_FRAMEMODE_UNKNOWN
 	};
+	u32 constellation = DRX_CONSTELLATION_AUTO;
 
 	/* Bring the demod out of sleep */
 	drx39xxj_set_powerstate(fe, 1);
@@ -217,6 +219,29 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
+	switch (p->delivery_system) {
+	case SYS_ATSC:
+		standard = DRX_STANDARD_8VSB;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		standard = DRX_STANDARD_ITU_B;
+
+		switch (p->modulation) {
+		case QAM_64:
+			constellation = DRX_CONSTELLATION_QAM64;
+			break;
+		case QAM_256:
+			constellation = DRX_CONSTELLATION_QAM256;
+			break;
+		default:
+			constellation = DRX_CONSTELLATION_AUTO;
+			break;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	if (standard != state->current_standard || state->powered_up == 0) {
 		/* Set the standard (will be powered up if necessary */
 		result = drx_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
@@ -233,7 +258,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	channel = def_channel;
 	channel.frequency = p->frequency / 1000;
 	channel.bandwidth = DRX_BANDWIDTH_6MHZ;
-	channel.constellation = DRX_CONSTELLATION_AUTO;
+	channel.constellation = constellation;
 
 	/* program channel */
 	result = drx_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
-- 
1.8.5.3

