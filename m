Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.194]:56420 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220AbaHKT62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:28 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: olli@cabbala.net
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] cx23885: add i2c client handling into dvb_unregister and state
Date: Mon, 11 Aug 2014 22:58:13 +0300
Message-Id: <1407787095-2167-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare cx23885 driver for handling I2C client that is needed for certain demodulators and tuners (for example Si2168 and Si2157). I2C client for tuner and demod stored in state and unregistering of the I2C devices added into dvb_unregister.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 16 ++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h     |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 968fecc..2608155 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1643,6 +1643,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 int cx23885_dvb_unregister(struct cx23885_tsport *port)
 {
 	struct videobuf_dvb_frontend *fe0;
+	struct i2c_client *client;
 
 	/* FIXME: in an error condition where the we have
 	 * an expected number of frontends (attach problem)
@@ -1651,6 +1652,21 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
 	 * This comment only applies to future boards IF they
 	 * implement MFE support.
 	 */
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
 	fe0 = videobuf_dvb_get_frontend(&port->frontends, 1);
 	if (fe0 && fe0->dvb.frontend)
 		videobuf_dvb_unregister_bus(&port->frontends);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 0e086c0..1040b3e 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -326,6 +326,9 @@ struct cx23885_tsport {
 	/* Workaround for a temp dvb_frontend that the tuner can attached to */
 	struct dvb_frontend analog_fe;
 
+	struct i2c_client *i2c_client_demod;
+	struct i2c_client *i2c_client_tuner;
+
 	int (*set_frontend)(struct dvb_frontend *fe);
 };
 
-- 
1.9.1

