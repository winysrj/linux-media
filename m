Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbcGRB43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 32/36] [media] doc-rst: add documentation for uvcvideo
Date: Sun, 17 Jul 2016 22:56:15 -0300
Message-Id: <a965d2024fe6f45a33462a62826c23a2175f3d5a.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst    |  1 +
 Documentation/media/v4l-drivers/uvcvideo.rst | 48 ++++++++++++++++++----------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index a982d73abcb6..90224e0231df 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -39,4 +39,5 @@ License".
 	si4713
 	si476x
 	soc-camera
+	uvcvideo
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/uvcvideo.rst b/Documentation/media/v4l-drivers/uvcvideo.rst
index 35ce19cddcf8..d68b3d59a4b5 100644
--- a/Documentation/media/v4l-drivers/uvcvideo.rst
+++ b/Documentation/media/v4l-drivers/uvcvideo.rst
@@ -1,5 +1,5 @@
-Linux USB Video Class (UVC) driver
-==================================
+The Linux USB Video Class (UVC) driver
+======================================
 
 This file documents some driver-specific aspects of the UVC driver, such as
 driver-specific ioctls and implementation notes.
@@ -11,7 +11,8 @@ linux-uvc-devel@lists.berlios.de.
 Extension Unit (XU) support
 ---------------------------
 
-1. Introduction
+Introduction
+~~~~~~~~~~~~
 
 The UVC specification allows for vendor-specific extensions through extension
 units (XUs). The Linux UVC driver supports extension unit controls (XU controls)
@@ -31,7 +32,8 @@ maximum flexibility.
 Both mechanisms complement each other and are described in more detail below.
 
 
-2. Control mappings
+Control mappings
+~~~~~~~~~~~~~~~~
 
 The UVC driver provides an API for user space applications to define so-called
 control mappings at runtime. These allow for individual XU controls or byte
@@ -82,7 +84,8 @@ For details on the UVCIOC_CTRL_QUERY ioctl please refer to the section titled
 "IOCTL reference" below.
 
 
-4. Security
+Security
+~~~~~~~~
 
 The API doesn't currently provide a fine-grained access control facility. The
 UVCIOC_CTRL_ADD and UVCIOC_CTRL_MAP ioctls require super user permissions.
@@ -90,20 +93,24 @@ UVCIOC_CTRL_ADD and UVCIOC_CTRL_MAP ioctls require super user permissions.
 Suggestions on how to improve this are welcome.
 
 
-5. Debugging
+Debugging
+~~~~~~~~~
 
 In order to debug problems related to XU controls or controls in general it is
 recommended to enable the UVC_TRACE_CONTROL bit in the module parameter 'trace'.
 This causes extra output to be written into the system log.
 
 
-6. IOCTL reference
+IOCTL reference
+~~~~~~~~~~~~~~~
 
----- UVCIOC_CTRL_MAP - Map a UVC control to a V4L2 control ----
+UVCIOC_CTRL_MAP - Map a UVC control to a V4L2 control
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Argument: struct uvc_xu_control_mapping
 
-Description:
+**Description**:
+
 	This ioctl creates a mapping between a UVC control or part of a UVC
 	control and a V4L2 control. Once mappings are defined, userspace
 	applications can access vendor-defined UVC control through the V4L2
@@ -122,7 +129,8 @@ Description:
 	For signed integer V4L2 controls the data_type field should be set to
 	UVC_CTRL_DATA_TYPE_SIGNED. Other values are currently ignored.
 
-Return value:
+**Return value**:
+
 	On success 0 is returned. On error -1 is returned and errno is set
 	appropriately.
 
@@ -137,7 +145,10 @@ Return value:
 	EEXIST
 		Mapping already exists.
 
-Data types:
+**Data types**:
+
+.. code-block:: none
+
 	* struct uvc_xu_control_mapping
 
 	__u32	id		V4L2 control identifier
@@ -170,11 +181,12 @@ Data types:
 	UVC_CTRL_DATA_TYPE_BITMASK	Bitmask
 
 
----- UVCIOC_CTRL_QUERY - Query a UVC XU control ----
-
+UVCIOC_CTRL_QUERY - Query a UVC XU control
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 Argument: struct uvc_xu_control_query
 
-Description:
+**Description**:
+
 	This ioctl queries a UVC XU control identified by its extension unit ID
 	and control selector.
 
@@ -213,7 +225,8 @@ Description:
 	important for the result of the UVC_GET_LEN requests, which is always
 	returned as a little-endian 16-bit integer by the device.
 
-Return value:
+**Return value**:
+
 	On success 0 is returned. On error -1 is returned and errno is set
 	appropriately.
 
@@ -229,7 +242,10 @@ Return value:
 	EFAULT
 		The data pointer references an inaccessible memory area.
 
-Data types:
+**Data types**:
+
+.. code-block:: none
+
 	* struct uvc_xu_control_query
 
 	__u8	unit		Extension unit ID
-- 
2.7.4

