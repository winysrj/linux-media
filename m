Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43738 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753319AbcL0J0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 04:26:44 -0500
Date: Tue, 27 Dec 2016 11:26:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161227092634.GK16630@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161222100104.GA30917@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 22, 2016 at 11:01:04AM +0100, Pavel Machek wrote:
> 
> Add driver for et8ek8 sensor, found in Nokia N900 main camera. Can be
> used for taking photos in 2.5MP resolution with fcam-dev.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Thanks!

I fixed a few checkpatch warnings and one or two minor matters, the diff is
here. No functional changes. I'm a bit surprised checkpatch.pl suggests to
use numerical values for permissions but I think I agree with that. Reason
is prioritised agains the rules. :-)

Btw. should we update maintainers as well? Would you like to put yourself
there? Feel free to add me, too...

The patches are here. I think they should be good to go to v4.11.

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=et8ek8>

Let me know if you're (not) happy with these:

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index d3de087..2df3ff4 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -347,13 +347,13 @@ static int et8ek8_i2c_write_reg(struct i2c_client *client, u16 data_length,
 	et8ek8_i2c_create_msg(client, data_length, reg, val, &msg, data);
 
 	r = i2c_transfer(client->adapter, &msg, 1);
-	if (r < 0)
+	if (r < 0) {
 		dev_err(&client->dev,
 			"wrote 0x%x to offset 0x%x error %d\n", val, reg, r);
-	else
-		r = 0; /* on success i2c_transfer() returns messages trasfered */
+		return r;
+	}
 
-	return r;
+	return 0;
 }
 
 static struct et8ek8_reglist *et8ek8_reglist_find_type(
@@ -620,14 +620,13 @@ static int et8ek8_set_test_pattern(struct et8ek8_sensor *sensor, s32 mode)
 	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1124,
 				    cbv_mode << 7);
 	if (rval)
-		return rval;		
+		return rval;
 
 	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x112C, din_sw);
 	if (rval)
 		return rval;
 
-	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1420, r1420);
-	return rval;
+	return et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1420, r1420);
 }
 
 /* -----------------------------------------------------------------------------
@@ -645,11 +644,11 @@ static int et8ek8_set_ctrl(struct v4l2_ctrl *ctrl)
 
 	case V4L2_CID_EXPOSURE:
 	{
-		int rows;
-		struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
-		rows = ctrl->val;
+		struct i2c_client *client =
+			v4l2_get_subdevdata(&sensor->subdev);
+
 		return et8ek8_i2c_write_reg(client, ET8EK8_REG_16BIT, 0x1243,
-					    rows);
+					    ctrl->val);
 	}
 
 	case V4L2_CID_TEST_PATTERN:
@@ -695,8 +694,9 @@ static int et8ek8_init_controls(struct et8ek8_sensor *sensor)
 		u32 min = 1, max = max_rows;
 
 		sensor->exposure =
-			v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
-					  V4L2_CID_EXPOSURE, min, max, min, max);
+			v4l2_ctrl_new_std(&sensor->ctrl_handler,
+					  &et8ek8_ctrl_ops, V4L2_CID_EXPOSURE,
+					  min, max, min, max);
 	}
 
 	/* V4L2_CID_PIXEL_RATE */
@@ -722,7 +722,7 @@ static void et8ek8_update_controls(struct et8ek8_sensor *sensor)
 {
 	struct v4l2_ctrl *ctrl;
 	struct et8ek8_mode *mode = &sensor->current_reglist->mode;
-	
+
 	u32 min, max, pixel_rate;
 	static const int S = 8;
 
@@ -1248,7 +1248,7 @@ et8ek8_priv_mem_read(struct device *dev, struct device_attribute *attr,
 
 	return ET8EK8_PRIV_MEM_SIZE;
 }
-static DEVICE_ATTR(priv_mem, S_IRUGO, et8ek8_priv_mem_read, NULL);
+static DEVICE_ATTR(priv_mem, 0444, et8ek8_priv_mem_read, NULL);
 
 /* --------------------------------------------------------------------------
  * V4L2 subdev core operations


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
