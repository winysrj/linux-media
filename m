Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Vladimir Zapolskiy <vz@mleia.com>, linux-doc@vger.kernel.org
Subject: [PATCH 02/12] [media] doc-rst: Split v4l-core into one file per kAPI
Date: Thu, 21 Jul 2016 17:18:07 -0300
Message-Id: <30398d4d860090a41a1472563a58c3e46c513949.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx produce a 1:1 mapping between a rst file and an html file.

So, we need to split the kernel-doc tags on multiple documents.

A side effect is that we're now having a better name for each
section of the kAPI documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-async.rst            |  4 ++
 Documentation/media/kapi/v4l2-controls.rst         |  5 ++
 Documentation/media/kapi/v4l2-core.rst             | 55 ++++++++--------------
 Documentation/media/kapi/v4l2-device.rst           |  4 ++
 Documentation/media/kapi/v4l2-dv-timings.rst       |  4 ++
 Documentation/media/kapi/v4l2-event.rst            |  5 ++
 Documentation/media/kapi/v4l2-flash-led-class.rst  |  4 ++
 Documentation/media/kapi/v4l2-mc.rst               |  4 ++
 Documentation/media/kapi/v4l2-mediabus.rst         |  4 ++
 Documentation/media/kapi/v4l2-mem2mem.rst          |  3 ++
 Documentation/media/kapi/v4l2-of.rst               |  3 ++
 Documentation/media/kapi/v4l2-rect.rst             |  4 ++
 Documentation/media/kapi/v4l2-subdev.rst           |  4 ++
 Documentation/media/kapi/v4l2-tuner.rst            |  6 +++
 Documentation/media/kapi/v4l2-tveeprom.rst         |  4 ++
 .../media/kapi/{videobuf.rst => v4l2-videobuf.rst} |  0
 Documentation/media/kapi/v4l2-videobuf2.rst        |  8 ++++
 Documentation/media/media_kapi.rst                 |  3 --
 18 files changed, 86 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-async.rst
 create mode 100644 Documentation/media/kapi/v4l2-device.rst
 create mode 100644 Documentation/media/kapi/v4l2-dv-timings.rst
 create mode 100644 Documentation/media/kapi/v4l2-event.rst
 create mode 100644 Documentation/media/kapi/v4l2-flash-led-class.rst
 create mode 100644 Documentation/media/kapi/v4l2-mc.rst
 create mode 100644 Documentation/media/kapi/v4l2-mediabus.rst
 create mode 100644 Documentation/media/kapi/v4l2-mem2mem.rst
 create mode 100644 Documentation/media/kapi/v4l2-of.rst
 create mode 100644 Documentation/media/kapi/v4l2-rect.rst
 create mode 100644 Documentation/media/kapi/v4l2-subdev.rst
 create mode 100644 Documentation/media/kapi/v4l2-tuner.rst
 create mode 100644 Documentation/media/kapi/v4l2-tveeprom.rst
 rename Documentation/media/kapi/{videobuf.rst => v4l2-videobuf.rst} (100%)
 create mode 100644 Documentation/media/kapi/v4l2-videobuf2.rst

diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/media/kapi/v4l2-async.rst
new file mode 100644
index 000000000000..372aa29fbf29
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-async.rst
@@ -0,0 +1,4 @@
+V4L2 Async kAPI
+^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-async.h
diff --git a/Documentation/media/kapi/v4l2-controls.rst b/Documentation/media/kapi/v4l2-controls.rst
index 8ff9ee806042..58b6b3d74ca7 100644
--- a/Documentation/media/kapi/v4l2-controls.rst
+++ b/Documentation/media/kapi/v4l2-controls.rst
@@ -824,3 +824,8 @@ notify function is called.
 
 There can be only one notify function per control handler. Any attempt
 to set another notify function will cause a WARN_ON.
+
+V4L2 control kAPI
+-----------------
+
+.. kernel-doc:: include/media/v4l2-ctrls.h
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index db571a4f498a..8c127ccdb0ae 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -1,38 +1,23 @@
 Video2Linux devices
 -------------------
 
-.. kernel-doc:: include/media/tuner.h
-
-.. kernel-doc:: include/media/tuner-types.h
-
-.. kernel-doc:: include/media/tveeprom.h
-
-.. kernel-doc:: include/media/v4l2-async.h
-
-.. kernel-doc:: include/media/v4l2-ctrls.h
-
-.. kernel-doc:: include/media/v4l2-device.h
-
-.. kernel-doc:: include/media/v4l2-dv-timings.h
-
-.. kernel-doc:: include/media/v4l2-event.h
-
-.. kernel-doc:: include/media/v4l2-flash-led-class.h
-
-.. kernel-doc:: include/media/v4l2-mc.h
-
-.. kernel-doc:: include/media/v4l2-mediabus.h
-
-.. kernel-doc:: include/media/v4l2-mem2mem.h
-
-.. kernel-doc:: include/media/v4l2-of.h
-
-.. kernel-doc:: include/media/v4l2-rect.h
-
-.. kernel-doc:: include/media/v4l2-subdev.h
-
-.. kernel-doc:: include/media/videobuf2-core.h
-
-.. kernel-doc:: include/media/videobuf2-v4l2.h
-
-.. kernel-doc:: include/media/videobuf2-memops.h
+.. toctree::
+    :maxdepth: 1
+
+    v4l2-framework
+    v4l2-async
+    v4l2-controls
+    v4l2-device
+    v4l2-dv-timings
+    v4l2-event
+    v4l2-flash-led-class
+    v4l2-mc
+    v4l2-mediabus
+    v4l2-mem2mem
+    v4l2-of
+    v4l2-rect
+    v4l2-subdev
+    v4l2-tuner
+    v4l2-tveeprom
+    v4l2-videobuf2
+    v4l2-videobuf
diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
new file mode 100644
index 000000000000..e324fbcb0353
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -0,0 +1,4 @@
+V4L2 Device kAPI
+^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-device.h
diff --git a/Documentation/media/kapi/v4l2-dv-timings.rst b/Documentation/media/kapi/v4l2-dv-timings.rst
new file mode 100644
index 000000000000..4b08a49c54a4
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-dv-timings.rst
@@ -0,0 +1,4 @@
+V4L2 DV Timings kAPI
+^^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-dv-timings.h
diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
new file mode 100644
index 000000000000..6ac94efc07bf
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -0,0 +1,5 @@
+V4L2 event kAPI
+^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-event.h
+
diff --git a/Documentation/media/kapi/v4l2-flash-led-class.rst b/Documentation/media/kapi/v4l2-flash-led-class.rst
new file mode 100644
index 000000000000..251ed6b3aab3
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-flash-led-class.rst
@@ -0,0 +1,4 @@
+V4L2 Flash and LED class kAPI
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-flash-led-class.h
diff --git a/Documentation/media/kapi/v4l2-mc.rst b/Documentation/media/kapi/v4l2-mc.rst
new file mode 100644
index 000000000000..c94ce0fa3839
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-mc.rst
@@ -0,0 +1,4 @@
+V4L2 Media Controller kAPI
+^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-mc.h
diff --git a/Documentation/media/kapi/v4l2-mediabus.rst b/Documentation/media/kapi/v4l2-mediabus.rst
new file mode 100644
index 000000000000..b3c246b51c2c
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-mediabus.rst
@@ -0,0 +1,4 @@
+V4L2 Media Bus kAPI
+^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-mediabus.h
diff --git a/Documentation/media/kapi/v4l2-mem2mem.rst b/Documentation/media/kapi/v4l2-mem2mem.rst
new file mode 100644
index 000000000000..61f9923286c7
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-mem2mem.rst
@@ -0,0 +1,3 @@
+V4L2 Memory to Memory kAPI
+^^^^^^^^^^^^^^^^^^^^^^^^^^
+.. kernel-doc:: include/media/v4l2-mem2mem.h
diff --git a/Documentation/media/kapi/v4l2-of.rst b/Documentation/media/kapi/v4l2-of.rst
new file mode 100644
index 000000000000..1ddf76b00944
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-of.rst
@@ -0,0 +1,3 @@
+V4L2 Open Firmware kAPI
+^^^^^^^^^^^^^^^^^^^^^^^
+.. kernel-doc:: include/media/v4l2-of.h
diff --git a/Documentation/media/kapi/v4l2-rect.rst b/Documentation/media/kapi/v4l2-rect.rst
new file mode 100644
index 000000000000..bb86dcbc5a3c
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-rect.rst
@@ -0,0 +1,4 @@
+V4L2 rect kAPI
+^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-rect.h
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
new file mode 100644
index 000000000000..1b262aa7e250
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -0,0 +1,4 @@
+V4L2 subdev kAPI
+^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-subdev.h
diff --git a/Documentation/media/kapi/v4l2-tuner.rst b/Documentation/media/kapi/v4l2-tuner.rst
new file mode 100644
index 000000000000..37b0ef310a62
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-tuner.rst
@@ -0,0 +1,6 @@
+Tuner kAPI
+^^^^^^^^^^
+
+.. kernel-doc:: include/media/tuner.h
+
+.. kernel-doc:: include/media/tuner-types.h
diff --git a/Documentation/media/kapi/v4l2-tveeprom.rst b/Documentation/media/kapi/v4l2-tveeprom.rst
new file mode 100644
index 000000000000..f7ef71742e93
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-tveeprom.rst
@@ -0,0 +1,4 @@
+Hauppauge TV EEPROM kAPI
+^^^^^^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/tveeprom.h
diff --git a/Documentation/media/kapi/videobuf.rst b/Documentation/media/kapi/v4l2-videobuf.rst
similarity index 100%
rename from Documentation/media/kapi/videobuf.rst
rename to Documentation/media/kapi/v4l2-videobuf.rst
diff --git a/Documentation/media/kapi/v4l2-videobuf2.rst b/Documentation/media/kapi/v4l2-videobuf2.rst
new file mode 100644
index 000000000000..b4f2d6983ef3
--- /dev/null
+++ b/Documentation/media/kapi/v4l2-videobuf2.rst
@@ -0,0 +1,8 @@
+V4L2 videobuf2 kAPI
+^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/videobuf2-core.h
+
+.. kernel-doc:: include/media/videobuf2-v4l2.h
+
+.. kernel-doc:: include/media/videobuf2-memops.h
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index 431fc3e43d6a..b71e8e8048ca 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -28,9 +28,6 @@ For more details see the file COPYING in the source distribution of Linux.
     :maxdepth: 5
     :numbered:
 
-    kapi/v4l2-framework
-    kapi/v4l2-controls
-    kapi/videobuf
     kapi/v4l2-core
     kapi/dtv-core
     kapi/rc-core
-- 
2.7.4

