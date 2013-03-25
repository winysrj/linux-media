Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55712 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669Ab3CYWFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 18:05:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH] Fix linking of shared libraries
Date: Mon, 25 Mar 2013 23:06:23 +0100
Message-ID: <5352417.g2H1czLqPc@avalon>
In-Reply-To: <20130219210353.GA6935@amos.fritz.box>
References: <20130219210353.GA6935@amos.fritz.box>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Thanks for the patch, and sorry for the late reply.

On Tuesday 19 February 2013 22:03:53 Andreas Bombe wrote:
> When using libudev, it is actually libmediactl that uses it and not the
> media-ctl executable. libv4l2subdev uses functions from libmediactl and
> therefore needs to be linked against it.
> 
> Signed-off-by: Andreas Bombe <aeb@debian.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and pushed to the repository.

> ---
> 
> In light of their relative simplicity as well as cross dependency, does
> it make sense to keep libmediactl and libv4l2subdev as separate
> libraries?

I think it does, as libmediactl is supposed to be media-agnostic. I'm working 
on a media device enumeration library that will likely result in all those 
libraries being rearchitectured, I'll keep the question in mind.

>  src/Makefile.am |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 2583464..f754763 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -1,12 +1,12 @@
>  lib_LTLIBRARIES = libmediactl.la libv4l2subdev.la
>  libmediactl_la_SOURCES = mediactl.c
> +libmediactl_la_CFLAGS = $(LIBUDEV_CFLAGS)
> +libmediactl_la_LDFLAGS = $(LIBUDEV_LIBS)
>  libv4l2subdev_la_SOURCES = v4l2subdev.c
> +libv4l2subdev_la_LIBADD = libmediactl.la
>  mediactl_includedir=$(includedir)/mediactl
>  mediactl_include_HEADERS = mediactl.h v4l2subdev.h
> 
>  bin_PROGRAMS = media-ctl
> -media_ctl_CFLAGS = $(LIBUDEV_CFLAGS)
> -media_ctl_LDFLAGS = $(LIBUDEV_LIBS)
>  media_ctl_SOURCES = main.c options.c options.h tools.h
>  media_ctl_LDADD = libmediactl.la libv4l2subdev.la
> -
-- 
Regards,

Laurent Pinchart

