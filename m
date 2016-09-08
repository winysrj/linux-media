Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941750AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 41/47] [media] libv4l-introduction.rst: improve crossr-references
Date: Thu,  8 Sep 2016 09:04:03 -0300
Message-Id: <c6f29e6fd5453c11e2fa22782630f780fc9d20dc.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use C cross-references to mention the V4L2 API calls on all
places it occurs inside this file.

While here, also mark constants as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/v4l/libv4l-introduction.rst         | 33 +++++++++++++---------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/libv4l-introduction.rst b/Documentation/media/uapi/v4l/libv4l-introduction.rst
index 1c1278d17fa7..ccc3c4d2fc0f 100644
--- a/Documentation/media/uapi/v4l/libv4l-introduction.rst
+++ b/Documentation/media/uapi/v4l/libv4l-introduction.rst
@@ -113,43 +113,47 @@ Libv4l device control functions
 
 The common file operation methods are provided by libv4l.
 
-Those functions operate just like glibc
-open/close/dup/ioctl/read/mmap/munmap:
+Those functions operate just like the gcc function ``dup()`` and
+V4L2 functions
+:c:func:`open() <v4l2-open>`, :c:func:`close() <v4l2-close>`,
+:c:func:`ioctl() <v4l2-ioctl>`, :c:func:`read() <v4l2-read>`,
+:c:func:`mmap() <v4l2-mmap>` and :c:func:`munmap() <v4l2-munmap>`:
 
 .. c:function:: int v4l2_open(const char *file, int oflag, ...)
 
-   operates like the standard :ref:`open() <func-open>` function.
+   operates like the :c:func:`open() <v4l2-open>` function.
 
 .. c:function:: int v4l2_close(int fd)
 
-   operates like the standard :ref:`close() <func-close>` function.
+   operates like the :c:func:`close() <v4l2-close>` function.
 
 .. c:function:: int v4l2_dup(int fd)
 
-   operates like the standard dup() function, duplicating a file handler.
+   operates like the libc ``dup()`` function, duplicating a file handler.
 
 .. c:function:: int v4l2_ioctl (int fd, unsigned long int request, ...)
 
-   operates like the standard :ref:`ioctl() <func-ioctl>` function.
+   operates like the :c:func:`ioctl() <v4l2-ioctl>` function.
 
 .. c:function:: int v4l2_read (int fd, void* buffer, size_t n)
 
-   operates like the standard :ref:`read() <func-read>` function.
+   operates like the :c:func:`read() <v4l2-read>` function.
 
 .. c:function:: void v4l2_mmap(void *start, size_t length, int prot, int flags, int fd, int64_t offset);
 
-   operates like the standard :ref:`mmap() <func-mmap>` function.
+   operates like the :c:func:`munmap() <v4l2-munmap>` function.
 
 .. c:function:: int v4l2_munmap(void *_start, size_t length);
-   operates like the standard :ref:`munmap() <func-munmap>` function.
+
+   operates like the :c:func:`munmap() <v4l2-munmap>` function.
 
 Those functions provide additional control:
 
 .. c:function:: int v4l2_fd_open(int fd, int v4l2_flags)
 
    opens an already opened fd for further use through v4l2lib and possibly
-   modify libv4l2's default behavior through the v4l2_flags argument.
-   Currently, v4l2_flags can be ``V4L2_DISABLE_CONVERSION``, to disable
+   modify libv4l2's default behavior through the ``v4l2_flags`` argument.
+   Currently, ``v4l2_flags`` can be ``V4L2_DISABLE_CONVERSION``, to disable
    format conversion.
 
 .. c:function:: int v4l2_set_control(int fd, int cid, int value)
@@ -168,9 +172,12 @@ Those functions provide additional control:
 v4l1compat.so wrapper library
 =============================
 
-This library intercepts calls to open/close/ioctl/mmap/mmunmap
+This library intercepts calls to
+:c:func:`open() <v4l2-open>`, :c:func:`close() <v4l2-close>`,
+:c:func:`ioctl() <v4l2-ioctl>`, :c:func:`mmap() <v4l2-mmap>` and
+:c:func:`munmap() <v4l2-munmap>`
 operations and redirects them to the libv4l counterparts, by using
-LD_PRELOAD=/usr/lib/v4l1compat.so. It also emulates V4L1 calls via V4L2
+``LD_PRELOAD=/usr/lib/v4l1compat.so``. It also emulates V4L1 calls via V4L2
 API.
 
 It allows usage of binary legacy applications that still don't use
-- 
2.7.4


