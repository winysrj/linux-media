Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43871 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965735AbcIHMEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 40/47] [media] libv4l-introdution.rst: fix function definitions
Date: Thu,  8 Sep 2016 09:04:02 -0300
Message-Id: <8c6c4d3cb0682cdd4195b89a87bb91cdf4fff4ae.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

c:type is not the right tag for function definitions.
Replace them by .. c:function::

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/v4l/libv4l-introduction.rst         | 62 ++++++++++++----------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/Documentation/media/uapi/v4l/libv4l-introduction.rst b/Documentation/media/uapi/v4l/libv4l-introduction.rst
index 61d085f9f105..1c1278d17fa7 100644
--- a/Documentation/media/uapi/v4l/libv4l-introduction.rst
+++ b/Documentation/media/uapi/v4l/libv4l-introduction.rst
@@ -116,45 +116,53 @@ The common file operation methods are provided by libv4l.
 Those functions operate just like glibc
 open/close/dup/ioctl/read/mmap/munmap:
 
--  :c:type:`int v4l2_open(const char *file, int oflag, ...)` - operates like the
-   standard :ref:`open() <func-open>` function.
+.. c:function:: int v4l2_open(const char *file, int oflag, ...)
 
--  :c:type:`int v4l2_close(int fd)` - operates like the standard
-   :ref:`close() <func-close>` function.
+   operates like the standard :ref:`open() <func-open>` function.
 
--  :c:type:`int v4l2_dup(int fd)` - operates like the standard dup() function,
-   duplicating a file handler.
+.. c:function:: int v4l2_close(int fd)
 
--  :c:type:`int v4l2_ioctl (int fd, unsigned long int request, ...)` - operates
-   like the standard :ref:`ioctl() <func-ioctl>` function.
+   operates like the standard :ref:`close() <func-close>` function.
 
--  :c:type:`int v4l2_read (int fd, void* buffer, size_t n)` - operates like the
-   standard :ref:`read() <func-read>` function.
+.. c:function:: int v4l2_dup(int fd)
 
--  :c:type:`void v4l2_mmap(void *start, size_t length, int prot, int flags, int
-   fd, int64_t offset);` - operates like the standard
-   :ref:`mmap() <func-mmap>` function.
+   operates like the standard dup() function, duplicating a file handler.
 
--  :c:type:`int v4l2_munmap(void *_start, size_t length);` - operates like the
-   standard :ref:`munmap() <func-munmap>` function.
+.. c:function:: int v4l2_ioctl (int fd, unsigned long int request, ...)
+
+   operates like the standard :ref:`ioctl() <func-ioctl>` function.
+
+.. c:function:: int v4l2_read (int fd, void* buffer, size_t n)
+
+   operates like the standard :ref:`read() <func-read>` function.
+
+.. c:function:: void v4l2_mmap(void *start, size_t length, int prot, int flags, int fd, int64_t offset);
+
+   operates like the standard :ref:`mmap() <func-mmap>` function.
+
+.. c:function:: int v4l2_munmap(void *_start, size_t length);
+   operates like the standard :ref:`munmap() <func-munmap>` function.
 
 Those functions provide additional control:
 
--  :c:type:`int v4l2_fd_open(int fd, int v4l2_flags)` - opens an already opened
-   fd for further use through v4l2lib and possibly modify libv4l2's
-   default behavior through the v4l2_flags argument. Currently,
-   v4l2_flags can be ``V4L2_DISABLE_CONVERSION``, to disable format
-   conversion.
+.. c:function:: int v4l2_fd_open(int fd, int v4l2_flags)
 
--  :c:type:`int v4l2_set_control(int fd, int cid, int value)` - This function
-   takes a value of 0 - 65535, and then scales that range to the actual
-   range of the given v4l control id, and then if the cid exists and is
+   opens an already opened fd for further use through v4l2lib and possibly
+   modify libv4l2's default behavior through the v4l2_flags argument.
+   Currently, v4l2_flags can be ``V4L2_DISABLE_CONVERSION``, to disable
+   format conversion.
+
+.. c:function:: int v4l2_set_control(int fd, int cid, int value)
+
+   This function takes a value of 0 - 65535, and then scales that range to the
+   actual range of the given v4l control id, and then if the cid exists and is
    not locked sets the cid to the scaled value.
 
--  :c:type:`int v4l2_get_control(int fd, int cid)` - This function returns a
-   value of 0 - 65535, scaled to from the actual range of the given v4l
-   control id. when the cid does not exist, could not be accessed for
-   some reason, or some error occurred 0 is returned.
+.. c:function:: int v4l2_get_control(int fd, int cid)
+
+   This function returns a value of 0 - 65535, scaled to from the actual range
+   of the given v4l control id. when the cid does not exist, could not be
+   accessed for some reason, or some error occurred 0 is returned.
 
 
 v4l1compat.so wrapper library
-- 
2.7.4


