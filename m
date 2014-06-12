Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53732 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933683AbaFLQKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 12:10:23 -0400
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6CD7260097
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:10:21 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] smiapp: Set 64-bit integer control using v4l2_ctrl_s_ctrl_int64()
Date: Thu, 12 Jun 2014 19:09:43 +0300
Message-Id: <1402589383-28165-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
References: <1402589383-28165-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Don't manipulate struct v4l2_ctrl directly. Instead, use
v4l2_ctrl_s_ctrl_int64() to change the values.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c669525..95d3d0e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -297,8 +297,9 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		return rval;
 
-	sensor->pixel_rate_parray->cur.val64 = pll->vt_pix_clk_freq_hz;
-	sensor->pixel_rate_csi->cur.val64 = pll->pixel_rate_csi;
+	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate_parray,
+				 pll->vt_pix_clk_freq_hz);
+	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate_csi, pll->pixel_rate_csi);
 
 	return 0;
 }
@@ -471,6 +472,10 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 
 		return smiapp_pll_update(sensor);
 
+	case V4L2_CID_PIXEL_RATE:
+		/* For v4l2_ctrl_s_ctrl_int64() used internally. */
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
-- 
1.7.10.4

