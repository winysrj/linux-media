Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:55901 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753176AbeBZOSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:18:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Shunqian Zheng <zhengsq@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: ov5695: mark PM functions as __maybe_unused
Date: Mon, 26 Feb 2018 15:18:03 +0100
Message-Id: <20180226141831.2980626-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_PM, we get a harmless build warning:

drivers/media/i2c/ov5695.c:1033:12: error: 'ov5695_runtime_suspend' defined but not used [-Werror=unused-function]
 static int ov5695_runtime_suspend(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~~~~
drivers/media/i2c/ov5695.c:1024:12: error: 'ov5695_runtime_resume' defined but not used [-Werror=unused-function]
 static int ov5695_runtime_resume(struct device *dev)

This marks the affected functions as __maybe_unused.

Fixes: 8a77009be4be ("media: ov5695: add support for OV5695 sensor")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/ov5695.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5695.c b/drivers/media/i2c/ov5695.c
index 2db7d2e535b9..a4985a4715f5 100644
--- a/drivers/media/i2c/ov5695.c
+++ b/drivers/media/i2c/ov5695.c
@@ -1021,7 +1021,7 @@ static void __ov5695_power_off(struct ov5695 *ov5695)
 	regulator_bulk_disable(OV5695_NUM_SUPPLIES, ov5695->supplies);
 }
 
-static int ov5695_runtime_resume(struct device *dev)
+static int __maybe_unused ov5695_runtime_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
@@ -1030,7 +1030,7 @@ static int ov5695_runtime_resume(struct device *dev)
 	return __ov5695_power_on(ov5695);
 }
 
-static int ov5695_runtime_suspend(struct device *dev)
+static int __maybe_unused ov5695_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-- 
2.9.0
