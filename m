Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab0KKNe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 08:34:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oABDYRJZ013143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 08:34:27 -0500
Received: from pedra (vpn-228-194.phx2.redhat.com [10.3.228.194])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oABDXNjX027735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 08:34:26 -0500
Date: Thu, 11 Nov 2010 11:33:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] rc: Allow specifying properties for i2c IR's
Message-ID: <20101111113314.505c9e05@pedra>
In-Reply-To: <cover.1289482268.git.mchehab@redhat.com>
References: <cover.1289482268.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Several I2C IR's only provide part of the IR protocol message (in general,
they provide only the command part). Due to that, some props fields need
to be specified.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index aee8943..82834ea 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -270,6 +270,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
+	struct ir_dev_props *props = NULL;
 	u64 ir_type = IR_TYPE_UNKNOWN;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
@@ -337,6 +338,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name = init_data->name;
 		if (init_data->type)
 			ir_type = init_data->type;
+		props = init_data->props;
 
 		if (init_data->polling_interval)
 			ir->polling_interval = init_data->polling_interval;
@@ -388,7 +390,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
 
-	err = ir_input_register(ir->input, ir->ir_codes, NULL, MODULE_NAME);
+	err = ir_input_register(ir->input, ir->ir_codes, props, MODULE_NAME);
 	if (err)
 		goto err_out_free;
 
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 8c37b5e..19ea5fa 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -47,5 +47,7 @@ struct IR_i2c_init_data {
 	 */
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
 	enum ir_kbd_get_key_fn internal_get_key_func;
+
+	struct ir_dev_props    *props;
 };
 #endif
-- 
1.7.1


