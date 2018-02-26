Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:50875 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753287AbeBZOS7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:18:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Shunqian Zheng <zhengsq@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: ov5695: mark PM functions as __maybe_unused
Date: Mon, 26 Feb 2018 15:18:04 +0100
Message-Id: <20180226141831.2980626-2-arnd@arndb.de>
In-Reply-To: <20180226141831.2980626-1-arnd@arndb.de>
References: <20180226141831.2980626-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_PM, we get a harmless build warning:

drivers/media/i2c/ov2685.c:516:12: error: 'ov2685_runtime_suspend' defined but not used [-Werror=unused-function]
 static int ov2685_runtime_suspend(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~~~~
drivers/media/i2c/ov2685.c:507:12: error: 'ov2685_runtime_resume' defined but not used [-Werror=unused-function]
 static int ov2685_runtime_resume(struct device *dev)

This marks the affected functions as __maybe_unused.

Fixes: e3861d9118c8 ("media: ov2685: add support for OV2685 sensor")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/ov2685.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2685.c b/drivers/media/i2c/ov2685.c
index 904ac305d499..9ac702e3ae95 100644
--- a/drivers/media/i2c/ov2685.c
+++ b/drivers/media/i2c/ov2685.c
@@ -504,7 +504,7 @@ static int ov2685_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 }
 #endif
 
-static int ov2685_runtime_resume(struct device *dev)
+static int __maybe_unused ov2685_runtime_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
@@ -513,7 +513,7 @@ static int ov2685_runtime_resume(struct device *dev)
 	return __ov2685_power_on(ov2685);
 }
 
-static int ov2685_runtime_suspend(struct device *dev)
+static int __maybe_unused ov2685_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-- 
2.9.0
