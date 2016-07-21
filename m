Return-path: <linux-media-owner@vger.kernel.org>
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:41942 "EHLO
	17.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbcGURj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 13:39:27 -0400
Received: from player734.ha.ovh.net (b7.ovh.net [213.186.33.57])
	by mo3.mail-out.ovh.net (Postfix) with ESMTP id 87DDC1010A8F
	for <linux-media@vger.kernel.org>; Thu, 21 Jul 2016 17:04:42 +0200 (CEST)
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
To: linux-media@vger.kernel.org
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH] V4L2: Add documentation for SDI timings and related flags
Date: Thu, 21 Jul 2016 17:04:36 +0200
Message-Id: <1469113476-1645-1-git-send-email-charles-antoine.couret@nexvision.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
---
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 31 +++++++++++++++++-----
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 15 +++++++++++
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 5060f54..18331b9 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -260,17 +260,34 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
     -  .. row 11
 
-       -  :cspan:`2` Digital Video
+       -  ``V4L2_IN_ST_NO_V_LOCK``
+
+       -  0x00000400
+
+       -  No vertical sync lock.
 
     -  .. row 12
 
+       -  ``V4L2_IN_ST_NO_STD_LOCK``
+
+       -  0x00000800
+
+       -  No standard format lock in case of auto-detection format
+	  by the component.
+
+    -  .. row 13
+
+       -  :cspan:`2` Digital Video
+
+    -  .. row 14
+
        -  ``V4L2_IN_ST_NO_SYNC``
 
        -  0x00010000
 
        -  No synchronization lock.
 
-    -  .. row 13
+    -  .. row 15
 
        -  ``V4L2_IN_ST_NO_EQU``
 
@@ -278,7 +295,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
        -  No equalizer lock.
 
-    -  .. row 14
+    -  .. row 16
 
        -  ``V4L2_IN_ST_NO_CARRIER``
 
@@ -286,11 +303,11 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
        -  Carrier recovery failed.
 
-    -  .. row 15
+    -  .. row 17
 
        -  :cspan:`2` VCR and Set-Top Box
 
-    -  .. row 16
+    -  .. row 18
 
        -  ``V4L2_IN_ST_MACROVISION``
 
@@ -300,7 +317,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 	  signal to confuse video recorders. When this flag is set
 	  Macrovision has been detected.
 
-    -  .. row 17
+    -  .. row 19
 
        -  ``V4L2_IN_ST_NO_ACCESS``
 
@@ -308,7 +325,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
        -  Conditional access denied.
 
-    -  .. row 18
+    -  .. row 20
 
        -  ``V4L2_IN_ST_VTR``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index f7bf21f..9acfa19 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -339,6 +339,13 @@ EBUSY
 
        -  The timings follow the VESA Generalized Timings Formula standard
 
+    -  .. row 7
+
+       -  ``V4L2_DV_BT_STD_SDI``
+
+       -  The timings follow the SDI Timings standard.
+	  There are no horizontal syncs/porches at all in this format.
+	  Total blanking timings must be set in hsync or vsync fields only.
 
 
 .. _dv-bt-flags:
@@ -415,3 +422,11 @@ EBUSY
 	  R'G'B' values use limited range (i.e. 16-235) as opposed to full
 	  range (i.e. 0-255). All formats defined in CEA-861 except for the
 	  640x480p59.94 format are CE formats.
+
+    -  .. row 8
+
+       -  ``V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE``
+
+       -  Some formats like SMPTE-125M have an interlaced signal with a odd
+	  total height. For these formats, if this flag is set, the first
+	  field has the extra line. Else, it is the second field.
-- 
2.7.4

