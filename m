Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:59985 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab2LJVho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:44 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 6/9] [media] m920x: introduce m920x_rc_core_query()
Date: Mon, 10 Dec 2012 22:37:14 +0100
Message-Id: <1355175437-21623-7-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an m920x_rc_core_query() function for drivers which want to use the
linux RC core infrastructure.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/m920x.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 5f6ca75..bddd763 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -215,6 +215,38 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return ret;
 }
 
+static int m920x_rc_core_query(struct dvb_usb_device *d)
+{
+	int ret = 0;
+	u8 *rc_state;
+	int state;
+
+	rc_state = kmalloc(2, GFP_KERNEL);
+	if (!rc_state)
+		return -ENOMEM;
+
+	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_STATE, &rc_state[0], 1)) != 0)
+		goto out;
+
+	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_KEY, &rc_state[1], 1)) != 0)
+		goto out;
+
+	deb("state=0x%02x keycode=0x%02x\n", rc_state[0], rc_state[1]);
+
+	m920x_parse_rc_state(d, rc_state[0], &state);
+
+	if (state == REMOTE_NO_KEY_PRESSED)
+		rc_keyup(d->rc_dev);
+	else if (state == REMOTE_KEY_REPEAT)
+		rc_repeat(d->rc_dev);
+	else
+		rc_keydown(d->rc_dev, rc_state[1], 0);
+
+out:
+	kfree(rc_state);
+	return ret;
+}
+
 /* I2C */
 static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
-- 
1.7.10.4

