Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:56858 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaI2HpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 03:45:05 -0400
Received: by mail-la0-f51.google.com with SMTP id pv20so7682157lab.24
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 00:45:03 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 4/5] cx23885: add I2C client for CI into state and handle unregistering
Date: Mon, 29 Sep 2014 10:44:19 +0300
Message-Id: <1411976660-19329-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the CI chip has an I2C driver, we need to store I2C client into state.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 7 +++++++
 drivers/media/pci/cx23885/cx23885.h     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index d327459..cc88997 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1923,6 +1923,13 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
 	 * implement MFE support.
 	 */
 
+	/* remove I2C client for CI */
+	client = port->i2c_client_ci;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	/* remove I2C client for tuner */
 	client = port->i2c_client_tuner;
 	if (client) {
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 1792d1a..c35ba2d 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -297,6 +297,7 @@ struct cx23885_tsport {
 
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
+	struct i2c_client *i2c_client_ci;
 
 	int (*set_frontend)(struct dvb_frontend *fe);
 	int (*fe_set_voltage)(struct dvb_frontend *fe,
-- 
1.9.1

