Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58921 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762263AbdLSLSa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:18:30 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 4/8] media: v4l2-async: better describe match union at async match struct
Date: Tue, 19 Dec 2017 09:18:20 -0200
Message-Id: <7387b7c2aac5b48ceb2c878006abea780aaa9d6c.1513682135.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513682135.git.mchehab@s-opensource.com>
References: <cover.1513682135.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513682135.git.mchehab@s-opensource.com>
References: <cover.1513682135.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc handles nested unions, better document the
match union at struct v4l2_async_subdev.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-async.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index a010af5134b2..96e19246b934 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -48,6 +48,31 @@ enum v4l2_async_match_type {
  *
  * @match_type:	type of match that will be used
  * @match:	union of per-bus type matching data sets
+ * @match.fwnode:
+ *		pointer to &struct fwnode_handle to be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_FWNODE.
+ * @match.device_name:
+ *		string containing the device name to be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_DEVNAME.
+ * @match.i2c:	embedded struct with I2C parameters to be matched.
+ * 		Both @match.i2c.adapter_id and @match.i2c.address
+ *		should be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.
+ * @match.i2c.adapter_id:
+ *		I2C adapter ID to be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.
+ * @match.i2c.address:
+ *		I2C address to be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.
+ * @match.custom:
+ *		Driver-specific match criteria.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_CUSTOM.
+ * @match.custom.match:
+ *		Driver-specific match function to be used if
+ *		%V4L2_ASYNC_MATCH_CUSTOM.
+ * @match.custom.priv:
+ *		Driver-specific private struct with match parameters
+ *		to be used if %V4L2_ASYNC_MATCH_CUSTOM.
  * @list:	used to link struct v4l2_async_subdev objects, waiting to be
  *		probed, to a notifier->waiting list
  *
-- 
2.14.3
