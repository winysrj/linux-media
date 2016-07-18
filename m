Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 20/36] [media] doc-rst: add meye documentation
Date: Sun, 17 Jul 2016 22:56:03 -0300
Message-Id: <c90495fe1e786c2a9b139917b784a1dbc55a770c.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the meye documentation to rst and add it to the
media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst |   1 +
 Documentation/media/v4l-drivers/meye.rst  | 103 ++++++++++++++++--------------
 2 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 99409c6e2518..8c6f4745aa07 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -27,4 +27,5 @@ License".
 	davinci-vpbe
 	fimc
 	ivtv
+	meye
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/meye.rst b/Documentation/media/v4l-drivers/meye.rst
index a051152ea99c..cfaba6021850 100644
--- a/Documentation/media/v4l-drivers/meye.rst
+++ b/Documentation/media/v4l-drivers/meye.rst
@@ -1,8 +1,13 @@
-Vaio Picturebook Motion Eye Camera Driver Readme
-------------------------------------------------
-	Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
-	Copyright (C) 2001-2002 Alcôve <www.alcove.com>
-	Copyright (C) 2000 Andrew Tridgell <tridge@samba.org>
+.. include:: <isonum.txt>
+
+Vaio Picturebook Motion Eye Camera Driver
+=========================================
+
+Copyright |copy| 2001-2004 Stelian Pop <stelian@popies.net>
+
+Copyright |copy| 2001-2002 Alcôve <www.alcove.com>
+
+Copyright |copy| 2000 Andrew Tridgell <tridge@samba.org>
 
 This driver enable the use of video4linux compatible applications with the
 Motion Eye camera. This driver requires the "Sony Laptop Extras" driver (which
@@ -15,8 +20,8 @@ Grabbing is supported in packed YUV colorspace only.
 
 MJPEG hardware grabbing is supported via a private API (see below).
 
-Hardware supported:
--------------------
+Hardware supported
+------------------
 
 This driver supports the 'second' version of the MotionEye camera :)
 
@@ -37,26 +42,30 @@ This camera is not supported at all by the current driver, in fact
 little information if any is available for this camera
 (USB vendor/device is 0x054c/0x0107).
 
-Driver options:
----------------
+Driver options
+--------------
 
 Several options can be passed to the meye driver using the standard
 module argument syntax (<param>=<value> when passing the option to the
 module or meye.<param>=<value> on the kernel boot line when meye is
 statically linked into the kernel). Those options are:
 
+.. code-block:: none
+
 	gbuffers:	number of capture buffers, default is 2 (32 max)
 
 	gbufsize:	size of each capture buffer, default is 614400
 
 	video_nr:	video device to register (0 = /dev/video0, etc)
 
-Module use:
------------
+Module use
+----------
 
 In order to automatically load the meye module on use, you can put those lines
 in your /etc/modprobe.d/meye.conf file:
 
+.. code-block:: none
+
 	alias char-major-81 videodev
 	alias char-major-81-0 meye
 	options meye gbuffers=32
@@ -64,6 +73,8 @@ in your /etc/modprobe.d/meye.conf file:
 Usage:
 ------
 
+.. code-block:: none
+
 	xawtv >= 3.49 (<http://bytesex.org/xawtv/>)
 		for display and uncompressed video capture:
 
@@ -74,50 +85,48 @@ Usage:
 	motioneye (<http://popies.net/meye/>)
 		for getting ppm or jpg snapshots, mjpeg video
 
-Private API:
-------------
+Private API
+-----------
 
-	The driver supports frame grabbing with the video4linux API,
-	so all video4linux tools (like xawtv) should work with this driver.
+The driver supports frame grabbing with the video4linux API,
+so all video4linux tools (like xawtv) should work with this driver.
 
-	Besides the video4linux interface, the driver has a private interface
-	for accessing the Motion Eye extended parameters (camera sharpness,
-	agc, video framerate), the shapshot and the MJPEG capture facilities.
+Besides the video4linux interface, the driver has a private interface
+for accessing the Motion Eye extended parameters (camera sharpness,
+agc, video framerate), the shapshot and the MJPEG capture facilities.
 
-	This interface consists of several ioctls (prototypes and structures
-	can be found in include/linux/meye.h):
+This interface consists of several ioctls (prototypes and structures
+can be found in include/linux/meye.h):
 
-	MEYEIOC_G_PARAMS
-	MEYEIOC_S_PARAMS
-		Get and set the extended parameters of the motion eye camera.
-		The user should always query the current parameters with
-		MEYEIOC_G_PARAMS, change what he likes and then issue the
-		MEYEIOC_S_PARAMS call (checking for -EINVAL). The extended
-		parameters are described by the meye_params structure.
+MEYEIOC_G_PARAMS and MEYEIOC_S_PARAMS
+	Get and set the extended parameters of the motion eye camera.
+	The user should always query the current parameters with
+	MEYEIOC_G_PARAMS, change what he likes and then issue the
+	MEYEIOC_S_PARAMS call (checking for -EINVAL). The extended
+	parameters are described by the meye_params structure.
 
 
-	MEYEIOC_QBUF_CAPT
-		Queue a buffer for capture (the buffers must have been
-		obtained with a VIDIOCGMBUF call and mmap'ed by the
-		application). The argument to MEYEIOC_QBUF_CAPT is the
-		buffer number to queue (or -1 to end capture). The first
-		call to MEYEIOC_QBUF_CAPT starts the streaming capture.
+MEYEIOC_QBUF_CAPT
+	Queue a buffer for capture (the buffers must have been
+	obtained with a VIDIOCGMBUF call and mmap'ed by the
+	application). The argument to MEYEIOC_QBUF_CAPT is the
+	buffer number to queue (or -1 to end capture). The first
+	call to MEYEIOC_QBUF_CAPT starts the streaming capture.
 
-	MEYEIOC_SYNC
-		Takes as an argument the buffer number you want to sync.
-		This ioctl blocks until the buffer is filled and ready
-		for the application to use. It returns the buffer size.
+MEYEIOC_SYNC
+	Takes as an argument the buffer number you want to sync.
+	This ioctl blocks until the buffer is filled and ready
+	for the application to use. It returns the buffer size.
 
-	MEYEIOC_STILLCAPT
-	MEYEIOC_STILLJCAPT
-		Takes a snapshot in an uncompressed or compressed jpeg format.
-		This ioctl blocks until the snapshot is done and returns (for
-		jpeg snapshot) the size of the image. The image data is
-		available from the first mmap'ed buffer.
+MEYEIOC_STILLCAPT and MEYEIOC_STILLJCAPT
+	Takes a snapshot in an uncompressed or compressed jpeg format.
+	This ioctl blocks until the snapshot is done and returns (for
+	jpeg snapshot) the size of the image. The image data is
+	available from the first mmap'ed buffer.
 
-	Look at the 'motioneye' application code for an actual example.
+Look at the 'motioneye' application code for an actual example.
 
-Bugs / Todo:
-------------
+Bugs / Todo
+-----------
 
-	- 'motioneye' still uses the meye private v4l1 API extensions.
+- 'motioneye' still uses the meye private v4l1 API extensions.
-- 
2.7.4

