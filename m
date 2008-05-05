Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45Ef1Lm010179
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 10:41:01 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m45Eec00028984
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 10:40:39 -0400
Received: by ti-out-0910.google.com with SMTP id 24so544574tim.7
	for <video4linux-list@redhat.com>; Mon, 05 May 2008 07:40:37 -0700 (PDT)
Message-ID: <cad107560805050740q67b331a2y690ee6d1621da6a9@mail.gmail.com>
Date: Mon, 5 May 2008 22:40:36 +0800
From: "Jeyner Gil Caga" <jeynergilcaga@gmail.com>
To: ".: formica :." <formica@messinalug.org>
In-Reply-To: <8dff1fad0805030804m27d2bfb2v4a1b4f8767dca894@mail.gmail.com>
MIME-Version: 1.0
References: <8dff1fad0805030252u342ae5f3l7891d0097fb85bb4@mail.gmail.com>
	<cad107560805030623h321f1880tf73fef25fe4a6535@mail.gmail.com>
	<8dff1fad0805030804m27d2bfb2v4a1b4f8767dca894@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Cross Compile Xawtv for XScale
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Roberto,

Have you tried making it work on a normal PC? If not, I suggest to start
from there. But if you have proven that it works, you may proceed with
cross-compiling it to XScale.

I have tried cross-compiling streamer ONLY from Xawtv. I only utilized its
capture to JPEG and capture to WAV file. I did not include the graphics
support. But it was on PPC440Epx platform, not XScale. All I needed was the
cross-compiler and the modified Makefiles. I posted some changes below which
could serve as your reference. Perhaps you could do similarly. You may want
to start from the easiest way, which is cross-compiling Xawtv with JPEG only
support. Once you're familiar with it, you may want to modify the Makefiles
to include other plugins to support AVI conversion or MPEG conversion.

This is a portion of the Makefile.in. I have commented out libng, man,
scripts, vbistuff and x11:
------------------------------------------------------
#########################################################
# include stuff

# must come first
include $(srcdir)/common/Subdir.mk

# subdirs
include $(srcdir)/console/Subdir.mk
include $(srcdir)/debug/Subdir.mk
include $(srcdir)/frequencies/Subdir.mk
include $(srcdir)/libng/Subdir.mk
include $(srcdir)/libng/plugins/Subdir.mk
#include $(srcdir)/libng/contrib-plugins/Subdir.mk
#include $(srcdir)/man/Subdir.mk
#include $(srcdir)/scripts/Subdir.mk
#include $(srcdir)/vbistuff/Subdir.mk
#include $(srcdir)/x11/Subdir.mk

# dependencies
-include $(depfiles)

------------------------------------------------------
Below is console\Subdir.mk. I only included streamer.


# targets to build
TARGETS-console := \
    console/streamer

console/streamer: \
    console/streamer.o \
    common/channel-no-x11.o \
    $(OBJS-common-capture)

console/streamer : LDLIBS  += $(THREAD_LIBS) -ljpeg -lm -L${JPEG_ROOT}/lib
console/streamer : LDFLAGS := $(DLFLAGS)

# global targets
all:: $(TARGETS-console)


install::
    $(INSTALL_PROGRAM) $(TARGETS-console) $(bindir)

distclean::
    rm -f $(TARGETS-console)

------------------------------------------------------
I compiled it using:

$ ./configure --disable-xfree-ext  --disable-xvideo  --disable-lirc \
            --disable-quicktime --disable-motif --disable-aa
--disable-alsa  \
            --disable-zvbi --disable-gl  --disable-dv  --disable-xft \
            --prefix=`pwd` --without-x
$  ppc_4xxFP-make CXX=ppc_4xxFP-g++ CC=ppc_4xxFP-gcc

I hope this will give you a clearer picture on what to do.

Regards,

Jeyner
On Sat, May 3, 2008 at 11:04 PM, .: formica :. <formica@messinalug.org>
wrote:

> Hi jeyner,
> and thanks for your answer!
> I need to record a video from a webcam and store it in a file (avi,
> mpeg...), on an embedded device with Xscale pxa270.
> I would like to use 'streamer' for this work. Do you have a suggestion for
> me?
>
> Thanks in advance.
> Roberto
>
>
> On Sat, May 3, 2008 at 1:23 PM, Jeyner Gil Caga <jeynergilcaga@gmail.com>
> wrote:
>
> > Hi Formica,
> >
> > May I know  what functionalities of XAWTV you need? Do you need to
> > cross-compile everything or only  a portion of it?
> >
> > jeyner
> >
> > On Sat, May 3, 2008 at 5:52 PM, .: formica :. <formica@messinalug.org>
> > wrote:
> >
> > > Hi all,
> > > is it possible to cross-compile Xawtv for XScale pxa270?
> > > If yes, how can I do it?
> > >
> > > Thanks in advance
> > > formica
> > > --
> > > video4linux-list mailing list
> > > Unsubscribe mailto:video4linux-list-request@redhat.com
> > > ?subject=unsubscribe
> > > https://www.redhat.com/mailman/listinfo/video4linux-list
> > >
> >
> >
>
>
> --
> Roberto (aka formica) Marino
> Computer Engineering Student
> Free Software User - Me|Lug Member
> --> formica@messinalug.org <--
> http://www.messinalug.org
> Mobile: 349-5740870
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
