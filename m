Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57437 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1K0VfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 16:35:15 -0500
Received: by wwp14 with SMTP id 14so7666618wwp.1
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2011 13:35:14 -0800 (PST)
Message-ID: <1322429706.29078.1.camel@tvbox>
Subject: [PATCH] for 3_3 it913x endpoint size changes.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 27 Nov 2011 21:35:06 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously endpoint had been aligned to packet size (128)

Some early it9135 devices appear to have problems with this.

This patch now aligns with mpeg TS size (188)

With the pid filter off max size is increased to the maxmium
size (348 * 188)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 9abdaee..24f04b4 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -337,6 +337,13 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 
 	return ret;
 }
+
+#define TS_MPEG_PKT_SIZE	188
+#define EP_LOW			21
+#define TS_BUFFER_SIZE_PID	(EP_LOW*TS_MPEG_PKT_SIZE)
+#define EP_HIGH			348
+#define TS_BUFFER_SIZE_MAX	(EP_HIGH*TS_MPEG_PKT_SIZE)
+
 static int it913x_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_properties *props,
 		struct dvb_usb_device_description **desc,
@@ -374,6 +381,17 @@ static int it913x_identify_state(struct usb_device *udev,
 	info("Dual mode=%x Remote=%x Tuner Type=%x", it913x_config.dual_mode
 		, remote, it913x_config.tuner_id_0);
 
+	/* Select Stream Buffer Size */
+	if (pid_filter)
+		props->adapter[0].fe[0].stream.u.bulk.buffersize =
+			TS_BUFFER_SIZE_MAX;
+	else
+		props->adapter[0].fe[0].stream.u.bulk.buffersize =
+			TS_BUFFER_SIZE_PID;
+	if (it913x_config.dual_mode)
+		props->adapter[1].fe[0].stream.u.bulk.buffersize =
+			props->adapter[0].fe[0].stream.u.bulk.buffersize;
+
 	if (firm_no > 0) {
 		*cold = 0;
 		return 0;
@@ -511,7 +529,7 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 	struct usb_device *udev = adap->dev->udev;
 	int ret = 0;
 	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
-	u16 ep_size = adap->props.fe[0].stream.u.bulk.buffersize;
+	u16 ep_size = adap->props.fe[0].stream.u.bulk.buffersize / 4;
 	u8 pkt_size = 0x80;
 
 	if (adap->dev->udev->speed != USB_SPEED_HIGH)
@@ -610,8 +628,8 @@ static struct dvb_usb_device_properties it913x_properties = {
 				.endpoint = 0x04,
 				.u = {/* Keep Low if PID filter on */
 					.bulk = {
-						.buffersize = 3584,
-
+					.buffersize =
+						TS_BUFFER_SIZE_PID,
 					}
 				}
 			}
@@ -635,8 +653,8 @@ static struct dvb_usb_device_properties it913x_properties = {
 				.endpoint = 0x05,
 				.u = {
 					.bulk = {
-						.buffersize = 3584,
-
+						.buffersize =
+							TS_BUFFER_SIZE_PID,
 					}
 				}
 			}
-- 
1.7.7.1


