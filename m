Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:40009 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751649AbeGJIpO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:45:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv6 02/12] media-ioc-g-topology.rst: document new 'index' field
Date: Tue, 10 Jul 2018 10:45:02 +0200
Message-Id: <20180710084512.99238-3-hverkuil@xs4all.nl>
In-Reply-To: <20180710084512.99238-1-hverkuil@xs4all.nl>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new struct media_v2_pad 'index' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../media/uapi/mediactl/media-ioc-g-topology.rst     | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index a3f259f83b25..bae2b4db89cc 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -176,7 +176,7 @@ desired arrays with the media graph elements.
     *  -  struct media_v2_intf_devnode
        -  ``devnode``
        -  Used only for device node interfaces. See
-	  :c:type:`media_v2_intf_devnode` for details..
+	  :c:type:`media_v2_intf_devnode` for details.
 
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
@@ -218,7 +218,15 @@ desired arrays with the media graph elements.
        -  Pad flags, see :ref:`media-pad-flag` for more details.
 
     *  -  __u32
-       -  ``reserved``\ [5]
+       -  ``index``
+       -  Pad index, starts at 0. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
+	  returns true. The ``media_version`` is defined in struct
+	  :c:type:`media_device_info` and can be retrieved using
+	  :ref:`MEDIA_IOC_DEVICE_INFO`. Pad indices are stable. If new pads are added
+	  for an entity in the future, then those will be added at the end.
+
+    *  -  __u32
+       -  ``reserved``\ [4]
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
-- 
2.18.0
