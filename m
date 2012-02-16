Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45112 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2BPJ5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 04:57:34 -0500
Message-ID: <1329386251.16824.83.camel@smile>
Subject: Re: [PATCH] media: video: append $(srctree) to -I parameters
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media @ vger . kernel . org" <linux-media@vger.kernel.org>,
	David Cohen <dacohen@gmail.com>
Date: Thu, 16 Feb 2012 11:57:31 +0200
In-Reply-To: <2218117.VoHfpPQjC4@avalon>
References: <1329318481-8530-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <2218117.VoHfpPQjC4@avalon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-02-16 at 07:22 +0100, Laurent Pinchart wrote: 
> Hi Andy,
> 
> Thanks for the patch.
> 
> On Wednesday 15 February 2012 17:08:01 Andy Shevchenko wrote:
> > Without this we have got the warnings like following if build with "make W=1
> > O=/var/tmp":
> >    CHECK   drivers/media/video/videobuf-vmalloc.c
> >    CC [M]  drivers/media/video/videobuf-vmalloc.o
> >  +cc1: warning: drivers/media/dvb/dvb-core: No such file or directory
> > [enabled by default] +cc1: warning: drivers/media/dvb/frontends: No such
> > file or directory [enabled by default] +cc1: warning:
> > drivers/media/dvb/dvb-core: No such file or directory [enabled by default]
> > +cc1: warning: drivers/media/dvb/frontends: No such file or directory
> > [enabled by default] LD      drivers/media/built-in.o
> > 
> > Some details could be found in [1] as well.
> > 
> > [1] http://comments.gmane.org/gmane.linux.kbuild.devel/7733
> 
> There are several occurencies if the same issue throughout drivers/. Could you 
> send a patch that fixes them all in one go ?
I guess it should be a patch series anyway to help with bisecting.
Okay, I will check it and make a patches if there any issue is found.

> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/media/video/Makefile |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index 3541388..3bf0aa8 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -199,6 +199,6 @@ obj-y	+= davinci/
> > 
> >  obj-$(CONFIG_ARCH_OMAP)	+= omap/
> > 
> > -ccflags-y += -Idrivers/media/dvb/dvb-core
> > -ccflags-y += -Idrivers/media/dvb/frontends
> > -ccflags-y += -Idrivers/media/common/tuners
> > +ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
> > +ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
> > +ccflags-y += -I$(srctree)/drivers/media/common/tuners
> 
> The above link mentions $(src). Is that different than $(srctree) ?
If I remember correctly $srctree points always to the root of the linux
kernel sources, but $src to the path of a certain Makefile.
In this case it seems $(src) == drivers/media/video. 

Moment...

Aha, the Documentation/kbuild/makefiles.txt clearly tells us:
    $(src)
        $(src) is a relative path which points to the directory
        where the Makefile is located. Always use $(src) when
        referring to files located in the src tree.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
