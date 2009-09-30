Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:51296 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZI3MZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 08:25:19 -0400
Date: Wed, 30 Sep 2009 14:25:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20090930142516.23eb09df@hyperion.delvare>
In-Reply-To: <200909301352.28362.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	<200909301016.15327.pluto@agmk.net>
	<20090930125737.704413c8@hyperion.delvare>
	<200909301352.28362.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 30 Sep 2009 13:52:27 +0200, Paweł Sikora wrote:
> On Wednesday 30 September 2009 12:57:37 Jean Delvare wrote:
> 
> > Are you running distribution kernels or self-compiled ones?
> > Any local patches applied?
> > Would you be able to apply debug patches and rebuild your kernel?
> 
> yes, i'm using patched (vserver,grsec) modular kernel from pld-linux
> but i'm able to boot custom git build and do the bisect if necessary.

OK, then it would be great if you could try the patch below on top of
kernel 2.6.31, and report everything that gets logged before the oops.
Of course, if you can also bisect to find out which exact change causes
the oops, that would be very helpful.

---
 drivers/media/common/ir-functions.c |    8 +++++++-
 drivers/media/video/ir-kbd-i2c.c    |    6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- linux-2.6.31.orig/drivers/media/common/ir-functions.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.31/drivers/media/common/ir-functions.c	2009-09-30 14:15:10.000000000 +0200
@@ -62,6 +62,9 @@ void ir_input_init(struct input_dev *dev
 {
 	int i;
 
+	pr_info("%s: dev=%p, ir=%p, ir_type=%d, ir_codes=%p\n",
+		__func__, dev, ir, ir_type, ir_codes);
+
 	ir->ir_type = ir_type;
 	if (ir_codes)
 		memcpy(ir->ir_codes, ir_codes, sizeof(ir->ir_codes));
@@ -69,8 +72,11 @@ void ir_input_init(struct input_dev *dev
 	dev->keycode     = ir->ir_codes;
 	dev->keycodesize = sizeof(IR_KEYTAB_TYPE);
 	dev->keycodemax  = IR_KEYTAB_SIZE;
-	for (i = 0; i < IR_KEYTAB_SIZE; i++)
+	for (i = 0; i < IR_KEYTAB_SIZE; i++) {
+		pr_info("%s: [i=%d] Setting bit %u of dev->keybit\n",
+			__func__, i, ir->ir_codes[i]);
 		set_bit(ir->ir_codes[i], dev->keybit);
+	}
 	clear_bit(0, dev->keybit);
 
 	set_bit(EV_KEY, dev->evbit);
--- linux-2.6.31.orig/drivers/media/video/ir-kbd-i2c.c	2009-09-10 10:08:22.000000000 +0200
+++ linux-2.6.31/drivers/media/video/ir-kbd-i2c.c	2009-09-30 14:17:37.000000000 +0200
@@ -317,6 +317,7 @@ static int ir_probe(struct i2c_client *c
 	ir->input = input_dev;
 	i2c_set_clientdata(client, ir);
 
+	pr_info("%s: addr=0x%02hx\n", __func__, addr);
 	switch(addr) {
 	case 0x64:
 		name        = "Pixelview";
@@ -385,6 +386,9 @@ static int ir_probe(struct i2c_client *c
 		goto err_out_free;
 	}
 
+	pr_info("%s: [before override] ir_codes=%p, name=%s, get_key=%p\n",
+		__func__, ir_codes, name, ir->get_key);
+
 	/* Let the caller override settings */
 	if (client->dev.platform_data) {
 		const struct IR_i2c_init_data *init_data =
@@ -393,6 +397,8 @@ static int ir_probe(struct i2c_client *c
 		ir_codes = init_data->ir_codes;
 		name = init_data->name;
 		ir->get_key = init_data->get_key;
+		pr_info("%s: [after  override] ir_codes=%p, name=%s, get_key=%p\n",
+			__func__, ir_codes, name, ir->get_key);
 	}
 
 	/* Make sure we are all setup before going on */


-- 
Jean Delvare
