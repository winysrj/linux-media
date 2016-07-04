Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 26/51] Documentation: linux_tv: use Example x.y. instead of a single number
Date: Mon,  4 Jul 2016 08:46:47 -0300
Message-Id: <a7366d84e8a699b297bece688004d6ed20bf84db.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the example captions, use always <chapter>.<number>., because:
1) it matches the DocBook;
2) it would mean less changes if we need to add a new example,
as only one chapter will be affected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/audio.rst    | 4 ++--
 Documentation/linux_tv/media/v4l/control.rst  | 6 +++---
 Documentation/linux_tv/media/v4l/crop.rst     | 8 ++++----
 Documentation/linux_tv/media/v4l/standard.rst | 6 +++---
 Documentation/linux_tv/media/v4l/video.rst    | 4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index e9d99f6a259a..bc2db0d8f389 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -55,7 +55,7 @@ the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
 .. code-block:: c
-    :caption: Example 3: Information about the current audio input
+    :caption: Example 1.3. Information about the current audio input
 
     struct v4l2_audio audio;
 
@@ -70,7 +70,7 @@ the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
 .. code-block:: c
-    :caption: Example 4: Switching to the first audio input
+    :caption: Example 1.4. Switching to the first audio input
 
     struct v4l2_audio audio;
 
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index 736d79080229..4f64f1db6ec8 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -374,7 +374,7 @@ more menu type controls.
 .. _enum_all_controls:
 
 .. code-block:: c
-    :caption: Example 8: Enumerating all user controls
+    :caption: Example 1.8. Enumerating all user controls
 
 
     struct v4l2_queryctrl queryctrl;
@@ -439,7 +439,7 @@ more menu type controls.
 
 
 .. code-block:: c
-    :caption: Example 9: Enumerating all user controls (alternative)
+    :caption: Example 1.9. Enumerating all user controls (alternative)
 
     memset(&queryctrl, 0, sizeof(queryctrl));
 
@@ -464,7 +464,7 @@ more menu type controls.
 
 
 .. code-block:: c
-    :caption: Example 10: Changing controls
+    :caption: Example 1.10. Changing controls
 
     struct v4l2_queryctrl queryctrl;
     struct v4l2_control control;
diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/linux_tv/media/v4l/crop.rst
index e1214d85b9c7..16d0983ff9fb 100644
--- a/Documentation/linux_tv/media/v4l/crop.rst
+++ b/Documentation/linux_tv/media/v4l/crop.rst
@@ -148,7 +148,7 @@ ensure the parameters are suitable before starting I/O.
 change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 
 .. code-block:: c
-    :caption: Example 11: Resetting the cropping parameters
+    :caption: Example 1.11. Resetting the cropping parameters
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
@@ -174,7 +174,7 @@ change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
     }
 
 .. code-block:: c
-    :caption: Example 12: Simple downscaling
+    :caption: Example 1.12. Simple downscaling
 
     struct v4l2_cropcap cropcap;
     struct v4l2_format format;
@@ -202,7 +202,7 @@ change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 **NOTE:** This example assumes an output device.
 
 .. code-block:: c
-    :caption: Example 13. Selecting an output area
+    :caption: Example 1.13. Selecting an output area
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
@@ -239,7 +239,7 @@ change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 **NOTE:** This example assumes a video capture device.
 
 .. code-block:: c
-    :caption: Example 14: Current scaling factor and pixel aspect
+    :caption: Example 1.14. Current scaling factor and pixel aspect
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index 11d1a7183c73..4131ca880268 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -66,7 +66,7 @@ standard ioctls can be used with the given input or output.
 
 
 .. code-block:: c
-    :caption: Example 5: Information about the current video standard
+    :caption: Example 1.5. Information about the current video standard
 
     v4l2_std_id std_id;
     struct v4l2_standard standard;
@@ -102,7 +102,7 @@ standard ioctls can be used with the given input or output.
 
 
 .. code-block:: c
-    :caption: Example 6: Listing the video standards supported by the current input
+    :caption: Example 1.6. Listing the video standards supported by the current input
 
     struct v4l2_input input;
     struct v4l2_standard standard;
@@ -141,7 +141,7 @@ standard ioctls can be used with the given input or output.
 
 
 .. code-block:: c
-    :caption: Example 7: Selecting a new video standard
+    :caption: Example 1.7. Selecting a new video standard
 
     struct v4l2_input input;
     v4l2_std_id std_id;
diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index 8e10ecc27123..b8ecc774719c 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -29,7 +29,7 @@ implement all the input ioctls when the device has one or more inputs,
 all the output ioctls when the device has one or more outputs.
 
 .. code-block:: c
-    :caption: Example 1: Information about the current video input
+    :caption: Example 1.1. Information about the current video input
 
     struct v4l2_input input;
     int index;
@@ -51,7 +51,7 @@ all the output ioctls when the device has one or more outputs.
 
 
 .. code-block:: c
-    :caption: Example 2: Switching to the first video input
+    :caption: Example 1.2. Switching to the first video input
 
     int index;
 
-- 
2.7.4


