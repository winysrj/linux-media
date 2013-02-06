Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1178 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab3BFUj5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 15:39:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH FOR V3.9] Remove __devinit/exit annotations: these are no longer supported
Date: Wed, 6 Feb 2013 21:39:47 +0100
Cc: Andrzej Hajda <a.hajda@samsung.com>, s.nawrocki@samsung.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302062139.47875.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The daily build broke on this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans


diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index c143c9e..9b351d6 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1561,7 +1561,7 @@ static int s5c73m3_configure_gpios(struct s5c73m3 *state,
 	return 0;
 }
 
-static int __devinit s5c73m3_probe(struct i2c_client *client,
+static int s5c73m3_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
 	struct device *dev = &client->dev;
@@ -1666,7 +1666,7 @@ out_err1:
 	return ret;
 }
 
-static int __devexit s5c73m3_remove(struct i2c_client *client)
+static int s5c73m3_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
@@ -1693,7 +1693,7 @@ static struct i2c_driver s5c73m3_i2c_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= s5c73m3_probe,
-	.remove		= __devexit_p(s5c73m3_remove),
+	.remove		= s5c73m3_remove,
 	.id_table	= s5c73m3_id,
 };
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index 889139c..6f3a9c0 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -111,7 +111,7 @@ int s5c73m3_spi_read(struct s5c73m3 *state, void *addr,
 	return 0;
 }
 
-static int __devinit s5c73m3_spi_probe(struct spi_device *spi)
+static int s5c73m3_spi_probe(struct spi_device *spi)
 {
 	int r;
 	struct s5c73m3 *state = container_of(spi->dev.driver, struct s5c73m3,
@@ -132,7 +132,7 @@ static int __devinit s5c73m3_spi_probe(struct spi_device *spi)
 	return 0;
 }
 
-static int __devexit s5c73m3_spi_remove(struct spi_device *spi)
+static int s5c73m3_spi_remove(struct spi_device *spi)
 {
 	return 0;
 }
@@ -141,7 +141,7 @@ int s5c73m3_register_spi_driver(struct s5c73m3 *state)
 {
 	struct spi_driver *spidrv = &state->spidrv;
 
-	spidrv->remove = __devexit_p(s5c73m3_spi_remove);
+	spidrv->remove = s5c73m3_spi_remove;
 	spidrv->probe = s5c73m3_spi_probe;
 	spidrv->driver.name = S5C73M3_SPI_DRV_NAME;
 	spidrv->driver.bus = &spi_bus_type;
