Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcGRB43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 31/36] [media] doc-rst: add soc-camera documentation
Date: Sun, 17 Jul 2016 22:56:14 -0300
Message-Id: <c0d0138255b37f362bb8559342cc0ac7da59b1be.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST format and add it at media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst      |  1 +
 Documentation/media/v4l-drivers/si476x.rst     | 12 +++++---
 Documentation/media/v4l-drivers/soc-camera.rst | 41 +++++++++++++++-----------
 3 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 3ff127195fd3..a982d73abcb6 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -38,4 +38,5 @@ License".
 	si470x
 	si4713
 	si476x
+	soc-camera
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/si476x.rst b/Documentation/media/v4l-drivers/si476x.rst
index 01a8d44425aa..d5c07bb7524d 100644
--- a/Documentation/media/v4l-drivers/si476x.rst
+++ b/Documentation/media/v4l-drivers/si476x.rst
@@ -1,9 +1,13 @@
-SI476x Driver Readme
-------------------------------------------------
-	Copyright (C) 2013 Andrey Smirnov <andrew.smirnov@gmail.com>
+.. include:: <isonum.txt>
+
+
+The SI476x Driver
+=================
+
+Copyright |copy| 2013 Andrey Smirnov <andrew.smirnov@gmail.com>
 
 TODO for the driver
-------------------------------
+-------------------
 
 - According to the SiLabs' datasheet it is possible to update the
   firmware of the radio chip in the run-time, thus bringing it to the
diff --git a/Documentation/media/v4l-drivers/soc-camera.rst b/Documentation/media/v4l-drivers/soc-camera.rst
index 84f41cf1f3e8..ba0c15dd092c 100644
--- a/Documentation/media/v4l-drivers/soc-camera.rst
+++ b/Documentation/media/v4l-drivers/soc-camera.rst
@@ -1,5 +1,7 @@
-			Soc-Camera Subsystem
-			====================
+The Soc-Camera Drivers
+======================
+
+Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 
 Terminology
 -----------
@@ -45,10 +47,14 @@ Camera host API
 
 A host camera driver is registered using the
 
-soc_camera_host_register(struct soc_camera_host *);
+.. code-block:: none
+
+	soc_camera_host_register(struct soc_camera_host *);
 
 function. The host object can be initialized as follows:
 
+.. code-block:: none
+
 	struct soc_camera_host	*ici;
 	ici->drv_name		= DRV_NAME;
 	ici->ops		= &camera_host_ops;
@@ -58,18 +64,20 @@ function. The host object can be initialized as follows:
 
 All camera host methods are passed in a struct soc_camera_host_ops:
 
-static struct soc_camera_host_ops camera_host_ops = {
-	.owner		= THIS_MODULE,
-	.add		= camera_add_device,
-	.remove		= camera_remove_device,
-	.set_fmt	= camera_set_fmt_cap,
-	.try_fmt	= camera_try_fmt_cap,
-	.init_videobuf2	= camera_init_videobuf2,
-	.poll		= camera_poll,
-	.querycap	= camera_querycap,
-	.set_bus_param	= camera_set_bus_param,
-	/* The rest of host operations are optional */
-};
+.. code-block:: none
+
+	static struct soc_camera_host_ops camera_host_ops = {
+		.owner		= THIS_MODULE,
+		.add		= camera_add_device,
+		.remove		= camera_remove_device,
+		.set_fmt	= camera_set_fmt_cap,
+		.try_fmt	= camera_try_fmt_cap,
+		.init_videobuf2	= camera_init_videobuf2,
+		.poll		= camera_poll,
+		.querycap	= camera_querycap,
+		.set_bus_param	= camera_set_bus_param,
+		/* The rest of host operations are optional */
+	};
 
 .add and .remove methods are called when a sensor is attached to or detached
 from the host. .set_bus_param is used to configure physical connection
@@ -159,6 +167,3 @@ configure camera drivers to produce the FOURCC format, requested by the user,
 using the VIDIOC_S_FMT ioctl(). Apart from those standard format conversions,
 host drivers can also provide their own conversion rules by implementing a
 .get_formats and, if required, a .put_formats methods.
-
---
-Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
-- 
2.7.4

