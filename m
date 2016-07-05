Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbcGEBb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 37/41] Documentation: dev-raw-vbi.rst fix conversion issues
Date: Mon,  4 Jul 2016 22:31:12 -0300
Message-Id: <a15201c578bfa7f085bfa2499650f023260f55d6.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several things that didn't convert well. Fix them,
in order to improve the layout of the formatted document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst | 29 ++++++++----------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index 3aa93943fe9f..da85be88d57e 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -155,7 +155,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
        -  __u32
 
-       -  ``start``\ [2]
+       -  ``start``\ [2]_
 
        -  This is the scanning system line number associated with the first
 	  line of the VBI image, of the first and the second field
@@ -173,7 +173,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
        -  __u32
 
-       -  ``count``\ [2]
+       -  ``count``\ [2]_
 
        -  The number of lines in the first and second field image,
 	  respectively.
@@ -218,7 +218,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ [2]_
 
        -  This array is reserved for future extensions. Drivers and
 	  applications must set it to zero.
@@ -275,11 +275,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
     :alt:    vbi_hsync.pdf / vbi_hsync.gif
     :align:  center
 
-    Line synchronization
-
-    Line synchronization diagram
-
-
+    **Figure 4.1. Line synchronization**
 
 
 .. _vbi-525:
@@ -288,10 +284,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
     :alt:    vbi_525.pdf / vbi_525.gif
     :align:  center
 
-    ITU-R 525 line numbering (M/NTSC and M/PAL)
-
-    NTSC field synchronization diagram
-
+    **Figure 4.2. ITU-R 525 line numbering (M/NTSC and M/PAL)**
 
 
 
@@ -301,9 +294,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
     :alt:    vbi_625.pdf / vbi_625.gif
     :align:  center
 
-    ITU-R 625 line numbering
-
-    PAL/SECAM field synchronization diagram
+    **Figure 4.3. ITU-R 625 line numbering**
 
 
 
@@ -327,8 +318,7 @@ The total size of a frame computes as follows:
 
 .. code-block:: c
 
-    (count[0] + count[1]) *
-    samples_per_line * sample size in bytes
+    (count[0] + count[1]) * samples_per_line * sample size in bytes
 
 The sample size is most likely always one byte, applications must check
 the ``sample_format`` field though, to function properly with other
@@ -339,8 +329,9 @@ A VBI device may support :ref:`read/write <rw>` and/or streaming
 The latter bears the possibility of synchronizing video and VBI data by
 using buffer timestamps.
 
-Remember the :ref:`VIDIOC_STREAMON` ioctl and the
-first read(), write() and select() call can be resource allocation
+Remember the :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the
+first :ref:`read() <func-read>`, :ref:`write() <func-write>` and
+:ref:`select() <func-select>` call can be resource allocation
 points returning an ``EBUSY`` error code if the required hardware resources
 are temporarily unavailable, for example the device is already in use by
 another process.
-- 
2.7.4

