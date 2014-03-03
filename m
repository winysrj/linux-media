Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 39/79] [media] drx-j: Be sure that all allocated data are properly initialized
Date: Mon,  3 Mar 2014 07:06:33 -0300
Message-Id: <1393841233-24840-40-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The state struct is allocated without cleaning the memory.
This causes random bugs.

Clean it, and move the memcpy functions just below each kalloc,
to be clearer that all those data are properly filled.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 44e9bafcc9ed..a19547b08b02 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -342,7 +342,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	int result;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct drx39xxj_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct drx39xxj_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
@@ -353,39 +353,38 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	demod_addr = kmalloc(sizeof(struct i2c_device_addr), GFP_KERNEL);
 	if (demod_addr == NULL)
 		goto error;
+	memcpy(demod_addr, &drxj_default_addr_g,
+	       sizeof(struct i2c_device_addr));
 
 	demod_comm_attr = kmalloc(sizeof(struct drx_common_attr), GFP_KERNEL);
 	if (demod_comm_attr == NULL)
 		goto error;
+	memcpy(demod_comm_attr, &drxj_default_comm_attr_g,
+	       sizeof(struct drx_common_attr));
 
 	demod_ext_attr = kmalloc(sizeof(struct drxj_data), GFP_KERNEL);
 	if (demod_ext_attr == NULL)
 		goto error;
+	memcpy(demod_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
 
 	/* setup the state */
 	state->i2c = i2c;
 	state->demod = demod;
 
+	/* setup the demod data */
 	memcpy(demod, &drxj_default_demod_g, sizeof(struct drx_demod_instance));
 
 	demod->my_i2c_dev_addr = demod_addr;
-	memcpy(demod->my_i2c_dev_addr, &drxj_default_addr_g,
-	       sizeof(struct i2c_device_addr));
-	demod->my_i2c_dev_addr->user_data = state;
 	demod->my_common_attr = demod_comm_attr;
-	memcpy(demod->my_common_attr, &drxj_default_comm_attr_g,
-	       sizeof(struct drx_common_attr));
+	demod->my_i2c_dev_addr->user_data = state;
 	demod->my_common_attr->microcode = DRXJ_MC_MAIN;
 #if 0
 	demod->my_common_attr->verify_microcode = false;
 #endif
 	demod->my_common_attr->verify_microcode = true;
 	demod->my_common_attr->intermediate_freq = 5000;
-
 	demod->my_ext_attr = demod_ext_attr;
-	memcpy(demod->my_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
-	((struct drxj_data *)demod->my_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
-
+	((struct drxj_data *)demod_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
 	demod->my_tuner = NULL;
 
 	result = drx_open(demod);
-- 
1.8.5.3

