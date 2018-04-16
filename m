Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37955 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755087AbeDPNV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:21:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 5/9] media-ioc-enum-entities.rst: document new 'function' field
Date: Mon, 16 Apr 2018 15:21:17 +0200
Message-Id: <20180416132121.46205-6-hverkuil@xs4all.nl>
In-Reply-To: <20180416132121.46205-1-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new struct media_entity_desc 'function' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../uapi/mediactl/media-ioc-enum-entities.rst      | 31 +++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 582fda488810..6b0ab65288c6 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -90,6 +90,12 @@ id's until they get an error.
        -
        -
        -  Entity type, see :ref:`media-entity-functions` for details.
+          Deprecated. If possible, use the ``function`` field instead.
+	  For backwards compatibility this ``type`` field will only
+	  expose functions ``MEDIA_ENT_F_IO_V4L``, ``MEDIA_ENT_F_CAM_SENSOR``,
+	  ``MEDIA_ENT_F_FLASH``, ``MEDIA_ENT_F_LENS``, ``MEDIA_ENT_F_ATV_DECODER``
+	  and ``MEDIA_ENT_F_TUNER``. Other functions will be mapped to
+	  ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN`` or ``MEDIA_ENT_T_DEVNODE_UNKNOWN``.
 
     -  .. row 4
 
@@ -146,18 +152,31 @@ id's until they get an error.
 
        -  __u32
 
-       -  ``reserved[4]``
+       -  ``function``
+
+       -
+       -
+       -  Entity main function, see :ref:`media-entity-functions` for details.
+          Only valid if ``MEDIA_ENTITY_DESC_HAS_FUNCTION(media_version)``
+          returns true. The ``media_version`` is defined in struct
+          :c:type:`media_device_info`.
+
+    -  .. row 10
+
+       -  __u32
+
+       -  ``reserved[3]``
 
        -
        -
        -  Reserved for future extensions. Drivers and applications must set
           the array to zero.
 
-    -  .. row 10
+    -  .. row 11
 
        -  union
 
-    -  .. row 11
+    -  .. row 12
 
        -
        -  struct
@@ -167,7 +186,7 @@ id's until they get an error.
        -
        -  Valid for (sub-)devices that create a single device node.
 
-    -  .. row 12
+    -  .. row 13
 
        -
        -
@@ -177,7 +196,7 @@ id's until they get an error.
 
        -  Device node major number.
 
-    -  .. row 13
+    -  .. row 14
 
        -
        -
@@ -187,7 +206,7 @@ id's until they get an error.
 
        -  Device node minor number.
 
-    -  .. row 14
+    -  .. row 15
 
        -
        -  __u8
-- 
2.15.1
