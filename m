Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33411
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752357AbdI0VrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 12/17] media: v4l2-fwnode.h: better describe bus union at fwnode endpoint struct
Date: Wed, 27 Sep 2017 18:46:55 -0300
Message-Id: <dfcea28fc432a398b4b87902a2bcb097ad416b2c.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc handles nested unions, better document the
bus union at struct v4l2_fwnode_endpoint.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-fwnode.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 7adec9851d9e..5f4716f967d0 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -79,7 +79,18 @@ struct v4l2_fwnode_bus_mipi_csi1 {
  * struct v4l2_fwnode_endpoint - the endpoint data structure
  * @base: fwnode endpoint of the v4l2_fwnode
  * @bus_type: bus type
- * @bus: bus configuration data structure
+ * @bus: union with bus configuration data structure
+ * @bus.parallel: pointer for &struct v4l2_fwnode_bus_parallel.
+ *		  Used if the bus is parallel.
+ * @bus.mipi_csi1: pointer for &struct v4l2_fwnode_bus_mipi_csi1.
+ *		   Used if the bus is Mobile Industry Processor
+ * 		   Interface's Camera Serial Interface version 1
+ * 		   (MIPI CSI1) or Standard Mobile Imaging Architecture's
+ *		   Compact Camera Port 2 (SMIA CCP2).
+ * @bus.mipi_csi2: pointer for &struct v4l2_fwnode_bus_mipi_csi2.
+ *		   Used if the bus is Mobile Industry Processor
+ * 		   Interface's Camera Serial Interface version 2
+ *		   (MIPI CSI2).
  * @link_frequencies: array of supported link frequencies
  * @nr_of_link_frequencies: number of elements in link_frequenccies array
  */
-- 
2.13.5
