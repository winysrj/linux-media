Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54588 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbeH0NP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 22/23] v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
Date: Mon, 27 Aug 2018 12:29:59 +0300
Message-Id: <20180827093000.29165-23-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semantics of v4l2_fwnode_endpoint_parse() and
v4l2_fwnode_endpoint_alloc_parse() have changed slightly: they now take
the bus type from the user as well as a default configuration for the bus
that shall reflect the DT binding defaults. Document this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-fwnode.h | 56 ++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 1ea1a3ecf6d5..b4a49ca27579 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -131,21 +131,30 @@ struct v4l2_fwnode_link {
  * @fwnode: pointer to the endpoint's fwnode handle
  * @vep: pointer to the V4L2 fwnode data structure
  *
- * All properties are optional. If none are found, we don't set any flags. This
- * means the port has a static configuration and no properties have to be
- * specified explicitly. If any properties that identify the bus as parallel
- * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if
- * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't set, we
- * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
- * reference to @fwnode.
- *
- * The caller must set the bus_type field of @vep to zero.
+ * This function parses the V4L2 fwnode endpoint specific parameters from the
+ * firmware. The caller is responsible for assigning @vep.bus_type to a valid
+ * media bus type. The caller may also set the default configuration for the
+ * endpoint --- a configuration that shall be in line with the DT binding
+ * documentation. Should a device support multiple bus types, the caller may
+ * call this function once the correct type is found --- with a default
+ * configuration valid for that type.
+ *
+ * As a compatibility means guessing the bus type is also supported by setting
+ * @vep.bus_type to V4L2_MBUS_UNKNOWN. The caller may not provide a default
+ * configuration in this case as the defaults are specific to a given bus type.
+ * This functionality is deprecated and should not be used in new drivers and it
+ * is only supported for CSI-2 D-PHY, parallel and Bt.656 busses.
+ *
+ * The function does not change the V4L2 fwnode endpoint state if it fails.
  *
  * NOTE: This function does not parse properties the size of which is variable
  * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_parse() in
  * new drivers instead.
  *
- * Return: 0 on success or a negative error code on failure.
+ * Return: %0 on success or a negative error code on failure:
+ *	   %-ENOMEM on memory allocation failure
+ *	   %-EINVAL on parsing failure
+ *	   %-ENXIO on mismatching bus types
  */
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			       struct v4l2_fwnode_endpoint *vep);
@@ -165,15 +174,21 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  * @fwnode: pointer to the endpoint's fwnode handle
  * @vep: pointer to the V4L2 fwnode data structure
  *
- * All properties are optional. If none are found, we don't set any flags. This
- * means the port has a static configuration and no properties have to be
- * specified explicitly. If any properties that identify the bus as parallel
- * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if
- * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't set, we
- * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
- * reference to @fwnode.
+ * This function parses the V4L2 fwnode endpoint specific parameters from the
+ * firmware. The caller is responsible for assigning @vep.bus_type to a valid
+ * media bus type. The caller may also set the default configuration for the
+ * endpoint --- a configuration that shall be in line with the DT binding
+ * documentation. Should a device support multiple bus types, the caller may
+ * call this function once the correct type is found --- with a default
+ * configuration valid for that type.
+ *
+ * As a compatibility means guessing the bus type is also supported by setting
+ * @vep.bus_type to V4L2_MBUS_UNKNOWN. The caller may not provide a default
+ * configuration in this case as the defaults are specific to a given bus type.
+ * This functionality is deprecated and should not be used in new drivers and it
+ * is only supported for CSI-2 D-PHY, parallel and Bt.656 busses.
  *
- * The caller must set the bus_type field of @vep to zero.
+ * The function does not change the V4L2 fwnode endpoint state if it fails.
  *
  * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
  * v4l2_fwnode_endpoint_parse():
@@ -183,7 +198,10 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  * 2. The memory it has allocated to store the variable size data must be freed
  *    using v4l2_fwnode_endpoint_free() when no longer needed.
  *
- * Return: 0 on success or a negative error code on failure.
+ * Return: %0 on success or a negative error code on failure:
+ *	   %-ENOMEM on memory allocation failure
+ *	   %-EINVAL on parsing failure
+ *	   %-ENXIO on mismatching bus types
  */
 int v4l2_fwnode_endpoint_alloc_parse(
 	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep);
-- 
2.11.0
