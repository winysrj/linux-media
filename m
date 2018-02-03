Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50506 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753169AbeBCSGG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 13:06:06 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] media: document and zero reservedX fields in
 media_v2_topology
Message-ID: <c1037baa-b278-03aa-e6f2-a9e35971ae3f@xs4all.nl>
Date: Sat, 3 Feb 2018 19:06:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MEDIA_IOC_G_TOPOLOGY documentation didn't document the reservedX fields.
Related to that was that the documented type of the num_* fields was also
wrong.

The reservedX fields were not set to 0, that is now also fixed.

Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
I think that the kernel should set these reserved fields to 0. What is
less clear is if userspace should set them to 0 as well. I think there are
very few users of this ioctl, so I have documented this as "Applications
and drivers shall set this to 0.".

However, it may be to late to make that change to the spec. In that case
it will become "Drivers shall set this to 0.".

Comments?

	Hans
---
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 997e6b17440d..cd44153199ac 100644
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

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e79f72b8b858..5b8bf62cd1de 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -263,6 +263,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		uentity++;
 	}
 	topo->num_entities = i;
+	topo->reserved1 = 0;

 	/* Get interfaces and number of interfaces */
 	i = 0;
@@ -298,6 +299,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		uintf++;
 	}
 	topo->num_interfaces = i;
+	topo->reserved2 = 0;

 	/* Get pads and number of pads */
 	i = 0;
@@ -324,6 +326,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		upad++;
 	}
 	topo->num_pads = i;
+	topo->reserved3 = 0;

 	/* Get links and number of links */
 	i = 0;
@@ -355,6 +358,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		ulink++;
 	}
 	topo->num_links = i;
+	topo->reserved4 = 0;

 	return ret;
 }
