Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbcHSU2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:28:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 6/6] [media] docs-rst: Convert MC uAPI to use C function references
Date: Fri, 19 Aug 2016 17:27:53 -0300
Message-Id: <af56aec4a1975581ae7a705822e4d49e21caec68.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name all ioctl references and make them match the ioctls that
are documented. That will improve the cross-reference index,
as it will have all ioctls and syscalls there.

While here, improve the documentation to make them to look more
like the rest of the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/mediactl/media-func-close.rst        | 4 ++--
 Documentation/media/uapi/mediactl/media-func-ioctl.rst        | 4 ++--
 Documentation/media/uapi/mediactl/media-func-open.rst         | 2 +-
 Documentation/media/uapi/mediactl/media-ioc-device-info.rst   | 6 ++----
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst | 6 ++----
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst    | 6 ++----
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    | 6 ++----
 Documentation/media/uapi/mediactl/media-ioc-setup-link.rst    | 6 ++----
 8 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-func-close.rst b/Documentation/media/uapi/mediactl/media-func-close.rst
index c13220c2696e..a8f5203afe4b 100644
--- a/Documentation/media/uapi/mediactl/media-func-close.rst
+++ b/Documentation/media/uapi/mediactl/media-func-close.rst
@@ -21,13 +21,13 @@ Synopsis
 
 
 .. c:function:: int close( int fd )
-
+    :name: mc-close
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <func-open>`.
+    File descriptor returned by :c:func:`open() <mc-open>`.
 
 
 Description
diff --git a/Documentation/media/uapi/mediactl/media-func-ioctl.rst b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
index 6fa0a8e65af5..fe072b7c8765 100644
--- a/Documentation/media/uapi/mediactl/media-func-ioctl.rst
+++ b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
@@ -21,13 +21,13 @@ Synopsis
 
 
 .. c:function:: int ioctl( int fd, int request, void *argp )
-
+    :name: mc-ioctl
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <func-open>`.
+    File descriptor returned by :c:func:`open() <mc-open>`.
 
 ``request``
     Media ioctl request code as defined in the media.h header file, for
diff --git a/Documentation/media/uapi/mediactl/media-func-open.rst b/Documentation/media/uapi/mediactl/media-func-open.rst
index aa77ba32db21..32f53016a9e5 100644
--- a/Documentation/media/uapi/mediactl/media-func-open.rst
+++ b/Documentation/media/uapi/mediactl/media-func-open.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int open( const char *device_name, int flags )
-
+    :name: mc-open
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index e8c97abed394..412014110570 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -15,7 +15,8 @@ MEDIA_IOC_DEVICE_INFO - Query device information
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_device_info *argp )
+.. c:function:: int ioctl( int fd, MEDIA_IOC_DEVICE_INFO, struct media_device_info *argp )
+    :name: MEDIA_IOC_DEVICE_INFO
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <media-func-open>`.
 
-``request``
-    MEDIA_IOC_DEVICE_INFO
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index a621b08187ea..628e91aeda97 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -15,7 +15,8 @@ MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
+.. c:function:: int ioctl( int fd, MEDIA_IOC_ENUM_ENTITIES, struct media_entity_desc *argp )
+    :name: MEDIA_IOC_ENUM_ENTITIES
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <media-func-open>`.
 
-``request``
-    MEDIA_IOC_ENUM_ENTITIES
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index d07629ba44db..c81765f14b9f 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -15,7 +15,8 @@ MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
+.. c:function:: int ioctl( int fd, MEDIA_IOC_ENUM_LINKS, struct media_links_enum *argp )
+    :name: MEDIA_IOC_ENUM_LINKS
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <media-func-open>`.
 
-``request``
-    MEDIA_IOC_ENUM_LINKS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index d01a4528cb47..c246df06ff7f 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -15,7 +15,8 @@ MEDIA_IOC_G_TOPOLOGY - Enumerate the graph topology and graph element properties
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
+.. c:function:: int ioctl( int fd, MEDIA_IOC_G_TOPOLOGY, struct media_v2_topology *argp )
+    :name: MEDIA_IOC_G_TOPOLOGY
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <media-func-open>`.
 
-``request``
-    MEDIA_IOC_G_TOPOLOGY
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
index 10be4c546f33..35a189e19962 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
@@ -15,7 +15,8 @@ MEDIA_IOC_SETUP_LINK - Modify the properties of a link
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
+.. c:function:: int ioctl( int fd, MEDIA_IOC_SETUP_LINK, struct media_link_desc *argp )
+    :name: MEDIA_IOC_SETUP_LINK
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <media-func-open>`.
 
-``request``
-    MEDIA_IOC_SETUP_LINK
-
 ``argp``
 
 
-- 
2.7.4


