Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0KLNaO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 08:30:14 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACDUEB9006486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 08:30:14 -0500
Received: from pedra (vpn-229-188.phx2.redhat.com [10.3.229.188])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oACDTBbY004220
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 08:30:13 -0500
Date: Fri, 12 Nov 2010 11:28:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] ir-kbd-i2c: add rc_dev as a parameter to the
 driver
Message-ID: <20101112112838.2218e2d7@pedra>
In-Reply-To: <cover.1289568397.git.mchehab@redhat.com>
References: <cover.1289568397.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are several fields on rc_dev that drivers can benefit. Allow drivers
to pass it as a parameter to the driver.

For now, the rc_dev parameter is optional. If drivers don't pass it, create
them internally. However, the best is to create rc_dev inside the drivers,
in order to fill other fields, like open(), close(), driver_name, etc.
So, a latter patch making it mandatory and changing the caller drivers is
welcome.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 55a22e7..50bb627 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -272,20 +272,16 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	const char *name = NULL;
 	u64 ir_type = IR_TYPE_UNKNOWN;
 	struct IR_i2c *ir;
-	struct rc_dev *rc;
+	struct rc_dev *rc = NULL;
 	struct i2c_adapter *adap = client->adapter;
 	unsigned short addr = client->addr;
 	int err;
 
-	ir = kzalloc(sizeof(struct IR_i2c),GFP_KERNEL);
-	rc = rc_allocate_device();
-	if (!ir || !rc) {
-		err = -ENOMEM;
-		goto err_out_free;
-	}
+	ir = kzalloc(sizeof(struct IR_i2c), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
 
 	ir->c = client;
-	ir->rc = rc;
 	ir->polling_interval = DEFAULT_POLLING_INTERVAL;
 	i2c_set_clientdata(client, ir);
 
@@ -334,6 +330,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 						client->dev.platform_data;
 
 		ir_codes = init_data->ir_codes;
+		rc = init_data->rc_dev;
+
 		name = init_data->name;
 		if (init_data->type)
 			ir_type = init_data->type;
@@ -367,6 +365,19 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		}
 	}
 
+	if (!rc) {
+		/*
+		 * If platform_data doesn't specify rc_dev, initilize it
+		 * internally
+		 */
+		rc = rc_allocate_device();
+		if (!rc) {
+			err = -ENOMEM;
+			goto err_out_free;
+		}
+	}
+	ir->rc = rc;
+
 	/* Make sure we are all setup before going on */
 	if (!name || !ir->get_key || !ir_type || !ir_codes) {
 		dprintk(1, ": Unsupported device at address 0x%02x\n",
@@ -383,12 +394,21 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 dev_name(&adap->dev),
 		 dev_name(&client->dev));
 
-	/* init + register input device */
+	/*
+	 * Initialize input_dev fields
+	 * It doesn't make sense to allow overriding them via platform_data
+	 */
 	rc->input_id.bustype = BUS_I2C;
-	rc->input_name       = ir->name;
 	rc->input_phys       = ir->phys;
-	rc->map_name         = ir->ir_codes;
-	rc->driver_name      = MODULE_NAME;
+	rc->input_name	     = ir->name;
+
+	/*
+	 * Initialize the other fields of rc_dev
+	 */
+	rc->map_name       = ir->ir_codes;
+	rc->allowed_protos = ir_type;
+	if (!rc->driver_name)
+		rc->driver_name = MODULE_NAME;
 
 	err = rc_register_device(rc);
 	if (err)
@@ -404,6 +424,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
  err_out_free:
+	/* Only frees rc if it were allocated internally */
 	rc_free_device(rc);
 	kfree(ir);
 	return err;
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 4ee9b42..aca015e 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -46,5 +46,7 @@ struct IR_i2c_init_data {
 	 */
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
 	enum ir_kbd_get_key_fn internal_get_key_func;
+
+	struct rc_dev		*rc_dev;
 };
 #endif
-- 
1.7.1


