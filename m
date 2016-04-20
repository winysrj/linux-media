Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0110.outbound.protection.outlook.com ([157.55.234.110]:10416
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751899AbcDTPfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:06 -0400
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
Subject: [PATCH v7 02/24] i2c: i2c-mux-gpio: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:42 +0200
Message-ID: <1461165484-2314-3-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-gpio.c | 55 ++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index b8e11c16d98c..f6270ee934f9 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -18,8 +18,6 @@
 #include <linux/of_gpio.h>
 
 struct gpiomux {
-	struct i2c_adapter *parent;
-	struct i2c_adapter **adap; /* child busses */
 	struct i2c_mux_gpio_platform_data data;
 	unsigned gpio_base;
 };
@@ -33,18 +31,18 @@ static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
 					val & (1 << i));
 }
 
-static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
+static int i2c_mux_gpio_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct gpiomux *mux = data;
+	struct gpiomux *mux = i2c_mux_priv(muxc);
 
 	i2c_mux_gpio_set(mux, chan);
 
 	return 0;
 }
 
-static int i2c_mux_gpio_deselect(struct i2c_adapter *adap, void *data, u32 chan)
+static int i2c_mux_gpio_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct gpiomux *mux = data;
+	struct gpiomux *mux = i2c_mux_priv(muxc);
 
 	i2c_mux_gpio_set(mux, mux->data.idle);
 
@@ -136,19 +134,15 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 
 static int i2c_mux_gpio_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct gpiomux *mux;
 	struct i2c_adapter *parent;
-	int (*deselect) (struct i2c_adapter *, void *, u32);
 	unsigned initial_state, gpio_base;
 	int i, ret;
 
 	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux) {
-		dev_err(&pdev->dev, "Cannot allocate gpiomux structure");
+	if (!mux)
 		return -ENOMEM;
-	}
-
-	platform_set_drvdata(pdev, mux);
 
 	if (!dev_get_platdata(&pdev->dev)) {
 		ret = i2c_mux_gpio_probe_dt(mux, pdev);
@@ -180,24 +174,23 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	if (!parent)
 		return -EPROBE_DEFER;
 
-	mux->parent = parent;
-	mux->gpio_base = gpio_base;
-
-	mux->adap = devm_kzalloc(&pdev->dev,
-				 sizeof(*mux->adap) * mux->data.n_values,
-				 GFP_KERNEL);
-	if (!mux->adap) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_adapter structure");
+	muxc = i2c_mux_alloc(parent, &pdev->dev, mux->data.n_values, 0, 0,
+			     i2c_mux_gpio_select, NULL);
+	if (!muxc) {
 		ret = -ENOMEM;
 		goto alloc_failed;
 	}
+	muxc->priv = mux;
+
+	platform_set_drvdata(pdev, muxc);
+
+	mux->gpio_base = gpio_base;
 
 	if (mux->data.idle != I2C_MUX_GPIO_NO_IDLE) {
 		initial_state = mux->data.idle;
-		deselect = i2c_mux_gpio_deselect;
+		muxc->deselect = i2c_mux_gpio_deselect;
 	} else {
 		initial_state = mux->data.values[0];
-		deselect = NULL;
 	}
 
 	for (i = 0; i < mux->data.n_gpios; i++) {
@@ -223,11 +216,8 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
-						   mux->data.values[i], class,
-						   i2c_mux_gpio_select, deselect);
-		if (!mux->adap[i]) {
-			ret = -ENODEV;
+		ret = i2c_mux_add_adapter(muxc, nr, mux->data.values[i], class);
+		if (ret) {
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
 			goto add_adapter_failed;
 		}
@@ -239,8 +229,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 add_adapter_failed:
-	for (; i > 0; i--)
-		i2c_del_mux_adapter(mux->adap[i - 1]);
+	i2c_mux_del_adapters(muxc);
 	i = mux->data.n_gpios;
 err_request_gpio:
 	for (; i > 0; i--)
@@ -253,16 +242,16 @@ alloc_failed:
 
 static int i2c_mux_gpio_remove(struct platform_device *pdev)
 {
-	struct gpiomux *mux = platform_get_drvdata(pdev);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
+	struct gpiomux *mux = i2c_mux_priv(muxc);
 	int i;
 
-	for (i = 0; i < mux->data.n_values; i++)
-		i2c_del_mux_adapter(mux->adap[i]);
+	i2c_mux_del_adapters(muxc);
 
 	for (i = 0; i < mux->data.n_gpios; i++)
 		gpio_free(mux->gpio_base + mux->data.gpios[i]);
 
-	i2c_put_adapter(mux->parent);
+	i2c_put_adapter(muxc->parent);
 
 	return 0;
 }
-- 
2.1.4

