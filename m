Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39064 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbLNBgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 20:36:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH v2 1/3] libv4l2subdev: Use generated format definitions in libv4l2subdev
Date: Sun, 13 Dec 2015 23:36 +0200
Message-ID: <1511163.TeqZ8E01HK@avalon>
In-Reply-To: <1449587716-22954-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com> <1449587716-22954-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 08 December 2015 17:15:14 Sakari Ailus wrote:
> Instead of manually adding each and every new media bus pixel code to
> libv4l2subdev, generate the list automatically. The pre-existing formats
> that do not match the list are not modified so that existing users are
> unaffected by this change, with the exception of converting codes to
> strings, which will use the new definitions.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

This will result in command line strings being a bit longer than I'd like, but 
I agree that adding them manually doesn't scale.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/.gitignore      | 1 +
>  utils/media-ctl/Makefile.am     | 8 ++++++++
>  utils/media-ctl/libv4l2subdev.c | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/utils/media-ctl/.gitignore b/utils/media-ctl/.gitignore
> index 95b6a57..8c7d576 100644
> --- a/utils/media-ctl/.gitignore
> +++ b/utils/media-ctl/.gitignore
> @@ -1 +1,2 @@
>  media-ctl
> +media-bus-formats.h
> diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
> index a3931fb..a1a9225 100644
> --- a/utils/media-ctl/Makefile.am
> +++ b/utils/media-ctl/Makefile.am
> @@ -4,6 +4,14 @@ libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
>  libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
>  libmediactl_la_LDFLAGS = -static $(LIBUDEV_LIBS)
> 
> +media-bus-formats.h: ../../include/linux/media-bus-format.h
> +	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*FMT_//; /FIXED/ d; s/\t.*//;
> s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \ +	< $< > $@
> +
> +BUILT_SOURCES = media-bus-formats.h
> +CLEANFILES = media-bus-formats.h
> +
> +nodist_libv4l2subdev_la_SOURCES = media-bus-formats.h
>  libv4l2subdev_la_SOURCES = libv4l2subdev.c
>  libv4l2subdev_la_LIBADD = libmediactl.la
>  libv4l2subdev_la_CFLAGS = -static
> diff --git a/utils/media-ctl/libv4l2subdev.c
> b/utils/media-ctl/libv4l2subdev.c index 33c1ee6..5bcfe34 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -719,6 +719,7 @@ static struct {
>  	const char *name;
>  	enum v4l2_mbus_pixelcode code;
>  } mbus_formats[] = {
> +#include "media-bus-formats.h"
>  	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
>  	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
>  	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },

-- 
Regards,

Laurent Pinchart

