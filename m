Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54380 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab3BZRYQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:24:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] anysee: coding style changes
Date: Tue, 26 Feb 2013 19:23:06 +0200
Message-Id: <1361899386-22946-5-git-send-email-crope@iki.fi>
In-Reply-To: <1361899386-22946-1-git-send-email-crope@iki.fi>
References: <1361899386-22946-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I did what I liked to do. Also corrected two long log writings
as checkpatch.pl was complaining about those.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 85ba246..2e76274 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -46,8 +46,8 @@
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
-	u8 *rbuf, u8 rlen)
+static int anysee_ctrl_msg(struct dvb_usb_device *d,
+		u8 *sbuf, u8 slen, u8 *rbuf, u8 rlen)
 {
 	struct anysee_state *state = d_to_priv(d);
 	int act_len, ret, i;
@@ -84,16 +84,16 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 				d->props->generic_bulk_ctrl_endpoint),
 				state->buf, sizeof(state->buf), &act_len, 2000);
 		if (ret) {
-			dev_dbg(&d->udev->dev, "%s: recv bulk message " \
-					"failed=%d\n", __func__, ret);
+			dev_dbg(&d->udev->dev,
+					"%s: recv bulk message failed=%d\n",
+					__func__, ret);
 		} else {
 			dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
 					rlen, state->buf);
 
 			if (state->buf[63] != 0x4f)
-				dev_dbg(&d->udev->dev, "%s: cmd failed\n",
-						__func__);
-
+				dev_dbg(&d->udev->dev,
+						"%s: cmd failed\n", __func__);
 			break;
 		}
 	}
@@ -881,9 +881,8 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 	if (!adap->fe[0]) {
 		/* we have no frontend :-( */
 		ret = -ENODEV;
-		dev_err(&d->udev->dev, "%s: Unsupported Anysee version. " \
-				"Please report the " \
-				"<linux-media@vger.kernel.org>.\n",
+		dev_err(&d->udev->dev,
+				"%s: Unsupported Anysee version. Please report the <linux-media@vger.kernel.org>.\n",
 				KBUILD_MODNAME);
 	}
 error:
-- 
1.7.11.7

