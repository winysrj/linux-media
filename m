Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49388 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872AbbEETCi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 15:02:38 -0400
Date: Tue, 5 May 2015 21:02:28 +0200
From: Felix Janda <felix.janda@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Petter Selasky <hselasky@freebsd.org>,
	linux-media@vger.kernel.org
Subject: [PATCHv2 3/4] Wrap LFS64 functions only if linux && __GLIBC__
Message-ID: <20150505190228.GA17585@euler>
References: <20150125203636.GC11999@euler>
 <20150505093402.4c29d565@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150505093402.4c29d565@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For musl libc, open64 is #define'd to open. Therefore we should not try
to wrap both open and open64.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
v2: Test for linux as well

Mauro Carvalho Chehab wrote:
[..]
> Hmm... linux was added here to avoid breaking on FreeBSD, on this
> changeset:
> 
> commit 9026d3cc277e9211a89345846dea95af7208383c
> Author: hans@rhel5-devel.localdomain <hans@rhel5-devel.localdomain>
> Date:   Tue Jun 2 15:34:34 2009 +0200
> 
>     libv4l: initial support for compiling on FreeBSD
>     
>     From: Hans Petter Selasky <hselasky@freebsd.org>
> 
> I'm afraid that removing the above would break for FreeBSD, as I think
> it also uses glibc, but not 100% sure.

Usually FreeBSD has its own libc (which does not define __GLIBC__).
However (as I've didn't know at the time) there is also kFreeBSD, which
has a FreeBSD kernel but still uses glibc.

> So, either we should get an ack from Hans Peter, or you should
> change the tests to:
> 
> 	#if linux && __GLIBC__

I've changed them to

#if defined(linux) && defined(__GLIBC__)

Thanks for the review!

---
 lib/libv4l1/v4l1compat.c  | 4 ++--
 lib/libv4l2/v4l2convert.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index 282173b..0d433c6 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -61,7 +61,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 	return fd;
 }
 
-#ifdef linux
+#if defined(linux) && defined(__GLIBC__)
 LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 {
 	int fd;
@@ -120,7 +120,7 @@ LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
 
-#ifdef linux
+#if defined(linux) && defined(__GLIBC__)
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
 		off64_t offset)
 {
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 2c2f12a..6abccbf 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -89,7 +89,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 	return fd;
 }
 
-#ifdef linux
+#if defined(linux) && defined(__GLIBC__)
 LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 {
 	int fd;
@@ -152,7 +152,7 @@ LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
 
-#ifdef linux
+#if defined(linux) && defined(__GLIBC__)
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
 		off64_t offset)
 {
-- 
2.3.6

















