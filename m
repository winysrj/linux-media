Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53226 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2IZJsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:21 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so357301wgb.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 02:48:20 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 5/5] media: ov7670: Add possibility to disable pixclk during hblank.
Date: Wed, 26 Sep 2012 11:47:57 +0200
Message-Id: <1348652877-25816-6-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/i2c/ov7670.c |    8 ++++++++
 include/media/ov7670.h     |    1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 54fb535..f7e4341 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -211,6 +211,7 @@ struct ov7670_info {
 	u8 clkrc;			/* Clock divider value */
 	bool use_smbus;			/* Use smbus I/O instead of I2C */
 	bool pll_bypass;
+	bool pclk_hb_disable;
 	enum ov7670_model model;
 };
 
@@ -1709,6 +1710,9 @@ static int ov7670_probe(struct i2c_client *client,
 
 		if (config->pll_bypass && id->driver_data != MODEL_OV7670)
 			info->pll_bypass = true;
+
+		if (config->pclk_hb_disable)
+			info->pclk_hb_disable = true;
 	}
 
 	/* Make sure it's an ov7670 */
@@ -1735,6 +1739,10 @@ static int ov7670_probe(struct i2c_client *client,
 		tpf.denominator = 30;
 		ov7670_set_framerate(sd, &tpf);
 	}
+
+	if (info->pclk_hb_disable)
+		ov7670_write(sd, REG_COM10, COM10_PCLK_HB);
+
 	return 0;
 }
 
diff --git a/include/media/ov7670.h b/include/media/ov7670.h
index a68c8bb..1913d51 100644
--- a/include/media/ov7670.h
+++ b/include/media/ov7670.h
@@ -16,6 +16,7 @@ struct ov7670_config {
 	int clock_speed;		/* External clock speed (MHz) */
 	bool use_smbus;			/* Use smbus I/O instead of I2C */
 	bool pll_bypass;		/* Choose whether to bypass the PLL */
+	bool pclk_hb_disable;		/* Disable toggling pixclk during horizontal blanking */
 };
 
 #endif
-- 
1.7.9.5

