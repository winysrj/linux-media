Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 30/41] Documentation: dmabuf.rst: Add ioctl cross references
Date: Mon,  4 Jul 2016 22:31:05 -0300
Message-Id: <739012fe35596c42f103bde5cd6acf0a2fa7af5c.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of ioctls mentioned there that aren't cross-referenced.

Convert the const to cross references. That makes it visually
better, and improves navigation along the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dmabuf.rst | 41 ++++++++++++++++-------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index 86cdc255e447..0b2113778cc9 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -20,9 +20,9 @@ exporting V4L2 buffers as DMABUF file descriptors.
 Input and output devices support the streaming I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP` ioctl is set. Whether
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. Whether
 importing DMA buffers through DMABUF file descriptors is supported is
-determined by calling the :ref:`VIDIOC_REQBUFS`
+determined by calling the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
 ioctl with the memory type set to ``V4L2_MEMORY_DMABUF``.
 
 This I/O method is dedicated to sharing DMA buffers between different
@@ -34,7 +34,7 @@ such file descriptor are exchanged. The descriptors and meta-information
 are passed in struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
 :ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
 driver must be switched into DMABUF I/O mode by calling the
-:ref:`VIDIOC_REQBUFS` with the desired buffer type.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
 
 
 .. code-block:: c
@@ -57,10 +57,10 @@ driver must be switched into DMABUF I/O mode by calling the
     }
 
 The buffer (plane) file descriptor is passed on the fly with the
-:ref:`VIDIOC_QBUF` ioctl. In case of multiplanar
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. In case of multiplanar
 buffers, every plane can be associated with a different DMABUF
 descriptor. Although buffers are commonly cycled, applications can pass
-a different DMABUF descriptor at each ``VIDIOC_QBUF`` call.
+a different DMABUF descriptor at each :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` call.
 
 
 .. code-block:: c
@@ -119,7 +119,7 @@ Captured or displayed buffers are dequeued with the
 buffer at any time between the completion of the DMA and this ioctl. The
 memory is also unlocked when
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called,
-:ref:`VIDIOC_REQBUFS`, or when the device is closed.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, or when the device is closed.
 
 For capturing applications it is customary to enqueue a number of empty
 buffers, to start capturing and enter the read loop. Here the
@@ -129,24 +129,27 @@ and enqueue buffers, when enough buffers are stacked up output is
 started. In the write loop, when the application runs out of free
 buffers it must wait until an empty buffer can be dequeued and reused.
 Two methods exist to suspend execution of the application until one or
-more buffers can be dequeued. By default ``VIDIOC_DQBUF`` blocks when no
-buffer is in the outgoing queue. When the ``O_NONBLOCK`` flag was given
-to the :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an ``EAGAIN`` error code when no buffer is available. The
+more buffers can be dequeued. By default :ref:`VIDIOC_DQBUF
+<VIDIOC_QBUF>` blocks when no buffer is in the outgoing queue. When the
+``O_NONBLOCK`` flag was given to the :ref:`open() <func-open>` function,
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` returns immediately with an ``EAGAIN``
+error code when no buffer is available. The
 :ref:`select() <func-select>` and :ref:`poll() <func-poll>`
 functions are always available.
 
 To start and stop capturing or displaying applications call the
-:ref:`VIDIOC_STREAMON` and
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls. Note that
-``VIDIOC_STREAMOFF`` removes all buffers from both queues and unlocks
-all buffers as a side effect. Since there is no notion of doing anything
-"now" on a multitasking system, if an application needs to synchronize
-with another event it should examine the struct
-:ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
+both queues and unlocks all buffers as a side effect. Since there is no
+notion of doing anything "now" on a multitasking system, if an
+application needs to synchronize with another event it should examine
+the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
 outputted buffers.
 
 Drivers implementing DMABUF importing I/O must support the
-``VIDIOC_REQBUFS``, ``VIDIOC_QBUF``, ``VIDIOC_DQBUF``,
-``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctls, and the
-:ref:`select() <func-select>` and :ref:`poll() <func-poll>` functions.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
+:ref:`VIDIOC_DQBUF <VIDIOC_DQBUF>`, :ref:`VIDIOC_STREAMON
+<VIDIOC_STREAMON>` and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls,
+and the :ref:`select() <func-select>` and :ref:`poll() <func-poll>`
+functions.
-- 
2.7.4

