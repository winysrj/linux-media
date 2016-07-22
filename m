Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 08/11] [media] move V4L2 clocks to a separate .rst file
Date: Fri, 22 Jul 2016 12:03:04 -0300
Message-Id: <90d60bf5fdb9e327c89ae7ddcce27d3a0bc23d57.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the v4l2 clocks stuff from v4l2-framework to a separate
file and adds an attention that came from the v4l2-clk.h.

Note: as this is meant to be a temporary kAPI, and it is
used only by two drivers (soc_camera and em28xx), where
the first one is in deprecation process, it probably not
a worth effort to document its header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-clocks.rst    | 29 +++++++++++++++++++++++++++++
 Documentation/media/kapi/v4l2-core.rst      |  1 +
 Documentation/media/kapi/v4l2-framework.rst | 25 -------------------------
 3 files changed, 30 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-clocks.rst

diff --git a/Documentation/media/kapi/v4l2-clocks.rst b/Documentation/media/kapi/v4l2-clocks.rst
new file mode 100644
index 000000000000..b8a895860a8a
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-clocks.rst
@@ -0,0 +1,29 @@
+V4L2 clocks
+-----------
+
+.. attention::
+
+	This is a temporary API and it shall be replaced by the generic
+	clock API, when the latter becomes widely available.
+
+Many subdevices, like camera sensors, TV decoders and encoders, need a clock
+signal to be supplied by the system. Often this clock is supplied by the
+respective bridge device. The Linux kernel provides a Common Clock Framework for
+this purpose. However, it is not (yet) available on all architectures. Besides,
+the nature of the multi-functional (clock, data + synchronisation, I2C control)
+connection of subdevices to the system might impose special requirements on the
+clock API usage. E.g. V4L2 has to support clock provider driver unregistration
+while a subdevice driver is holding a reference to the clock. For these reasons
+a V4L2 clock helper API has been developed and is provided to bridge and
+subdevice drivers.
+
+The API consists of two parts: two functions to register and unregister a V4L2
+clock source: v4l2_clk_register() and v4l2_clk_unregister() and calls to control
+a clock object, similar to the respective generic clock API calls:
+v4l2_clk_get(), v4l2_clk_put(), v4l2_clk_enable(), v4l2_clk_disable(),
+v4l2_clk_get_rate(), and v4l2_clk_set_rate(). Clock suppliers have to provide
+clock operations that will be called when clock users invoke respective API
+methods.
+
+It is expected that once the CCF becomes available on all relevant
+architectures this API will be removed.
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 67eaf0c0b6b6..c69d167bce7a 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -9,6 +9,7 @@ Video2Linux devices
     v4l2-controls
     v4l2-device
     v4l2-fh
+    v4l2-clocks
     v4l2-dv-timings
     v4l2-event
     v4l2-flash-led-class
diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-framework.rst
index 8b4f684e1a7a..7f4f26e666a2 100644
--- a/Documentation/media/kapi/v4l2-framework.rst
+++ b/Documentation/media/kapi/v4l2-framework.rst
@@ -79,28 +79,3 @@ and the v4l2_fh struct keeps track of filehandle instances.
 The V4L2 framework also optionally integrates with the media framework. If a
 driver sets the struct v4l2_device mdev field, sub-devices and video nodes
 will automatically appear in the media framework as entities.
-
-V4L2 clocks
------------
-
-Many subdevices, like camera sensors, TV decoders and encoders, need a clock
-signal to be supplied by the system. Often this clock is supplied by the
-respective bridge device. The Linux kernel provides a Common Clock Framework for
-this purpose. However, it is not (yet) available on all architectures. Besides,
-the nature of the multi-functional (clock, data + synchronisation, I2C control)
-connection of subdevices to the system might impose special requirements on the
-clock API usage. E.g. V4L2 has to support clock provider driver unregistration
-while a subdevice driver is holding a reference to the clock. For these reasons
-a V4L2 clock helper API has been developed and is provided to bridge and
-subdevice drivers.
-
-The API consists of two parts: two functions to register and unregister a V4L2
-clock source: v4l2_clk_register() and v4l2_clk_unregister() and calls to control
-a clock object, similar to the respective generic clock API calls:
-v4l2_clk_get(), v4l2_clk_put(), v4l2_clk_enable(), v4l2_clk_disable(),
-v4l2_clk_get_rate(), and v4l2_clk_set_rate(). Clock suppliers have to provide
-clock operations that will be called when clock users invoke respective API
-methods.
-
-It is expected that once the CCF becomes available on all relevant
-architectures this API will be removed.
-- 
2.7.4

