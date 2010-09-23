Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab0IWEfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 00:35:11 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4ZBit023774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:35:11 -0400
Received: from pedra (vpn-239-203.phx2.redhat.com [10.3.239.203])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4X3mf018821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:35:10 -0400
Date: Thu, 23 Sep 2010 01:32:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] V4L/DVB: saa7134: get rid of I2C_HW_SAA7134
Message-ID: <20100923013256.572781b1@pedra>
In-Reply-To: <cover.1285215968.git.mchehab@redhat.com>
References: <cover.1285215968.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The only reason for keeping I2C_HW_SAA7134 is to allow setting a
per-device polling interval. Just move this info to the platform
data, allowing drivers to change it per device, where needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 91b2c88..5a000c6 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -259,15 +259,9 @@ static void ir_key_poll(struct IR_i2c *ir)
 static void ir_work(struct work_struct *work)
 {
 	struct IR_i2c *ir = container_of(work, struct IR_i2c, work.work);
-	int polling_interval = 100;
-
-	/* MSI TV@nywhere Plus requires more frequent polling
-	   otherwise it will miss some keypresses */
-	if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
-		polling_interval = 50;
 
 	ir_key_poll(ir);
-	schedule_delayed_work(&ir->work, msecs_to_jiffies(polling_interval));
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling_interval));
 }
 
 /* ----------------------------------------------------------------------- */
@@ -292,6 +286,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	ir->c = client;
 	ir->input = input_dev;
+	ir->polling_interval = DEFAULT_POLLING_INTERVAL;
 	i2c_set_clientdata(client, ir);
 
 	switch(addr) {
@@ -343,6 +338,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		if (init_data->type)
 			ir_type = init_data->type;
 
+		if (init_data->polling_interval)
+			ir->polling_interval = init_data->polling_interval;
+
 		switch (init_data->internal_get_key_func) {
 		case IR_KBD_GET_KEY_CUSTOM:
 			/* The bridge driver provided us its own function */
diff --git a/drivers/media/video/saa7134/saa7134-i2c.c b/drivers/media/video/saa7134/saa7134-i2c.c
index da41b6b..2d3f6d2 100644
--- a/drivers/media/video/saa7134/saa7134-i2c.c
+++ b/drivers/media/video/saa7134/saa7134-i2c.c
@@ -328,7 +328,6 @@ static struct i2c_algorithm saa7134_algo = {
 static struct i2c_adapter saa7134_adap_template = {
 	.owner         = THIS_MODULE,
 	.name          = "saa7134",
-	.id            = I2C_HW_SAA7134,
 	.algo          = &saa7134_algo,
 };
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 0b336ca..52a1ee5 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -959,6 +959,11 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "MSI TV@nywhere Plus";
 		dev->init_data.get_key = get_key_msi_tvanywhere_plus;
 		dev->init_data.ir_codes = RC_MAP_MSI_TVANYWHERE_PLUS;
+		/*
+		 * MSI TV@nyware Plus requires more frequent polling
+		 * otherwise it will miss some keypresses
+		 */
+		dev->init_data.polling_interval = 50;
 		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 4102f0d..557c676 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -3,6 +3,8 @@
 
 #include <media/ir-common.h>
 
+#define DEFAULT_POLLING_INTERVAL	100	/* ms */
+
 struct IR_i2c;
 
 struct IR_i2c {
@@ -15,6 +17,8 @@ struct IR_i2c {
 	/* Used to avoid fast repeating */
 	unsigned char          old;
 
+	u32                    polling_interval; /* in ms */
+
 	struct delayed_work    work;
 	char                   name[32];
 	char                   phys[32];
@@ -34,8 +38,9 @@ enum ir_kbd_get_key_fn {
 /* Can be passed when instantiating an ir_video i2c device */
 struct IR_i2c_init_data {
 	char			*ir_codes;
-	const char             *name;
-	u64          type; /* IR_TYPE_RC5, etc */
+	const char		*name;
+	u64			type; /* IR_TYPE_RC5, etc */
+	u32			polling_interval; /* 0 means DEFAULT_POLLING_INTERVAL */
 	/*
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions
-- 
1.7.1

