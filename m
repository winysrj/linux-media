Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46560 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3HBWT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 18:19:57 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so570459eek.18
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 15:19:56 -0700 (PDT)
Message-ID: <51FC308A.1080406@googlemail.com>
Date: Sat, 03 Aug 2013 00:19:54 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: =?UTF-8?B?QsOlcmQgRWlyaWsgV2ludGhlcg==?= <bwinther@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] qv4l2: add ALSA stream to qv4l2
References: <1375445137-19443-1-git-send-email-bwinther@cisco.com> <228d662aff38f8798b8bd23f1e8e4515b67dc03b.1375445112.git.bwinther@cisco.com>
In-Reply-To: <228d662aff38f8798b8bd23f1e8e4515b67dc03b.1375445112.git.bwinther@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

> diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
> index 22d4c17..eed25b0 100644
> --- a/utils/qv4l2/Makefile.am
> +++ b/utils/qv4l2/Makefile.am
> @@ -4,7 +4,8 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp
>     capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h \
>     raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
>   nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
> -qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
> +qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
> +  ../libmedia_dev/libmedia_dev.la
>
>   if WITH_QV4L2_GL
>   qv4l2_CPPFLAGS = $(QTGL_CFLAGS) -DENABLE_GL
> @@ -14,6 +15,12 @@ qv4l2_CPPFLAGS = $(QT_CFLAGS)
>   qv4l2_LDFLAGS = $(QT_LIBS)
>   endif
>
> +if WITH_QV4L2_ALSA
> +qv4l2_CPPFLAGS += $(ALSA_CFLAGS) -DENABLE_ALSA

I would prefer if you don't add another define to the command line. To 
check for ALSA support please include config.h and use the flag provided 
there.

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

unimportant typo here

Thanks,
Gregor

