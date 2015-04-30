Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15790 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbD3KZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 06:25:15 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Emil Velikov' <emil.l.velikov@gmail.com>
Cc: 'ML dri-devel' <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org,
	"'moderated list:ARM/S5P EXYNOS AR...'"
	<linux-samsung-soc@vger.kernel.org>, sean@mess.org,
	mchehab@osg.samsung.com, dmitry.torokhov@gmail.com,
	lars@opdenkamp.eu, 'Kyungmin Park' <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, linux-input@vger.kernel.org,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
References: <1430301765-22202-1-git-send-email-k.debski@samsung.com>
 <1430301765-22202-13-git-send-email-k.debski@samsung.com>
 <CACvgo52hDYpgv2FY8X-O7SC=+2YMn7osHt_V=NJxP+4REaw1=Q@mail.gmail.com>
In-reply-to: <CACvgo52hDYpgv2FY8X-O7SC=+2YMn7osHt_V=NJxP+4REaw1=Q@mail.gmail.com>
Subject: RE: [PATCH] libgencec: Add userspace library for the generic CEC
 kernel interface
Date: Thu, 30 Apr 2015 12:25:11 +0200
Message-id: <"0af301d0832f$f0ffec70$d2ffc550$@debski"@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Emil,

From: linux-media-owner@vger.kernel.org [mailto:linux-media-
owner@vger.kernel.org] On Behalf Of Emil Velikov
Sent: Wednesday, April 29, 2015 5:00 PM
> 
> Hi Kamil,
> 
> Allow me to put a few suggestions:
> 
> On 29 April 2015 at 11:02, Kamil Debski <k.debski@samsung.com> wrote:
> > This is the first version of the libGenCEC library. It was designed
> to
> > act as an interface between the generic CEC kernel API and userspace
> > applications. It provides a simple interface for applications and an
> > example application that can be used to test the CEC functionality.
> >
> > signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  AUTHORS              |    1 +
> >  INSTALL              |    9 +
> >  LICENSE              |  202 ++++++++++++++++
> >  Makefile.am          |    4 +
> >  README               |   22 ++
> >  configure.ac         |   24 ++
> >  doc/index.html       |  345 +++++++++++++++++++++++++++
> >  examples/Makefile.am |    4 +
> >  examples/cectest.c   |  631
> ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/gencec.h     |  255 ++++++++++++++++++++
> >  src/Makefile.am      |    4 +
> >  src/gencec.c         |  445 +++++++++++++++++++++++++++++++++++
> >  12 files changed, 1946 insertions(+)
> >  create mode 100644 AUTHORS
> >  create mode 100644 INSTALL
> >  create mode 100644 LICENSE
> >  create mode 100644 Makefile.am
> >  create mode 100644 README
> >  create mode 100644 configure.ac
> >  create mode 100644 doc/index.html
> >  create mode 100644 examples/Makefile.am  create mode 100644
> > examples/cectest.c  create mode 100644 include/gencec.h  create mode
> > 100644 m4/.gitkeep  create mode 100644 src/Makefile.am  create mode
> > 100644 src/gencec.c
> >
> > diff --git a/AUTHORS b/AUTHORS
> > new file mode 100644
> > index 0000000..e4b7117
> > --- /dev/null
> > +++ b/AUTHORS
> > @@ -0,0 +1 @@
> > +Kamil Debski <k.debski@samsung.com>
> > diff --git a/INSTALL b/INSTALL
> > new file mode 100644
> > index 0000000..aac6101
> > --- /dev/null
> > +++ b/INSTALL
> > @@ -0,0 +1,9 @@
> > +To install libgencec run following commands:
> > +
> > +autoreconf -i
> You might want add --force in here, otherwise the files will stay as-is
> if you update libtool and friends "mid-flight".
> Many projects include autogen.sh like the following. Feel free to add
> it to libgencec.

Thanks, I'll include this in the next version.
 
> $cat autogen.sh
> #! /bin/sh
> 
> srcdir=`dirname "$0"`
> test -z "$srcdir" && srcdir=.
> 
> ORIGDIR=`pwd`
> cd "$srcdir"
> 
> autoreconf --force --verbose --install || exit 1 cd "$ORIGDIR" || exit
> $?
> 
> if test -z "$NOCONFIGURE"; then
>     "$srcdir"/configure "$@"
> fi
> 
> 
> 
> > --- /dev/null
> > +++ b/configure.ac
> > @@ -0,0 +1,24 @@
> 
> You can save yourself some headaches if you restrict old and/or buggy
> autoconf versions which don't work with the project.
> If I have to guess 2.60 should be ok.
> AC_PREREQ([XXX])

Good suggestion, thanks.

> 
> > +AC_INIT([libgencec], [0.1], [k.debski@samsung.com])
> > +AM_INIT_AUTOMAKE([-Wall -Werror foreign])
> > +
> > +AC_PROG_CC
> > +AM_PROG_AR
> > +AC_CONFIG_MACRO_DIR([m4])
> > +AC_DEFINE([_GNU_SOURCE], [], [Use GNU extensions])
> > +
> 
> Same for libtool - 2.2 perhaps ?
> LT_PREREQ([XXX])

I agree.

> 
> > +LT_INIT
> > +
> > +# Checks for typedefs, structures, and compiler characteristics.
> > +AC_C_INLINE
> > +AC_TYPE_SIZE_T
> > +AC_TYPE_UINT16_T
> > +AC_TYPE_UINT32_T
> > +AC_TYPE_UINT8_T
> > +
> > +#AC_CHECK_LIB([c], [malloc])
> > +# Checks for library functions.
> > +#AC_FUNC_MALLOC
> > +l
> > +AC_CONFIG_FILES([Makefile src/Makefile examples/Makefile])
> Would be nice if the library provides libgencec.pc file. This way any
> users can avoid the explicit header/library check, amongst other useful
> bits.

Thanks for the suggestion, I'll look into this.
 
> > --- /dev/null
> > +++ b/examples/Makefile.am
> > @@ -0,0 +1,4 @@
> > +bin_PROGRAMS = cectest
> > +cectest_SOURCES = cectest.c
> > +AM_CPPFLAGS=-I$(top_srcdir)/include/
> > +AM_LDFLAGS=-L../src/ -lgencec
> The following seems more common (in the projects I've seen at least)
> cectest_LDADD = $(top_builddir)/src/libgencec.la
> 
> > diff --git a/m4/.gitkeep b/m4/.gitkeep new file mode 100644 index
> > 0000000..e69de29
> Haven't seen any projects doing this. Curious what the benefits of
> keeping and empty folder might be ?

When I run autoreconf -i it complained about missing m4 folder, hence I added
this filler file such that the folder is created. Any suggestion on how to do
this better?

> 
> > diff --git a/src/Makefile.am b/src/Makefile.am new file mode 100644
> > index 0000000..cb024f0
> > --- /dev/null
> > +++ b/src/Makefile.am
> > @@ -0,0 +1,4 @@
> > +lib_LTLIBRARIES = libgencec.la
> > +libgencec_la_SOURCES = gencec.c
> > +libgencec_la_LDFLAGS = -version-info 0:1:0
> You might want to add -no-undefined in order to prevent having a
> library with unresolved symbols.
> 
> Hope you find the above useful :-)

Thank you so much for your review. It is my first real approach at autotools,
so your comments are very much appreciated :)

> 
> Cheers
> Emil
> --

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

