Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35413 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322AbbEEQeO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:34:14 -0400
Received: by lbbuc2 with SMTP id uc2so132956806lbb.2
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 09:34:13 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/4] dw2102: debugging improvements
Date: Tue,  5 May 2015 19:33:54 +0300
Message-Id: <1430843635-24002-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430843635-24002-1-git-send-email-olli.salonen@iki.fi>
References: <1430843635-24002-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move some info printouts to be debugging printouts that are only shown
if debugging for the module is enabled. The module already implemented
deb_rc and deb_xfer, but not deb_info.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 6 ++++--
 drivers/media/usb/dvb-usb/dw2102.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index b1f8a3f..7552521 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -881,6 +881,8 @@ static int su3000_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		.len = 1
 	};
 
+	deb_info("%s: onoff: %d\n", __func__, onoff);
+
 	i2c_transfer(&adap->dev->i2c_adap, &msg, 1);
 
 	return 0;
@@ -891,7 +893,7 @@ static int su3000_power_ctrl(struct dvb_usb_device *d, int i)
 	struct dw2102_state *state = (struct dw2102_state *)d->priv;
 	u8 obuf[] = {0xde, 0};
 
-	info("%s: %d, initialized %d", __func__, i, state->initialized);
+	deb_info("%s: %d, initialized %d\n", __func__, i, state->initialized);
 
 	if (i && !state->initialized) {
 		state->initialized = 1;
@@ -938,7 +940,7 @@ static int su3000_identify_state(struct usb_device *udev,
 				 struct dvb_usb_device_description **desc,
 				 int *cold)
 {
-	info("%s", __func__);
+	deb_info("%s\n", __func__);
 
 	*cold = 0;
 	return 0;
diff --git a/drivers/media/usb/dvb-usb/dw2102.h b/drivers/media/usb/dvb-usb/dw2102.h
index 5cd0b0e..1602368 100644
--- a/drivers/media/usb/dvb-usb/dw2102.h
+++ b/drivers/media/usb/dvb-usb/dw2102.h
@@ -4,6 +4,7 @@
 #define DVB_USB_LOG_PREFIX "dw2102"
 #include "dvb-usb.h"
 
+#define deb_info(args...) dprintk(dvb_usb_dw2102_debug, 0x01, args)
 #define deb_xfer(args...) dprintk(dvb_usb_dw2102_debug, 0x02, args)
 #define deb_rc(args...)   dprintk(dvb_usb_dw2102_debug, 0x04, args)
 #endif
-- 
1.9.1

