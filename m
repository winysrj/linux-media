Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41748 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1033216AbeE1POd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 11:14:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, jasonx.z.chen@intel.com,
        "Lai, Jim" <jim.lai@intel.com>
Subject: [PATCH 1/1] imx258: Check the rotation property has a value of 180
Date: Mon, 28 May 2018 18:14:31 +0300
Message-Id: <20180528151431.12524-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver only supports streaming images flipped horizontally and
vertically. In order to ensure that all current users will be fine if or
when support for upright streaming is added, require the presence of the
"rotation" control now.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: "Lai, Jim" <jim.lai@intel.com>
---
 drivers/media/i2c/imx258.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index fad3012f4fe5..0383394f5676 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -1223,6 +1223,14 @@ static int imx258_probe(struct i2c_client *client)
 	if (val != 19200000)
 		return -EINVAL;
 
+	/*
+	 * Check that the device is mounted upside down. The driver only
+	 * supports a single pixel order right now.
+	 */
+	ret = device_property_read_u32(&client->dev, "rotation", &val);
+	if (ret || val != 180)
+		return -EINVAL;
+
 	imx258 = devm_kzalloc(&client->dev, sizeof(*imx258), GFP_KERNEL);
 	if (!imx258)
 		return -ENOMEM;
-- 
2.11.0
