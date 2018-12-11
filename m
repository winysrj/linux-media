Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A48C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC79F2084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="kQt/Rlsw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC79F2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbeLKPRs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:17:48 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35742 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbeLKPRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:17:47 -0500
Received: by mail-lj1-f194.google.com with SMTP id x85-v6so13314728ljb.2
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2018 07:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2qSIxSQncuwcjuZLSZ8uB570EN85s4hTaJfrKuYBYzE=;
        b=kQt/RlswECuFCtBT6rifywoSOHQrIFLS+eKne8e3/Xc9fvnQYPJPhvCyqAMQLxjUR3
         Ey7vdZP25B92R2LGrdVMegthK2tLPTpV9Fl50ZRnl63BZH4Iet3wMi7sPNczrTznJtwL
         rSo/PSdaFScEaaW2bpbTlqF2+XSH0sIQNYCqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2qSIxSQncuwcjuZLSZ8uB570EN85s4hTaJfrKuYBYzE=;
        b=LQcdIkNtYxqn6fT6lJXBOKS7zkd3oZEA5D6IybjMvx38O/7XUQx1AmVg+Ip1Dys6eg
         4VAj6eaRkUHHnnhQXPFu/IeKUxmSZTiqVNk2uwbiHfz99I/T5Dgsu0zfU2vzNpOaUqlj
         rH+ZPSCerWeYb9g1SQFKMlhPYtfEDcVfJjpezbX8RnmnFTc/d/BQQ8rwsIl6bsAOS9D2
         YqazawTQ4mMBNdB9dI138+6fjmlK4bN7hA1hru9q77ElybRMB4PWu+671pajLYO01Vgy
         +LsEYEQ1u7mvfXxLXwmTV3l/LY7E9LH4QlYL7LNCymK0VlU/t9c4Dm37FnVNTN8NUkHa
         JXxg==
X-Gm-Message-State: AA+aEWbUr3UnfykffxgaOtzua5yFDYkdT26qJ2WnspKdsZfhbPdJMQes
        VQHM1BaDRfvGHuYhA0PPnktKe5zdaaA=
X-Google-Smtp-Source: AFSGD/Wns/d0OI5MmJRXO85ib2H3vIbKUg04hfb5obNLL/3IWoAi9O736+95TFC5hgEiDsqmHgBI8g==
X-Received: by 2002:a2e:2e1a:: with SMTP id u26-v6mr11029088lju.8.1544541464495;
        Tue, 11 Dec 2018 07:17:44 -0800 (PST)
Received: from virtualbox.ipredator.se (anon-49-167.vpn.ipredator.se. [46.246.49.167])
        by smtp.gmail.com with ESMTPSA id g12-v6sm2712158lja.74.2018.12.11.07.17.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 07:17:43 -0800 (PST)
From:   Matt Ranostay <matt.ranostay@konsulko.com>
To:     linux-media@vger.kernel.org
Cc:     Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v4 2/2] media: video-i2c: add Melexis MLX90640 thermal camera
Date:   Tue, 11 Dec 2018 07:17:01 -0800
Message-Id: <20181211151701.10002-3-matt.ranostay@konsulko.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181211151701.10002-1-matt.ranostay@konsulko.com>
References: <20181211151701.10002-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add initial support for MLX90640 thermal cameras which output an 32x24
greyscale pixel image along with 2 rows of coefficent data.

Because of this the data outputed is really 32x26 and needs the two rows
removed after using the coefficent information to generate processed
images in userspace.

Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 drivers/media/i2c/Kconfig     |   1 +
 drivers/media/i2c/video-i2c.c | 110 +++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4c936e129500..a8819686e078 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1100,6 +1100,7 @@ config VIDEO_I2C
 	  Enable the I2C transport video support which supports the
 	  following:
 	   * Panasonic AMG88xx Grid-Eye Sensors
+	   * Melexis MLX90640 Thermal Cameras
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called video-i2c
diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 01dcf179f203..abd3152df7d0 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -6,6 +6,7 @@
  *
  * Supported:
  * - Panasonic AMG88xx Grid-Eye Sensors
+ * - Melexis MLX90640 Thermal Cameras
  */
 
 #include <linux/delay.h>
@@ -18,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/nvmem-provider.h>
 #include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -66,12 +68,26 @@ static const struct v4l2_frmsize_discrete amg88xx_size = {
 	.height = 8,
 };
 
+static const struct v4l2_fmtdesc mlx90640_format = {
+	.pixelformat = V4L2_PIX_FMT_Y16_BE,
+};
+
+static const struct v4l2_frmsize_discrete mlx90640_size = {
+	.width = 32,
+	.height = 26, /* 24 lines of pixel data + 2 lines of processing data */
+};
+
 static const struct regmap_config amg88xx_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = 0xff
 };
 
+static const struct regmap_config mlx90640_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+};
+
 struct video_i2c_chip {
 	/* video dimensions */
 	const struct v4l2_fmtdesc *format;
@@ -88,6 +104,7 @@ struct video_i2c_chip {
 	unsigned int bpp;
 
 	const struct regmap_config *regmap_config;
+	struct nvmem_config *nvmem_config;
 
 	/* setup function */
 	int (*setup)(struct video_i2c_data *data);
@@ -102,6 +119,22 @@ struct video_i2c_chip {
 	int (*hwmon_init)(struct video_i2c_data *data);
 };
 
+static int mlx90640_nvram_read(void *priv, unsigned int offset, void *val,
+			     size_t bytes)
+{
+	struct video_i2c_data *data = priv;
+
+	return regmap_bulk_read(data->regmap, 0x2400 + offset, val, bytes);
+}
+
+static struct nvmem_config mlx90640_nvram_config = {
+	.name = "mlx90640_nvram",
+	.word_size = 2,
+	.stride = 1,
+	.size = 1664,
+	.reg_read = mlx90640_nvram_read,
+};
+
 /* Power control register */
 #define AMG88XX_REG_PCTL	0x00
 #define AMG88XX_PCTL_NORMAL		0x00
@@ -122,12 +155,23 @@ struct video_i2c_chip {
 /* Temperature register */
 #define AMG88XX_REG_T01L	0x80
 
+/* Control register */
+#define MLX90640_REG_CTL1		0x800d
+#define MLX90640_REG_CTL1_MASK		0x0380
+#define MLX90640_REG_CTL1_MASK_SHIFT	7
+
 static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
 {
 	return regmap_bulk_read(data->regmap, AMG88XX_REG_T01L, buf,
 				data->chip->buffer_size);
 }
 
+static int mlx90640_xfer(struct video_i2c_data *data, char *buf)
+{
+	return regmap_bulk_read(data->regmap, 0x400, buf,
+				data->chip->buffer_size);
+}
+
 static int amg88xx_setup(struct video_i2c_data *data)
 {
 	unsigned int mask = AMG88XX_FPSC_1FPS;
@@ -141,6 +185,27 @@ static int amg88xx_setup(struct video_i2c_data *data)
 	return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask, val);
 }
 
+static int mlx90640_setup(struct video_i2c_data *data)
+{
+	unsigned int n, idx;
+
+	for (n = 0; n < data->chip->num_frame_intervals - 1; n++) {
+		if (data->frame_interval.numerator
+				!= data->chip->frame_intervals[n].numerator)
+			continue;
+
+		if (data->frame_interval.denominator
+				== data->chip->frame_intervals[n].denominator)
+			break;
+	}
+
+	idx = data->chip->num_frame_intervals - n - 1;
+
+	return regmap_update_bits(data->regmap, MLX90640_REG_CTL1,
+				  MLX90640_REG_CTL1_MASK,
+				  idx << MLX90640_REG_CTL1_MASK_SHIFT);
+}
+
 static int amg88xx_set_power_on(struct video_i2c_data *data)
 {
 	int ret;
@@ -274,13 +339,27 @@ static int amg88xx_hwmon_init(struct video_i2c_data *data)
 #define	amg88xx_hwmon_init	NULL
 #endif
 
-#define AMG88XX		0
+enum {
+	AMG88XX,
+	MLX90640,
+};
 
 static const struct v4l2_fract amg88xx_frame_intervals[] = {
 	{ 1, 10 },
 	{ 1, 1 },
 };
 
+static const struct v4l2_fract mlx90640_frame_intervals[] = {
+	{ 1, 64 },
+	{ 1, 32 },
+	{ 1, 16 },
+	{ 1, 8 },
+	{ 1, 4 },
+	{ 1, 2 },
+	{ 1, 1 },
+	{ 2, 1 },
+};
+
 static const struct video_i2c_chip video_i2c_chip[] = {
 	[AMG88XX] = {
 		.size		= &amg88xx_size,
@@ -295,6 +374,18 @@ static const struct video_i2c_chip video_i2c_chip[] = {
 		.set_power	= amg88xx_set_power,
 		.hwmon_init	= amg88xx_hwmon_init,
 	},
+	[MLX90640] = {
+		.size		= &mlx90640_size,
+		.format		= &mlx90640_format,
+		.frame_intervals	= mlx90640_frame_intervals,
+		.num_frame_intervals	= ARRAY_SIZE(mlx90640_frame_intervals),
+		.buffer_size	= 1664,
+		.bpp		= 16,
+		.regmap_config	= &mlx90640_regmap_config,
+		.nvmem_config	= &mlx90640_nvram_config,
+		.setup		= mlx90640_setup,
+		.xfer		= mlx90640_xfer,
+	},
 };
 
 static const struct v4l2_file_operations video_i2c_fops = {
@@ -756,6 +847,21 @@ static int video_i2c_probe(struct i2c_client *client,
 		}
 	}
 
+	if (data->chip->nvmem_config) {
+		struct nvmem_config *config = data->chip->nvmem_config;
+		struct nvmem_device *device;
+
+		config->priv = data;
+		config->dev = &client->dev;
+
+		device = devm_nvmem_register(&client->dev, config);
+
+		if (IS_ERR(device)) {
+			dev_warn(&client->dev,
+				 "failed to register nvmem device\n");
+		}
+	}
+
 	ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
 		goto error_pm_disable;
@@ -835,12 +941,14 @@ static const struct dev_pm_ops video_i2c_pm_ops = {
 
 static const struct i2c_device_id video_i2c_id_table[] = {
 	{ "amg88xx", AMG88XX },
+	{ "mlx90640", MLX90640 },
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, video_i2c_id_table);
 
 static const struct of_device_id video_i2c_of_match[] = {
 	{ .compatible = "panasonic,amg88xx", .data = &video_i2c_chip[AMG88XX] },
+	{ .compatible = "melexis,mlx90640", .data = &video_i2c_chip[MLX90640] },
 	{}
 };
 MODULE_DEVICE_TABLE(of, video_i2c_of_match);
-- 
2.17.1

