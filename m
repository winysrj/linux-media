Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbcERIaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2016 04:30:52 -0400
Date: Wed, 18 May 2016 10:30:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi
Subject: Re: [PATCH] support for AD5820 camera auto-focus coil
Message-ID: <20160518083048.GA30870@amd>
References: <20160517181927.GA28741@amd>
 <20160517183340.GA10358@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160517183340.GA10358@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

...
> Use module_i2c_driver() instead.

Thanks for all the comments, I've fixed it up like this, will post new
version soon.

Best regards,
								Pavel

commit 97a793fb20be29e7ed217c007e8bf857f9854968
Author: Pavel <pavel@ucw.cz>
Date:   Wed May 18 10:22:06 2016 +0200

    Cleanups, as suggested by Marcus Folkesson

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index b71cc11..7725829 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -147,7 +147,6 @@ static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
 	struct ad5820_device *coil =
 		container_of(ctrl->handler, struct ad5820_device, ctrls);
 	u32 code;
-	int r = 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_FOCUS_ABSOLUTE:
@@ -165,7 +164,7 @@ static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	}
 
-	return r;
+	return 0;
 }
 
 static const struct v4l2_ctrl_ops ad5820_ctrl_ops = {
@@ -245,8 +244,6 @@ static int ad5820_init_controls(struct ad5820_device *coil)
  */
 static int ad5820_registered(struct v4l2_subdev *subdev)
 {
-	static const int CHECK_VALUE = 0x3FF0;
-
 	struct ad5820_device *coil = to_ad5820_device(subdev);
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 
@@ -364,16 +361,19 @@ static int ad5820_probe(struct i2c_client *client,
 	strcpy(coil->subdev.name, "ad5820 focus");
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
-	if (ret < 0) {
-		kfree(coil);
-		return ret;
-	}
+	if (ret < 0)
+		goto free;
 
 	ret = v4l2_async_register_subdev(&coil->subdev);
 	if (ret < 0)
-		kfree(coil);
+		goto cleanup;
 
 	return ret;
+cleanup:
+	media_entity_cleanup(&coil->subdev.entity);
+free:
+	kfree(coil);
+	return ret;
 }
 
 static int __exit ad5820_remove(struct i2c_client *client)
@@ -409,26 +409,7 @@ static struct i2c_driver ad5820_i2c_driver = {
 	.id_table	= ad5820_id_table,
 };
 
-static int __init ad5820_init(void)
-{
-	int rval;
-
-	rval = i2c_add_driver(&ad5820_i2c_driver);
-	if (rval)
-		printk(KERN_INFO "%s: failed registering " AD5820_NAME "\n",
-		       __func__);
-
-	return rval;
-}
-
-static void __exit ad5820_exit(void)
-{
-	i2c_del_driver(&ad5820_i2c_driver);
-}
-
-
-module_init(ad5820_init);
-module_exit(ad5820_exit);
+module_i2c_driver(ad5820_i2c_driver);
 
 MODULE_AUTHOR("Tuukka Toivonen");
 MODULE_DESCRIPTION("AD5820 camera lens driver");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
