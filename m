Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40177 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2GZStI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 14:49:08 -0400
Received: by bkwj10 with SMTP id j10so1462666bkw.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 11:49:07 -0700 (PDT)
Message-ID: <5011911C.4070703@googlemail.com>
Date: Thu, 26 Jul 2012 20:49:00 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library Signed-off-by:
 Konke Radlow <kradlow@cisco.com>
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
In-Reply-To: <d4b6f91016e799647e929972c60c604f271fb188.1343237398.git.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/25/12 7:44 PM, Konke Radlow wrote:
> --- /dev/null
> +++ b/lib/libv4l2rds/Makefile.am
> @@ -0,0 +1,11 @@
> +if WITH_LIBV4L
> +lib_LTLIBRARIES = libv4l2rds.la
> +include_HEADERS = ../include/libv4l2rds.h
> +pkgconfig_DATA = libv4l2rds.pc
> +else
> +noinst_LTLIBRARIES = libv4l2rds.la
> +endif
> +
> +libv4l2rds_la_SOURCES = libv4l2rds.c
> +libv4l2rds_la_CPPFLAGS = -fvisibility=hidden $(ENFORCE_LIBV4L_STATIC) -std=c99
> +libv4l2rds_la_LDFLAGS = -version-info 0 -lpthread $(DLOPEN_LIBS) $(ENFORCE_LIBV4L_STATIC)

You don't call dlopen, so you can drop $(DLOPEN_LIBS)

