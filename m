Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43087 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbeHDLst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 07:48:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] mediactl/*.rst: document argp
Message-ID: <32cf513a-601a-4171-10e5-a31ccffe22b5@xs4all.nl>
Date: Sat, 4 Aug 2018 11:48:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation of the Media Controller API ioctls is missing a description
of the argp ioctl argument. Add this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index 649cb3d9e058..c6f224e404b7 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <media-func-open>`.

 ``argp``
+    Pointer to struct :c:type:`media_device_info`.


 Description
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index fc2e39c070c9..02738640e34e 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <media-func-open>`.

 ``argp``
+    Pointer to struct :c:type:`media_entity_desc`.


 Description
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index f158c134e9b0..b89aaae373df 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <media-func-open>`.

 ``argp``
+    Pointer to struct :c:type:`media_links_enum`.


 Description
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index bac128c7eda9..4e1c59238371 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <media-func-open>`.

 ``argp``
+    Pointer to struct :c:type:`media_v2_topology`.


 Description
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
index ae5194940100..e345e7dc9ad7 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <media-func-open>`.

 ``argp``
+    Pointer to struct :c:type:`media_link_desc`.


 Description
