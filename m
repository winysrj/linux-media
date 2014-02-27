Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42896 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaB0Aal (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:30:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 13/16] rtl2832_sdr: expose e4000 controls to user
Date: Thu, 27 Feb 2014 02:30:22 +0200
Message-Id: <1393461025-11857-14-git-send-email-crope@iki.fi>
In-Reply-To: <1393461025-11857-1-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

E4000 tuner driver provides now some controls. Expose those to
userland.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index dea7743..38000d2 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -25,6 +25,7 @@
 #include "dvb_frontend.h"
 #include "rtl2832_sdr.h"
 #include "dvb_usb.h"
+#include "e4000.h"
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -1347,6 +1348,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	struct rtl2832_sdr_state *s;
 	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
+	struct v4l2_ctrl_handler *hdl;
 
 	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1386,10 +1388,10 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	/* Register controls */
 	switch (s->cfg->tuner) {
 	case RTL2832_TUNER_E4000:
-		v4l2_ctrl_handler_init(&s->hdl, 2);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
-		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+		hdl = e4000_get_ctrl_handler(fe);
+		v4l2_ctrl_handler_init(&s->hdl, 9);
+		if (hdl)
+			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
 		break;
 	case RTL2832_TUNER_R820T:
 		v4l2_ctrl_handler_init(&s->hdl, 2);
-- 
1.8.5.3

