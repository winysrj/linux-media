Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3TBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 15:01:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [media-ctl][PATCHv2 3/4] libmediactl: use udev conditionally to get a devname
Date: Tue, 30 Aug 2011 21:01:58 +0200
Cc: linux-media@vger.kernel.org
References: <201108151652.54417.laurent.pinchart@ideasonboard.com> <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com> <3fa73211e84c4b2e70d4777e3664954948042d64.1313490446.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <3fa73211e84c4b2e70d4777e3664954948042d64.1313490446.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108302101.58685.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch, and sorry for the late reply.

On Tuesday 16 August 2011 12:28:04 Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  configure.in    |   22 ++++++++++++++++++++++
>  src/Makefile.am |    2 ++
>  src/media.c     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/configure.in b/configure.in
> index fd4c70c..45e0663 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -13,6 +13,28 @@ AC_PROG_LIBTOOL
> 
>  # Checks for libraries.
> 
> +AC_ARG_WITH([libudev],
> +    AS_HELP_STRING([--without-libudev],
> +        [Ignore presence of libudev and disable it]))
> +
> +AS_IF([test "x$with_libudev" != "xno"],
> +    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes,
> have_libudev=no)], +    [have_libudev=no])
> +
> +AS_IF([test "x$have_libudev" = "xyes"],
> +    [
> +        AC_DEFINE([HAVE_LIBUDEV], [], [Use libudev])
> +        LIBUDEV_CFLAGS="$lbudev_CFLAGS"
> +        LIBUDEV_LIBS="$libudev_LIBS"
> +        AC_SUBST(LIBUDEV_CFLAGS)
> +        AC_SUBST(LIBUDEV_LIBS)
> +    ],
> +    [AS_IF([test "x$with_libudev" = "xyes"],
> +        [AC_MSG_ERROR([libudev requested but not found])
> +    ])
> +])
> +
> +
>  # Kernel headers path.
>  AC_ARG_WITH(kernel-headers,
>      [AC_HELP_STRING([--with-kernel-headers=DIR],
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 267ea83..52628d2 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -5,6 +5,8 @@ mediactl_includedir=$(includedir)/mediactl
>  mediactl_include_HEADERS = media.h subdev.h
> 
>  bin_PROGRAMS = media-ctl
> +media_ctl_CFLAGS = $(LIBUDEV_CFLAGS)
> +media_ctl_LDFLAGS = $(LIBUDEV_LIBS)
>  media_ctl_SOURCES = main.c options.c options.h tools.h
>  media_ctl_LDADD = libmediactl.la libv4l2subdev.la
> 
> diff --git a/src/media.c b/src/media.c
> index fc05a86..e159526 100644
> --- a/src/media.c
> +++ b/src/media.c
> @@ -17,6 +17,8 @@
>   * with this program; if not, write to the Free Software Foundation, Inc.,
>   */
> 
> +#include "config.h"
> +
>  #include <sys/ioctl.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
> @@ -31,6 +33,10 @@
>  #include <linux/videodev2.h>
>  #include <linux/media.h>
> 
> +#ifdef HAVE_LIBUDEV
> +#include <libudev.h>
> +#endif	/* HAVE_LIBUDEV */
> +
>  #include "media.h"
>  #include "tools.h"
> 
> @@ -245,6 +251,37 @@ static int media_enum_links(struct media_device
> *media) return ret;
>  }
> 
> +#ifdef HAVE_LIBUDEV
> +
> +static struct udev *udev;

I would move this to media_enum_entities() and pass the variable explicitly to 
media_get_devname(). I will make the change unless you want to resubmit the 
patch yourself.

> +
> +static int media_get_devname(struct media_entity *entity)
> +{
> +	dev_t devnum;
> +	struct udev_device *device;
> +	const char *p;
> +	int ret = -ENODEV;
> +
> +	if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE &&
> +	    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return 0;
> +
> +	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
> +	printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
> +	device = udev_device_new_from_devnum(udev, 'c', devnum);
> +	if (device) {
> +		p = udev_device_get_devnode(device);
> +		if (p)
> +			snprintf(entity->devname, sizeof(entity->devname), "%s", p);
> +		ret = 0;
> +	}
> +
> +	udev_device_unref(device);
> +	return ret;
> +}
> +
> +#else	/* HAVE_LIBUDEV */
> +
>  static int media_get_devname(struct media_entity *entity)
>  {
>  	struct stat devstat;
> @@ -284,6 +321,7 @@ static int media_get_devname(struct media_entity
> *entity)
> 
>  	return 0;
>  }
> +#endif	/* HAVE_LIBUDEV */
> 
>  static int media_enum_entities(struct media_device *media)
>  {
> @@ -292,6 +330,14 @@ static int media_enum_entities(struct media_device
> *media) __u32 id;
>  	int ret = 0;
> 
> +#ifdef HAVE_LIBUDEV
> +	udev = udev_new();
> +	if (udev == NULL) {
> +		printf("unable to allocate memory for context\n");
> +		return -ENOMEM;
> +	}
> +#endif	/* HAVE_LIBUDEV */
> +

If the code is compiled with libudev support enabled, but the target system 
has no udev, runtime failures will be experienced. Do you think it would be 
useful to fall back to the sysfs-based approach in that case ? Do you know 
which udev-related call would then fail ?

>  	for (id = 0; ; id = entity->info.id) {
>  		size = (media->entities_count + 1) * sizeof(*media->entities);
>  		media->entities = realloc(media->entities, size);
> @@ -327,6 +373,10 @@ static int media_enum_entities(struct media_device
> *media) media_get_devname(entity);
>  	}
> 
> +#ifdef HAVE_LIBUDEV
> +	udev_unref(udev);
> +	udev = NULL;
> +#endif
>  	return ret;
>  }

-- 
Regards,

Laurent Pinchart
