Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33988 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751637AbdF2HaS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 03:30:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 1/2] v4l: fwnode: link_frequency is an optional property
Date: Thu, 29 Jun 2017 10:30:09 +0300
Message-Id: <1498721410-28199-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1498721410-28199-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1498721410-28199-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fwnode_endpoint_alloc_parse() is intended as a replacement for
v4l2_fwnode_endpoint_parse(). It parses the "link-frequency" property and
if the property isn't found, it returns an error. However,
"link-frequency" is an optional property and if it does not exist is not
an error. Instead, the number of link frequencies is simply zero in that
case.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 153c53c..0ec6c14 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -247,23 +247,23 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 
 	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
 					      NULL, 0);
-	if (rval < 0)
-		goto out_err;
-
-	vep->link_frequencies =
-		kmalloc_array(rval, sizeof(*vep->link_frequencies), GFP_KERNEL);
-	if (!vep->link_frequencies) {
-		rval = -ENOMEM;
-		goto out_err;
-	}
+	if (rval > 0) {
+		vep->link_frequencies =
+			kmalloc_array(rval, sizeof(*vep->link_frequencies),
+				      GFP_KERNEL);
+		if (!vep->link_frequencies) {
+			rval = -ENOMEM;
+			goto out_err;
+		}
 
-	vep->nr_of_link_frequencies = rval;
+		vep->nr_of_link_frequencies = rval;
 
-	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
-					      vep->link_frequencies,
-					      vep->nr_of_link_frequencies);
-	if (rval < 0)
-		goto out_err;
+		rval = fwnode_property_read_u64_array(
+			fwnode, "link-frequencies", vep->link_frequencies,
+			vep->nr_of_link_frequencies);
+		if (rval < 0)
+			goto out_err;
+	}
 
 	return vep;
 
-- 
2.1.4
