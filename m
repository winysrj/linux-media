Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:57512 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753691AbdHWLGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 07:06:18 -0400
Subject: Re: [PATCH v4l-utils] configure.ac: drop --disable-libv4l, disable
 plugin support instead
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
References: <20170821210206.21055-1-thomas.petazzoni@free-electrons.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eb9e0ad2-1003-f861-9cc0-7bdb77939af8@xs4all.nl>
Date: Wed, 23 Aug 2017 13:06:13 +0200
MIME-Version: 1.0
In-Reply-To: <20170821210206.21055-1-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/17 23:02, Thomas Petazzoni wrote:
> In commit 2e604dfbcd09b93f0808cedb2a0b324c5569a599 ("configure.ac: add
> --disable-libv4l option"), an option --disable-libv4l was added. As
> part of this, libv4l is no longer built at all in static linking
> configurations, just because libv4l uses dlopen() for plugin support.
> 
> However, plugin support is only a side feature of libv4l, and one may
> need to use libv4l in static configurations, just without plugin
> support.
> 
> Therefore, this commit:
> 
>  - Essentially reverts 2e604dfbcd09b93f0808cedb2a0b324c5569a599, so
>    that libv4l can be built in static linking configurations again.
> 
>  - Adjusts the compilation of libv4l2 so that the plugin support is
>    not compiled in when dlopen() in static linking configuration
>    (dlopen is not available).
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
> NOTE: this was only build-time tested, not runtime tested.

Hugues, can you test this to make sure this still does what you need?

It looks good to me, but I'd like to make sure it works for you as well
before committing this.

Thanks!

	Hans

> ---
>  Makefile.am                       | 11 ++---------
>  configure.ac                      | 15 +++------------
>  lib/libv4l2/Makefile.am           |  6 +++++-
>  lib/libv4l2/libv4l2-priv.h        | 14 ++++++++++++++
>  utils/Makefile.am                 |  6 +-----
>  utils/v4l2-compliance/Makefile.am |  4 ----
>  utils/v4l2-ctl/Makefile.am        |  4 ----
>  7 files changed, 25 insertions(+), 35 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 07c3ef8..e603472 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,17 +1,10 @@
>  AUTOMAKE_OPTIONS = foreign
>  ACLOCAL_AMFLAGS = -I m4
>  
> -SUBDIRS = v4l-utils-po libdvbv5-po
> -
> -if WITH_LIBV4L
> -SUBDIRS += lib
> -endif
> +SUBDIRS = v4l-utils-po libdvbv5-po lib
>  
>  if WITH_V4LUTILS
> -SUBDIRS += utils
> -if WITH_LIBV4L
> -SUBDIRS += contrib
> -endif
> +SUBDIRS += utils contrib
>  endif
>  
>  EXTRA_DIST = android-config.h bootstrap.sh doxygen_libdvbv5.cfg include COPYING.libv4l \
> diff --git a/configure.ac b/configure.ac
> index 72c9421..af44663 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -375,14 +375,6 @@ AC_ARG_ENABLE(libdvbv5,
>     esac]
>  )
>  
> -AC_ARG_ENABLE(libv4l,
> -  AS_HELP_STRING([--disable-libv4l], [disable libv4l compilation]),
> -  [case "${enableval}" in
> -     yes | no ) ;;
> -     *) AC_MSG_ERROR(bad value ${enableval} for --disable-libv4l) ;;
> -   esac]
> -)
> -
>  AC_ARG_ENABLE(dyn-libv4l,
>    AS_HELP_STRING([--disable-dyn-libv4l], [disable dynamic libv4l support]),
>    [case "${enableval}" in
> @@ -448,7 +440,6 @@ AM_CONDITIONAL([WITH_LIBDVBV5],     [test x$enable_libdvbv5  != xno -a x$have_li
>  AM_CONDITIONAL([WITH_DVBV5_REMOTE], [test x$enable_libdvbv5  != xno -a x$have_libudev = xyes -a x$have_pthread = xyes])
>  
>  AM_CONDITIONAL([WITH_DYN_LIBV4L],   [test x$enable_dyn_libv4l != xno])
> -AM_CONDITIONAL([WITH_LIBV4L],       [test x$enable_libv4l    != xno -a x$enable_shared != xno])
>  AM_CONDITIONAL([WITH_V4LUTILS],	    [test x$enable_v4l_utils != xno -a x$linux_os = xyes])
>  AM_CONDITIONAL([WITH_QV4L2],	    [test x${qt_pkgconfig} = xtrue -a x$enable_qv4l2 != xno])
>  AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_dyn_libv4l != xno -a x$enable_shared != xno])
> @@ -477,11 +468,12 @@ AM_COND_IF([WITH_LIBDVBV5], [USE_LIBDVBV5="yes"], [USE_LIBDVBV5="no"])
>  AM_COND_IF([WITH_DVBV5_REMOTE], [USE_DVBV5_REMOTE="yes"
>  				 AC_DEFINE([HAVE_DVBV5_REMOTE], [1], [Usage of DVBv5 remote enabled])],
>  			        [USE_DVBV5_REMOTE="no"])
> -AM_COND_IF([WITH_LIBV4L], [USE_LIBV4L="yes"], [USE_LIBV4L="no"])
>  AM_COND_IF([WITH_DYN_LIBV4L], [USE_DYN_LIBV4L="yes"], [USE_DYN_LIBV4L="no"])
>  AM_COND_IF([WITH_V4LUTILS], [USE_V4LUTILS="yes"], [USE_V4LUTILS="no"])
>  AM_COND_IF([WITH_QV4L2], [USE_QV4L2="yes"], [USE_QV4L2="no"])
> -AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"], [USE_V4L_PLUGINS="no"])
> +AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"
> +				AC_DEFINE([HAVE_V4L_PLUGINS], [1], [V4L plugin support enabled])],
> +				[USE_V4L_PLUGINS="no"])
>  AM_COND_IF([WITH_V4L_WRAPPERS], [USE_V4L_WRAPPERS="yes"], [USE_V4L_WRAPPERS="no"])
>  AM_COND_IF([WITH_GCONV], [USE_GCONV="yes"], [USE_GCONV="no"])
>  AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL_LIBV4L="yes"], [USE_V4L2_CTL_LIBV4L="no"])
> @@ -513,7 +505,6 @@ compile time options summary
>  
>      gconv                      : $USE_GCONV
>  
> -    libv4l                     : $USE_LIBV4L
>      dynamic libv4l             : $USE_DYN_LIBV4L
>      v4l_plugins                : $USE_V4L_PLUGINS
>      v4l_wrappers               : $USE_V4L_WRAPPERS
> diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
> index 811c45c..3a1bb90 100644
> --- a/lib/libv4l2/Makefile.am
> +++ b/lib/libv4l2/Makefile.am
> @@ -15,7 +15,11 @@ else
>  noinst_LTLIBRARIES = libv4l2.la
>  endif
>  
> -libv4l2_la_SOURCES = libv4l2.c v4l2-plugin.c log.c libv4l2-priv.h
> +libv4l2_la_SOURCES = libv4l2.c log.c libv4l2-priv.h
> +if WITH_V4L_PLUGINS
> +libv4l2_la_SOURCES += v4l2-plugin.c
> +endif
> +
>  libv4l2_la_CPPFLAGS = $(CFLAG_VISIBILITY) $(ENFORCE_LIBV4L_STATIC)
>  libv4l2_la_LDFLAGS = $(LIBV4L2_VERSION) -lpthread $(DLOPEN_LIBS) $(ENFORCE_LIBV4L_STATIC)
>  libv4l2_la_LIBADD = ../libv4lconvert/libv4lconvert.la
> diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
> index 343db5e..1924c91 100644
> --- a/lib/libv4l2/libv4l2-priv.h
> +++ b/lib/libv4l2/libv4l2-priv.h
> @@ -107,10 +107,24 @@ struct v4l2_dev_info {
>  };
>  
>  /* From v4l2-plugin.c */
> +#if defined(HAVE_V4L_PLUGINS)
>  void v4l2_plugin_init(int fd, void **plugin_lib_ret, void **plugin_priv_ret,
>  		      const struct libv4l_dev_ops **dev_ops_ret);
>  void v4l2_plugin_cleanup(void *plugin_lib, void *plugin_priv,
>  			 const struct libv4l_dev_ops *dev_ops);
> +#else
> +static inline void v4l2_plugin_init(int fd, void **plugin_lib_ret, void **plugin_priv_ret,
> +				    const struct libv4l_dev_ops **dev_ops_ret)
> +{
> +	*dev_ops_ret = v4lconvert_get_default_dev_ops();
> +	*plugin_lib_ret = NULL;
> +	*plugin_priv_ret = NULL;
> +}
> +static inline void v4l2_plugin_cleanup(void *plugin_lib, void *plugin_priv,
> +				       const struct libv4l_dev_ops *dev_ops)
> +{
> +}
> +#endif /* WITH_V4L_PLUGINS */
>  
>  /* From log.c */
>  extern const char *v4l2_ioctls[];
> diff --git a/utils/Makefile.am b/utils/Makefile.am
> index ce710c2..d7708cc 100644
> --- a/utils/Makefile.am
> +++ b/utils/Makefile.am
> @@ -13,12 +13,8 @@ SUBDIRS = \
>  	v4l2-sysfs-path \
>  	cec-ctl \
>  	cec-compliance \
> -	cec-follower
> -
> -if WITH_LIBV4L
> -SUBDIRS += \
> +	cec-follower \
>  	rds-ctl
> -endif
>  
>  if WITH_LIBDVBV5
>  SUBDIRS += \
> diff --git a/utils/v4l2-compliance/Makefile.am b/utils/v4l2-compliance/Makefile.am
> index 0671fda..58bad86 100644
> --- a/utils/v4l2-compliance/Makefile.am
> +++ b/utils/v4l2-compliance/Makefile.am
> @@ -7,16 +7,12 @@ v4l2_compliance_SOURCES = v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-inpu
>  	v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-compliance.h
>  v4l2_compliance_CPPFLAGS = -I$(top_srcdir)/utils/common
>  
> -if WITH_LIBV4L
>  if WITH_V4L2_COMPLIANCE_LIBV4L
>  v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
>  else
>  v4l2_compliance_LDADD = -lrt -lpthread
>  DEFS += -DNO_LIBV4L2
>  endif
> -else
> -DEFS += -DNO_LIBV4L2
> -endif
>  
>  EXTRA_DIST = Android.mk fixme.txt v4l2-compliance.1
>  
> diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
> index cae4e74..83fa49a 100644
> --- a/utils/v4l2-ctl/Makefile.am
> +++ b/utils/v4l2-ctl/Makefile.am
> @@ -9,15 +9,11 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
>  	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp
>  v4l2_ctl_CPPFLAGS = -I$(top_srcdir)/utils/common
>  
> -if WITH_LIBV4L
>  if WITH_V4L2_CTL_LIBV4L
>  v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
>  else
>  DEFS += -DNO_LIBV4L2
>  endif
> -else
> -DEFS += -DNO_LIBV4L2
> -endif
>  
>  if !WITH_V4L2_CTL_STREAM_TO
>  DEFS += -DNO_STREAM_TO
> 
