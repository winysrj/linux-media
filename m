Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbcB0Kvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Christian=20L=C3=B6pke?= <loepke@edfritsch.de>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] [media] technisat-usb2: don't do DMA on the stack
Date: Sat, 27 Feb 2016 07:51:10 -0300
Message-Id: <fe604c7ac76b314930a6be60b1e95495b9f5c57f.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/usb/dvb-usb/technisat-usb2.c:263 technisat_usb2_set_led() error: doing dma on the stack (led)
	drivers/media/usb/dvb-usb/technisat-usb2.c:280 technisat_usb2_set_led_timer() error: doing dma on the stack (&b)
	drivers/media/usb/dvb-usb/technisat-usb2.c:341 technisat_usb2_identify_state() error: doing dma on the stack (version)
	drivers/media/usb/dvb-usb/technisat-usb2.c:609 technisat_usb2_get_ir() error: doing dma on the stack (buf)
	drivers/media/usb/dvb-usb/technisat-usb2.c:619 technisat_usb2_get_ir() error: doing dma on the stack (buf)

Create a buffer at the device state and use it for all the DMA
transfers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c | 40 +++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 51487d2f7764..03047b76519e 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -60,6 +60,8 @@ struct technisat_usb2_state {
 	u8 power_state;
 
 	u16 last_scan_code;
+
+	u8 buf[64];
 };
 
 /* debug print helpers */
@@ -220,19 +222,18 @@ enum technisat_usb2_led_state {
 	TECH_LED_UNDEFINED
 };
 
-static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum technisat_usb2_led_state state)
+static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum technisat_usb2_led_state st)
 {
+	struct technisat_usb2_state *state = d->priv;
+	u8 *led = state->buf;
 	int ret;
 
-	u8 led[8] = {
-		red ? SET_RED_LED_VENDOR_REQUEST : SET_GREEN_LED_VENDOR_REQUEST,
-		0
-	};
+	led[0] = red ? SET_RED_LED_VENDOR_REQUEST : SET_GREEN_LED_VENDOR_REQUEST;
 
-	if (disable_led_control && state != TECH_LED_OFF)
+	if (disable_led_control && st != TECH_LED_OFF)
 		return 0;
 
-	switch (state) {
+	switch (st) {
 	case TECH_LED_ON:
 		led[1] = 0x82;
 		break;
@@ -263,7 +264,7 @@ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum techni
 		red ? SET_RED_LED_VENDOR_REQUEST : SET_GREEN_LED_VENDOR_REQUEST,
 		USB_TYPE_VENDOR | USB_DIR_OUT,
 		0, 0,
-		led, sizeof(led), 500);
+		led, 8, 500);
 
 	mutex_unlock(&d->i2c_mutex);
 	return ret;
@@ -271,8 +272,11 @@ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum techni
 
 static int technisat_usb2_set_led_timer(struct dvb_usb_device *d, u8 red, u8 green)
 {
+	struct technisat_usb2_state *state = d->priv;
+	u8 *b = state->buf;
 	int ret;
-	u8 b = 0;
+
+	b[0] = 0;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -281,7 +285,7 @@ static int technisat_usb2_set_led_timer(struct dvb_usb_device *d, u8 red, u8 gre
 		SET_LED_TIMER_DIVIDER_VENDOR_REQUEST,
 		USB_TYPE_VENDOR | USB_DIR_OUT,
 		(red << 8) | green, 0,
-		&b, 1, 500);
+		b, 1, 500);
 
 	mutex_unlock(&d->i2c_mutex);
 
@@ -328,7 +332,11 @@ static int technisat_usb2_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_description **desc, int *cold)
 {
 	int ret;
-	u8 version[3];
+	u8 *version;
+
+	version = kmalloc(3, GFP_KERNEL);
+	if (!version)
+		return -ENOMEM;
 
 	/* first select the interface */
 	if (usb_set_interface(udev, 0, 1) != 0)
@@ -342,7 +350,7 @@ static int technisat_usb2_identify_state(struct usb_device *udev,
 		GET_VERSION_INFO_VENDOR_REQUEST,
 		USB_TYPE_VENDOR | USB_DIR_IN,
 		0, 0,
-		version, sizeof(version), 500);
+		version, 3, 500);
 
 	if (ret < 0)
 		*cold = 1;
@@ -351,6 +359,8 @@ static int technisat_usb2_identify_state(struct usb_device *udev,
 		*cold = 0;
 	}
 
+	kfree(version);
+
 	return 0;
 }
 
@@ -594,7 +604,9 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
 
 static int technisat_usb2_get_ir(struct dvb_usb_device *d)
 {
-	u8 buf[62], *b;
+	struct technisat_usb2_state *state = d->priv;
+	u8 *buf = state->buf;
+	u8 *b;
 	int ret;
 	struct ir_raw_event ev;
 
@@ -620,7 +632,7 @@ static int technisat_usb2_get_ir(struct dvb_usb_device *d)
 			GET_IR_DATA_VENDOR_REQUEST,
 			USB_TYPE_VENDOR | USB_DIR_IN,
 			0x8080, 0,
-			buf, sizeof(buf), 500);
+			buf, 62, 500);
 
 unlock:
 	mutex_unlock(&d->i2c_mutex);
-- 
2.5.0

