Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43961 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752316AbdK2TIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:51 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/22] media: s5k6aa: describe some function parameters
Date: Wed, 29 Nov 2017 14:08:25 -0500
Message-Id: <edc0fd71b2c52f8e79357eb1e25be606017005a2.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

as warned:
  drivers/media/i2c/s5k6aa.c:429: warning: No description found for parameter 's5k6aa'
  drivers/media/i2c/s5k6aa.c:679: warning: No description found for parameter 's5k6aa'
  drivers/media/i2c/s5k6aa.c:733: warning: No description found for parameter 's5k6aa'
  drivers/media/i2c/s5k6aa.c:733: warning: No description found for parameter 'preset'
  drivers/media/i2c/s5k6aa.c:787: warning: No description found for parameter 'sd'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/s5k6aa.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 9fd254a8e20d..13c10b5e2b45 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -421,6 +421,7 @@ static int s5k6aa_set_ahb_address(struct i2c_client *client)
 
 /**
  * s5k6aa_configure_pixel_clock - apply ISP main clock/PLL configuration
+ * @s5k6aa: pointer to &struct s5k6aa describing the device
  *
  * Configure the internal ISP PLL for the required output frequency.
  * Locking: called with s5k6aa.lock mutex held.
@@ -669,6 +670,7 @@ static int s5k6aa_set_input_params(struct s5k6aa *s5k6aa)
 
 /**
  * s5k6aa_configure_video_bus - configure the video output interface
+ * @s5k6aa: pointer to &struct s5k6aa describing the device
  * @bus_type: video bus type: parallel or MIPI-CSI
  * @nlanes: number of MIPI lanes to be used (MIPI-CSI only)
  *
@@ -724,6 +726,8 @@ static int s5k6aa_new_config_sync(struct i2c_client *client, int timeout,
 
 /**
  * s5k6aa_set_prev_config - write user preview register set
+ * @s5k6aa: pointer to &struct s5k6aa describing the device
+ * @preset: s5kaa preset to be applied
  *
  * Configure output resolution and color fromat, pixel clock
  * frequency range, device frame rate type and frame period range.
@@ -777,6 +781,7 @@ static int s5k6aa_set_prev_config(struct s5k6aa *s5k6aa,
 
 /**
  * s5k6aa_initialize_isp - basic ISP MCU initialization
+ * @sd: pointer to V4L2 sub-device descriptor
  *
  * Configure AHB addresses for registers read/write; configure PLLs for
  * required output pixel clock. The ISP power supply needs to be already
-- 
2.14.3
