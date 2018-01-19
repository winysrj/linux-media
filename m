Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46798 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755289AbeASKzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 05:55:43 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: zhengsq@rock-chips.com
Subject: [PATCH 1/1] ov2685: Assign ret in default case in s_ctrl callback
Date: Fri, 19 Jan 2018 12:55:40 +0200
Message-Id: <20180119105540.5573-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assign ret in the default case for s_ctrl callback. This can't happen but
still may result in compiler warnings.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov2685.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov2685.c b/drivers/media/i2c/ov2685.c
index df4abecd8d74..904ac305d499 100644
--- a/drivers/media/i2c/ov2685.c
+++ b/drivers/media/i2c/ov2685.c
@@ -574,6 +574,7 @@ static int ov2685_set_ctrl(struct v4l2_ctrl *ctrl)
 	default:
 		dev_warn(&client->dev, "%s Unhandled id:0x%x, val:0x%x\n",
 			 __func__, ctrl->id, ctrl->val);
+		ret = -EINVAL;
 		break;
 	};
 
-- 
2.11.0
