Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcGJL1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 07:27:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: Don't use captions for examples
Date: Sun, 10 Jul 2016 08:26:50 -0300
Message-Id: <6e70f993a41aaa2399affc61f3c0de4b9397c8b7.1468149968.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately, captions are new on Sphinx for c blocks: it was
added only on version 1.3. Also, it were already bad enough
not being able to auto-numerate them.

So, let's give up and use, instead, titles before the examples.
Not much is lost, and, as a side track, we don't need to
numerate them anymore.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dvbproperty.rst       |  7 ++++++-
 Documentation/media/uapi/dvb/examples.rst          |  8 ++++----
 Documentation/media/uapi/v4l/audio.rst             |  8 ++++++--
 Documentation/media/uapi/v4l/control.rst           | 11 ++++++++---
 Documentation/media/uapi/v4l/crop.rst              |  9 +++++++--
 Documentation/media/uapi/v4l/dev-osd.rst           |  3 ++-
 Documentation/media/uapi/v4l/dmabuf.rst            | 10 +++++++---
 Documentation/media/uapi/v4l/mmap.rst              |  7 +++++--
 Documentation/media/uapi/v4l/selection-api-006.rst |  9 ++++++---
 Documentation/media/uapi/v4l/standard.rst          |  9 ++++++---
 Documentation/media/uapi/v4l/userp.rst             |  3 ++-
 Documentation/media/uapi/v4l/video.rst             |  8 ++++++--
 12 files changed, 65 insertions(+), 27 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 9b3782c5bb44..3c348e585729 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -48,8 +48,13 @@ symbol rate of 5.217 Mbauds, those properties should be sent to
 
 -  :ref:`DTV_TUNE <DTV-TUNE>`
 
-The code that would do the above is:
+The code that would that would do the above is show in
+:ref:`dtv-prop-example`.
 
+.. _dtv-prop-example:
+
+Example: Setting digital TV frontend properties
+===============================================
 
 .. code-block:: c
 
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
index 64e029ecd047..ead3ddf764c0 100644
--- a/Documentation/media/uapi/dvb/examples.rst
+++ b/Documentation/media/uapi/dvb/examples.rst
@@ -17,8 +17,8 @@ updated/recommended examples.
 
 .. _tuning:
 
-Tuning
-======
+Example: Tuning
+===============
 
 We will start with a generic tuning subroutine that uses the frontend
 and SEC, as well as the demux devices. The example is given for QPSK
@@ -238,8 +238,8 @@ switch, and weather conditions this may be necessary.
 
 .. _the_dvr_device:
 
-The DVR device
-==============
+Example: The DVR device
+========================
 
 The following program code shows how to use the DVR device for
 recording.
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index 71502f0bf8bd..47f8334f071e 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -54,8 +54,10 @@ in the struct :ref:`v4l2_capability <v4l2-capability>` returned by
 the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
+Example: Information about the current audio input
+==================================================
+
 .. code-block:: c
-    :caption: Example 1.3. Information about the current audio input
 
     struct v4l2_audio audio;
 
@@ -69,8 +71,10 @@ the :ref:`VIDIOC_QUERYCAP` ioctl.
     printf("Current input: %s\\n", audio.name);
 
 
+Example: Switching to the first audio input
+===========================================
+
 .. code-block:: c
-    :caption: Example 1.4. Switching to the first audio input
 
     struct v4l2_audio audio;
 
diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
index 6cf218ab36fb..feb55ac14377 100644
--- a/Documentation/media/uapi/v4l/control.rst
+++ b/Documentation/media/uapi/v4l/control.rst
@@ -373,8 +373,10 @@ more menu type controls.
 
 .. _enum_all_controls:
 
+Example: Enumerating all user controls
+======================================
+
 .. code-block:: c
-    :caption: Example 1.8. Enumerating all user controls
 
 
     struct v4l2_queryctrl queryctrl;
@@ -438,8 +440,10 @@ more menu type controls.
     }
 
 
+Example: Enumerating all user controls (alternative)
+====================================================
+
 .. code-block:: c
-    :caption: Example 1.9. Enumerating all user controls (alternative)
 
     memset(&queryctrl, 0, sizeof(queryctrl));
 
@@ -462,9 +466,10 @@ more menu type controls.
 	exit(EXIT_FAILURE);
     }
 
+Example: Changing controls
+==========================
 
 .. code-block:: c
-    :caption: Example 1.10. Changing controls
 
     struct v4l2_queryctrl queryctrl;
     struct v4l2_control control;
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index ed43b36c51d8..bf1f487250fe 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -147,8 +147,10 @@ ensure the parameters are suitable before starting I/O.
 **NOTE:** on the next two examples, a video capture device is assumed;
 change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 
+Example: Resetting the cropping parameters
+==========================================
+
 .. code-block:: c
-    :caption: Example 1.11. Resetting the cropping parameters
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
@@ -173,8 +175,11 @@ change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 	exit (EXIT_FAILURE);
     }
 
+
+Example: Simple downscaling
+===========================
+
 .. code-block:: c
-    :caption: Example 1.12. Simple downscaling
 
     struct v4l2_cropcap cropcap;
     struct v4l2_format format;
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index b9b53fd7eb5d..98570cea63a5 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -50,9 +50,10 @@ standard. A V4L2 driver may reject attempts to change the video standard
 (or any other ioctl which would imply a framebuffer size change) with an
 ``EBUSY`` error code until all applications closed the framebuffer device.
 
+Example: Finding a framebuffer device for OSD
+---------------------------------------------
 
 .. code-block:: c
-    :caption: Example 4.1. Finding a framebuffer device for OSD
 
     #include <linux/fb.h>
 
diff --git a/Documentation/media/uapi/v4l/dmabuf.rst b/Documentation/media/uapi/v4l/dmabuf.rst
index 474d8c021507..57917fb98c7a 100644
--- a/Documentation/media/uapi/v4l/dmabuf.rst
+++ b/Documentation/media/uapi/v4l/dmabuf.rst
@@ -37,8 +37,10 @@ driver must be switched into DMABUF I/O mode by calling the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
 
 
+Example: Initiating streaming I/O with DMABUF file descriptors
+==============================================================
+
 .. code-block:: c
-    :caption: Example 3.4. Initiating streaming I/O with DMABUF file descriptors
 
     struct v4l2_requestbuffers reqbuf;
 
@@ -62,9 +64,10 @@ buffers, every plane can be associated with a different DMABUF
 descriptor. Although buffers are commonly cycled, applications can pass
 a different DMABUF descriptor at each :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` call.
 
+Example: Queueing DMABUF using single plane API
+===============================================
 
 .. code-block:: c
-    :caption: Example 3.5. Queueing DMABUF using single plane API
 
     int buffer_queue(int v4lfd, int index, int dmafd)
     {
@@ -84,9 +87,10 @@ a different DMABUF descriptor at each :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` call.
 	return 0;
     }
 
+Example 3.6. Queueing DMABUF using multi plane API
+==================================================
 
 .. code-block:: c
-    :caption: Example 3.6. Queueing DMABUF using multi plane API
 
     int buffer_queue_mp(int v4lfd, int index, int dmafd[], int n_planes)
     {
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index f7fe26e7ca43..b01f4486499a 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -52,9 +52,10 @@ allocated in physical memory, as opposed to virtual memory, which can be
 swapped out to disk. Applications should free the buffers as soon as
 possible with the :ref:`munmap() <func-munmap>` function.
 
+Example: Mapping buffers in the single-planar API
+=================================================
 
 .. code-block:: c
-    :caption: Example 3.1. Mapping buffers in the single-planar API
 
     struct v4l2_requestbuffers reqbuf;
     struct {
@@ -122,8 +123,10 @@ possible with the :ref:`munmap() <func-munmap>` function.
 	munmap(buffers[i].start, buffers[i].length);
 
 
+Example: Mapping buffers in the multi-planar API
+================================================
+
 .. code-block:: c
-    :caption: Example 3.2. Mapping buffers in the multi-planar API
 
     struct v4l2_requestbuffers reqbuf;
     /* Our current format uses 3 planes per buffer */
diff --git a/Documentation/media/uapi/v4l/selection-api-006.rst b/Documentation/media/uapi/v4l/selection-api-006.rst
index b2ac12f2e3d4..67e0e9aed9e8 100644
--- a/Documentation/media/uapi/v4l/selection-api-006.rst
+++ b/Documentation/media/uapi/v4l/selection-api-006.rst
@@ -8,9 +8,10 @@ Examples
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other devices; change target to
 ``V4L2_SEL_TGT_COMPOSE_*`` family to configure composing area)
 
+Example: Resetting the cropping parameters
+==========================================
 
 .. code-block:: c
-	:caption: Example 1.15. Resetting the cropping parameters
 
 	struct v4l2_selection sel = {
 	    .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
@@ -27,9 +28,10 @@ Examples
 Setting a composing area on output of size of *at most* half of limit
 placed at a center of a display.
 
+Example: Simple downscaling
+===========================
 
 .. code-block:: c
-   :caption: Example 1.16. Simple downscaling
 
 	struct v4l2_selection sel = {
 	    .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
@@ -55,9 +57,10 @@ placed at a center of a display.
 A video output device is assumed; change ``V4L2_BUF_TYPE_VIDEO_OUTPUT``
 for other devices
 
+Example: Querying for scaling factors
+=====================================
 
 .. code-block:: c
-   :caption: Example 1.17. Querying for scaling factors
 
 	struct v4l2_selection compose = {
 	    .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
index 538588eef317..529891cf3af2 100644
--- a/Documentation/media/uapi/v4l/standard.rst
+++ b/Documentation/media/uapi/v4l/standard.rst
@@ -64,9 +64,10 @@ Applications can make use of the :ref:`input-capabilities` and
 :ref:`output-capabilities` flags to determine whether the video
 standard ioctls can be used with the given input or output.
 
+Example: Information about the current video standard
+=====================================================
 
 .. code-block:: c
-    :caption: Example 1.5. Information about the current video standard
 
     v4l2_std_id std_id;
     struct v4l2_standard standard;
@@ -100,9 +101,10 @@ standard ioctls can be used with the given input or output.
 	exit(EXIT_FAILURE);
     }
 
+Example: Listing the video standards supported by the current input
+===================================================================
 
 .. code-block:: c
-    :caption: Example 1.6. Listing the video standards supported by the current input
 
     struct v4l2_input input;
     struct v4l2_standard standard;
@@ -139,9 +141,10 @@ standard ioctls can be used with the given input or output.
 	exit(EXIT_FAILURE);
     }
 
+Example: Selecting a new video standard
+=======================================
 
 .. code-block:: c
-    :caption: Example 1.7. Selecting a new video standard
 
     struct v4l2_input input;
     v4l2_std_id std_id;
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index 2f0002bfbc3f..0871c204dc6c 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -26,9 +26,10 @@ No buffers (planes) are allocated beforehand, consequently they are not
 indexed and cannot be queried like mapped buffers with the
 :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl.
 
+Example: Initiating streaming I/O with user pointers
+====================================================
 
 .. code-block:: c
-    :caption: Example 3.3. Initiating streaming I/O with user pointers
 
     struct v4l2_requestbuffers reqbuf;
 
diff --git a/Documentation/media/uapi/v4l/video.rst b/Documentation/media/uapi/v4l/video.rst
index e38ebe192614..d3f00715fbc1 100644
--- a/Documentation/media/uapi/v4l/video.rst
+++ b/Documentation/media/uapi/v4l/video.rst
@@ -28,8 +28,10 @@ applications call the :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` and
 implement all the input ioctls when the device has one or more inputs,
 all the output ioctls when the device has one or more outputs.
 
+Example: Information about the current video input
+==================================================
+
 .. code-block:: c
-    :caption: Example 1.1. Information about the current video input
 
     struct v4l2_input input;
     int index;
@@ -50,8 +52,10 @@ all the output ioctls when the device has one or more outputs.
     printf("Current input: %s\\n", input.name);
 
 
+Example: Switching to the first video input
+===========================================
+
 .. code-block:: c
-    :caption: Example 1.2. Switching to the first video input
 
     int index;
 
-- 
2.7.4

