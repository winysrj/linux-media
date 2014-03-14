Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58006 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbaCNAOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/17] rtl2832_sdr: expose e4000 controls to user
Date: Fri, 14 Mar 2014 02:14:20 +0200
Message-Id: <1394756071-22410-7-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

E4000 tuner driver provides now some controls. Expose those to
userland.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 86fffcf..7e20576 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -1387,10 +1387,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	/* Register controls */
 	switch (s->cfg->tuner) {
 	case RTL2832_TUNER_E4000:
-		v4l2_ctrl_handler_init(&s->hdl, 2);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_RF_TUNER_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
-		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+		v4l2_ctrl_handler_init(&s->hdl, 9);
+		if (sd)
+			v4l2_ctrl_add_handler(&s->hdl, sd->ctrl_handler, NULL);
 		break;
 	case RTL2832_TUNER_R820T:
 		v4l2_ctrl_handler_init(&s->hdl, 2);
-- 
1.8.5.3

