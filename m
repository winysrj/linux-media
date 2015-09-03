Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33980 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbbICRkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 13:40:22 -0400
Date: Thu, 3 Sep 2015 14:40:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, gjasny@googlemail.com,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 2/2] v4l-utils: allow building even if argp.h is not
 present
Message-ID: <20150903144016.4c6f9dce@recife.lan>
In-Reply-To: <dd3bbf524477c868636605620b34a7acb32b1238.1441293195.git.hansverk@cisco.com>
References: <1441293796-16972-1-git-send-email-hverkuil@xs4all.nl>
	<dd3bbf524477c868636605620b34a7acb32b1238.1441293195.git.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  3 Sep 2015 17:23:16 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hansverk@cisco.com>
> 
> The argp.h functionality is not always available on embedded systems
> (android!). A number of utilities depend on this and running configure
> will fail if argp.h is missing.
> 
> Add a new configure option --without-argp to disable that argp.h check
> and instead skip any utilities that use argp.h.

Not sure about this patch. Maybe the better would be to see if we could
add a poor man's argp, instead, for those broken userspace systems.

Weird enough, a quick search on Google for "argp replacement android"
actually showed an argp.h at some android source:
	https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.7-4.6/+/jb-dev/sysroot/usr/include/argp.h

This site has an standalone argp imported from glibc-2.2, according
with its ChangeLog:
	https://github.com/jahrome/argp-standalone

Static linking an standalone version is a little ugly. So, wee can do
something simpler than that, as there is just one important function at
argp: the one that calls a callback that will handle the command line
options (argp_parse). This can be trivial to be implemented, specially 
if it would handle just the one letter parameters, as it would be just
a callback.

It can just ignore the help message functions like argp_help(), 
giving some error message and giving up.

Eventually, just a small set of inline functions, plus adding the
argp structures on a header would be enough.

Regards,
Mauro

> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  configure.ac             | 22 ++++++++++++++++------
>  contrib/test/Makefile.am |  7 ++++++-
>  utils/Makefile.am        | 11 +++++++----
>  3 files changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 13df263..d645386 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -270,14 +270,24 @@ dl_saved_libs=$LIBS
>    AC_SUBST([DLOPEN_LIBS])
>  LIBS=$dl_saved_libs
>  
> -AC_CHECK_HEADER([argp.h],,AC_MSG_ERROR(Cannot continue: argp.h not found))
> +AC_ARG_WITH([argp],
> +            AS_HELP_STRING([--without-argp], [Do not use argp.h]),
> +            [],
> +            [with_argp=yes])
> +
>  argp_saved_libs=$LIBS
> -  AC_SEARCH_LIBS([argp_parse],
> -                 [argp],
> -                 [test "$ac_cv_search_argp_parse" = "none required" || ARGP_LIBS=$ac_cv_search_argp_parse],
> -                 [AC_MSG_ERROR([unable to find the argp_parse() function])])
> -  AC_SUBST([ARGP_LIBS])
> +AS_IF([test "x$with_argp" != xno],
> +      [
> +          AC_CHECK_HEADER([argp.h],,AC_MSG_ERROR(Cannot continue: argp.h not found))]
> +	  AC_SEARCH_LIBS([argp_parse],
> +			 [argp],
> +			 [test "$ac_cv_search_argp_parse" = "none required" || ARGP_LIBS=$ac_cv_search_argp_parse],
> +			 [AC_MSG_ERROR([unable to find the argp_parse() function])])
> +	  AC_SUBST([ARGP_LIBS])
> +      ],
> +      )
>  LIBS=$argp_saved_libs
> +AM_CONDITIONAL([HAVE_ARGP], [test "x$with_argp" != xno])
>  
>  AC_CHECK_HEADER([linux/i2c-dev.h], [linux_i2c_dev=yes], [linux_i2c_dev=no])
>  AM_CONDITIONAL([HAVE_LINUX_I2C_DEV], [test x$linux_i2c_dev = xyes])
> diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
> index 7f84435..f223f68 100644
> --- a/contrib/test/Makefile.am
> +++ b/contrib/test/Makefile.am
> @@ -2,7 +2,6 @@ noinst_PROGRAMS = \
>  	ioctl-test		\
>  	sliced-vbi-test		\
>  	sliced-vbi-detect	\
> -	v4l2grab		\
>  	driver-test		\
>  	stress-buffer		\
>  	capture-example
> @@ -12,8 +11,14 @@ noinst_PROGRAMS += pixfmt-test
>  endif
>  
>  if HAVE_GLU
> +if HAVE_ARGP
>  noinst_PROGRAMS += v4l2gl
>  endif
> +endif
> +
> +if HAVE_ARGP
> +noinst_PROGRAMS += v4l2grab
> +endif
>  
>  driver_test_SOURCES = driver-test.c
>  driver_test_LDADD = ../../utils/libv4l2util/libv4l2util.la
> diff --git a/utils/Makefile.am b/utils/Makefile.am
> index 5674c16..5645d55 100644
> --- a/utils/Makefile.am
> +++ b/utils/Makefile.am
> @@ -1,16 +1,12 @@
>  SUBDIRS = \
> -	dvb \
>  	libv4l2util \
>  	libmedia_dev \
> -	decode_tm6000 \
>  	ivtv-ctl \
>  	cx18-ctl \
> -	keytable \
>  	media-ctl \
>  	v4l2-compliance \
>  	v4l2-ctl \
>  	v4l2-dbg \
> -	v4l2-sysfs-path \
>  	rds-ctl
>  
>  if LINUX_OS
> @@ -27,3 +23,10 @@ if WITH_QV4L2
>  SUBDIRS += qv4l2
>  endif
>  
> +if HAVE_ARGP
> +SUBDIRS += \
> +	dvb \
> +	keytable \
> +	decode_tm6000 \
> +	v4l2-sysfs-path
> +endif
