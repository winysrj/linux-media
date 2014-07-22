Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43263 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbaGVUMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 16:12:37 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, m.chehab@samsung.com, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 4/8] cx231xx: prepare for i2c_client attachment
Date: Tue, 22 Jul 2014 22:12:14 +0200
Message-Id: <1406059938-21141-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed to support PCTV QuatroStick 522e which uses a si2157.
The si2157 driver is written using i2c_client attachment.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 4504bc6..5c69be7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -67,6 +67,7 @@ struct cx231xx_dvb {
 	struct dmx_frontend fe_hw;
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
+	struct i2c_client *i2c_client_tuner;
 };
 
 static struct s5h1432_config dvico_s5h1432_config = {
@@ -549,11 +550,18 @@ fail_adapter:
 
 static void unregister_dvb(struct cx231xx_dvb *dvb)
 {
+	struct i2c_client *client;
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	dvb_dmxdev_release(&dvb->dmxdev);
 	dvb_dmx_release(&dvb->demux);
+	client = dvb->i2c_client_tuner;
+	/* remove I2C tuner */
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
 	dvb_unregister_frontend(dvb->frontend);
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
-- 
2.0.0

