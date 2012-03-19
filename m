Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48518 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2CSL3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 07:29:05 -0400
Received: by pbcun15 with SMTP id un15so1063139pbc.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 04:29:04 -0700 (PDT)
From: santosh nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org
Cc: olivier.grenie@parrot.com, olivier.grenie@dibcom.fr,
	pboettcher@kernellabs.com, florian@mickler.org,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [media] dib0700: Return -EINTR and unlock mutex if locking attempts fails.
Date: Mon, 19 Mar 2012 16:57:37 +0530
Message-Id: <1332156457-18180-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

In 'dib0700_i2c_xfer_new()' and 'dib0700_i2c_xfer_legacy()'
we are taking two locks:
                1. i2c_mutex
                2. usb_mutex
If attempt to take 'usb_mutex' lock fails then the previously taken
lock 'i2c_mutex' should be unlocked and -EINTR should be returned so
that caller can take appropriate action.

If locking attempt was interrupted by a signal then
we should return -EINTR. At present we are returning '0' for
such scenarios  which is wrong.

Replace -EAGAIN by -EINTR as a return type for the the scenario
where locking attempt was interrupted by signal.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 070e82a..a271203 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -32,7 +32,7 @@ int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
 
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		return -EINTR;
 	}
 
 	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
@@ -118,7 +118,7 @@ int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_
 
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		return -EINTR;
 	}
 
 	st->buf[0] = REQUEST_SET_GPIO;
@@ -139,7 +139,7 @@ static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
 	if (st->fw_version >= 0x10201) {
 		if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 			err("could not acquire lock");
-			return 0;
+			return -EINTR;
 		}
 
 		st->buf[0] = REQUEST_SET_USB_XFER_LEN;
@@ -178,7 +178,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 	/* Ensure nobody else hits the i2c bus while we're sending our
 	   sequence of messages, (such as the remote control thread) */
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
+		return -EINTR;
 
 	for (i = 0; i < num; i++) {
 		if (i == 0) {
@@ -228,7 +228,8 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			/* Write request */
 			if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 				err("could not acquire lock");
-				return 0;
+				mutex_unlock(&d->i2c_mutex);
+				return -EINTR;
 			}
 			st->buf[0] = REQUEST_NEW_I2C_WRITE;
 			st->buf[1] = msg[i].addr << 1;
@@ -271,10 +272,11 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 	int i,len;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
+		return -EINTR;
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		mutex_unlock(&d->i2c_mutex);
+		return -EINTR;
 	}
 
 	for (i = 0; i < num; i++) {
@@ -369,7 +371,7 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
 
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		return -EINTR;
 	}
 
 	st->buf[0] = REQUEST_SET_CLOCK;
@@ -401,7 +403,7 @@ int dib0700_set_i2c_speed(struct dvb_usb_device *d, u16 scl_kHz)
 
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		return -EINTR;
 	}
 
 	st->buf[0] = REQUEST_SET_I2C_PARAM;
@@ -561,7 +563,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	if (mutex_lock_interruptible(&adap->dev->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		return -EINTR;
 	}
 
 	st->buf[0] = REQUEST_ENABLE_VIDEO;
@@ -611,7 +613,7 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
 
 	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 		err("could not acquire lock");
-		return 0;
+		return -EINTR;
 	}
 
 	st->buf[0] = REQUEST_SET_RC;
-- 
1.7.4.4

