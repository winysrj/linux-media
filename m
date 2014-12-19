Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43386 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaLSI5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 03:57:43 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] cx23885: do not unregister demod I2C client twice on error
Date: Fri, 19 Dec 2014 10:56:40 +0200
Message-Id: <1418979403-28225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Demod I2C client should be NULL after demod is unregistered on error
path, otherwise it will be unregistered again when driver is unload.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index c47d182..6bb7935 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1793,12 +1793,14 @@ static int dvb_register(struct cx23885_tsport *port)
 					client_tuner->dev.driver == NULL) {
 				module_put(client_demod->dev.driver->owner);
 				i2c_unregister_device(client_demod);
+				port->i2c_client_demod = NULL;
 				goto frontend_detach;
 			}
 			if (!try_module_get(client_tuner->dev.driver->owner)) {
 				i2c_unregister_device(client_tuner);
 				module_put(client_demod->dev.driver->owner);
 				i2c_unregister_device(client_demod);
+				port->i2c_client_demod = NULL;
 				goto frontend_detach;
 			}
 			port->i2c_client_tuner = client_tuner;
@@ -1843,12 +1845,14 @@ static int dvb_register(struct cx23885_tsport *port)
 				client_tuner->dev.driver == NULL) {
 			module_put(client_demod->dev.driver->owner);
 			i2c_unregister_device(client_demod);
+			port->i2c_client_demod = NULL;
 			goto frontend_detach;
 		}
 		if (!try_module_get(client_tuner->dev.driver->owner)) {
 			i2c_unregister_device(client_tuner);
 			module_put(client_demod->dev.driver->owner);
 			i2c_unregister_device(client_demod);
+			port->i2c_client_demod = NULL;
 			goto frontend_detach;
 		}
 		port->i2c_client_tuner = client_tuner;
@@ -1989,6 +1993,7 @@ static int dvb_register(struct cx23885_tsport *port)
 				client_tuner->dev.driver == NULL) {
 			module_put(client_demod->dev.driver->owner);
 			i2c_unregister_device(client_demod);
+			port->i2c_client_demod = NULL;
 			goto frontend_detach;
 		}
 		if (!try_module_get(client_tuner->dev.driver->owner)) {
-- 
http://palosaari.fi/

