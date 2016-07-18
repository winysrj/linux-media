Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:50137 "EHLO
	avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbcGRVUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 17:20:00 -0400
From: y@shmanahar.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH] Documentation: add support for V4L touch devices
Date: Mon, 18 Jul 2016 22:11:52 +0100
Message-Id: <1468876312-24688-1-git-send-email-y>
In-Reply-To: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nick Dyer <nick@shmanahar.org>

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 Documentation/media/uapi/mediactl/media-types.rst |   24 +++--
 Documentation/media/uapi/v4l/dev-touch.rst        |   55 ++++++++++
 Documentation/media/uapi/v4l/devices.rst          |    1 +
 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst  |   80 +++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst  |  111 +++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst  |   78 +++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst  |  110 ++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt.rst           |    1 +
 Documentation/media/uapi/v4l/tch-formats.rst      |   18 ++++
 9 files changed, 471 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-touch.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
 create mode 100644 Documentation/media/uapi/v4l/tch-formats.rst

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index c77717b..0265edc 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -429,6 +429,16 @@ Types and flags used to represent the media graph elements
 
     -  .. row 11
 
+       ..  _MEDIA-INTF-T-V4L-TOUCH:
+
+       -  ``MEDIA_INTF_T_V4L_TOUCH``
+
+       -  Device node interface for Touch device (V4L)
+
+       -  typically, /dev/v4l-touch?
+
+    -  .. row 12
+
        ..  _MEDIA-INTF-T-ALSA-PCM-CAPTURE:
 
        -  ``MEDIA_INTF_T_ALSA_PCM_CAPTURE``
@@ -437,7 +447,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/pcmC?D?c
 
-    -  .. row 12
+    -  .. row 13
 
        ..  _MEDIA-INTF-T-ALSA-PCM-PLAYBACK:
 
@@ -447,7 +457,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/pcmC?D?p
 
-    -  .. row 13
+    -  .. row 14
 
        ..  _MEDIA-INTF-T-ALSA-CONTROL:
 
@@ -457,7 +467,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/controlC?
 
-    -  .. row 14
+    -  .. row 15
 
        ..  _MEDIA-INTF-T-ALSA-COMPRESS:
 
@@ -467,7 +477,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/compr?
 
-    -  .. row 15
+    -  .. row 16
 
        ..  _MEDIA-INTF-T-ALSA-RAWMIDI:
 
@@ -477,7 +487,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/midi?
 
-    -  .. row 16
+    -  .. row 17
 
        ..  _MEDIA-INTF-T-ALSA-HWDEP:
 
@@ -487,7 +497,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/hwC?D?
 
-    -  .. row 17
+    -  .. row 18
 
        ..  _MEDIA-INTF-T-ALSA-SEQUENCER:
 
@@ -497,7 +507,7 @@ Types and flags used to represent the media graph elements
 
        -  typically, /dev/snd/seq
 
-    -  .. row 18
+    -  .. row 19
 
        ..  _MEDIA-INTF-T-ALSA-TIMER:
 
diff --git a/Documentation/media/uapi/v4l/dev-touch.rst b/Documentation/media/uapi/v4l/dev-touch.rst
new file mode 100644
index 0000000..5c71ee9
--- /dev/null
+++ b/Documentation/media/uapi/v4l/dev-touch.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _touch:
+
+*************
+Touch Devices
+*************
+
+Touch devices are accessed through character device special files named
+``/dev/v4l-touch0`` to ``/dev/v4l-touch255`` with major number 81 and
+dynamically allocated minor numbers 0 to 255.
+
+Overview
+========
+
+Sensors may be Optical, or Projected Capacitive touch (PCT).
+
+Processing is required to analyse the raw data and produce input events. In
+some systems, this may be performed on the ASIC and the raw data is purely a
+side-channel for diagnostics or tuning. In other systems, the ASIC is a simple
+analogue front end device which delivers touch data at high rate, and any touch
+processing must be done on the host.
+
+For capacitive touch sensing, the touchscreen is composed of an array of
+horizontal and vertical conductors (alternatively called rows/columns, X/Y
+lines, or tx/rx). Mutual Capacitance measured is at the nodes where the
+conductors cross. Alternatively, Self Capacitance measures the signal from each
+column and row independently.
+
+A touch input may be determined by comparing the raw capacitance measurement to
+a no-touch reference (or "baseline") measurement:
+
+Delta = Raw - Reference
+
+The reference measurement takes account of variations in the capacitance across
+the touch sensor matrix, for example manufacturing irregularities,
+environmental or edge effects.
+
+Querying Capabilities
+=====================
+
+Devices supporting the touch interface set the ``V4L2_CAP_VIDEO_CAPTURE`` flag
+in the ``capabilities`` field of :ref:`v4l2_capability <v4l2-capability>`
+returned by the :ref:`VIDIOC_QUERYCAP` ioctl.
+
+At least one of the read/write or streaming I/O methods must be
+supported.
+
+The formats supported by touch devices are documented in
+:ref:`Touch Formats <tch-formats>`.
+
+Data Format Negotiation
+=======================
+
+A touch device may support any I/O method.
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index aed0ce1..5c3d6c2 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -22,5 +22,6 @@ Interfaces
     dev-radio
     dev-rds
     dev-sdr
+    dev-touch
     dev-event
     dev-subdev
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst b/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
new file mode 100644
index 0000000..e1d1b75
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
@@ -0,0 +1,80 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-TCH-FMT-DELTA-TD08:
+
+********************************
+V4L2_TCH_FMT_DELTA_TD08 ('TD08')
+********************************
+
+*man V4L2_TCH_FMT_DELTA_TD08(2)*
+
+8-bit signed Touch Delta
+
+Description
+===========
+
+This format represents delta data from a touch controller.
+
+Delta values may range from -128 to 127. Typically the values will vary through
+a small range depending on whether the sensor is touched or not. The full value
+may be seen if one of the touchscreen nodes has a fault or the line is not
+connected.
+
+**Byte Order.**
+Each cell is one byte.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1
+
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  D'\ :sub:`00`
+
+       -  D'\ :sub:`01`
+
+       -  D'\ :sub:`02`
+
+       -  D'\ :sub:`03`
+
+    -  .. row 2
+
+       -  start + 4:
+
+       -  D'\ :sub:`10`
+
+       -  D'\ :sub:`11`
+
+       -  D'\ :sub:`12`
+
+       -  D'\ :sub:`13`
+
+    -  .. row 3
+
+       -  start + 8:
+
+       -  D'\ :sub:`20`
+
+       -  D'\ :sub:`21`
+
+       -  D'\ :sub:`22`
+
+       -  D'\ :sub:`23`
+
+    -  .. row 4
+
+       -  start + 12:
+
+       -  D'\ :sub:`30`
+
+       -  D'\ :sub:`31`
+
+       -  D'\ :sub:`32`
+
+       -  D'\ :sub:`33`
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst b/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
new file mode 100644
index 0000000..dfbbc40
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
@@ -0,0 +1,111 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-TCH-FMT-DELTA-TD16:
+
+********************************
+V4L2_TCH_FMT_DELTA_TD16 ('TD16')
+********************************
+
+*man V4L2_TCH_FMT_DELTA_TD16(2)*
+
+16-bit signed Touch Delta
+
+
+Description
+===========
+
+This format represents delta data from a touch controller.
+
+Delta values may range from -32768 to 32767. Typically the values will vary
+through a small range depending on whether the sensor is touched or not. The
+full value may be seen if one of the touchscreen nodes has a fault or the line
+is not connected.
+
+**Byte Order.**
+Each cell is one byte.
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1 1 1 1 1
+
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  D'\ :sub:`00high`
+
+       -  D'\ :sub:`00low`
+
+       -  D'\ :sub:`01high`
+
+       -  D'\ :sub:`01low`
+
+       -  D'\ :sub:`02high`
+
+       -  D'\ :sub:`02low`
+
+       -  D'\ :sub:`03high`
+
+       -  D'\ :sub:`03low`
+
+    -  .. row 2
+
+       -  start + 8:
+
+       -  D'\ :sub:`10high`
+
+       -  D'\ :sub:`10low`
+
+       -  D'\ :sub:`11high`
+
+       -  D'\ :sub:`11low`
+
+       -  D'\ :sub:`12high`
+
+       -  D'\ :sub:`12low`
+
+       -  D'\ :sub:`13high`
+
+       -  D'\ :sub:`13low`
+
+    -  .. row 3
+
+       -  start + 16:
+
+       -  D'\ :sub:`20high`
+
+       -  D'\ :sub:`20low`
+
+       -  D'\ :sub:`21high`
+
+       -  D'\ :sub:`21low`
+
+       -  D'\ :sub:`22high`
+
+       -  D'\ :sub:`22low`
+
+       -  D'\ :sub:`23high`
+
+       -  D'\ :sub:`23low`
+
+    -  .. row 4
+
+       -  start + 24:
+
+       -  D'\ :sub:`30high`
+
+       -  D'\ :sub:`30low`
+
+       -  D'\ :sub:`31high`
+
+       -  D'\ :sub:`31low`
+
+       -  D'\ :sub:`32high`
+
+       -  D'\ :sub:`32low`
+
+       -  D'\ :sub:`33high`
+
+       -  D'\ :sub:`33low`
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst b/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
new file mode 100644
index 0000000..32e21f8
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
@@ -0,0 +1,78 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-TCH-FMT-DELTA-TU08:
+
+**************************
+V4L2_TCH_FMT_DELTA_TU08 ('TU08')
+**************************
+
+*man V4L2_TCH_FMT_DELTA_TU08(2)*
+
+8-bit unsigned raw touch data
+
+Description
+===========
+
+This format represents unsigned 8-bit data from a touch controller.
+
+This may be used for output for raw and reference data. Values may range from
+0 to 255.
+
+**Byte Order.**
+Each cell is one byte.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1
+
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  R'\ :sub:`00`
+
+       -  R'\ :sub:`01`
+
+       -  R'\ :sub:`02`
+
+       -  R'\ :sub:`03`
+
+    -  .. row 2
+
+       -  start + 4:
+
+       -  R'\ :sub:`10`
+
+       -  R'\ :sub:`11`
+
+       -  R'\ :sub:`12`
+
+       -  R'\ :sub:`13`
+
+    -  .. row 3
+
+       -  start + 8:
+
+       -  R'\ :sub:`20`
+
+       -  R'\ :sub:`21`
+
+       -  R'\ :sub:`22`
+
+       -  R'\ :sub:`23`
+
+    -  .. row 4
+
+       -  start + 12:
+
+       -  R'\ :sub:`30`
+
+       -  R'\ :sub:`31`
+
+       -  R'\ :sub:`32`
+
+       -  R'\ :sub:`33`
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst b/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
new file mode 100644
index 0000000..c4bc3a1
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
@@ -0,0 +1,110 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-TCH-FMT-DELTA-TU16:
+
+********************************
+V4L2_TCH_FMT_DELTA_TU16 ('TU16')
+********************************
+
+*man V4L2_TCH_FMT_DELTA_TU16(2)*
+
+16-bit unsigned raw touch data
+
+
+Description
+===========
+
+This format represents unsigned 16-bit data from a touch controller.
+
+This may be used for output for raw and reference data. Values may range from
+0 to 65535.
+
+**Byte Order.**
+Each cell is one byte.
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       2 1 1 1 1 1 1 1 1
+
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  R'\ :sub:`00high`
+
+       -  R'\ :sub:`00low`
+
+       -  R'\ :sub:`01high`
+
+       -  R'\ :sub:`01low`
+
+       -  R'\ :sub:`02high`
+
+       -  R'\ :sub:`02low`
+
+       -  R'\ :sub:`03high`
+
+       -  R'\ :sub:`03low`
+
+    -  .. row 2
+
+       -  start + 8:
+
+       -  R'\ :sub:`10high`
+
+       -  R'\ :sub:`10low`
+
+       -  R'\ :sub:`11high`
+
+       -  R'\ :sub:`11low`
+
+       -  R'\ :sub:`12high`
+
+       -  R'\ :sub:`12low`
+
+       -  R'\ :sub:`13high`
+
+       -  R'\ :sub:`13low`
+
+    -  .. row 3
+
+       -  start + 16:
+
+       -  R'\ :sub:`20high`
+
+       -  R'\ :sub:`20low`
+
+       -  R'\ :sub:`21high`
+
+       -  R'\ :sub:`21low`
+
+       -  R'\ :sub:`22high`
+
+       -  R'\ :sub:`22low`
+
+       -  R'\ :sub:`23high`
+
+       -  R'\ :sub:`23low`
+
+    -  .. row 4
+
+       -  start + 24:
+
+       -  R'\ :sub:`30high`
+
+       -  R'\ :sub:`30low`
+
+       -  R'\ :sub:`31high`
+
+       -  R'\ :sub:`31low`
+
+       -  R'\ :sub:`32high`
+
+       -  R'\ :sub:`32low`
+
+       -  R'\ :sub:`33high`
+
+       -  R'\ :sub:`33low`
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
index 81222a9..6866bcb 100644
--- a/Documentation/media/uapi/v4l/pixfmt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt.rst
@@ -32,4 +32,5 @@ see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
     depth-formats
     pixfmt-013
     sdr-formats
+    tch-formats
     pixfmt-reserved
diff --git a/Documentation/media/uapi/v4l/tch-formats.rst b/Documentation/media/uapi/v4l/tch-formats.rst
new file mode 100644
index 0000000..dbaabf3
--- /dev/null
+++ b/Documentation/media/uapi/v4l/tch-formats.rst
@@ -0,0 +1,18 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _tch-formats:
+
+*************
+Touch Formats
+*************
+
+These formats are used for :ref:`touch` interface only.
+
+
+.. toctree::
+    :maxdepth: 1
+
+    pixfmt-tch-td16
+    pixfmt-tch-td08
+    pixfmt-tch-tu16
+    pixfmt-tch-tu08
-- 
1.7.9.5

