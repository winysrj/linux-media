Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0141.outbound.protection.outlook.com ([157.55.234.141]:28992
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbcDTPfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:35:11 -0400
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
Subject: [PATCH v7 04/24] i2c: i2c-arb-gpio-challenge: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:44 +0200
Message-ID: <1461165484-2314-5-git-send-email-peda@axentia.se>
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
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c | 47 +++++++++++++-----------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index 402e3a6c671a..a90bbc4037dd 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -28,8 +28,6 @@
 /**
  * struct i2c_arbitrator_data - Driver data for I2C arbitrator
  *
- * @parent: Parent adapter
- * @child: Child bus
  * @our_gpio: GPIO we'll use to claim.
  * @our_gpio_release: 0 if active high; 1 if active low; AKA if the GPIO ==
  *   this then consider it released.
@@ -42,8 +40,6 @@
  */
 
 struct i2c_arbitrator_data {
-	struct i2c_adapter *parent;
-	struct i2c_adapter *child;
 	int our_gpio;
 	int our_gpio_release;
 	int their_gpio;
@@ -59,9 +55,9 @@ struct i2c_arbitrator_data {
  *
  * Use the GPIO-based signalling protocol; return -EBUSY if we fail.
  */
-static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
+static int i2c_arbitrator_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	const struct i2c_arbitrator_data *arb = data;
+	const struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
 	unsigned long stop_retry, stop_time;
 
 	/* Start a round of trying to claim the bus */
@@ -93,7 +89,7 @@ static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
 	/* Give up, release our claim */
 	gpio_set_value(arb->our_gpio, arb->our_gpio_release);
 	udelay(arb->slew_delay_us);
-	dev_err(&adap->dev, "Could not claim bus, timeout\n");
+	dev_err(muxc->dev, "Could not claim bus, timeout\n");
 	return -EBUSY;
 }
 
@@ -102,10 +98,9 @@ static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
  *
  * Release the I2C bus using the GPIO-based signalling protocol.
  */
-static int i2c_arbitrator_deselect(struct i2c_adapter *adap, void *data,
-				   u32 chan)
+static int i2c_arbitrator_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	const struct i2c_arbitrator_data *arb = data;
+	const struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
 
 	/* Release the bus and wait for the other master to notice */
 	gpio_set_value(arb->our_gpio, arb->our_gpio_release);
@@ -119,6 +114,7 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct device_node *parent_np;
+	struct i2c_mux_core *muxc;
 	struct i2c_arbitrator_data *arb;
 	enum of_gpio_flags gpio_flags;
 	unsigned long out_init;
@@ -134,12 +130,13 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	arb = devm_kzalloc(dev, sizeof(*arb), GFP_KERNEL);
-	if (!arb) {
-		dev_err(dev, "Cannot allocate i2c_arbitrator_data\n");
+	muxc = i2c_mux_alloc(NULL, dev, 1, sizeof(*arb), 0,
+			     i2c_arbitrator_select, i2c_arbitrator_deselect);
+	if (!muxc)
 		return -ENOMEM;
-	}
-	platform_set_drvdata(pdev, arb);
+	arb = i2c_mux_priv(muxc);
+
+	platform_set_drvdata(pdev, muxc);
 
 	/* Request GPIOs */
 	ret = of_get_named_gpio_flags(np, "our-claim-gpio", 0, &gpio_flags);
@@ -196,21 +193,18 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 		dev_err(dev, "Cannot parse i2c-parent\n");
 		return -EINVAL;
 	}
-	arb->parent = of_get_i2c_adapter_by_node(parent_np);
+	muxc->parent = of_get_i2c_adapter_by_node(parent_np);
 	of_node_put(parent_np);
-	if (!arb->parent) {
+	if (!muxc->parent) {
 		dev_err(dev, "Cannot find parent bus\n");
 		return -EPROBE_DEFER;
 	}
 
 	/* Actually add the mux adapter */
-	arb->child = i2c_add_mux_adapter(arb->parent, dev, arb, 0, 0, 0,
-					 i2c_arbitrator_select,
-					 i2c_arbitrator_deselect);
-	if (!arb->child) {
+	ret = i2c_mux_add_adapter(muxc, 0, 0, 0);
+	if (ret) {
 		dev_err(dev, "Failed to add adapter\n");
-		ret = -ENODEV;
-		i2c_put_adapter(arb->parent);
+		i2c_put_adapter(muxc->parent);
 	}
 
 	return ret;
@@ -218,11 +212,10 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 
 static int i2c_arbitrator_remove(struct platform_device *pdev)
 {
-	struct i2c_arbitrator_data *arb = platform_get_drvdata(pdev);
-
-	i2c_del_mux_adapter(arb->child);
-	i2c_put_adapter(arb->parent);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 
+	i2c_mux_del_adapters(muxc);
+	i2c_put_adapter(muxc->parent);
 	return 0;
 }
 
-- 
2.1.4

