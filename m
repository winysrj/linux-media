Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54757 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbcADM0i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 07:26:38 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 09/10] [media] tvp5150: Initialize the chip on probe
Date: Mon,  4 Jan 2016 09:25:31 -0300
Message-Id: <1451910332-23385-10-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After power-up, the tvp5150 decoder is in a unknown state until the
RESETB pin is driven LOW which reset all the registers and restarts
the chip's internal state machine.

The init sequence has some timing constraints and the RESETB signal
can only be used if the PDN (Power-down) pin is first released.

So, the initialization sequence is as follows:

1- PDN (active-low) is driven HIGH so the chip is power-up
2- A 20 ms delay is needed before sending a RESETB (active-low) signal.
3- The RESETB pulse duration is 500 ns.
4- A 200 us delay is needed for the I2C client to be active after reset.

This patch used as a reference the logic in the IGEPv2 board file from
the ISEE 2.6.37 vendor tree.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index caac96a577f8..fed89a811ab7 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -5,6 +5,7 @@
  * This code is placed under the terms of the GNU General Public License v2
  */
 
+#include <linux/of_gpio.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
@@ -1197,6 +1198,36 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 	return 0;
 }
 
+static inline int tvp5150_init(struct i2c_client *c)
+{
+	struct gpio_desc *pdn_gpio;
+	struct gpio_desc *reset_gpio;
+
+	pdn_gpio = devm_gpiod_get_optional(&c->dev, "powerdown", GPIOD_OUT_HIGH);
+	if (IS_ERR(pdn_gpio))
+		return PTR_ERR(pdn_gpio);
+
+	if (pdn_gpio) {
+		gpiod_set_value_cansleep(pdn_gpio, 0);
+		/* Delay time between power supplies active and reset */
+		msleep(20);
+	}
+
+	reset_gpio = devm_gpiod_get_optional(&c->dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(reset_gpio))
+		return PTR_ERR(reset_gpio);
+
+	if (reset_gpio) {
+		/* RESETB pulse duration */
+		ndelay(500);
+		gpiod_set_value_cansleep(reset_gpio, 0);
+		/* Delay time between end of reset to I2C active */
+		usleep_range(200, 250);
+	}
+
+	return 0;
+}
+
 static int tvp5150_probe(struct i2c_client *c,
 			 const struct i2c_device_id *id)
 {
@@ -1209,6 +1240,10 @@ static int tvp5150_probe(struct i2c_client *c,
 	     I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EIO;
 
+	res = tvp5150_init(c);
+	if (res)
+		return res;
+
 	core = devm_kzalloc(&c->dev, sizeof(*core), GFP_KERNEL);
 	if (!core)
 		return -ENOMEM;
-- 
2.4.3

