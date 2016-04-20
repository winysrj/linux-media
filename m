Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0119.outbound.protection.outlook.com ([157.55.234.119]:59727
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752028AbcDTPgR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:36:17 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v7 23/24] [media] rtl2832_sdr: get rid of empty regmap wrappers
Date: Wed, 20 Apr 2016 17:18:03 +0200
Message-ID: <1461165484-2314-24-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 302 +++++++++++++-----------------
 1 file changed, 132 insertions(+), 170 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 6a6b1debe277..47a480a7d46c 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -120,6 +120,7 @@ struct rtl2832_sdr_dev {
 	unsigned long flags;
 
 	struct platform_device *pdev;
+	struct regmap *regmap;
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
@@ -164,47 +165,6 @@ struct rtl2832_sdr_dev {
 	unsigned long jiffies_next;
 };
 
-/* write multiple registers */
-static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_dev *dev, u16 reg,
-		const u8 *val, int len)
-{
-	struct platform_device *pdev = dev->pdev;
-	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct regmap *regmap = pdata->regmap;
-
-	return regmap_bulk_write(regmap, reg, val, len);
-}
-
-#if 0
-/* read multiple registers */
-static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val,
-		int len)
-{
-	struct platform_device *pdev = dev->pdev;
-	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct regmap *regmap = pdata->regmap;
-
-	return regmap_bulk_read(regmap, reg, val, len);
-}
-#endif
-
-/* write single register */
-static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_dev *dev, u16 reg, u8 val)
-{
-	return rtl2832_sdr_wr_regs(dev, reg, &val, 1);
-}
-
-/* write single register with mask */
-static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
-		u8 val, u8 mask)
-{
-	struct platform_device *pdev = dev->pdev;
-	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct regmap *regmap = pdata->regmap;
-
-	return regmap_update_bits(regmap, reg, mask, val);
-}
-
 /* Private functions */
 static struct rtl2832_sdr_frame_buf *rtl2832_sdr_get_next_fill_buf(
 		struct rtl2832_sdr_dev *dev)
@@ -559,11 +519,11 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 
 	f_sr = dev->f_adc;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x13e, "\x00\x00", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x13e, "\x00\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x00\x00\x00\x00", 4);
+	ret = regmap_bulk_write(dev->regmap, 0x115, "\x00\x00\x00\x00", 4);
 	if (ret)
 		goto err;
 
@@ -589,7 +549,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 	buf[1] = (u32tmp >>  8) & 0xff;
 	buf[2] = (u32tmp >>  0) & 0xff;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x119, buf, 3);
+	ret = regmap_bulk_write(dev->regmap, 0x119, buf, 3);
 	if (ret)
 		goto err;
 
@@ -603,15 +563,15 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		u8tmp2 = 0xcd; /* enable ADC I, ADC Q */
 	}
 
-	ret = rtl2832_sdr_wr_reg(dev, 0x1b1, u8tmp1);
+	ret = regmap_write(dev->regmap, 0x1b1, u8tmp1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_reg(dev, 0x008, u8tmp2);
+	ret = regmap_write(dev->regmap, 0x008, u8tmp2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_reg(dev, 0x006, 0x80);
+	ret = regmap_write(dev->regmap, 0x006, 0x80);
 	if (ret)
 		goto err;
 
@@ -622,168 +582,169 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 	buf[1] = (u32tmp >> 16) & 0xff;
 	buf[2] = (u32tmp >>  8) & 0xff;
 	buf[3] = (u32tmp >>  0) & 0xff;
-	ret = rtl2832_sdr_wr_regs(dev, 0x19f, buf, 4);
+	ret = regmap_bulk_write(dev->regmap, 0x19f, buf, 4);
 	if (ret)
 		goto err;
 
 	/* low-pass filter */
-	ret = rtl2832_sdr_wr_regs(dev, 0x11c,
-			"\xca\xdc\xd7\xd8\xe0\xf2\x0e\x35\x06\x50\x9c\x0d\x71\x11\x14\x71\x74\x19\x41\xa5",
-			20);
+	ret = regmap_bulk_write(dev->regmap, 0x11c,
+				"\xca\xdc\xd7\xd8\xe0\xf2\x0e\x35\x06\x50\x9c\x0d\x71\x11\x14\x71\x74\x19\x41\xa5",
+				20);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x017, "\x11\x10", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x017, "\x11\x10", 2);
 	if (ret)
 		goto err;
 
 	/* mode */
-	ret = rtl2832_sdr_wr_regs(dev, 0x019, "\x05", 1);
+	ret = regmap_write(dev->regmap, 0x019, 0x05);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x01a, "\x1b\x16\x0d\x06\x01\xff", 6);
+	ret = regmap_bulk_write(dev->regmap, 0x01a,
+				"\x1b\x16\x0d\x06\x01\xff", 6);
 	if (ret)
 		goto err;
 
 	/* FSM */
-	ret = rtl2832_sdr_wr_regs(dev, 0x192, "\x00\xf0\x0f", 3);
+	ret = regmap_bulk_write(dev->regmap, 0x192, "\x00\xf0\x0f", 3);
 	if (ret)
 		goto err;
 
 	/* PID filter */
-	ret = rtl2832_sdr_wr_regs(dev, 0x061, "\x60", 1);
+	ret = regmap_write(dev->regmap, 0x061, 0x60);
 	if (ret)
 		goto err;
 
 	/* used RF tuner based settings */
 	switch (pdata->tuner) {
 	case RTL2832_SDR_TUNER_E4000:
-		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x30", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xd0", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x18", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xd4", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1e5, "\xf0", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1d9, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1db, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1dd, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1de, "\xec", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1d8, "\x0c", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1e6, "\x02", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1d7, "\x09", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x83", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x010, "\x49", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x87", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x85", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x013, "\x02", 1);
+		ret = regmap_write(dev->regmap, 0x112, 0x5a);
+		ret = regmap_write(dev->regmap, 0x102, 0x40);
+		ret = regmap_write(dev->regmap, 0x103, 0x5a);
+		ret = regmap_write(dev->regmap, 0x1c7, 0x30);
+		ret = regmap_write(dev->regmap, 0x104, 0xd0);
+		ret = regmap_write(dev->regmap, 0x105, 0xbe);
+		ret = regmap_write(dev->regmap, 0x1c8, 0x18);
+		ret = regmap_write(dev->regmap, 0x106, 0x35);
+		ret = regmap_write(dev->regmap, 0x1c9, 0x21);
+		ret = regmap_write(dev->regmap, 0x1ca, 0x21);
+		ret = regmap_write(dev->regmap, 0x1cb, 0x00);
+		ret = regmap_write(dev->regmap, 0x107, 0x40);
+		ret = regmap_write(dev->regmap, 0x1cd, 0x10);
+		ret = regmap_write(dev->regmap, 0x1ce, 0x10);
+		ret = regmap_write(dev->regmap, 0x108, 0x80);
+		ret = regmap_write(dev->regmap, 0x109, 0x7f);
+		ret = regmap_write(dev->regmap, 0x10a, 0x80);
+		ret = regmap_write(dev->regmap, 0x10b, 0x7f);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_write(dev->regmap, 0x011, 0xd4);
+		ret = regmap_write(dev->regmap, 0x1e5, 0xf0);
+		ret = regmap_write(dev->regmap, 0x1d9, 0x00);
+		ret = regmap_write(dev->regmap, 0x1db, 0x00);
+		ret = regmap_write(dev->regmap, 0x1dd, 0x14);
+		ret = regmap_write(dev->regmap, 0x1de, 0xec);
+		ret = regmap_write(dev->regmap, 0x1d8, 0x0c);
+		ret = regmap_write(dev->regmap, 0x1e6, 0x02);
+		ret = regmap_write(dev->regmap, 0x1d7, 0x09);
+		ret = regmap_write(dev->regmap, 0x00d, 0x83);
+		ret = regmap_write(dev->regmap, 0x010, 0x49);
+		ret = regmap_write(dev->regmap, 0x00d, 0x87);
+		ret = regmap_write(dev->regmap, 0x00d, 0x85);
+		ret = regmap_write(dev->regmap, 0x013, 0x02);
 		break;
 	case RTL2832_SDR_TUNER_FC0012:
 	case RTL2832_SDR_TUNER_FC0013:
-		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x2c", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x16", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xe9\xbf", 2);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1e5, "\xf0", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1d9, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1db, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1dd, "\x11", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1de, "\xef", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1d8, "\x0c", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1e6, "\x02", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1d7, "\x09", 1);
+		ret = regmap_write(dev->regmap, 0x112, 0x5a);
+		ret = regmap_write(dev->regmap, 0x102, 0x40);
+		ret = regmap_write(dev->regmap, 0x103, 0x5a);
+		ret = regmap_write(dev->regmap, 0x1c7, 0x2c);
+		ret = regmap_write(dev->regmap, 0x104, 0xcc);
+		ret = regmap_write(dev->regmap, 0x105, 0xbe);
+		ret = regmap_write(dev->regmap, 0x1c8, 0x16);
+		ret = regmap_write(dev->regmap, 0x106, 0x35);
+		ret = regmap_write(dev->regmap, 0x1c9, 0x21);
+		ret = regmap_write(dev->regmap, 0x1ca, 0x21);
+		ret = regmap_write(dev->regmap, 0x1cb, 0x00);
+		ret = regmap_write(dev->regmap, 0x107, 0x40);
+		ret = regmap_write(dev->regmap, 0x1cd, 0x10);
+		ret = regmap_write(dev->regmap, 0x1ce, 0x10);
+		ret = regmap_write(dev->regmap, 0x108, 0x80);
+		ret = regmap_write(dev->regmap, 0x109, 0x7f);
+		ret = regmap_write(dev->regmap, 0x10a, 0x80);
+		ret = regmap_write(dev->regmap, 0x10b, 0x7f);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_bulk_write(dev->regmap, 0x011, "\xe9\xbf", 2);
+		ret = regmap_write(dev->regmap, 0x1e5, 0xf0);
+		ret = regmap_write(dev->regmap, 0x1d9, 0x00);
+		ret = regmap_write(dev->regmap, 0x1db, 0x00);
+		ret = regmap_write(dev->regmap, 0x1dd, 0x11);
+		ret = regmap_write(dev->regmap, 0x1de, 0xef);
+		ret = regmap_write(dev->regmap, 0x1d8, 0x0c);
+		ret = regmap_write(dev->regmap, 0x1e6, 0x02);
+		ret = regmap_write(dev->regmap, 0x1d7, 0x09);
 		break;
 	case RTL2832_SDR_TUNER_R820T:
 	case RTL2832_SDR_TUNER_R828D:
-		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x01", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x24", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xf4", 1);
+		ret = regmap_write(dev->regmap, 0x112, 0x5a);
+		ret = regmap_write(dev->regmap, 0x102, 0x40);
+		ret = regmap_write(dev->regmap, 0x115, 0x01);
+		ret = regmap_write(dev->regmap, 0x103, 0x80);
+		ret = regmap_write(dev->regmap, 0x1c7, 0x24);
+		ret = regmap_write(dev->regmap, 0x104, 0xcc);
+		ret = regmap_write(dev->regmap, 0x105, 0xbe);
+		ret = regmap_write(dev->regmap, 0x1c8, 0x14);
+		ret = regmap_write(dev->regmap, 0x106, 0x35);
+		ret = regmap_write(dev->regmap, 0x1c9, 0x21);
+		ret = regmap_write(dev->regmap, 0x1ca, 0x21);
+		ret = regmap_write(dev->regmap, 0x1cb, 0x00);
+		ret = regmap_write(dev->regmap, 0x107, 0x40);
+		ret = regmap_write(dev->regmap, 0x1cd, 0x10);
+		ret = regmap_write(dev->regmap, 0x1ce, 0x10);
+		ret = regmap_write(dev->regmap, 0x108, 0x80);
+		ret = regmap_write(dev->regmap, 0x109, 0x7f);
+		ret = regmap_write(dev->regmap, 0x10a, 0x80);
+		ret = regmap_write(dev->regmap, 0x10b, 0x7f);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_write(dev->regmap, 0x011, 0xf4);
 		break;
 	case RTL2832_SDR_TUNER_FC2580:
-		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x39", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x2c", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x16", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x9c", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
-		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xe9\xf4", 2);
+		ret = regmap_write(dev->regmap, 0x112, 0x39);
+		ret = regmap_write(dev->regmap, 0x102, 0x40);
+		ret = regmap_write(dev->regmap, 0x103, 0x5a);
+		ret = regmap_write(dev->regmap, 0x1c7, 0x2c);
+		ret = regmap_write(dev->regmap, 0x104, 0xcc);
+		ret = regmap_write(dev->regmap, 0x105, 0xbe);
+		ret = regmap_write(dev->regmap, 0x1c8, 0x16);
+		ret = regmap_write(dev->regmap, 0x106, 0x35);
+		ret = regmap_write(dev->regmap, 0x1c9, 0x21);
+		ret = regmap_write(dev->regmap, 0x1ca, 0x21);
+		ret = regmap_write(dev->regmap, 0x1cb, 0x00);
+		ret = regmap_write(dev->regmap, 0x107, 0x40);
+		ret = regmap_write(dev->regmap, 0x1cd, 0x10);
+		ret = regmap_write(dev->regmap, 0x1ce, 0x10);
+		ret = regmap_write(dev->regmap, 0x108, 0x80);
+		ret = regmap_write(dev->regmap, 0x109, 0x7f);
+		ret = regmap_write(dev->regmap, 0x10a, 0x9c);
+		ret = regmap_write(dev->regmap, 0x10b, 0x7f);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_write(dev->regmap, 0x00e, 0xfc);
+		ret = regmap_bulk_write(dev->regmap, 0x011, "\xe9\xf4", 2);
 		break;
 	default:
 		dev_notice(&pdev->dev, "Unsupported tuner\n");
 	}
 
 	/* software reset */
-	ret = rtl2832_sdr_wr_reg_mask(dev, 0x101, 0x04, 0x04);
+	ret = regmap_update_bits(dev->regmap, 0x101, 0x04, 0x04);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_reg_mask(dev, 0x101, 0x00, 0x04);
+	ret = regmap_update_bits(dev->regmap, 0x101, 0x04, 0x00);
 	if (ret)
 		goto err;
 err:
@@ -798,29 +759,29 @@ static void rtl2832_sdr_unset_adc(struct rtl2832_sdr_dev *dev)
 	dev_dbg(&pdev->dev, "\n");
 
 	/* PID filter */
-	ret = rtl2832_sdr_wr_regs(dev, 0x061, "\xe0", 1);
+	ret = regmap_write(dev->regmap, 0x061, 0xe0);
 	if (ret)
 		goto err;
 
 	/* mode */
-	ret = rtl2832_sdr_wr_regs(dev, 0x019, "\x20", 1);
+	ret = regmap_write(dev->regmap, 0x019, 0x20);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x017, "\x11\x10", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x017, "\x11\x10", 2);
 	if (ret)
 		goto err;
 
 	/* FSM */
-	ret = rtl2832_sdr_wr_regs(dev, 0x192, "\x00\x0f\xff", 3);
+	ret = regmap_bulk_write(dev->regmap, 0x192, "\x00\x0f\xff", 3);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x13e, "\x40\x00", 2);
+	ret = regmap_bulk_write(dev->regmap, 0x13e, "\x40\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x06\x3f\xce\xcc", 4);
+	ret = regmap_bulk_write(dev->regmap, 0x115, "\x06\x3f\xce\xcc", 4);
 	if (ret)
 		goto err;
 err:
@@ -1400,6 +1361,7 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 	subdev = pdata->v4l2_subdev;
 	dev->v4l2_subdev = pdata->v4l2_subdev;
 	dev->pdev = pdev;
+	dev->regmap = pdata->regmap;
 	dev->udev = pdata->dvb_usb_device->udev;
 	dev->f_adc = bands_adc[0].rangelow;
 	dev->f_tuner = bands_fm[0].rangelow;
-- 
2.1.4

