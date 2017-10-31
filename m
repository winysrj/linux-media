Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40769 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753056AbdJaOW2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 10:22:28 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v1 14/15] media: adv7180: Remove duplicate checks
Date: Tue, 31 Oct 2017 16:21:48 +0200
Message-Id: <20171031142149.32512-14-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171031142149.32512-1-andriy.shevchenko@linux.intel.com>
References: <20171031142149.32512-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since i2c_unregister_device() became NULL-aware we may remove duplicate checks.

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/i2c/adv7180.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 3df28f2f9b38..c7e2ee7fe8a4 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1366,11 +1366,9 @@ static int adv7180_probe(struct i2c_client *client,
 err_free_ctrl:
 	adv7180_exit_controls(state);
 err_unregister_vpp_client:
-	if (state->chip_info->flags & ADV7180_FLAG_I2P)
-		i2c_unregister_device(state->vpp_client);
+	i2c_unregister_device(state->vpp_client);
 err_unregister_csi_client:
-	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
-		i2c_unregister_device(state->csi_client);
+	i2c_unregister_device(state->csi_client);
 	mutex_destroy(&state->mutex);
 	return ret;
 }
@@ -1388,10 +1386,8 @@ static int adv7180_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	adv7180_exit_controls(state);
 
-	if (state->chip_info->flags & ADV7180_FLAG_I2P)
-		i2c_unregister_device(state->vpp_client);
-	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
-		i2c_unregister_device(state->csi_client);
+	i2c_unregister_device(state->vpp_client);
+	i2c_unregister_device(state->csi_client);
 
 	adv7180_set_power_pin(state, false);
 
-- 
2.14.2
