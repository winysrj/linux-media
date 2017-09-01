Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48389
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752441AbdIATiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 02/14] media: gen-errors.rst: remove row number comments
Date: Fri,  1 Sep 2017 16:37:38 -0300
Message-Id: <7279ec89ce20f404d538b036f9bb3f7bfcb4624b.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are introduced by the conversion scripts and don't
really help. Get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/gen-errors.rst | 44 +++++++++------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index d39e34d1b19d..d51f672021c4 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -17,9 +17,7 @@ Generic Error Codes
     :widths: 1 16
 
 
-    -  .. row 1
-
-       -  ``EAGAIN`` (aka ``EWOULDBLOCK``)
+    -  -  ``EAGAIN`` (aka ``EWOULDBLOCK``)
 
        -  The ioctl can't be handled because the device is in state where it
 	  can't perform it. This could happen for example in case where
@@ -27,15 +25,11 @@ Generic Error Codes
 	  is also returned when the ioctl would need to wait for an event,
 	  but the device was opened in non-blocking mode.
 
-    -  .. row 2
-
-       -  ``EBADF``
+    -  -  ``EBADF``
 
        -  The file descriptor is not a valid.
 
-    -  .. row 3
-
-       -  ``EBUSY``
+    -  -  ``EBUSY``
 
        -  The ioctl can't be handled because the device is busy. This is
 	  typically return while device is streaming, and an ioctl tried to
@@ -44,59 +38,43 @@ Generic Error Codes
 	  ioctl must not be retried without performing another action to fix
 	  the problem first (typically: stop the stream before retrying).
 
-    -  .. row 4
-
-       -  ``EFAULT``
+    -  -  ``EFAULT``
 
        -  There was a failure while copying data from/to userspace, probably
 	  caused by an invalid pointer reference.
 
-    -  .. row 5
-
-       -  ``EINVAL``
+    -  -  ``EINVAL``
 
        -  One or more of the ioctl parameters are invalid or out of the
 	  allowed range. This is a widely used error code. See the
 	  individual ioctl requests for specific causes.
 
-    -  .. row 6
-
-       -  ``ENODEV``
+    -  -  ``ENODEV``
 
        -  Device not found or was removed.
 
-    -  .. row 7
-
-       -  ``ENOMEM``
+    -  -  ``ENOMEM``
 
        -  There's not enough memory to handle the desired operation.
 
-    -  .. row 8
-
-       -  ``ENOTTY``
+    -  -  ``ENOTTY``
 
        -  The ioctl is not supported by the driver, actually meaning that
 	  the required functionality is not available, or the file
 	  descriptor is not for a media device.
 
-    -  .. row 9
-
-       -  ``ENOSPC``
+    -  -  ``ENOSPC``
 
        -  On USB devices, the stream ioctl's can return this error, meaning
 	  that this request would overcommit the usb bandwidth reserved for
 	  periodic transfers (up to 80% of the USB bandwidth).
 
-    -  .. row 10
-
-       -  ``EPERM``
+    -  -  ``EPERM``
 
        -  Permission denied. Can be returned if the device needs write
 	  permission, or some special capabilities is needed (e. g. root)
 
-    -  .. row 11
-
-       -  ``EIO``
+    -  -  ``EIO``
 
        -  I/O error. Typically used when there are problems communicating with
           a hardware device. This could indicate broken or flaky hardware.
-- 
2.13.5
