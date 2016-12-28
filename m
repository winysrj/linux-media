Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbcL1LJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Dec 2016 06:09:04 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Olli Salonen <olli.salonen@iki.fi>,
        Benjamin Larsson <benjamin@southpole.se>,
        =?UTF-8?q?Torbj=C3=B6rn=20Jansson?=
        <torbjorn.jansson@mbox200.swipnet.se>
Subject: [PATCH] Don't detach frontends at .exit() callback
Date: Wed, 28 Dec 2016 09:08:54 -0200
Message-Id: <0a4df5797c3165441cc425382dfced711109edb1.1482923326.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The .exit() callback is called when the USB device is
detached. On dvbsky, this callback was used to detach the
frontends. However, i the frontend kthread is still running on
that time, the logic will keep calling the tuner drivers, with
could lead to either warnings about mutexes taking too long or
GPF, because a removed module would be called.

Instead, move such logic to the frontend_detach() callback,
where it belongs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 0636eac37bbb..d3fa75a2aa7e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -696,9 +696,9 @@ static int dvbsky_init(struct dvb_usb_device *d)
 	return 0;
 }
 
-static void dvbsky_exit(struct dvb_usb_device *d)
+static int dvbsky_frontend_detach(struct dvb_usb_adapter *adap)
 {
-	struct dvbsky_state *state = d_to_priv(d);
+	struct dvbsky_state *state = adap_to_priv(adap);
 	struct i2c_client *client;
 
 	client = state->i2c_client_tuner;
@@ -719,6 +719,7 @@ static void dvbsky_exit(struct dvb_usb_device *d)
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
 	}
+	return 0;
 }
 
 /* DVB USB Driver stuff */
@@ -734,11 +735,11 @@ static struct dvb_usb_device_properties dvbsky_s960_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_s960_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -761,11 +762,11 @@ static struct dvb_usb_device_properties dvbsky_s960c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_s960c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -788,11 +789,11 @@ static struct dvb_usb_device_properties dvbsky_t680c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_t680c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -815,11 +816,11 @@ static struct dvb_usb_device_properties dvbsky_t330_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_t330_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
-- 
2.9.3

