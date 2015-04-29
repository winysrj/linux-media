Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f47.google.com ([209.85.216.47]:43465 "EHLO
	mail-vn0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423246AbbD2PAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 11:00:20 -0400
MIME-Version: 1.0
In-Reply-To: <1430301765-22202-13-git-send-email-k.debski@samsung.com>
References: <1430301765-22202-1-git-send-email-k.debski@samsung.com>
	<1430301765-22202-13-git-send-email-k.debski@samsung.com>
Date: Wed, 29 Apr 2015 16:00:19 +0100
Message-ID: <CACvgo52hDYpgv2FY8X-O7SC=+2YMn7osHt_V=NJxP+4REaw1=Q@mail.gmail.com>
Subject: Re: [PATCH] libgencec: Add userspace library for the generic CEC
 kernel interface
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: ML dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>, sean@mess.org,
	mchehab@osg.samsung.com, dmitry.torokhov@gmail.com,
	lars@opdenkamp.eu, Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, linux-input@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Allow me to put a few suggestions:

On 29 April 2015 at 11:02, Kamil Debski <k.debski@samsung.com> wrote:
> This is the first version of the libGenCEC library. It was designed to
> act as an interface between the generic CEC kernel API and userspace
> applications. It provides a simple interface for applications and an
> example application that can be used to test the CEC functionality.
>
> signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  AUTHORS              |    1 +
>  INSTALL              |    9 +
>  LICENSE              |  202 ++++++++++++++++
>  Makefile.am          |    4 +
>  README               |   22 ++
>  configure.ac         |   24 ++
>  doc/index.html       |  345 +++++++++++++++++++++++++++
>  examples/Makefile.am |    4 +
>  examples/cectest.c   |  631 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/gencec.h     |  255 ++++++++++++++++++++
>  src/Makefile.am      |    4 +
>  src/gencec.c         |  445 +++++++++++++++++++++++++++++++++++
>  12 files changed, 1946 insertions(+)
>  create mode 100644 AUTHORS
>  create mode 100644 INSTALL
>  create mode 100644 LICENSE
>  create mode 100644 Makefile.am
>  create mode 100644 README
>  create mode 100644 configure.ac
>  create mode 100644 doc/index.html
>  create mode 100644 examples/Makefile.am
>  create mode 100644 examples/cectest.c
>  create mode 100644 include/gencec.h
>  create mode 100644 m4/.gitkeep
>  create mode 100644 src/Makefile.am
>  create mode 100644 src/gencec.c
>
> diff --git a/AUTHORS b/AUTHORS
> new file mode 100644
> index 0000000..e4b7117
> --- /dev/null
> +++ b/AUTHORS
> @@ -0,0 +1 @@
> +Kamil Debski <k.debski@samsung.com>
> diff --git a/INSTALL b/INSTALL
> new file mode 100644
> index 0000000..aac6101
> --- /dev/null
> +++ b/INSTALL
> @@ -0,0 +1,9 @@
> +To install libgencec run following commands:
> +
> +autoreconf -i
You might want add --force in here, otherwise the files will stay
as-is if you update libtool and friends "mid-flight".
Many projects include autogen.sh like the following. Feel free to add
it to libgencec.

$cat autogen.sh
#! /bin/sh

srcdir=`dirname "$0"`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd "$srcdir"

autoreconf --force --verbose --install || exit 1
cd "$ORIGDIR" || exit $?

if test -z "$NOCONFIGURE"; then
    "$srcdir"/configure "$@"
fi



> --- /dev/null
> +++ b/configure.ac
> @@ -0,0 +1,24 @@

You can save yourself some headaches if you restrict old and/or buggy
autoconf versions which don't work with the project.
If I have to guess 2.60 should be ok.
AC_PREREQ([XXX])

> +AC_INIT([libgencec], [0.1], [k.debski@samsung.com])
> +AM_INIT_AUTOMAKE([-Wall -Werror foreign])
> +
> +AC_PROG_CC
> +AM_PROG_AR
> +AC_CONFIG_MACRO_DIR([m4])
> +AC_DEFINE([_GNU_SOURCE], [], [Use GNU extensions])
> +

Same for libtool - 2.2 perhaps ?
LT_PREREQ([XXX])

> +LT_INIT
> +
> +# Checks for typedefs, structures, and compiler characteristics.
> +AC_C_INLINE
> +AC_TYPE_SIZE_T
> +AC_TYPE_UINT16_T
> +AC_TYPE_UINT32_T
> +AC_TYPE_UINT8_T
> +
> +#AC_CHECK_LIB([c], [malloc])
> +# Checks for library functions.
> +#AC_FUNC_MALLOC
> +
> +AC_CONFIG_FILES([Makefile src/Makefile examples/Makefile])
Would be nice if the library provides libgencec.pc file. This way any
users can avoid the explicit header/library check, amongst other
useful bits.

> --- /dev/null
> +++ b/examples/Makefile.am
> @@ -0,0 +1,4 @@
> +bin_PROGRAMS = cectest
> +cectest_SOURCES = cectest.c
> +AM_CPPFLAGS=-I$(top_srcdir)/include/
> +AM_LDFLAGS=-L../src/ -lgencec
The following seems more common (in the projects I've seen at least)
cectest_LDADD = $(top_builddir)/src/libgencec.la

> diff --git a/m4/.gitkeep b/m4/.gitkeep
> new file mode 100644
> index 0000000..e69de29
Haven't seen any projects doing this. Curious what the benefits of
keeping and empty folder might be ?

> diff --git a/src/Makefile.am b/src/Makefile.am
> new file mode 100644
> index 0000000..cb024f0
> --- /dev/null
> +++ b/src/Makefile.am
> @@ -0,0 +1,4 @@
> +lib_LTLIBRARIES = libgencec.la
> +libgencec_la_SOURCES = gencec.c
> +libgencec_la_LDFLAGS = -version-info 0:1:0
You might want to add -no-undefined in order to prevent having a
library with unresolved symbols.

Hope you find the above useful :-)

Cheers
Emil
