Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:51778 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752653AbbCJThf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 15:37:35 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH 1/3] omap3isp: Defer probing when subdev isn't available
Date: Tue, 10 Mar 2015 14:24:52 -0500
Message-ID: <1426015494-16799-2-git-send-email-tim.nordell@logicpd.com>
In-Reply-To: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the subdev isn't available just yet, defer probing of
the system.  This is useful if the omap3isp comes up before
the I2C subsystem does.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 drivers/media/platform/omap3isp/isp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 51c2129..a361c40 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1811,7 +1811,7 @@ isp_register_subdev_group(struct isp_device *isp,
 				"device %s\n", __func__,
 				board_info->i2c_adapter_id,
 				board_info->board_info->type);
-			continue;
+			return ERR_PTR(-EPROBE_DEFER);
 		}
 
 		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
@@ -1898,6 +1898,10 @@ static int isp_register_entities(struct isp_device *isp)
 		unsigned int i;
 
 		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
+		if (IS_ERR(sensor)) {
+			ret = PTR_ERR(sensor);
+			goto done;
+		}
 		if (sensor == NULL)
 			continue;
 
-- 
2.0.4

