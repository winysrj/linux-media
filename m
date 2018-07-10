Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:33767 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751263AbeGJIpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:45:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv6 12/12] media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage
Date: Tue, 10 Jul 2018 10:45:12 +0200
Message-Id: <20180710084512.99238-13-hverkuil@xs4all.nl>
In-Reply-To: <20180710084512.99238-1-hverkuil@xs4all.nl>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Mention that IDs should not be hardcoded in applications and that the
entity name must be unique within the media topology.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../uapi/mediactl/media-ioc-enum-entities.rst |  9 +++++---
 .../uapi/mediactl/media-ioc-g-topology.rst    | 22 ++++++++++++++-----
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 961466ae821d..fc2e39c070c9 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -62,15 +62,18 @@ id's until they get an error.
        -  ``id``
        -
        -
-       -  Entity id, set by the application. When the id is or'ed with
+       -  Entity ID, set by the application. When the ID is or'ed with
 	  ``MEDIA_ENT_ID_FLAG_NEXT``, the driver clears the flag and returns
-	  the first entity with a larger id.
+	  the first entity with a larger ID. Do not expect that the ID will
+	  always be the same for each instance of the device. In other words,
+	  do not hardcode entity IDs in an application.
 
     *  -  char
        -  ``name``\ [32]
        -
        -
-       -  Entity name as an UTF-8 NULL-terminated string.
+       -  Entity name as an UTF-8 NULL-terminated string. This name must be unique
+          within the media topology.
 
     *  -  __u32
        -  ``type``
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index e572dd0d806d..3a5f165d9811 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -131,11 +131,14 @@ desired arrays with the media graph elements.
 
     *  -  __u32
        -  ``id``
-       -  Unique ID for the entity.
+       -  Unique ID for the entity. Do not expect that the ID will
+	  always be the same for each instance of the device. In other words,
+	  do not hardcode entity IDs in an application.
 
     *  -  char
        -  ``name``\ [64]
-       -  Entity name as an UTF-8 NULL-terminated string.
+       -  Entity name as an UTF-8 NULL-terminated string. This name must be unique
+          within the media topology.
 
     *  -  __u32
        -  ``function``
@@ -166,7 +169,9 @@ desired arrays with the media graph elements.
 
     *  -  __u32
        -  ``id``
-       -  Unique ID for the interface.
+       -  Unique ID for the interface. Do not expect that the ID will
+	  always be the same for each instance of the device. In other words,
+	  do not hardcode interface IDs in an application.
 
     *  -  __u32
        -  ``intf_type``
@@ -215,7 +220,9 @@ desired arrays with the media graph elements.
 
     *  -  __u32
        -  ``id``
-       -  Unique ID for the pad.
+       -  Unique ID for the pad. Do not expect that the ID will
+	  always be the same for each instance of the device. In other words,
+	  do not hardcode pad IDs in an application.
 
     *  -  __u32
        -  ``entity_id``
@@ -231,7 +238,8 @@ desired arrays with the media graph elements.
 	  returns true. The ``media_version`` is defined in struct
 	  :c:type:`media_device_info` and can be retrieved using
 	  :ref:`MEDIA_IOC_DEVICE_INFO`. Pad indices are stable. If new pads are added
-	  for an entity in the future, then those will be added at the end.
+	  for an entity in the future, then those will be added at the end of the
+	  entity's pad array.
 
     *  -  __u32
        -  ``reserved``\ [4]
@@ -250,7 +258,9 @@ desired arrays with the media graph elements.
 
     *  -  __u32
        -  ``id``
-       -  Unique ID for the link.
+       -  Unique ID for the link. Do not expect that the ID will
+	  always be the same for each instance of the device. In other words,
+	  do not hardcode link IDs in an application.
 
     *  -  __u32
        -  ``source_id``
-- 
2.18.0
