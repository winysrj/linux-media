Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41337 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab0G3Or0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:47:26 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 30 Jul 2010 09:47:22 -0500
Subject: RE: [media-ctl PATCH 2/3] Just include kernel headers
Message-ID: <A24693684029E5489D1D202277BE894456C0B4F4@dlee02.ent.ti.com>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
 <201007301545.07534.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894456C0B476@dlee02.ent.ti.com>
 <201007301623.46995.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007301623.46995.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, July 30, 2010 9:24 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: [media-ctl PATCH 2/3] Just include kernel headers
> 
> Hi Sergio,
> 
> On Friday 30 July 2010 16:10:08 Aguirre, Sergio wrote:
> > On Friday 30 July 2010 8:45 AM Laurent Pinchart wrote:
> > > On Wednesday 14 July 2010 18:17:25 Sergio Aguirre wrote:
> > > > We shouldn't require full kernel source for this.
> > >
> > > That's right in theory, but I then get
> > >
> > > $ make KDIR=/home/laurent/src/arm/kernel/
> > > arm-none-linux-gnueabi-gcc -O2 -Wall -fpic -I. -
> > > I/home/laurent/src/arm/kernel//include    -c -o media.o media.c
> > > In file included from /opt/cs/arm-2009q1/bin/../arm-none-linux-
> > > gnueabi/libc/usr/include/asm/types.h:4,
> > >                  from
> > > /home/laurent/src/arm/kernel//include/linux/types.h:4,
> > >                  from
> > > /home/laurent/src/arm/kernel//include/linux/videodev2.h:66,
> > >                  from media.c:31:
> > > /home/laurent/src/arm/kernel//include/asm-generic/int-ll64.h:11:29:
> > > error: asm/bitsperlong.h: No such file or directory
> > > make: *** [media.o] Error 1
> > >
> > > when building against a kernel tree.
> >
> > KDIR doesn't exist anymore.
> >
> > By the result of your log, I don't see how that value got passed into
> the
> > makefile... Are you sure you applied the patch correctly?
> 
> I haven't, I've just removed the arch include dir from KDIR in the
> Makefile.
> The end result is the same.

Hmm..

I think this is expected, since the kernel headers folder generated with

make ARCH=arm INSTALL_HDR_PATH=<your-fs-root> headers_install

Is not the same as just reading the kernel source include folder.

Some #ifdef get resolved depending on the arch, and the headers are
"rebuilt". See : Documentation/make/headers_install.txt

So, I guess it's not as simple as just removing the arch include folder.

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
