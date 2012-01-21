Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39237 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2AUPTm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 10:19:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] anysee: repeat failed USB control messages
Date: Sat, 21 Jan 2012 17:19:29 +0200
Message-Id: <1327159169-14619-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Control message load increased heavily after CI/CAM support due
to dvb_ca_en50221. It looks like CI/CAM drops to non-working
state easily after error is returned to its callbacks. Due to
that, add some logic to avoid errors repeating failed messages.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/anysee.c |   38 ++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index fdee856..6eb7046 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -58,7 +58,7 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	u8 *rbuf, u8 rlen)
 {
 	struct anysee_state *state = d->priv;
-	int act_len, ret;
+	int act_len, ret, i;
 	u8 buf[64];
 
 	memcpy(&buf[0], sbuf, slen);
@@ -73,26 +73,52 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	/* We need receive one message more after dvb_usb_generic_rw due
 	   to weird transaction flow, which is 1 x send + 2 x receive. */
 	ret = dvb_usb_generic_rw(d, buf, sizeof(buf), buf, sizeof(buf), 0);
-	if (!ret) {
+	if (ret)
+		goto error_unlock;
+
+	/* TODO FIXME: dvb_usb_generic_rw() fails rarely with error code -32
+	 * (EPIPE, Broken pipe). Function supports currently msleep() as a
+	 * parameter but I would not like to use it, since according to
+	 * Documentation/timers/timers-howto.txt it should not be used such
+	 * short, under < 20ms, sleeps. Repeating failed message would be
+	 * better choice as not to add unwanted delays...
+	 * Fixing that correctly is one of those or both;
+	 * 1) use repeat if possible
+	 * 2) add suitable delay
+	 */
+
+	/* get answer, retry few times if error returned */
+	for (i = 0; i < 3; i++) {
 		/* receive 2nd answer */
 		ret = usb_bulk_msg(d->udev, usb_rcvbulkpipe(d->udev,
 			d->props.generic_bulk_ctrl_endpoint), buf, sizeof(buf),
 			&act_len, 2000);
-		if (ret)
-			err("%s: recv bulk message failed: %d", __func__, ret);
-		else {
+
+		if (ret) {
+			deb_info("%s: recv bulk message failed: %d",
+					__func__, ret);
+		} else {
 			deb_xfer("<<< ");
 			debug_dump(buf, rlen, deb_xfer);
 
 			if (buf[63] != 0x4f)
 				deb_info("%s: cmd failed\n", __func__);
+
+			break;
 		}
 	}
 
+	if (ret) {
+		/* all retries failed, it is fatal */
+		err("%s: recv bulk message failed: %d", __func__, ret);
+		goto error_unlock;
+	}
+
 	/* read request, copy returned data to return buf */
-	if (!ret && rbuf && rlen)
+	if (rbuf && rlen)
 		memcpy(rbuf, buf, rlen);
 
+error_unlock:
 	mutex_unlock(&anysee_usb_mutex);
 
 	return ret;
-- 
1.7.4.4

