Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53594 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaBKCFQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 21:05:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 15/16] rtl2832_sdr: expose R820T controls to user
Date: Tue, 11 Feb 2014 04:04:58 +0200
Message-Id: <1392084299-16549-16-git-send-email-crope@iki.fi>
In-Reply-To: <1392084299-16549-1-git-send-email-crope@iki.fi>
References: <1392084299-16549-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

R820T tuner driver provides now some controls. Expose those to
userland.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 18f8c56..cc554f7 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -26,6 +26,7 @@
 #include "rtl2832_sdr.h"
 #include "dvb_usb.h"
 #include "e4000.h"
+#include "r820t.h"
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -1398,6 +1399,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
 		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 0, 8000000, 100000, 0);
 		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+		hdl = r820t_get_ctrl_handler(fe);
+		if (hdl)
+			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
 		break;
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
-- 
1.8.5.3

