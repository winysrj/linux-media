Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49469 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab0G3OKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:10:12 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 30 Jul 2010 09:10:08 -0500
Subject: RE: [media-ctl PATCH 2/3] Just include kernel headers
Message-ID: <A24693684029E5489D1D202277BE894456C0B476@dlee02.ent.ti.com>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
 <1279124246-12187-3-git-send-email-saaguirre@ti.com>
 <201007301545.07534.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007301545.07534.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, July 30, 2010 8:45 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: [media-ctl PATCH 2/3] Just include kernel headers
> 
> Hi Sergio,
> 
> On Wednesday 14 July 2010 18:17:25 Sergio Aguirre wrote:
> > We shouldn't require full kernel source for this.
> 
> That's right in theory, but I then get
> 
> $ make KDIR=/home/laurent/src/arm/kernel/
> arm-none-linux-gnueabi-gcc -O2 -Wall -fpic -I. -
> I/home/laurent/src/arm/kernel//include    -c -o media.o media.c
> In file included from /opt/cs/arm-2009q1/bin/../arm-none-linux-
> gnueabi/libc/usr/include/asm/types.h:4,
>                  from
> /home/laurent/src/arm/kernel//include/linux/types.h:4,
>                  from
> /home/laurent/src/arm/kernel//include/linux/videodev2.h:66,
>                  from media.c:31:
> /home/laurent/src/arm/kernel//include/asm-generic/int-ll64.h:11:29: error:
> asm/bitsperlong.h: No such file or directory
> make: *** [media.o] Error 1
> 
> when building against a kernel tree.

KDIR doesn't exist anymore.

By the result of your log, I don't see how that value got passed into the makefile... Are you sure you applied the patch correctly?

Regards,
Sergio

> 
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> >  Makefile |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index bf4cf55..300ed7e 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,11 +1,9 @@
> > -SRCARCH ?= arm
> >  CROSS_COMPILE ?= arm-none-linux-gnueabi-
> > -KDIR ?= /usr/src/linux
> > +HDIR ?= /usr/include
> >
> > -KINC := -I$(KDIR)/include -I$(KDIR)/arch/$(SRCARCH)/include
> >  CC   := $(CROSS_COMPILE)gcc
> >
> > -CFLAGS = -O2 -Wall -fpic -I. $(KINC)
> > +CFLAGS = -O2 -Wall -fpic -I$(HDIR)
> >  OBJS = media.o main.o options.o subdev.o
> >
> >  all: media-ctl
> 
> --
> Regards,
> 
> Laurent Pinchart
