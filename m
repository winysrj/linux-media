Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbcGTOlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:41:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/5] [media] doc-rst: better organize the media books
Date: Wed, 20 Jul 2016 11:41:33 -0300
Message-Id: <7ad98238fc9c1880a2ec15bea272fe0fbe681382.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uAPI book has 5 parts, but they lost numeration after
conversion to rst. Manually number those parts, and make
the main index with 1 depth, to only show the parts and
the annexes.

At each part, use :maxwidth: 5, in order to show a more
complete index.

While here, fix the cross-references between different
books.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/mc-core.rst                   |  2 +-
 Documentation/media/media_uapi.rst                     |  2 +-
 Documentation/media/uapi/cec/cec-api.rst               | 14 ++++++++------
 Documentation/media/uapi/dvb/dvbapi.rst                | 12 ++++++++----
 Documentation/media/uapi/mediactl/media-controller.rst | 17 +++++++----------
 Documentation/media/uapi/rc/remote_controllers.rst     | 17 +++++++----------
 Documentation/media/uapi/v4l/v4l2.rst                  | 12 ++++++++----
 Documentation/media/v4l-drivers/fimc.rst               | 10 ++++------
 8 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index c1fe0d69207d..4c47f5e3611d 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -5,7 +5,7 @@ Media Controller
 ~~~~~~~~~~~~~~~~
 
 The media controller userspace API is documented in
-:ref:`the Media Controller uAPI book <media_common>`. This document focus
+:ref:`the Media Controller uAPI book <media_controller>`. This document focus
 on the kernel-side implementation of the media framework.
 
 Abstract media device model
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index aaa9a0e387c4..fd8ebe002cd2 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -19,7 +19,7 @@ License".
         Table of Contents
 
 .. toctree::
-    :maxdepth: 5
+    :maxdepth: 1
 
     intro
     uapi/v4l/v4l2
diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index 246fbae2e079..bb018709970c 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -4,16 +4,18 @@
 
 .. _cec:
 
-#######
-CEC API
-#######
-
-.. _cec-api:
+#########################################
+Part V - Consumer Electronics Control API
+#########################################
 
 This part describes the CEC: Consumer Electronics Control
 
+.. class:: toc-title
+
+        Table of Contents
+
 .. toctree::
-    :maxdepth: 1
+    :maxdepth: 5
     :numbered:
 
     cec-intro
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 6c06147f167c..48e61aba741e 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -4,17 +4,21 @@
 
 .. _dvbapi:
 
-##############
-Digital TV API
-##############
+########################
+Part II - Digital TV API
+########################
 
 .. note:: This API is also known as **DVB API**, although it is generic
    enough to support all digital TV standards.
 
 **Version 5.10**
 
+.. class:: toc-title
+
+        Table of Contents
+
 .. toctree::
-    :maxdepth: 1
+    :maxdepth: 5
     :numbered:
 
     intro
diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
index 7e08c93a15ab..7ae38d48969e 100644
--- a/Documentation/media/uapi/mediactl/media-controller.rst
+++ b/Documentation/media/uapi/mediactl/media-controller.rst
@@ -2,21 +2,18 @@
 
 .. include:: <isonum.txt>
 
-.. _media_common:
-
-####################
-Media Controller API
-####################
-
 .. _media_controller:
 
-****************
-Media Controller
-****************
+##############################
+Part IV - Media Controller API
+##############################
 
+.. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
-    :maxdepth: 1
+    :maxdepth: 5
     :numbered:
 
     media-controller-intro
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
index 169286501ebb..3e25cc9f65e0 100644
--- a/Documentation/media/uapi/rc/remote_controllers.rst
+++ b/Documentation/media/uapi/rc/remote_controllers.rst
@@ -2,21 +2,18 @@
 
 .. include:: <isonum.txt>
 
-.. _remotes:
-
-#####################
-Remote Controller API
-#####################
-
 .. _remote_controllers:
 
-******************
-Remote Controllers
-******************
+################################
+Part III - Remote Controller API
+################################
 
+.. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
-    :maxdepth: 1
+    :maxdepth: 5
     :numbered:
 
     rc-intro
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index c0859ebc88ee..5e41a8505301 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -3,17 +3,21 @@
 .. include:: <isonum.txt>
 .. _v4l2spec:
 
-###################
-Video for Linux API
-###################
+############################
+Part I - Video for Linux API
+############################
 
 This part describes the Video for Linux API version 2 (V4L2 API) specification.
 
 **Revision 4.5**
 
+.. class:: toc-title
+
+        Table of Contents
+
 .. toctree::
     :numbered:
-    :maxdepth: 1
+    :maxdepth: 5
 
     common
     pixfmt
diff --git a/Documentation/media/v4l-drivers/fimc.rst b/Documentation/media/v4l-drivers/fimc.rst
index d9f950d90eb5..3adc19bcf039 100644
--- a/Documentation/media/v4l-drivers/fimc.rst
+++ b/Documentation/media/v4l-drivers/fimc.rst
@@ -62,8 +62,7 @@ User space interfaces
 Media device interface
 ~~~~~~~~~~~~~~~~~~~~~~
 
-The driver supports Media Controller API as defined at
-https://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
+The driver supports Media Controller API as defined at :ref:`media_controller`.
 The media device driver name is "SAMSUNG S5P FIMC".
 
 The purpose of this interface is to allow changing assignment of FIMC instances
@@ -89,12 +88,11 @@ undefined behaviour.
 Capture video node
 ~~~~~~~~~~~~~~~~~~
 
-The driver supports V4L2 Video Capture Interface as defined at:
-https://linuxtv.org/downloads/v4l-dvb-apis/devices.html
+The driver supports V4L2 Video Capture Interface as defined at
+:ref:`devices`.
 
 At the capture and mem-to-mem video nodes only the multi-planar API is
-supported. For more details see:
-https://linuxtv.org/downloads/v4l-dvb-apis/planar-apis.html
+supported. For more details see: :ref:`planar-apis`.
 
 Camera capture subdevs
 ~~~~~~~~~~~~~~~~~~~~~~
-- 
2.7.4

