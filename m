Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbcGEBb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 27/41] Documentation: userp.rst: Add ioctl cross references
Date: Mon,  4 Jul 2016 22:31:02 -0300
Message-Id: <56510b63d7769bf7cbda2a80c446f1820c69223c.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of ioctls mentioned there that aren't cross-referenced.

Convert the const to cross references. That makes it visually
better, and improves navigation along the document.

While here, remove bad whitespaces.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/userp.rst | 56 ++++++++++++++++--------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index 6db760d3d725..188c0b9f169e 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -24,7 +24,7 @@ driver must be switched into user pointer I/O mode by calling the
 :ref:`VIDIOC_REQBUFS` with the desired buffer type.
 No buffers (planes) are allocated beforehand, consequently they are not
 indexed and cannot be queried like mapped buffers with the
-``VIDIOC_QUERYBUF`` ioctl.
+:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl.
 
 
 .. code-block:: c
@@ -37,23 +37,23 @@ indexed and cannot be queried like mapped buffers with the
     reqbuf.memory = V4L2_MEMORY_USERPTR;
 
     if (ioctl (fd, VIDIOC_REQBUFS, &reqbuf) == -1) {
-        if (errno == EINVAL)
-            printf ("Video capturing or user pointer streaming is not supported\\n");
-        else
-            perror ("VIDIOC_REQBUFS");
+	if (errno == EINVAL)
+	    printf ("Video capturing or user pointer streaming is not supported\\n");
+	else
+	    perror ("VIDIOC_REQBUFS");
 
-        exit (EXIT_FAILURE);
+	exit (EXIT_FAILURE);
     }
 
 Buffer (plane) addresses and sizes are passed on the fly with the
-:ref:`VIDIOC_QBUF` ioctl. Although buffers are commonly
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. Although buffers are commonly
 cycled, applications can pass different addresses and sizes at each
-``VIDIOC_QBUF`` call. If required by the hardware the driver swaps
-memory pages within physical memory to create a continuous area of
-memory. This happens transparently to the application in the virtual
-memory subsystem of the kernel. When buffer pages have been swapped out
-to disk they are brought back and finally locked in physical memory for
-DMA. [1]_
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` call. If required by the hardware the
+driver swaps memory pages within physical memory to create a continuous
+area of memory. This happens transparently to the application in the
+virtual memory subsystem of the kernel. When buffer pages have been
+swapped out to disk they are brought back and finally locked in physical
+memory for DMA. [1]_
 
 Filled or displayed buffers are dequeued with the
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The driver can unlock the
@@ -75,26 +75,28 @@ and enqueue buffers, when enough buffers are stacked up output is
 started. In the write loop, when the application runs out of free
 buffers it must wait until an empty buffer can be dequeued and reused.
 Two methods exist to suspend execution of the application until one or
-more buffers can be dequeued. By default ``VIDIOC_DQBUF`` blocks when no
-buffer is in the outgoing queue. When the ``O_NONBLOCK`` flag was given
-to the :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an ``EAGAIN`` error code when no buffer is available. The
-:ref:`select() <func-select>` or :ref:`poll() <func-poll>` function
-are always available.
+more buffers can be dequeued. By default :ref:`VIDIOC_DQBUF
+<VIDIOC_QBUF>`` blocks when no buffer is in the outgoing queue. When the
+``O_NONBLOCK`` flag was given to the :ref:`open() <func-open>` function,
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` returns immediately with an ``EAGAIN``
+error code when no buffer is available. The :ref:`select()
+<func-select>` or :ref:`poll() <func-poll>` function are always
+available.
 
 To start and stop capturing or output applications call the
-:ref:`VIDIOC_STREAMON` and
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
-``VIDIOC_STREAMOFF`` removes all buffers from both queues and unlocks
-all buffers as a side effect. Since there is no notion of doing anything
-"now" on a multitasking system, if an application needs to synchronize
-with another event it should examine the struct
-:ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from both
+queues and unlocks all buffers as a side effect. Since there is no
+notion of doing anything "now" on a multitasking system, if an
+application needs to synchronize with another event it should examine
+the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
 outputted buffers.
 
 Drivers implementing user pointer I/O must support the
-``VIDIOC_REQBUFS``, ``VIDIOC_QBUF``, ``VIDIOC_DQBUF``,
-``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctl, the
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
+and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls, the
 :ref:`select() <func-select>` and :ref:`poll() <func-poll>` function. [2]_
 
 .. [1]
-- 
2.7.4

