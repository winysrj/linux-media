Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56634 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbdKANWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 09:22:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: v4l2-fwnode: use a typedef for a function callback
Date: Wed,  1 Nov 2017 09:22:50 -0400
Message-Id: <e7c1eccf22beb14262e34f47d1867dde93676a58.1509542559.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That allows having a kernel-doc markup for the function
prototype. It also prevents the need of describing the
return values twice.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-fwnode.h | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index ca50108dfd8f..9b04692e4fde 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -203,6 +203,27 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
  */
 void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
 
+
+/**
+ * typedef parse_endpoint_fnc - Driver's callback function to be called on
+ *	each V4L2 fwnode endpoint.
+ *
+ * @dev: pointer to &struct device
+ * @vep: pointer to &struct v4l2_fwnode_endpoint
+ * @asd: pointer to &struct v4l2_async_subdev
+ *
+ * Return:
+ * * %0 on success
+ * * %-ENOTCONN if the endpoint is to be skipped but this
+ *   should not be considered as an error
+ * * %-EINVAL if the endpoint configuration is invalid
+ */
+
+typedef	int (*parse_endpoint_fnc)(struct device *dev,
+			        struct v4l2_fwnode_endpoint *vep,
+			        struct v4l2_async_subdev *asd);
+
+
 /**
  * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
  *						device node
@@ -215,10 +236,6 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
  *		     begin at the same memory address.
  * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
  *		    endpoint. Optional.
- *		    Return: %0 on success
- *			    %-ENOTCONN if the endpoint is to be skipped but this
- *				       should not be considered as an error
- *			    %-EINVAL if the endpoint configuration is invalid
  *
  * Parse the fwnode endpoints of the @dev device and populate the async sub-
  * devices array of the notifier. The @parse_endpoint callback function is
@@ -253,9 +270,7 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
 int v4l2_async_notifier_parse_fwnode_endpoints(
 	struct device *dev, struct v4l2_async_notifier *notifier,
 	size_t asd_struct_size,
-	int (*parse_endpoint)(struct device *dev,
-			      struct v4l2_fwnode_endpoint *vep,
-			      struct v4l2_async_subdev *asd));
+	parse_endpoint_fnc parse_endpoint);
 
 /**
  * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2 fwnode
@@ -271,10 +286,6 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
  * @port: port number where endpoints are to be parsed
  * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
  *		    endpoint. Optional.
- *		    Return: %0 on success
- *			    %-ENOTCONN if the endpoint is to be skipped but this
- *				       should not be considered as an error
- *			    %-EINVAL if the endpoint configuration is invalid
  *
  * This function is just like v4l2_async_notifier_parse_fwnode_endpoints() with
  * the exception that it only parses endpoints in a given port. This is useful
@@ -315,9 +326,7 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
 int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
 	struct device *dev, struct v4l2_async_notifier *notifier,
 	size_t asd_struct_size, unsigned int port,
-	int (*parse_endpoint)(struct device *dev,
-			      struct v4l2_fwnode_endpoint *vep,
-			      struct v4l2_async_subdev *asd));
+	parse_endpoint_fnc parse_endpoint);
 
 /**
  * v4l2_fwnode_reference_parse_sensor_common - parse common references on
-- 
2.13.6
