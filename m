Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:40162 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388249AbeGXMOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 08:14:34 -0400
Subject: [PATCHv6.1 02/12] media-ioc-g-topology.rst: document new 'index'
 field
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
 <20180710084512.99238-3-hverkuil@xs4all.nl>
Message-ID: <1bfe9e0f-2a01-65af-d3cf-c2ceec4f71f9@xs4all.nl>
Date: Tue, 24 Jul 2018 13:08:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180710084512.99238-3-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the new struct media_v2_pad 'index' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Dropped the text about stable index values.
---
 .../media/uapi/mediactl/media-ioc-g-topology.rst      | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index a3f259f83b25..725961198143 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -176,7 +176,7 @@ desired arrays with the media graph elements.
     *  -  struct media_v2_intf_devnode
        -  ``devnode``
        -  Used only for device node interfaces. See
-	  :c:type:`media_v2_intf_devnode` for details..
+	  :c:type:`media_v2_intf_devnode` for details.


 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
@@ -218,7 +218,14 @@ desired arrays with the media graph elements.
        -  Pad flags, see :ref:`media-pad-flag` for more details.

     *  -  __u32
-       -  ``reserved``\ [5]
+       -  ``index``
+       -  Pad index, starts at 0. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
+	  returns true. The ``media_version`` is defined in struct
+	  :c:type:`media_device_info` and can be retrieved using
+	  :ref:`MEDIA_IOC_DEVICE_INFO`.
+
+    *  -  __u32
+       -  ``reserved``\ [4]
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.

-- 
2.18.0
