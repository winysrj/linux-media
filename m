Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753699AbcKPQnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 28/35] [media] msp3400-driver: don't use KERN_CONT
Date: Wed, 16 Nov 2016 14:43:00 -0200
Message-Id: <cfd923aa95ee579f1e9271c0548d7c697b343196.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers using dev_foo() macro should not use KERN_CONT, as, internally,
those macros work as if all strings were terminated by a \n. So, doing:

	dev_info(&client->dev, "%s ", client->name);
	printk(KERN_CONT "supports radio, mode is autodetect and autoselect");

Would produce the following output:

	msp3400 6-0044: msp3400
	supports radio, mode is autodetect and autoselect

As there's no good reason to use KERN_CONT, let's rewrite the code
to avoid that, allowing this driver to be converted to dev_foo().

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/msp3400-driver.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 503b7c4f0a9b..8b5913188bc8 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -670,6 +670,13 @@ static const struct v4l2_subdev_ops msp_ops = {
 
 /* ----------------------------------------------------------------------- */
 
+
+static const char const *opmode_str[] = {
+	[OPMODE_MANUAL] = "manual",
+	[OPMODE_AUTODETECT] = "autodetect",
+	[OPMODE_AUTOSELECT] = "autodetect and autoselect",
+};
+
 static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct msp_state *state;
@@ -791,7 +798,8 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		msp_family == 3 && msp_revision == 'G' && msp_prod_hi == 3;
 
 	state->opmode = opmode;
-	if (state->opmode == OPMODE_AUTO) {
+	if (state->opmode < OPMODE_MANUAL
+	    || state->opmode > OPMODE_AUTOSELECT) {
 		/* MSP revision G and up have both autodetect and autoselect */
 		if (msp_revision >= 'G')
 			state->opmode = OPMODE_AUTOSELECT;
@@ -829,36 +837,28 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	v4l2_ctrl_cluster(2, &state->volume);
 	v4l2_ctrl_handler_setup(hdl);
 
-	/* hello world :-) */
-	v4l_info(client, "MSP%d4%02d%c-%c%d found @ 0x%x (%s)\n",
-			msp_family, msp_product,
-			msp_revision, msp_hard, msp_rom,
-			client->addr << 1, client->adapter->name);
-	v4l_info(client, "%s ", client->name);
-	if (state->has_nicam && state->has_radio)
-		printk(KERN_CONT "supports nicam and radio, ");
-	else if (state->has_nicam)
-		printk(KERN_CONT "supports nicam, ");
-	else if (state->has_radio)
-		printk(KERN_CONT "supports radio, ");
-	printk(KERN_CONT "mode is ");
+	dev_info(&client->dev,
+		 "MSP%d4%02d%c-%c%d found on %s: supports %s%s%s, mode is %s\n",
+		 msp_family, msp_product,
+		 msp_revision, msp_hard, msp_rom,
+		 client->adapter->name,
+		 (state->has_nicam) ? "nicam" : "",
+		 (state->has_nicam && state->has_radio) ? " and " : "",
+		 (state->has_radio) ? "radio" : "",
+		 opmode_str[state->opmode]);
 
 	/* version-specific initialization */
 	switch (state->opmode) {
 	case OPMODE_MANUAL:
-		printk(KERN_CONT "manual");
 		thread_func = msp3400c_thread;
 		break;
 	case OPMODE_AUTODETECT:
-		printk(KERN_CONT "autodetect");
 		thread_func = msp3410d_thread;
 		break;
 	case OPMODE_AUTOSELECT:
-		printk(KERN_CONT "autodetect and autoselect");
 		thread_func = msp34xxg_thread;
 		break;
 	}
-	printk(KERN_CONT "\n");
 
 	/* startup control thread if needed */
 	if (thread_func) {
-- 
2.7.4


