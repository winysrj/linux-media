Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:59357 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550AbcCCW3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:29:20 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	Adriana Reus <adriana.reus@intel.com>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v4 08/18] iio: imu: inv_mpu6050: convert to use an explicit i2c mux core
Date: Thu,  3 Mar 2016 23:27:20 +0100
Message-Id: <1457044050-15230-9-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c |  2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 30 +++++++++++++-----------------
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  3 ++-
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
index 1c982a56acd5..d433e7b64011 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
@@ -182,7 +182,7 @@ int inv_mpu_acpi_create_mux_client(struct inv_mpu6050_state *st)
 			} else
 				return 0; /* no secondary addr, which is OK */
 		}
-		st->mux_client = i2c_new_device(st->mux_adapter, &info);
+		st->mux_client = i2c_new_device(st->muxc->adapter[0], &info);
 		if (!st->mux_client)
 			return -ENODEV;
 
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index f0e06093b5e8..642f22013d17 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -23,7 +23,6 @@
 #include <linux/kfifo.h>
 #include <linux/spinlock.h>
 #include <linux/iio/iio.h>
-#include <linux/i2c-mux.h>
 #include <linux/acpi.h>
 #include "inv_mpu_iio.h"
 
@@ -109,10 +108,9 @@ static int inv_mpu6050_write_reg_unlocked(struct inv_mpu6050_state *st,
 	return 0;
 }
 
-static int inv_mpu6050_select_bypass(struct i2c_adapter *adap, void *mux_priv,
-				     u32 chan_id)
+static int inv_mpu6050_select_bypass(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct iio_dev *indio_dev = mux_priv;
+	struct iio_dev *indio_dev = i2c_mux_priv(muxc);
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 	int ret = 0;
 
@@ -138,10 +136,9 @@ write_error:
 	return ret;
 }
 
-static int inv_mpu6050_deselect_bypass(struct i2c_adapter *adap,
-				       void *mux_priv, u32 chan_id)
+static int inv_mpu6050_deselect_bypass(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct iio_dev *indio_dev = mux_priv;
+	struct iio_dev *indio_dev = i2c_mux_priv(muxc);
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 
 	mutex_lock(&indio_dev->mlock);
@@ -842,16 +839,15 @@ static int inv_mpu_probe(struct i2c_client *client,
 		goto out_remove_trigger;
 	}
 
-	st->mux_adapter = i2c_add_mux_adapter(client->adapter,
-					      &client->dev,
-					      indio_dev,
-					      0, 0, 0,
-					      inv_mpu6050_select_bypass,
-					      inv_mpu6050_deselect_bypass);
-	if (!st->mux_adapter) {
-		result = -ENODEV;
+	st->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
+				       0, 0, 0,
+				       inv_mpu6050_select_bypass,
+				       inv_mpu6050_deselect_bypass);
+	if (IS_ERR(st->muxc)) {
+		result = PTR_ERR(st->muxc);
 		goto out_unreg_device;
 	}
+	st->muxc->priv = indio_dev;
 
 	result = inv_mpu_acpi_create_mux_client(st);
 	if (result)
@@ -860,7 +856,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 	return 0;
 
 out_del_mux:
-	i2c_del_mux_adapter(st->mux_adapter);
+	i2c_mux_del_adapters(st->muxc);
 out_unreg_device:
 	iio_device_unregister(indio_dev);
 out_remove_trigger:
@@ -876,7 +872,7 @@ static int inv_mpu_remove(struct i2c_client *client)
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 
 	inv_mpu_acpi_delete_mux_client(st);
-	i2c_del_mux_adapter(st->mux_adapter);
+	i2c_mux_del_adapters(st->muxc);
 	iio_device_unregister(indio_dev);
 	inv_mpu6050_remove_trigger(st);
 	iio_triggered_buffer_cleanup(indio_dev);
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index db0a4a2758ab..61a3a04b84b8 100644
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
@@ -120,7 +121,7 @@ struct inv_mpu6050_state {
 	enum   inv_devices chip_type;
 	spinlock_t time_stamp_lock;
 	struct i2c_client *client;
-	struct i2c_adapter *mux_adapter;
+	struct i2c_mux_core *muxc;
 	struct i2c_client *mux_client;
 	unsigned int powerup_count;
 	struct inv_mpu6050_platform_data plat_data;
-- 
2.1.4

