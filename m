Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39893 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422851AbbEEMeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 08:34:08 -0400
Date: Tue, 5 May 2015 09:34:02 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Felix Janda <felix.janda@posteo.de>,
	Hans Petter Selasky <hselasky@freebsd.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] Wrap LFS64 functions only if __GLIBC__
Message-ID: <20150505093402.4c29d565@recife.lan>
In-Reply-To: <20150125203636.GC11999@euler>
References: <20150125203636.GC11999@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 25 Jan 2015 21:36:36 +0100
Felix Janda <felix.janda@posteo.de> escreveu:

> The functions open64 and mmap64 are glibc specific.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  lib/libv4l1/v4l1compat.c  | 4 ++--
>  lib/libv4l2/v4l2convert.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
> index 282173b..c78adb4 100644
> --- a/lib/libv4l1/v4l1compat.c
> +++ b/lib/libv4l1/v4l1compat.c
> @@ -61,7 +61,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
>  	return fd;
>  }
>  
> -#ifdef linux
> +#ifdef __GLIBC__

Hmm... linux was added here to avoid breaking on FreeBSD, on this
changeset:

commit 9026d3cc277e9211a89345846dea95af7208383c
Author: hans@rhel5-devel.localdomain <hans@rhel5-devel.localdomain>
Date:   Tue Jun 2 15:34:34 2009 +0200

    libv4l: initial support for compiling on FreeBSD
    
    From: Hans Petter Selasky <hselasky@freebsd.org>

I'm afraid that removing the above would break for FreeBSD, as I think
it also uses glibc, but not 100% sure.

So, either we should get an ack from Hans Peter, or you should
change the tests to:

	#if linux && __GLIBC__

Regards,
Mauro



>  LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
>  {
>  	int fd;
> @@ -120,7 +120,7 @@ LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd
>  	return v4l1_mmap(start, length, prot, flags, fd, offset);
>  }
>  
> -#ifdef linux
> +#ifdef __GLIBC__
>  LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
>  		off64_t offset)
>  {
> diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
> index c79f9da..9345641 100644
> --- a/lib/libv4l2/v4l2convert.c
> +++ b/lib/libv4l2/v4l2convert.c
> @@ -86,7 +86,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
>  	return fd;
>  }
>  
> -#ifdef linux
> +#ifdef __GLIBC__
>  LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
>  {
>  	int fd;
> @@ -148,7 +148,7 @@ LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd
>  	return v4l2_mmap(start, length, prot, flags, fd, offset);
>  }
>  
> -#ifdef linux
> +#ifdef __GLIBC__
>  LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
>  		off64_t offset)
>  {
