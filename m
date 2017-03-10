Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44265 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935188AbdCJK0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 05:26:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 02/15] ov7670: call v4l2_async_register_subdev
Date: Fri, 10 Mar 2017 11:26:01 +0100
Message-Id: <20170310102614.20922-3-hverkuil@xs4all.nl>
In-Reply-To: <20170310102614.20922-1-hverkuil@xs4all.nl>
References: <20170310102614.20922-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add v4l2-async support for this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7670.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 56cfb5ca9c95..9af8d3b8f848 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1636,10 +1636,9 @@ static int ov7670_probe(struct i2c_client *client,
 			V4L2_EXPOSURE_AUTO);
 	sd->ctrl_handler = &info->hdl;
 	if (info->hdl.error) {
-		int err = info->hdl.error;
+		ret = info->hdl.error;
 
-		v4l2_ctrl_handler_free(&info->hdl);
-		return err;
+		goto hdl_free;
 	}
 	/*
 	 * We have checked empirically that hw allows to read back the gain
@@ -1651,7 +1650,15 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l2_ctrl_cluster(2, &info->saturation);
 	v4l2_ctrl_handler_setup(&info->hdl);
 
+	ret = v4l2_async_register_subdev(&info->sd);
+	if (ret < 0)
+		goto hdl_free;
+
 	return 0;
+
+hdl_free:
+	v4l2_ctrl_handler_free(&info->hdl);
+	return ret;
 }
 
 
-- 
2.11.0
