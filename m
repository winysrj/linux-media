Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f53.google.com ([209.85.216.53]:39691 "EHLO
	mail-vn0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbbEFPJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 11:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <1430915838-20547-1-git-send-email-k.debski@samsung.com>
References: <1430915838-20547-1-git-send-email-k.debski@samsung.com>
Date: Wed, 6 May 2015 16:09:19 +0100
Message-ID: <CACvgo52weKaFL44jbYiWTeQDFv9WqFNXFW+RMhPp4kcPt7L6cw@mail.gmail.com>
Subject: Re: [PATCH v3] libgencec: Add userspace library for the generic CEC
 kernel interface
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: ML dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, sean@mess.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>, lars@opdenkamp.eu
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

There are a couple of bits that I've missed out previously. All but
the missing install of libgencec.pc are general cleanups.

On 6 May 2015 at 13:37, Kamil Debski <k.debski@samsung.com> wrote:

> --- /dev/null
> +++ b/.gitignore
> @@ -0,0 +1,26 @@

> +/ar-lib
You can drop this (see the configure.ac note).

> +/aclocal.m4
> +/autom4te.cache/*
> +/config.*
> +/configure
> +/depcomp
> +/install-sh
> +/missing
Normally one can drop the leading forward slash in .gitignore files.
This way git won't bother if you build in a subdirectory - for example
$(project_top)/build.

> +/examples/.deps/*
> +/examples/.libs/*
> +src/.deps/*
> +src/.libs/*
One can replace these four with
.deps/
.libs/

> +/examples/cectest
echo cectest > examples/.gitignore


> --- /dev/null
> +++ b/Makefile.am
> @@ -0,0 +1,4 @@
> +SUBDIRS = src examples
> +ACLOCAL_AMFLAGS = -I m4
> +library_includedir=$(includedir)
> +library_include_HEADERS = include/gencec.h
We want to install the pc file. Otherwise one cannot really use it.

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libgencec.pc


> --- /dev/null
> +++ b/configure.ac
> @@ -0,0 +1,27 @@
> +AC_PREREQ(2.60)
> +
> +AC_INIT([libgencec], [0.1], [k.debski@samsung.com])
> +AM_INIT_AUTOMAKE([-Wall -Werror foreign])
> +
> +AC_PROG_CC
> +AM_PROG_AR
There is not plan to use the library on Windows is there ? If so we
can remove this as per the manual [1].

"You must use this macro when you use the archiver in your project, if
you want support for unusual archivers such as Microsoft lib"

Cheers,
Emil

[1] http://www.gnu.org/software/automake/manual/html_node/Public-Macros.html
