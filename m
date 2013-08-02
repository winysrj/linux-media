Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3318 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3HBMZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 08:25:23 -0400
Message-ID: <51FBA52A.6020302@xs4all.nl>
Date: Fri, 02 Aug 2013 14:25:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?QsOlcmQgRWlyaWsgV2ludGhlcg==?= <bwinther@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] qv4l2: add ALSA stream to qv4l2
References: <1375445137-19443-1-git-send-email-bwinther@cisco.com> <228d662aff38f8798b8bd23f1e8e4515b67dc03b.1375445112.git.bwinther@cisco.com>
In-Reply-To: <228d662aff38f8798b8bd23f1e8e4515b67dc03b.1375445112.git.bwinther@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bård!

Two small comments below...

On 08/02/2013 02:05 PM, Bård Eirik Winther wrote:
> Changes the ALSA streaming code to work with qv4l2 and allows it to
> be compiled in. qv4l2 does not use the streaming function yet.
> 
> Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> ---
>  configure.ac              |  6 ++++++
>  utils/qv4l2/Makefile.am   |  9 ++++++++-
>  utils/qv4l2/alsa_stream.c | 21 +++++++++++++++------
>  utils/qv4l2/alsa_stream.h | 13 ++++++++++---
>  4 files changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index d74da61..e12507e 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -136,6 +136,11 @@ if test "x$qt_pkgconfig_gl" = "xfalse"; then
>     AC_MSG_WARN(Qt4 OpenGL or higher is not available)
>  fi
>  
> +PKG_CHECK_MODULES(ALSA, [alsa], [alsa_pkgconfig=true], [alsa_pkgconfig=false])
> +if test "x$alsa_pkgconfig" = "xfalse"; then
> +   AC_MSG_WARN(ALSA library not available)
> +fi
> +
>  AC_SUBST([JPEG_LIBS])
>  
>  # The dlopen() function is in the C library for *BSD and in
> @@ -243,6 +248,7 @@ AM_CONDITIONAL([WITH_LIBV4L], [test x$enable_libv4l != xno])
>  AM_CONDITIONAL([WITH_V4LUTILS], [test x$enable_v4lutils != xno])
>  AM_CONDITIONAL([WITH_QV4L2], [test ${qt_pkgconfig} = true -a x$enable_qv4l2 != xno])
>  AM_CONDITIONAL([WITH_QV4L2_GL], [test WITH_QV4L2 -a ${qt_pkgconfig_gl} = true])
> +AM_CONDITIONAL([WITH_QV4L2_ALSA], [test WITH_QV4L2 -a ${alsa_pkgconfig} = true])
>  AM_CONDITIONAL([WITH_V4L_PLUGINS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
>  AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
>  
> diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
> index 22d4c17..eed25b0 100644
> --- a/utils/qv4l2/Makefile.am
> +++ b/utils/qv4l2/Makefile.am
> @@ -4,7 +4,8 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp
>    capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h \
>    raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
>  nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
> -qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
> +qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
> +  ../libmedia_dev/libmedia_dev.la
>  
>  if WITH_QV4L2_GL
>  qv4l2_CPPFLAGS = $(QTGL_CFLAGS) -DENABLE_GL
> @@ -14,6 +15,12 @@ qv4l2_CPPFLAGS = $(QT_CFLAGS)
>  qv4l2_LDFLAGS = $(QT_LIBS)
>  endif
>  
> +if WITH_QV4L2_ALSA
> +qv4l2_CPPFLAGS += $(ALSA_CFLAGS) -DENABLE_ALSA
> +qv4l2_LDFLAGS += $(ALSA_LIBS) -pthread
> +qv4l2_SOURCES += alsa_stream.c alsa_stream.h
> +endif
> +
>  EXTRA_DIST = exit.png fileopen.png qv4l2_24x24.png qv4l2_64x64.png qv4l2.png qv4l2.svg snapshot.png \
>    video-television.png fileclose.png qv4l2_16x16.png qv4l2_32x32.png qv4l2.desktop qv4l2.qrc record.png \
>    saveraw.png qv4l2.pro
> diff --git a/utils/qv4l2/alsa_stream.c b/utils/qv4l2/alsa_stream.c
> index 3e33b5e..90d3afb 100644
> --- a/utils/qv4l2/alsa_stream.c
> +++ b/utils/qv4l2/alsa_stream.c
> @@ -26,9 +26,7 @@
>   *
>   */
>  
> -#include "config.h"
> -
> -#ifdef HAVE_ALSA_ASOUNDLIB_H
> +#include "alsa_stream.h"
>  
>  #include <stdio.h>
>  #include <stdlib.h>
> @@ -40,12 +38,12 @@
>  #include <alsa/asoundlib.h>
>  #include <sys/time.h>
>  #include <math.h>
> -#include "alsa_stream.h"
>  
>  #define ARRAY_SIZE(a) (sizeof(a)/sizeof(*(a)))
>  
>  /* Private vars to control alsa thread status */
>  static int stop_alsa = 0;
> +static snd_htimestamp_t timestamp;
>  
>  /* Error handlers */
>  snd_output_t *output = NULL;
> @@ -422,7 +420,8 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
>  static snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len)
>  {
>      snd_pcm_sframes_t r;
> -
> +    snd_pcm_uframes_t frames;
> +    snd_pcm_htimestamp(handle, &frames, &timestamp);
>      r = snd_pcm_readi(handle, buf, len);
>      if (r < 0 && r != -EAGAIN) {
>  	r = snd_pcm_recover(handle, r, 0);
> @@ -453,6 +452,7 @@ static snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len)
>  	len -= r;
>  	snd_pcm_wait(handle, 100);
>      }
> +    return -1;
>  }
>  
>  static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
> @@ -642,4 +642,13 @@ int alsa_thread_is_running(void)
>      return alsa_is_running;
>  }
>  
> -#endif
> +void alsa_thread_timestamp(struct timeval *tv)
> +{
> +	if (alsa_thread_is_running()) {
> +		tv->tv_sec = timestamp.tv_sec;
> +		tv->tv_usec = timestamp.tv_nsec / 1000;
> +	} else {
> +		tv->tv_sec = 1337;

Why 1337? I would expect either 0, or a bool return from this function to signify that there
is no valid timestamp.

> +		tv->tv_usec = 0;
> +	}
> +}
> diff --git a/utils/qv4l2/alsa_stream.h b/utils/qv4l2/alsa_stream.h
> index c68fd6d..b74c3aa 100644
> --- a/utils/qv4l2/alsa_stream.h
> +++ b/utils/qv4l2/alsa_stream.h
> @@ -1,5 +1,12 @@
> -int alsa_thread_startup(const char *pdevice, const char *cdevice, int latency,
> -			FILE *__error_fp,
> -			int __verbose);
> +#ifndef ALSA_STRAM_H
> +#define ALSA_STRAM_H

A small typo: STRAM -> STREAM

> +
> +#include <stdio.h>
> +#include <sys/time.h>
> +
> +int alsa_thread_startup(const char *pdevice, const char *cdevice,
> +			int latency, FILE *__error_fp, int __verbose);
>  void alsa_thread_stop(void);
>  int alsa_thread_is_running(void);
> +void alsa_thread_timestamp(struct timeval *tv);
> +#endif
> 

Regards,

	Hans
