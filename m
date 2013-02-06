Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:55850 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3BFVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 16:35:59 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so876163eaa.21
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 13:35:57 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: a.hajda@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] s5c73m3: Remove __dev* attributes
Date: Wed,  6 Feb 2013 22:35:41 +0100
Message-Id: <1360186541-2225-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <201302062139.47875.hverkuil@xs4all.nl>
References: <201302062139.47875.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove no longer supported __devinit, __devexit attributes.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---

Hi Hans,

I've noticed this last night, prepared a patch but forgot
to send it out today :/
Here is the one with a relevant summary line, I don't
want a patch with "[,FOR,V3.9]" in it applied..

Thanks,
Sylwester

 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    8 ++++----
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c  |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index c143c9e..5dbb65e 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1561,8 +1561,8 @@ static int s5c73m3_configure_gpios(struct s5c73m3 *state,
 	return 0;
 }

-static int __devinit s5c73m3_probe(struct i2c_client *client,
-				   const struct i2c_device_id *id)
+static int s5c73m3_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
 {
 	struct device *dev = &client->dev;
 	const struct s5c73m3_platform_data *pdata = client->dev.platform_data;
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
--
1.7.4.1

