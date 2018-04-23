Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36394 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932122AbeDWTbs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 15:31:48 -0400
Received: by mail-lf0-f68.google.com with SMTP id d20-v6so16713143lfe.3
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:31:48 -0700 (PDT)
From: Anders Roxell <anders.roxell@linaro.org>
To: mchehab@kernel.org, p.zabel@pengutronix.de
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] drivers: media: platform: make VIDEO_VIU depend on I2C
Date: Mon, 23 Apr 2018 21:31:39 +0200
Message-Id: <20180423193139.16792-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 7378f1149884 ("media: omap2: omapfb: allow building it with
COMPILE_TEST") broke compilation without CONFIG_I2C selected.
drivers/media/platform/fsl-viu.c: In function ‘viu_of_probe’:
drivers/media/platform/fsl-viu.c:1452:7: error: implicit declaration of function ‘i2c_get_adapter’; did you mean ‘i2c_lock_adapter’? [-Werror=implicit-function-declaration]
  ad = i2c_get_adapter(0);
       ^~~~~~~~~~~~~~~
       i2c_lock_adapter
drivers/media/platform/fsl-viu.c:1452:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  ad = i2c_get_adapter(0);
     ^
drivers/media/platform/fsl-viu.c:1534:2: error: implicit declaration of function ‘i2c_put_adapter’; did you mean ‘i2c_lock_adapter’? [-Werror=implicit-function-declaration]
  i2c_put_adapter(ad);
  ^~~~~~~~~~~~~~~
  i2c_lock_adapter

Added I2C dependency in order to make all configurations work again.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 91b0c7324afb..56c205b44ee1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -42,7 +42,7 @@ config VIDEO_SH_VOU
 
 config VIDEO_VIU
 	tristate "Freescale VIU Video Driver"
-	depends on VIDEO_V4L2 && (PPC_MPC512x || COMPILE_TEST)
+	depends on VIDEO_V4L2 && (PPC_MPC512x || COMPILE_TEST) && I2C
 	select VIDEOBUF_DMA_CONTIG
 	default y
 	---help---
-- 
2.17.0
