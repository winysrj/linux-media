Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56342 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388287AbeGWOsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 20/21] v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
Date: Mon, 23 Jul 2018 16:47:05 +0300
Message-Id: <20180723134706.15334-21-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semantics of v4l2_fwnode_endpoint_parse() and
v4l2_fwnode_endpoint_alloc_parse() have changed slightly: they now take
the bus type from the user as well as a default configuration for the bus
that shall reflect the DT binding defaults. Document this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c |  3 ++-
 include/media/v4l2-fwnode.h           | 28 +++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 04ddac86aec2..39491c6435ce 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -484,7 +484,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		break;
 	case V4L2_MBUS_PARALLEL:
 	case V4L2_MBUS_BT656:
-		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, vep->bus_type);
+		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep,
+							vep->bus_type);
 
 		break;
 	default:
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 4cef723a6ad9..7cad3b2756ec 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -139,6 +139,20 @@ struct v4l2_fwnode_link {
  * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
  * reference to @fwnode.
  *
+ * The caller is responsible for assigning @vep.bus_type to a valid media bus
+ * type, or alternatively V4L2_MBUS_UNKNOWN. Depending on the hardware, the
+ * information may also be read from the firmware. As a compatibility means
+ * guessing the bus type is also supported. Mismatching bus types in the V4L2
+ * fwnode endpoint and in firmware will also yield an error (-ENXIO).
+ *
+ * The user may also set the default parameters for the bus if the bus type is
+ * explicitly set by the user. In particular, the user may set the default
+ * number of CSI-2 lanes but without assigning lane mapping, in which case the
+ * defaults (clock lane 0, data lanes from 1 onwards) will be used. The defaults
+ * shall reflect the defaults defined in the DT binding documentation.
+ *
+ * The function does not change the V4L2 fwnode endpoint state if it fails.
+ *
  * NOTE: This function does not parse properties the size of which is variable
  * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_parse() in
  * new drivers instead.
@@ -171,7 +185,19 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
  * reference to @fwnode.
  *
- * The caller must set the bus_type field of @vep to zero.
+ * The caller is responsible for assigning @vep.bus_type to a valid media bus
+ * type, or alternatively V4L2_MBUS_UNKNOWN. Depending on the hardware, the
+ * information may also be read from the firmware. As a compatibility means
+ * guessing the bus type is also supported. Mismatching bus types in the V4L2
+ * fwnode endpoint and in firmware will also yield an error (-ENXIO).
+ *
+ * The user may also set the default parameters for the bus if the bus type is
+ * explicitly set by the user. In particular, the user may set the default
+ * number of CSI-2 lanes but without assigning lane mapping, in which case the
+ * defaults (clock lane 0, data lanes from 1 onwards) will be used. The defaults
+ * shall reflect the defaults defined in the DT binding documentation.
+ *
+ * The function does not change the V4L2 fwnode endpoint state if it fails.
  *
  * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
  * v4l2_fwnode_endpoint_parse():
-- 
2.11.0
