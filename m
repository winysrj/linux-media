Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35526 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3BZRYM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:24:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/5] anysee: do not use buffers from stack for usb_bulk_msg()
Date: Tue, 26 Feb 2013 19:23:05 +0200
Message-Id: <1361899386-22946-4-git-send-email-crope@iki.fi>
In-Reply-To: <1361899386-22946-1-git-send-email-crope@iki.fi>
References: <1361899386-22946-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 27 ++++++++++++---------------
 drivers/media/usb/dvb-usb-v2/anysee.h |  3 ++-
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index a20d691..85ba246 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -45,25 +45,24 @@
 #include "cxd2820r.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-static DEFINE_MUTEX(anysee_usb_mutex);
 
 static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	u8 *rbuf, u8 rlen)
 {
 	struct anysee_state *state = d_to_priv(d);
 	int act_len, ret, i;
-	u8 buf[64];
 
-	memcpy(&buf[0], sbuf, slen);
-	buf[60] = state->seq++;
+	mutex_lock(&d->usb_mutex);
 
-	mutex_lock(&anysee_usb_mutex);
+	memcpy(&state->buf[0], sbuf, slen);
+	state->buf[60] = state->seq++;
 
-	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, slen, buf);
+	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, slen, state->buf);
 
 	/* We need receive one message more after dvb_usb_generic_rw due
 	   to weird transaction flow, which is 1 x send + 2 x receive. */
-	ret = dvb_usbv2_generic_rw(d, buf, sizeof(buf), buf, sizeof(buf));
+	ret = dvb_usbv2_generic_rw_locked(d, state->buf, sizeof(state->buf),
+			state->buf, sizeof(state->buf));
 	if (ret)
 		goto error_unlock;
 
@@ -82,17 +81,16 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	for (i = 0; i < 3; i++) {
 		/* receive 2nd answer */
 		ret = usb_bulk_msg(d->udev, usb_rcvbulkpipe(d->udev,
-			d->props->generic_bulk_ctrl_endpoint), buf, sizeof(buf),
-			&act_len, 2000);
-
+				d->props->generic_bulk_ctrl_endpoint),
+				state->buf, sizeof(state->buf), &act_len, 2000);
 		if (ret) {
 			dev_dbg(&d->udev->dev, "%s: recv bulk message " \
 					"failed=%d\n", __func__, ret);
 		} else {
 			dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
-					rlen, buf);
+					rlen, state->buf);
 
-			if (buf[63] != 0x4f)
+			if (state->buf[63] != 0x4f)
 				dev_dbg(&d->udev->dev, "%s: cmd failed\n",
 						__func__);
 
@@ -109,11 +107,10 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 
 	/* read request, copy returned data to return buf */
 	if (rbuf && rlen)
-		memcpy(rbuf, buf, rlen);
+		memcpy(rbuf, state->buf, rlen);
 
 error_unlock:
-	mutex_unlock(&anysee_usb_mutex);
-
+	mutex_unlock(&d->usb_mutex);
 	return ret;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
index c1a4273..8f426d9 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.h
+++ b/drivers/media/usb/dvb-usb-v2/anysee.h
@@ -52,8 +52,9 @@ enum cmd {
 };
 
 struct anysee_state {
-	u8 hw; /* PCB ID */
+	u8 buf[64];
 	u8 seq;
+	u8 hw; /* PCB ID */
 	u8 fe_id:1; /* frondend ID */
 	u8 has_ci:1;
 	u8 ci_attached:1;
-- 
1.7.11.7

