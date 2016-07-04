Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 33/51] Documentation: linux_tv: fix some warnings due to '*'
Date: Mon,  4 Jul 2016 08:46:54 -0300
Message-Id: <46fd87e437d897110a30baf03f7db51f965d3b66.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unescaped * causes warnings on Sphinx.

Add an escape at hist-v4l2.rst occurrences.

At libv4l-introduction, the best is do declare the function
prototypes as C code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     |  5 ++---
 .../linux_tv/media/v4l/libv4l-introduction.rst     | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index 664fbe4780af..6e9706f791de 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -187,7 +187,7 @@ common Linux driver API conventions.
    until the time in the timestamp field has arrived. I would like to
    follow SGI's lead, and adopt a multimedia timestamping system like
    their UST (Unadjusted System Time). See
-   http://web.archive.org/web/*/http://reality.sgi.com
+   http://web.archive.org/web/\*/http://reality.sgi.com
    /cpirazzi_engr/lg/time/intro.html. UST uses timestamps that are
    64-bit signed integers (not struct timeval's) and given in nanosecond
    units. The UST clock starts at zero when the system is booted and
@@ -1408,13 +1408,12 @@ XFree86 and XOrg, just programming any overlay capable Video4Linux
 device it finds. To enable it ``/etc/X11/XF86Config`` must contain these
 lines:
 
-
-
 ::
 
     Section "Module"
         Load "v4l"
     EndSection
+
 As of XFree86 4.2 this driver still supports only V4L ioctls, however it
 should work just fine with all V4L2 devices through the V4L2
 backward-compatibility layer. Since V4L2 permits multiple opens it is
diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
index b8d247dc236d..d189316dc1da 100644
--- a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
@@ -116,42 +116,42 @@ The common file operation methods are provided by libv4l.
 Those functions operate just like glibc
 open/close/dup/ioctl/read/mmap/munmap:
 
--  int v4l2_open(const char *file, int oflag, ...) - operates like the
+-  :c:type:`int v4l2_open(const char *file, int oflag, ...)` - operates like the
    standard :ref:`open() <func-open>` function.
 
--  int v4l2_close(int fd) - operates like the standard
+-  :c:type:`int v4l2_close(int fd)` - operates like the standard
    :ref:`close() <func-close>` function.
 
--  int v4l2_dup(int fd) - operates like the standard dup() function,
+-  :c:type:`int v4l2_dup(int fd)` - operates like the standard dup() function,
    duplicating a file handler.
 
--  int v4l2_ioctl (int fd, unsigned long int request, ...) - operates
+-  :c:type:`int v4l2_ioctl (int fd, unsigned long int request, ...)` - operates
    like the standard :ref:`ioctl() <func-ioctl>` function.
 
--  int v4l2_read (int fd, void* buffer, size_t n) - operates like the
+-  :c:type:`int v4l2_read (int fd, void* buffer, size_t n)` - operates like the
    standard :ref:`read() <func-read>` function.
 
--  void v4l2_mmap(void *start, size_t length, int prot, int flags, int
-   fd, int64_t offset); - operates like the standard
+-  :c:type:`void v4l2_mmap(void *start, size_t length, int prot, int flags, int
+   fd, int64_t offset);` - operates like the standard
    :ref:`mmap() <func-mmap>` function.
 
--  int v4l2_munmap(void *_start, size_t length); - operates like the
+-  :c:type:`int v4l2_munmap(void *_start, size_t length);` - operates like the
    standard :ref:`munmap() <func-munmap>` function.
 
 Those functions provide additional control:
 
--  int v4l2_fd_open(int fd, int v4l2_flags) - opens an already opened
+-  :c:type:`int v4l2_fd_open(int fd, int v4l2_flags)` - opens an already opened
    fd for further use through v4l2lib and possibly modify libv4l2's
    default behavior through the v4l2_flags argument. Currently,
    v4l2_flags can be ``V4L2_DISABLE_CONVERSION``, to disable format
    conversion.
 
--  int v4l2_set_control(int fd, int cid, int value) - This function
+-  :c:type:`int v4l2_set_control(int fd, int cid, int value)` - This function
    takes a value of 0 - 65535, and then scales that range to the actual
    range of the given v4l control id, and then if the cid exists and is
    not locked sets the cid to the scaled value.
 
--  int v4l2_get_control(int fd, int cid) - This function returns a
+-  :c:type:`int v4l2_get_control(int fd, int cid)` - This function returns a
    value of 0 - 65535, scaled to from the actual range of the given v4l
    control id. when the cid does not exist, could not be accessed for
    some reason, or some error occurred 0 is returned.
-- 
2.7.4


