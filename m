Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:57522 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLKDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 06:03:52 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so5343505lab.19
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 03:03:50 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: nibble.max@gmail.com, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/4] dvbsky: clean logging
Date: Sun, 12 Oct 2014 13:03:10 +0300
Message-Id: <1413108191-32510-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi>
References: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev_err includes the function name in the log printout, so there is no need to include it manually. While here, fix a small grammatical error in the i2c error message.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index fabe3f5..5c7387a 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -101,8 +101,7 @@ static int dvbsky_gpio_ctrl(struct dvb_usb_device *d, u8 gport, u8 value)
 	obuf[2] = value;
 	ret = dvbsky_usb_generic_rw(d, obuf, 3, ibuf, 1);
 	if (ret)
-		dev_err(&d->udev->dev, "%s: %s() failed=%d\n",
-			KBUILD_MODNAME, __func__, ret);
+		dev_err(&d->udev->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -119,7 +118,7 @@ static int dvbsky_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 	if (num > 2) {
 		dev_err(&d->udev->dev,
-		"dvbsky_usb: too many i2c messages[%d] than 2.", num);
+		"too many i2c messages[%d], max 2.", num);
 		ret = -EOPNOTSUPP;
 		goto i2c_error;
 	}
@@ -127,7 +126,7 @@ static int dvbsky_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	if (num == 1) {
 		if (msg[0].len > 60) {
 			dev_err(&d->udev->dev,
-			"dvbsky_usb: too many i2c bytes[%d] than 60.",
+			"too many i2c bytes[%d], max 60.",
 			msg[0].len);
 			ret = -EOPNOTSUPP;
 			goto i2c_error;
@@ -141,8 +140,7 @@ static int dvbsky_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			ret = dvbsky_usb_generic_rw(d, obuf, 4,
 					ibuf, msg[0].len + 1);
 			if (ret)
-				dev_err(&d->udev->dev, "%s: %s() failed=%d\n",
-					KBUILD_MODNAME, __func__, ret);
+				dev_err(&d->udev->dev, "failed=%d\n", ret);
 			if (!ret)
 				memcpy(msg[0].buf, &ibuf[1], msg[0].len);
 		} else {
@@ -154,13 +152,12 @@ static int dvbsky_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			ret = dvbsky_usb_generic_rw(d, obuf,
 					msg[0].len + 3, ibuf, 1);
 			if (ret)
-				dev_err(&d->udev->dev, "%s: %s() failed=%d\n",
-					KBUILD_MODNAME, __func__, ret);
+				dev_err(&d->udev->dev, "failed=%d\n", ret);
 		}
 	} else {
 		if ((msg[0].len > 60) || (msg[1].len > 60)) {
 			dev_err(&d->udev->dev,
-			"dvbsky_usb: too many i2c bytes[w-%d][r-%d] than 60.",
+			"too many i2c bytes[w-%d][r-%d], max 60.",
 			msg[0].len, msg[1].len);
 			ret = -EOPNOTSUPP;
 			goto i2c_error;
@@ -174,8 +171,7 @@ static int dvbsky_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		ret = dvbsky_usb_generic_rw(d, obuf,
 			msg[0].len + 4, ibuf, msg[1].len + 1);
 		if (ret)
-			dev_err(&d->udev->dev, "%s: %s() failed=%d\n",
-				KBUILD_MODNAME, __func__, ret);
+			dev_err(&d->udev->dev, "failed=%d\n", ret);
 
 		if (!ret)
 			memcpy(msg[1].buf, &ibuf[1], msg[1].len);
@@ -206,8 +202,7 @@ static int dvbsky_rc_query(struct dvb_usb_device *d)
 	obuf[0] = 0x10;
 	ret = dvbsky_usb_generic_rw(d, obuf, 1, ibuf, 2);
 	if (ret)
-		dev_err(&d->udev->dev, "%s: %s() failed=%d\n",
-			KBUILD_MODNAME, __func__, ret);
+		dev_err(&d->udev->dev, "failed=%d\n", ret);
 	if (ret == 0)
 		code = (ibuf[0] << 8) | ibuf[1];
 	if (code != 0xffff) {
-- 
1.9.1

