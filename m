Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 34/41] Documentation: dev-osd.rst: Fix some issues due to conversion
Date: Mon,  4 Jul 2016 22:31:09 -0300
Message-Id: <1818691f50582b89ebbc2a75c6d2dd993f560c2b.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion to ReST broke a minor things. Fix them.

While here, also make EBUSY constant, just like on other places.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-osd.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index 6a6ead6df54d..b9b53fd7eb5d 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -6,8 +6,8 @@
 Video Output Overlay Interface
 ******************************
 
-
 **Also known as On-Screen Display (OSD)**
+
 Some video output devices can overlay a framebuffer image onto the
 outgoing video signal. Applications can set up such an overlay using
 this interface, which borrows structures and ioctls of the
@@ -48,10 +48,11 @@ the ``linux/fb.h`` header file.
 The width and height of the framebuffer depends on the current video
 standard. A V4L2 driver may reject attempts to change the video standard
 (or any other ioctl which would imply a framebuffer size change) with an
-EBUSY error code until all applications closed the framebuffer device.
+``EBUSY`` error code until all applications closed the framebuffer device.
 
 
 .. code-block:: c
+    :caption: Example 4.1. Finding a framebuffer device for OSD
 
     #include <linux/fb.h>
 
-- 
2.7.4

