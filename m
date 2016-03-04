Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:52769 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbcCDOtj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 09:49:39 -0500
Message-ID: <56D9A07A.5040106@lysator.liu.se>
Date: Fri, 04 Mar 2016 15:49:30 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 00/18] i2c mux cleanup and locking update
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se> <56D96B15.8090806@lysator.liu.se>
In-Reply-To: <56D96B15.8090806@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I wrote:
> I wrote:
>> Concerns:
>> - The locking is perhaps too complex?
> 
> Ok, to highlight the benefits of this series, I expect that patches such as
> [1] and the one inlined below can follow up to clean up ad-hoc i2c locking
> in drivers. Putting this locking in one place instead of having it spread
> out in random drivers is a good thing.
> 
> PS. the inlined patch has not been tested as I have no hw, it's a proof of
> concept. Maybe the simplifications can be extended into rtl2832_sdr.c as well?
> Anyway, please do test this patch on top of the v4 series if you have the hw.

The untested patch in the previous message indeed has some obvious problems, so
I fixed that and folded some more removed code now that rtl2832_sdr does not
need to do anything special to access device registers.

The result builds for me, that's all the testing I have done.

diffstat for the two patches combined:
 drivers/media/dvb-frontends/rtl2832.c      | 216 ++++-------------------------
 drivers/media/dvb-frontends/rtl2832.h      |   4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h |   1 -
 drivers/media/dvb-frontends/rtl2832_sdr.c  |  13 +-
 drivers/media/dvb-frontends/rtl2832_sdr.h  |   5 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |   5 +-
 6 files changed, 34 insertions(+), 210 deletions(-)

Cheers,
Peter

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index fd1f05e9e79a..6ade321503f0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -153,31 +153,6 @@ static const struct rtl2832_reg_entry registers[] = {
 	[DVBT_REG_4MSEL]	= {0x013,  0, 0},
 };
 
-/* Our regmap is bypassing I2C adapter lock, thus we do it! */
-static int rtl2832_bulk_write(struct i2c_client *client, unsigned int reg,
-			      const void *val, size_t val_count)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-
-	return regmap_bulk_write(dev->regmap, reg, val, val_count);
-}
-
-static int rtl2832_update_bits(struct i2c_client *client, unsigned int reg,
-			       unsigned int mask, unsigned int val)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-
-	return regmap_update_bits(dev->regmap, reg, mask, val);
-}
-
-static int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg,
-			     void *val, size_t val_count)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-
-	return regmap_bulk_read(dev->regmap, reg, val, val_count);
-}
-
 static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 {
 	struct i2c_client *client = dev->client;
@@ -1091,7 +1066,6 @@ static int rtl2832_probe(struct i2c_client *client,
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
 	INIT_DELAYED_WORK(&dev->stat_work, rtl2832_stat_work);
 	/* create regmap */
-	mutex_init(&dev->regmap_mutex);
 	dev->regmap_config.reg_bits =  8,
 	dev->regmap_config.val_bits =  8,
 	dev->regmap_config.volatile_reg = rtl2832_volatile_reg,
@@ -1099,8 +1073,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev->regmap_config.ranges = regmap_range_cfg,
 	dev->regmap_config.num_ranges = ARRAY_SIZE(regmap_range_cfg),
 	dev->regmap_config.cache_type = REGCACHE_NONE,
-	dev->regmap = regmap_init(&client->dev, NULL, client,
-				  &dev->regmap_config);
+	dev->regmap = regmap_init_i2c(client, &dev->regmap_config);
 	if (IS_ERR(dev->regmap)) {
 		ret = PTR_ERR(dev->regmap);
 		goto err_kfree;
@@ -1131,9 +1104,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	pdata->enable_slave_ts = rtl2832_enable_slave_ts;
 	pdata->pid_filter = rtl2832_pid_filter;
 	pdata->pid_filter_ctrl = rtl2832_pid_filter_ctrl;
-	pdata->bulk_read = rtl2832_bulk_read;
-	pdata->bulk_write = rtl2832_bulk_write;
-	pdata->update_bits = rtl2832_update_bits;
+	pdata->regmap = dev->regmap;
 
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index c29a4c2bf71a..fab2f99672d6 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -57,9 +57,7 @@ struct rtl2832_platform_data {
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
 /* private: Register access for SDR module use only */
-	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
-	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
-	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
+	struct regmap *regmap;
 };
 
 #endif /* RTL2832_H */
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 6b3cd23a2c26..8657e0e578c5 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -33,7 +33,6 @@
 struct rtl2832_dev {
 	struct rtl2832_platform_data *pdata;
 	struct i2c_client *client;
-	struct mutex regmap_mutex;
 	struct regmap_config regmap_config;
 	struct regmap *regmap;
 	struct i2c_mux_core *muxc;
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index b860f02a4e55..6a6b1debe277 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -35,6 +35,7 @@
 #include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <linux/math64.h>
+#include <linux/regmap.h>
 
 static bool rtl2832_sdr_emulated_fmt;
 module_param_named(emulated_formats, rtl2832_sdr_emulated_fmt, bool, 0644);
@@ -169,9 +170,9 @@ static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_dev *dev, u16 reg,
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct i2c_client *client = pdata->i2c_client;
+	struct regmap *regmap = pdata->regmap;
 
-	return pdata->bulk_write(client, reg, val, len);
+	return regmap_bulk_write(regmap, reg, val, len);
 }
 
 #if 0
@@ -181,9 +182,9 @@ static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val,
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct i2c_client *client = pdata->i2c_client;
+	struct regmap *regmap = pdata->regmap;
 
-	return pdata->bulk_read(client, reg, val, len);
+	return regmap_bulk_read(regmap, reg, val, len);
 }
 #endif
 
@@ -199,9 +200,9 @@ static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct i2c_client *client = pdata->i2c_client;
+	struct regmap *regmap = pdata->regmap;
 
-	return pdata->update_bits(client, reg, mask, val);
+	return regmap_update_bits(regmap, reg, mask, val);
 }
 
 /* Private functions */
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index 342ea84860df..d8fc7e7212e3 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -56,10 +56,7 @@ struct rtl2832_sdr_platform_data {
 #define RTL2832_SDR_TUNER_R828D     0x2b
 	u8 tuner;
 
-	struct i2c_client *i2c_client;
-	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
-	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
-	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
+	struct regmap *regmap;
 	struct dvb_frontend *dvb_frontend;
 	struct v4l2_subdev *v4l2_subdev;
 	struct dvb_usb_device *dvb_usb_device;
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index eb5787a3191e..799def499f67 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1325,10 +1325,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_R828D:
 		pdata.clk = dev->rtl2832_platform_data.clk;
 		pdata.tuner = dev->tuner;
-		pdata.i2c_client = dev->i2c_client_demod;
-		pdata.bulk_read = dev->rtl2832_platform_data.bulk_read;
-		pdata.bulk_write = dev->rtl2832_platform_data.bulk_write;
-		pdata.update_bits = dev->rtl2832_platform_data.update_bits;
+		pdata.regmap = dev->rtl2832_platform_data.regmap;
 		pdata.dvb_frontend = adap->fe[0];
 		pdata.dvb_usb_device = d;
 		pdata.v4l2_subdev = subdev;
-- 
2.1.4

