Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34064 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbbCPROZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 13:14:25 -0400
Received: by lbbsy1 with SMTP id sy1so35727278lbb.1
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 10:14:23 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/3] dw2102: combine su3000_state and s6x0_state into dw2102_state
Date: Mon, 16 Mar 2015 19:14:04 +0200
Message-Id: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two separate state structs are defined for different devices inside the dw2102. Combine them, 
as both only contain one element. This will also make it easier to implement the next patch 
in the patch series.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 1a3df10..c68a610 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -112,11 +112,8 @@
 		"Please see linux/Documentation/dvb/ for more details " \
 		"on firmware-problems."
 
-struct su3000_state {
+struct dw2102_state {
 	u8 initialized;
-};
-
-struct s6x0_state {
 	int (*old_set_voltage)(struct dvb_frontend *f, fe_sec_voltage_t v);
 };
 
@@ -887,7 +884,7 @@ static int su3000_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 static int su3000_power_ctrl(struct dvb_usb_device *d, int i)
 {
-	struct su3000_state *state = (struct su3000_state *)d->priv;
+	struct dw2102_state *state = (struct dw2102_state *)d->priv;
 	u8 obuf[] = {0xde, 0};
 
 	info("%s: %d, initialized %d\n", __func__, i, state->initialized);
@@ -973,7 +970,7 @@ static int s660_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	struct dvb_usb_adapter *d =
 		(struct dvb_usb_adapter *)(fe->dvb->priv);
-	struct s6x0_state *st = (struct s6x0_state *)d->dev->priv;
+	struct dw2102_state *st = (struct dw2102_state *)d->dev->priv;
 
 	dw210x_set_voltage(fe, voltage);
 	if (st->old_set_voltage)
@@ -1295,7 +1292,7 @@ static int stv0288_frontend_attach(struct dvb_usb_adapter *d)
 
 static int ds3000_frontend_attach(struct dvb_usb_adapter *d)
 {
-	struct s6x0_state *st = (struct s6x0_state *)d->dev->priv;
+	struct dw2102_state *st = d->dev->priv;
 	u8 obuf[] = {7, 1};
 
 	d->fe_adap[0].fe = dvb_attach(ds3000_attach, &s660_ds3000_config,
@@ -1857,7 +1854,7 @@ static struct dvb_usb_device_properties dw3101_properties = {
 static struct dvb_usb_device_properties s6x0_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
-	.size_of_priv = sizeof(struct s6x0_state),
+	.size_of_priv = sizeof(struct dw2102_state),
 	.firmware = S630_FIRMWARE,
 	.no_reconnect = 1,
 
@@ -1950,7 +1947,7 @@ static struct dvb_usb_device_description d632 = {
 static struct dvb_usb_device_properties su3000_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
-	.size_of_priv = sizeof(struct su3000_state),
+	.size_of_priv = sizeof(struct dw2102_state),
 	.power_ctrl = su3000_power_ctrl,
 	.num_adapters = 1,
 	.identify_state	= su3000_identify_state,
@@ -2015,7 +2012,7 @@ static struct dvb_usb_device_properties su3000_properties = {
 static struct dvb_usb_device_properties t220_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
-	.size_of_priv = sizeof(struct su3000_state),
+	.size_of_priv = sizeof(struct dw2102_state),
 	.power_ctrl = su3000_power_ctrl,
 	.num_adapters = 1,
 	.identify_state	= su3000_identify_state,
-- 
1.9.1

