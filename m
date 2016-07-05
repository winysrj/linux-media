Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 36/41] Documentation: linux_tv: Use references for read()/write()
Date: Mon,  4 Jul 2016 22:31:11 -0300
Message-Id: <bdb153df9622b6e8bd75ca57a7dd5a22cea6f71c.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use cross-references for read()/write() on a few places
where they weren't used.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-capture.rst |  4 ++--
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst |  4 ++--
 Documentation/linux_tv/media/v4l/func-open.rst   | 12 ++++++------
 Documentation/linux_tv/media/v4l/open.rst        |  3 ++-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/linux_tv/media/v4l/dev-capture.rst
index c927b7834b90..16030a8354fd 100644
--- a/Documentation/linux_tv/media/v4l/dev-capture.rst
+++ b/Documentation/linux_tv/media/v4l/dev-capture.rst
@@ -97,6 +97,6 @@ requests and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_F
 Reading Images
 ==============
 
-A video capture device may support the :ref:`read() function <rw>`
-and/or streaming (:ref:`memory mapping <mmap>` or
+A video capture device may support the ::ref:`read() function <func-read>`
+and/or streaming (:ref:`memory mapping <func-mmap>` or
 :ref:`user pointer <userp>`) I/O. See :ref:`io` for details.
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index a26e10e92460..3aa93943fe9f 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -91,8 +91,8 @@ happen for instance when the video and VBI areas to capture would
 overlap, or when the driver supports multiple opens and another process
 already requested VBI capturing or output. Anyway, applications must
 expect other resource allocation points which may return ``EBUSY``, at the
-:ref:`VIDIOC_STREAMON` ioctl and the first read(),
-write() and select() call.
+:ref:`VIDIOC_STREAMON` ioctl and the first :ref:`read() <func-read>`
+, :ref:`write() <func-write>` and :ref:`select() <func-select>` calls.
 
 VBI devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all requests
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index 9598c0fd592e..705175be80e6 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -32,12 +32,12 @@ Arguments
     technicality, input devices still support only reading and output
     devices only writing.
 
-    When the ``O_NONBLOCK`` flag is given, the read() function and the
-    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will return the ``EAGAIN``
-    error code when no data is available or no buffer is in the driver
-    outgoing queue, otherwise these functions block until data becomes
-    available. All V4L2 drivers exchanging data with applications must
-    support the ``O_NONBLOCK`` flag.
+    When the ``O_NONBLOCK`` flag is given, the :ref:`read() <func-read>`
+    function and the :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will
+    return the ``EAGAIN`` error code when no data is available or no
+    buffer is in the driver outgoing queue, otherwise these functions
+    block until data becomes available. All V4L2 drivers exchanging data
+    with applications must support the ``O_NONBLOCK`` flag.
 
     Other flags have no effect.
 
diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/linux_tv/media/v4l/open.rst
index c349575efc03..a3e39df91e9d 100644
--- a/Documentation/linux_tv/media/v4l/open.rst
+++ b/Documentation/linux_tv/media/v4l/open.rst
@@ -73,7 +73,8 @@ support all functions. However, in practice this never worked: this
 'feature' was never used by applications and many drivers did not
 support it and if they did it was certainly never tested. In addition,
 switching a device node between different functions only works when
-using the streaming I/O API, not with the read()/write() API.
+using the streaming I/O API, not with the
+:ref:`read() <func-read>`/\ :ref:`write() <func-write>` API.
 
 Today each device node supports just one function.
 
-- 
2.7.4

