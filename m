Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20890 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753427AbdCTOzt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:55:49 -0400
Subject: [PATCH 08/24] atomisp/imx: Fix locking bug on error path
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:40:06 +0000
Message-ID: <149002080343.17109.13144918778111462380.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was reported by Dan Carpenter. When we error with an IMX 227 we don't release
the lock and the sensor would then hang.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/imx/imx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.c b/drivers/staging/media/atomisp/i2c/imx/imx.c
index a73f902..408a7b9 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.c
@@ -454,8 +454,10 @@ static int imx_set_exposure_gain(struct v4l2_subdev *sd, u16 coarse_itg,
 
 	if (dev->sensor_id == IMX227_ID) {
 		ret = imx_write_reg_array(client, imx_param_hold);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&dev->input_lock);
 			return ret;
+		}
 	}
 
 	/* For imx175, setting gain must be delayed by one */
