Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45162 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab1H3TNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 15:13:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [media-ctl][PATCHv2 3/4] libmediactl: use udev conditionally to get a devname
Date: Tue, 30 Aug 2011 21:14:13 +0200
Cc: linux-media@vger.kernel.org
References: <201108151652.54417.laurent.pinchart@ideasonboard.com> <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com> <3fa73211e84c4b2e70d4777e3664954948042d64.1313490446.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <3fa73211e84c4b2e70d4777e3664954948042d64.1313490446.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108302114.14136.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

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
> have_libudev=no)],
> +    [have_libudev=no])

I don't think this works when cross-compiling.

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

-- 
Regards,

Laurent Pinchart
