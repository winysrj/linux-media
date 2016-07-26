Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55110 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbcGZHJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:39 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 3/7] cx231xx: Prepare for attaching new style i2c_client DVB demod drivers
Date: Tue, 26 Jul 2016 09:09:04 +0200
Message-Id: <20160726070908.10135-3-zzam@gentoo.org>
In-Reply-To: <20160726070908.10135-1-zzam@gentoo.org>
References: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx231xx does not yet support attaching new-style i2c_client DVB demod
drivers. Add necessary code base on tuner support for i2c_client.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index ab2fb9f..f030345 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -65,6 +65,7 @@ struct cx231xx_dvb {
 	struct dmx_frontend fe_hw;
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
+	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 };
 
@@ -586,8 +587,14 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	dvb_dmxdev_release(&dvb->dmxdev);
 	dvb_dmx_release(&dvb->demux);
-	client = dvb->i2c_client_tuner;
 	/* remove I2C tuner */
+	client = dvb->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+	/* remove I2C demod */
+	client = dvb->i2c_client_demod;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
-- 
2.9.2

