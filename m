Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39766 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbcBYVaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 16:30:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v5 3/4] libv4l2subdev: Add a function to list library supported pixel codes
Date: Thu, 25 Feb 2016 23:30:08 +0200
Message-ID: <18438076.LjvAzkEb7o@avalon>
In-Reply-To: <1456331128-7036-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1456331128-7036-1-git-send-email-sakari.ailus@linux.intel.com> <1456331128-7036-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 24 February 2016 18:25:27 Sakari Ailus wrote:
> Also mark which format definitions are compat definitions for the
> pre-existing codes. This way we don't end up listing the same formats
> twice.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/.gitignore      |  1 +
>  utils/media-ctl/Makefile.am     |  6 +++++-
>  utils/media-ctl/libv4l2subdev.c | 11 +++++++++++
>  utils/media-ctl/v4l2subdev.h    | 11 +++++++++++
>  4 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/media-ctl/.gitignore b/utils/media-ctl/.gitignore
> index 799ab33..5354fec 100644
> --- a/utils/media-ctl/.gitignore
> +++ b/utils/media-ctl/.gitignore
> @@ -1,2 +1,3 @@
>  media-ctl
>  media-bus-format-names.h
> +media-bus-format-codes.h
> diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
> index 23ad90b..ee7dcc9 100644
> --- a/utils/media-ctl/Makefile.am
> +++ b/utils/media-ctl/Makefile.am
> @@ -8,7 +8,11 @@ media-bus-format-names.h:
> ../../include/linux/media-bus-format.h sed -e '/#define MEDIA_BUS_FMT/ ! d;
> s/.*FMT_//; /FIXED/ d; s/\t.*//; s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \ < $<
> > $@
> 
> -BUILT_SOURCES = media-bus-format-names.h
> +media-bus-format-codes.h: ../../include/linux/media-bus-format.h
> +	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*#define //; /FIXED/ d; s/\t.*//;
> s/.*/ &,/;' \ +	< $< > $@
> +
> +BUILT_SOURCES = media-bus-format-names.h media-bus-format-codes.h
>  CLEANFILES = $(BUILT_SOURCES)
> 
>  nodist_libv4l2subdev_la_SOURCES = $(BUILT_SOURCES)
> diff --git a/utils/media-ctl/libv4l2subdev.c
> b/utils/media-ctl/libv4l2subdev.c index f3c0a9a..8d39898 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -821,3 +821,14 @@ enum v4l2_field v4l2_subdev_string_to_field(const char
> *string,
> 
>  	return fields[i].field;
>  }
> +
> +static const enum v4l2_mbus_pixelcode mbus_codes[] = {
> +#include "media-bus-format-codes.h"
> +};
> +
> +const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(unsigned int
> *length) +{
> +	*length = ARRAY_SIZE(mbus_codes);
> +
> +	return mbus_codes;
> +}
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index 104e420..97f46a8 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -279,4 +279,15 @@ const char *v4l2_subdev_field_to_string(enum v4l2_field
> field); enum v4l2_field v4l2_subdev_string_to_field(const char *string,
>  					    unsigned int length);
> 
> +/**
> + * @brief Enumerate library supported media bus pixel codes.
> + * @param length - the number of the supported pixel codes
> + *
> + * Obtain pixel codes supported by libv4l2subdev.
> + *
> + * @return A pointer to the pixel code array
> + */
> +const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(
> +	unsigned int *length);
> +
>  #endif

-- 
Regards,

Laurent Pinchart

