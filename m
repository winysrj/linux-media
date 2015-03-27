Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:36401 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbC0L5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 07:57:38 -0400
Received: by labe2 with SMTP id e2so68313018lab.3
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 04:57:36 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/5] saa7164: store i2c_client for demod and tuner in state
Date: Fri, 27 Mar 2015 13:57:17 +0200
Message-Id: <1427457439-1493-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to support demodulators and tuners that have their drivers
implemented as I2C drivers, the i2c_client should be stored in state for
both.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/saa7164/saa7164-dvb.c | 16 ++++++++++++++++
 drivers/media/pci/saa7164/saa7164.h     |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index 16ae715..6b9e8f6 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -425,6 +425,7 @@ int saa7164_dvb_unregister(struct saa7164_port *port)
 	struct saa7164_dev *dev = port->dev;
 	struct saa7164_buffer *b;
 	struct list_head *c, *n;
+	struct i2c_client *client;
 
 	dprintk(DBGLVL_DVB, "%s()\n", __func__);
 
@@ -451,6 +452,21 @@ int saa7164_dvb_unregister(struct saa7164_port *port)
 	dvb_unregister_frontend(dvb->frontend);
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
+
+	/* remove I2C client for tuner */
+	client = port->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	/* remove I2C client for demodulator */
+	client = port->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index cd1a07c..37e450a 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -422,6 +422,9 @@ struct saa7164_port {
 	u8 last_v_cc;
 	u8 last_a_cc;
 	u32 done_first_interrupt;
+
+	struct i2c_client *i2c_client_demod;
+	struct i2c_client *i2c_client_tuner;
 };
 
 struct saa7164_dev {
-- 
1.9.1

