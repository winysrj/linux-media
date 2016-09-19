Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53290
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbcISOV4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 10:21:56 -0400
Date: Mon, 19 Sep 2016 11:21:50 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, gjasny@googlemail.com
Subject: Re: [v4l-utils PATCH 2/2] Add --with-static-binaries option to link
 binaries statically
Message-ID: <20160919112150.4c3eef98@vento.lan>
In-Reply-To: <1474291350-15655-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
        <1474291350-15655-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Sep 2016 16:22:30 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Add a new variable STATIC_LDFLAGS to add the linker flags required for
> static linking for each binary built.
> 
> Static and dynamic libraries are built by default but the binaries are
> otherwise linked dynamically. --with-static-binaries requires that static
> libraries are built.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  configure.ac                      |  5 +++++
>  contrib/gconv/Makefile.am         |  4 ++--
>  contrib/test/Makefile.am          |  8 ++++----
>  lib/libv4l1/Makefile.am           |  2 +-
>  lib/libv4l2/Makefile.am           |  2 +-
>  utils/cec-compliance/Makefile.am  |  2 +-
>  utils/cec-ctl/Makefile.am         |  1 +
>  utils/cec-follower/Makefile.am    |  2 +-
>  utils/cx18-ctl/Makefile.am        |  1 +
>  utils/decode_tm6000/Makefile.am   |  2 +-
>  utils/dvb/Makefile.am             | 10 +++++-----
>  utils/ir-ctl/Makefile.am          |  2 +-
>  utils/ivtv-ctl/Makefile.am        |  2 +-
>  utils/keytable/Makefile.am        |  2 +-
>  utils/media-ctl/Makefile.am       |  1 +
>  utils/qv4l2/Makefile.am           |  6 +++---
>  utils/rds-ctl/Makefile.am         |  2 +-
>  utils/v4l2-compliance/Makefile.am |  1 +
>  utils/v4l2-ctl/Makefile.am        |  1 +
>  utils/v4l2-sysfs-path/Makefile.am |  2 +-
>  20 files changed, 34 insertions(+), 24 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 0d416b0..91597a4 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -427,6 +427,11 @@ AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x${enable_v4l2_compliance_li
>  # append -static to libtool compile and link command to enforce static libs
>  AS_IF([test x$enable_libdvbv5 = xno], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
>  AS_IF([test x$enable_libv4l = xno],   [AC_SUBST([ENFORCE_LIBV4L_STATIC],   ["-static"])])
> +AC_ARG_WITH([static-binaries], AS_HELP_STRING([--with-static-binaries], [link binaries statically, requires static libraries to be built]))
> +AS_IF([test x$with_static_binaries = xyes],
> +      [AS_IF([test x$enable_static = xno],
> +	     [AC_MSG_ERROR([--with-static-binaries requires --enable-static])])]
> +      [AC_SUBST([STATIC_LDFLAGS], ["--static -static"])])
>  
>  # misc
>  
> diff --git a/contrib/gconv/Makefile.am b/contrib/gconv/Makefile.am
> index 0e89f5b..2a39e5e 100644
> --- a/contrib/gconv/Makefile.am
> +++ b/contrib/gconv/Makefile.am
> @@ -9,9 +9,9 @@ gconv_base_sources = iconv/skeleton.c iconv/loop.c
>  arib-std-b24.c, en300-468-tab00.c: $(gconv_base_sources)
>  
>  ARIB_STD_B24_la_SOURCES = arib-std-b24.c jis0201.h jis0208.h jisx0213.h
> -ARIB_STD_B24_la_LDFLAGS = $(gconv_ldflags) -L@gconvsysdir@ -R @gconvsysdir@ -lJIS -lJISX0213
> +ARIB_STD_B24_la_LDFLAGS = $(gconv_ldflags) -L@gconvsysdir@ -R @gconvsysdir@ -lJIS -lJISX0213 $(STATIC_LDFLAGS)

Instead of adding STATIC_LDFLAGS to all LDFLAGS, wouldn't be better to
add the flags to LDFLAGS on configure.ac?

Regards,
Mauro
