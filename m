Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60481 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966002AbeBUPcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 13/15] media: document the reservedX fields in media_v2_topology
Date: Wed, 21 Feb 2018 16:32:16 +0100
Message-Id: <20180221153218.15654-14-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MEDIA_IOC_G_TOPOLOGY documentation didn't document the reservedX
fields. Related to that was that the documented type of the num_* fields
was also wrong.

Fix both.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../media/uapi/mediactl/media-ioc-g-topology.rst   | 52 +++++++++++++++++-----
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 870a6c0d1f7a..c8f9ea37db2d 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -68,7 +68,7 @@ desired arrays with the media graph elements.
 
     -  .. row 2
 
-       -  __u64
+       -  __u32
 
        -  ``num_entities``
 
@@ -76,6 +76,14 @@ desired arrays with the media graph elements.
 
     -  .. row 3
 
+       -  __u32
+
+       -  ``reserved1``
+
+       -  Applications and drivers shall set this to 0.
+
+    -  .. row 4
+
        -  __u64
 
        -  ``ptr_entities``
@@ -85,15 +93,23 @@ desired arrays with the media graph elements.
 	  the ioctl won't store the entities. It will just update
 	  ``num_entities``
 
-    -  .. row 4
+    -  .. row 5
 
-       -  __u64
+       -  __u32
 
        -  ``num_interfaces``
 
        -  Number of interfaces in the graph
 
-    -  .. row 5
+    -  .. row 6
+
+       -  __u32
+
+       -  ``reserved2``
+
+       -  Applications and drivers shall set this to 0.
+
+    -  .. row 7
 
        -  __u64
 
@@ -104,15 +120,23 @@ desired arrays with the media graph elements.
 	  the ioctl won't store the interfaces. It will just update
 	  ``num_interfaces``
 
-    -  .. row 6
+    -  .. row 8
 
-       -  __u64
+       -  __u32
 
        -  ``num_pads``
 
        -  Total number of pads in the graph
 
-    -  .. row 7
+    -  .. row 9
+
+       -  __u32
+
+       -  ``reserved3``
+
+       -  Applications and drivers shall set this to 0.
+
+    -  .. row 10
 
        -  __u64
 
@@ -122,15 +146,23 @@ desired arrays with the media graph elements.
 	  converted to a 64-bits integer. It can be zero. if zero, the ioctl
 	  won't store the pads. It will just update ``num_pads``
 
-    -  .. row 8
+    -  .. row 11
 
-       -  __u64
+       -  __u32
 
        -  ``num_links``
 
        -  Total number of data and interface links in the graph
 
-    -  .. row 9
+    -  .. row 12
+
+       -  __u32
+
+       -  ``reserved4``
+
+       -  Applications and drivers shall set this to 0.
+
+    -  .. row 13
 
        -  __u64
 
-- 
2.16.1
