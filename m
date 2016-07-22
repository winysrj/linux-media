Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 10/11] [media] doc-rst: reorganize the kAPI v4l2 chapters
Date: Fri, 22 Jul 2016 12:03:06 -0300
Message-Id: <a6276f0e39db57e6d9ff18ebb9ce907e2b8dec1d.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorganize the order of the document, putting the chapters
on a more logical order and renaming some sections.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-common.rst          |  4 ++++
 Documentation/media/kapi/v4l2-controls.rst        |  4 ++--
 Documentation/media/kapi/v4l2-core.rst            | 11 ++++++-----
 Documentation/media/kapi/v4l2-dev.rst             | 12 ++++++------
 Documentation/media/kapi/v4l2-device.rst          |  8 ++++----
 Documentation/media/kapi/v4l2-dv-timings.rst      |  4 ++--
 Documentation/media/kapi/v4l2-event.rst           |  4 ++--
 Documentation/media/kapi/v4l2-fh.rst              |  5 +++--
 Documentation/media/kapi/v4l2-flash-led-class.rst |  4 ++--
 Documentation/media/kapi/v4l2-intro.rst           | 15 ++++-----------
 Documentation/media/kapi/v4l2-mc.rst              |  4 ++--
 Documentation/media/kapi/v4l2-mediabus.rst        |  4 ++--
 Documentation/media/kapi/v4l2-mem2mem.rst         |  5 +++--
 Documentation/media/kapi/v4l2-rect.rst            |  4 ++--
 Documentation/media/kapi/v4l2-subdev.rst          | 12 ------------
 Documentation/media/kapi/v4l2-tuner.rst           |  4 ++--
 Documentation/media/kapi/v4l2-tveeprom.rst        |  4 ++--
 Documentation/media/kapi/v4l2-videobuf2.rst       |  4 ++--
 18 files changed, 50 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-common.rst

diff --git a/Documentation/media/kapi/v4l2-common.rst b/Documentation/media/kapi/v4l2-common.rst
new file mode 100644
index 000000000000..d1ea1c9e35a0
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-common.rst
@@ -0,0 +1,4 @@
+V4L2 common functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-common.h
diff --git a/Documentation/media/kapi/v4l2-controls.rst b/Documentation/media/kapi/v4l2-controls.rst
index 2d433305fd4e..07a179eeb2fb 100644
--- a/Documentation/media/kapi/v4l2-controls.rst
+++ b/Documentation/media/kapi/v4l2-controls.rst
@@ -808,7 +808,7 @@ notify function is called.
 There can be only one notify function per control handler. Any attempt
 to set another notify function will cause a WARN_ON.
 
-V4L2 control kAPI
------------------
+v4l2_ctrl functions and data structures
+---------------------------------------
 
 .. kernel-doc:: include/media/v4l2-ctrls.h
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 6285c18978d1..e9677150ed99 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -6,20 +6,21 @@ Video2Linux devices
 
     v4l2-intro
     v4l2-dev
-    v4l2-controls
     v4l2-device
     v4l2-fh
+    v4l2-subdev
+    v4l2-event
+    v4l2-controls
+    v4l2-videobuf
+    v4l2-videobuf2
     v4l2-clocks
     v4l2-dv-timings
-    v4l2-event
     v4l2-flash-led-class
     v4l2-mc
     v4l2-mediabus
     v4l2-mem2mem
     v4l2-of
     v4l2-rect
-    v4l2-subdev
     v4l2-tuner
+    v4l2-common
     v4l2-tveeprom
-    v4l2-videobuf2
-    v4l2-videobuf
diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index 306306d8a43d..b03f9b33ad93 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -1,5 +1,5 @@
-Video device creation
-=====================
+Video device' s internal representation
+=======================================
 
 The actual device nodes in the ``/dev`` directory are created using the
 :c:type:`video_device` struct (``v4l2-dev.h``). This struct can either be
@@ -309,8 +309,8 @@ it has been initialized:
 This can be done from the release callback.
 
 
-video_device helper functions
------------------------------
+helper functions
+----------------
 
 There are a few useful helper functions:
 
@@ -357,7 +357,7 @@ The name is used as a hint by userspace tools such as udev. The function
 should be used where possible instead of accessing the video_device::num and
 video_device::minor fields.
 
-video_device kAPI
------------------
+video_device functions and data structures
+------------------------------------------
 
 .. kernel-doc:: include/media/v4l2-dev.h
diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
index 8e275d0ff0f5..c9115bcd8a9d 100644
--- a/Documentation/media/kapi/v4l2-device.rst
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -1,5 +1,5 @@
-V4L2 Device register logic
---------------------------
+V4L2 device instance
+--------------------
 
 Each device instance is represented by a struct :c:type:`v4l2_device`.
 Very simple devices can just allocate this struct, but most of the time you
@@ -138,7 +138,7 @@ Since the initial refcount is 1 you also need to call
 or in the ``remove()`` callback (for e.g. PCI devices), otherwise the refcount
 will never reach 0.
 
-V4L2 device kAPI
-^^^^^^^^^^^^^^^^
+v4l2_device functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-device.h
diff --git a/Documentation/media/kapi/v4l2-dv-timings.rst b/Documentation/media/kapi/v4l2-dv-timings.rst
index 4b08a49c54a4..55274329d229 100644
--- a/Documentation/media/kapi/v4l2-dv-timings.rst
+++ b/Documentation/media/kapi/v4l2-dv-timings.rst
@@ -1,4 +1,4 @@
-V4L2 DV Timings kAPI
-^^^^^^^^^^^^^^^^^^^^
+V4L2 DV Timings functions
+^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-dv-timings.h
diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index 0aed99459732..d81bbf23b6b1 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -130,8 +130,8 @@ function with ``V4L2_DEVICE_NOTIFY_EVENT``. This allows the bridge to map
 the subdev that sends the event to the video node(s) associated with the
 subdev that need to be informed about such an event.
 
-V4L2 event kAPI
-^^^^^^^^^^^^^^^
+V4L2 event functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-event.h
 
diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
index a212698d5725..ef4ae046c0c5 100644
--- a/Documentation/media/kapi/v4l2-fh.rst
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -133,6 +133,7 @@ associated device node:
 - Same, but it calls v4l2_fh_is_singular with filp->private_data.
 
 
-V4L2 File Handler kAPI
-^^^^^^^^^^^^^^^^^^^^^^
+V4L2 fh functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
 .. kernel-doc:: include/media/v4l2-fh.h
diff --git a/Documentation/media/kapi/v4l2-flash-led-class.rst b/Documentation/media/kapi/v4l2-flash-led-class.rst
index 251ed6b3aab3..20798bdac387 100644
--- a/Documentation/media/kapi/v4l2-flash-led-class.rst
+++ b/Documentation/media/kapi/v4l2-flash-led-class.rst
@@ -1,4 +1,4 @@
-V4L2 Flash and LED class kAPI
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+V4L2 flash functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-flash-led-class.h
diff --git a/Documentation/media/kapi/v4l2-intro.rst b/Documentation/media/kapi/v4l2-intro.rst
index 7f4f26e666a2..e614d8d4ca1c 100644
--- a/Documentation/media/kapi/v4l2-intro.rst
+++ b/Documentation/media/kapi/v4l2-intro.rst
@@ -1,10 +1,3 @@
-Overview of the V4L2 driver framework
-=====================================
-
-This text documents the various structures provided by the V4L2 framework and
-their relationships.
-
-
 Introduction
 ------------
 
@@ -39,8 +32,8 @@ source that is available in samples/v4l/. It is a skeleton driver for
 a PCI capture card, and demonstrates how to use the V4L2 driver
 framework. It can be used as a template for real PCI video capture driver.
 
-Structure of a driver
----------------------
+Structure of a V4L driver
+-------------------------
 
 All drivers have the following structure:
 
@@ -68,8 +61,8 @@ This is a rough schematic of how it all relates:
 	  \-filehandle instances
 
 
-Structure of the framework
---------------------------
+Structure of the V4L2 framework
+-------------------------------
 
 The framework closely resembles the driver structure: it has a v4l2_device
 struct for the device instance data, a v4l2_subdev struct to refer to
diff --git a/Documentation/media/kapi/v4l2-mc.rst b/Documentation/media/kapi/v4l2-mc.rst
index c94ce0fa3839..8af347013490 100644
--- a/Documentation/media/kapi/v4l2-mc.rst
+++ b/Documentation/media/kapi/v4l2-mc.rst
@@ -1,4 +1,4 @@
-V4L2 Media Controller kAPI
-^^^^^^^^^^^^^^^^^^^^^^^^^^
+V4L2 Media Controller functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-mc.h
diff --git a/Documentation/media/kapi/v4l2-mediabus.rst b/Documentation/media/kapi/v4l2-mediabus.rst
index b3c246b51c2c..e64131906d11 100644
--- a/Documentation/media/kapi/v4l2-mediabus.rst
+++ b/Documentation/media/kapi/v4l2-mediabus.rst
@@ -1,4 +1,4 @@
-V4L2 Media Bus kAPI
-^^^^^^^^^^^^^^^^^^^
+V4L2 Media Bus functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-mediabus.h
diff --git a/Documentation/media/kapi/v4l2-mem2mem.rst b/Documentation/media/kapi/v4l2-mem2mem.rst
index 61f9923286c7..5536b4a71e51 100644
--- a/Documentation/media/kapi/v4l2-mem2mem.rst
+++ b/Documentation/media/kapi/v4l2-mem2mem.rst
@@ -1,3 +1,4 @@
-V4L2 Memory to Memory kAPI
-^^^^^^^^^^^^^^^^^^^^^^^^^^
+V4L2 Memory to Memory functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
 .. kernel-doc:: include/media/v4l2-mem2mem.h
diff --git a/Documentation/media/kapi/v4l2-rect.rst b/Documentation/media/kapi/v4l2-rect.rst
index bb86dcbc5a3c..8df5067ad57d 100644
--- a/Documentation/media/kapi/v4l2-rect.rst
+++ b/Documentation/media/kapi/v4l2-rect.rst
@@ -1,4 +1,4 @@
-V4L2 rect kAPI
-^^^^^^^^^^^^^^
+V4L2 rect helper functions
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-rect.h
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 456fdec69042..7e45b23ad3bd 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -440,18 +440,6 @@ well, but with irq set to 0 and platform_data set to ``NULL``.
 V4L2 sub-device functions and data structures
 ---------------------------------------------
 
-V4L2 sub-device kAPI
-^^^^^^^^^^^^^^^^^^^^
-
 .. kernel-doc:: include/media/v4l2-subdev.h
 
-V4L2 sub-device asynchronous kAPI
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-
 .. kernel-doc:: include/media/v4l2-async.h
-
-
-V4L2 common kAPI
-^^^^^^^^^^^^^^^^
-
-.. kernel-doc:: include/media/v4l2-common.h
diff --git a/Documentation/media/kapi/v4l2-tuner.rst b/Documentation/media/kapi/v4l2-tuner.rst
index 37b0ef310a62..86e894639651 100644
--- a/Documentation/media/kapi/v4l2-tuner.rst
+++ b/Documentation/media/kapi/v4l2-tuner.rst
@@ -1,5 +1,5 @@
-Tuner kAPI
-^^^^^^^^^^
+Tuner functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/tuner.h
 
diff --git a/Documentation/media/kapi/v4l2-tveeprom.rst b/Documentation/media/kapi/v4l2-tveeprom.rst
index f7ef71742e93..33422cb26aa7 100644
--- a/Documentation/media/kapi/v4l2-tveeprom.rst
+++ b/Documentation/media/kapi/v4l2-tveeprom.rst
@@ -1,4 +1,4 @@
-Hauppauge TV EEPROM kAPI
-^^^^^^^^^^^^^^^^^^^^^^^^
+Hauppauge TV EEPROM functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/tveeprom.h
diff --git a/Documentation/media/kapi/v4l2-videobuf2.rst b/Documentation/media/kapi/v4l2-videobuf2.rst
index bdb8b83f1ea0..3c4cb1e7e05f 100644
--- a/Documentation/media/kapi/v4l2-videobuf2.rst
+++ b/Documentation/media/kapi/v4l2-videobuf2.rst
@@ -1,7 +1,7 @@
 .. _vb2_framework:
 
-V4L2 videobuf2 kAPI
-^^^^^^^^^^^^^^^^^^^
+V4L2 videobuf2 functions and data structures
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/videobuf2-core.h
 
-- 
2.7.4

