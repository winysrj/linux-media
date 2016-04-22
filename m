Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-am1on0146.outbound.protection.outlook.com ([157.56.112.146]:2115
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752655AbcDVLhv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 07:37:51 -0400
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
Subject: [PATCH v8 08/24] iio: imu: inv_mpu6050: convert to use an explicit i2c mux core
Date: Fri, 22 Apr 2016 13:37:12 +0200
Message-ID: <1461325032-24299-1-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-9-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c |  2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  1 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c  | 33 +++++++++++++++---------------
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  3 ++-
 4 files changed, 19 insertions(+), 20 deletions(-)

v8 compared to v7:
- Do not change i2c_get_clientdata() into dev_get_drvdata()

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
index 2771106fd650..f62b8bd9ad7e 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
@@ -183,7 +183,7 @@ int inv_mpu_acpi_create_mux_client(struct i2c_client *client)
 			} else
 				return 0; /* no secondary addr, which is OK */
 		}
-		st->mux_client = i2c_new_device(st->mux_adapter, &info);
+		st->mux_client = i2c_new_device(st->muxc->adapter[0], &info);
 		if (!st->mux_client)
 			return -ENODEV;
 	}
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index d192953e9a38..0c2bded2b5b7 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -23,7 +23,6 @@
 #include <linux/kfifo.h>
 #include <linux/spinlock.h>
 #include <linux/iio/iio.h>
-#include <linux/i2c-mux.h>
 #include <linux/acpi.h>
 #include "inv_mpu_iio.h"
 
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
index f581256d9d4c..3a078df84224 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
@@ -15,7 +15,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
-#include <linux/i2c-mux.h>
 #include <linux/iio/iio.h>
 #include <linux/module.h>
 #include "inv_mpu_iio.h"
@@ -52,10 +51,9 @@ static int inv_mpu6050_write_reg_unlocked(struct i2c_client *client,
 	return 0;
 }
 
-static int inv_mpu6050_select_bypass(struct i2c_adapter *adap, void *mux_priv,
-				     u32 chan_id)
+static int inv_mpu6050_select_bypass(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 	int ret = 0;
@@ -84,10 +82,9 @@ write_error:
 	return ret;
 }
 
-static int inv_mpu6050_deselect_bypass(struct i2c_adapter *adap,
-				       void *mux_priv, u32 chan_id)
+static int inv_mpu6050_deselect_bypass(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 
@@ -136,16 +133,18 @@ static int inv_mpu_probe(struct i2c_client *client,
 		return result;
 
 	st = iio_priv(dev_get_drvdata(&client->dev));
-	st->mux_adapter = i2c_add_mux_adapter(client->adapter,
-					      &client->dev,
-					      client,
-					      0, 0, 0,
-					      inv_mpu6050_select_bypass,
-					      inv_mpu6050_deselect_bypass);
-	if (!st->mux_adapter) {
-		result = -ENODEV;
+	st->muxc = i2c_mux_alloc(client->adapter, &client->dev,
+				 1, 0, 0,
+				 inv_mpu6050_select_bypass,
+				 inv_mpu6050_deselect_bypass);
+	if (!st->muxc) {
+		result = -ENOMEM;
 		goto out_unreg_device;
 	}
+	st->muxc->priv = dev_get_drvdata(&client->dev);
+	result = i2c_mux_add_adapter(st->muxc, 0, 0, 0);
+	if (result)
+		goto out_unreg_device;
 
 	result = inv_mpu_acpi_create_mux_client(client);
 	if (result)
@@ -154,7 +153,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 	return 0;
 
 out_del_mux:
-	i2c_del_mux_adapter(st->mux_adapter);
+	i2c_mux_del_adapters(st->muxc);
 out_unreg_device:
 	inv_mpu_core_remove(&client->dev);
 	return result;
@@ -166,7 +165,7 @@ static int inv_mpu_remove(struct i2c_client *client)
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 
 	inv_mpu_acpi_delete_mux_client(client);
-	i2c_del_mux_adapter(st->mux_adapter);
+	i2c_mux_del_adapters(st->muxc);
 
 	return inv_mpu_core_remove(&client->dev);
 }
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index e302a49703bf..bb3cef6d7059 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -11,6 +11,7 @@
 * GNU General Public License for more details.
 */
 #include <linux/i2c.h>
+#include <linux/i2c-mux.h>
 #include <linux/kfifo.h>
 #include <linux/spinlock.h>
 #include <linux/iio/iio.h>
@@ -127,7 +128,7 @@ struct inv_mpu6050_state {
 	const struct inv_mpu6050_hw *hw;
 	enum   inv_devices chip_type;
 	spinlock_t time_stamp_lock;
-	struct i2c_adapter *mux_adapter;
+	struct i2c_mux_core *muxc;
 	struct i2c_client *mux_client;
 	unsigned int powerup_count;
 	struct inv_mpu6050_platform_data plat_data;
-- 
2.1.4

