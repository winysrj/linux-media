Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33415
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752374AbdI0VrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 14/17] media: v4l2-async: better describe match union at async match struct
Date: Wed, 27 Sep 2017 18:46:57 -0300
Message-Id: <d7534d804eedd7bd6bc46b65a810679bda81b3cc.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc handles nested unions, better document the
match union at struct v4l2_async_subdev.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-async.h | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index e66a3521596f..62c2d572ec23 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -46,10 +46,39 @@ enum v4l2_async_match_type {
 /**
  * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
  *
- * @match_type:	type of match that will be used
- * @match:	union of per-bus type matching data sets
+ * @match_type:
+ *	type of match that will be used
+ * @match:
+ *	union of per-bus type matching data sets
+ * @match.fwnode:
+ *		pointer to &struct fwnode_handle to be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_FWNODE.
+ * @match.device_name:
+ *		string containing the device name to be matched.
+ *		Used if @match_type is %V4L2_ASYNC_MATCH_DEVNAME.
+ * @match.i2c:
+ *		embedded struct with I2C parameters to be matched.
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
- *		probed, to a notifier->waiting list
+ *		probed, to a notifier->waiting list.
+ *		Not to be used by drivers.
  */
 struct v4l2_async_subdev {
 	enum v4l2_async_match_type match_type;
-- 
2.13.5
