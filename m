Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48968 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab2JEUor (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 16:44:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] mxl111sf: revert patch: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
Date: Fri,  5 Oct 2012 23:44:17 +0300
Message-Id: <1349469857-21396-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commits:
3fd7e4341e04f80e2605f56bbd8cb1e8b027901a
[media] mxl111sf: remove an unused variable
3be5bb71fbf18f83cb88b54a62a78e03e5a4f30a
[media] mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()

...as bug behind these is fixed by the DVB USB v2.

Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index efdcb15..fcfe124 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -343,6 +343,7 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 	struct mxl111sf_state *state = fe_to_priv(fe);
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe->id];
 	int ret = 0;
+	u8 tmp;
 
 	deb_info("%s(%d)\n", __func__, onoff);
 
@@ -353,13 +354,15 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 					      adap_state->ep6_clockphase,
 					      0, 0);
 		mxl_fail(ret);
-#if 0
 	} else {
 		ret = mxl111sf_disable_656_port(state);
 		mxl_fail(ret);
-#endif
 	}
 
+	mxl111sf_read_reg(state, 0x12, &tmp);
+	tmp &= ~0x04;
+	mxl111sf_write_reg(state, 0x12, tmp);
+
 	return ret;
 }
 
-- 
1.7.11.4

