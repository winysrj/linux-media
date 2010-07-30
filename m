Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44042 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0G3PkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 11:40:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [media-ctl PATCH 2/3] Just include kernel headers
Date: Fri, 30 Jul 2010 17:39:56 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com> <201007301623.46995.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894456C0B4F4@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894456C0B4F4@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007301739.59013.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Friday 30 July 2010 16:47:22 Aguirre, Sergio wrote:
> > > On Friday 30 July 2010 9:24 AM Laurent Pinchart wrote:
> > On Friday 30 July 2010 16:10:08 Aguirre, Sergio wrote:
> > > On Friday 30 July 2010 8:45 AM Laurent Pinchart wrote:
> > > > On Wednesday 14 July 2010 18:17:25 Sergio Aguirre wrote:
> > > > > We shouldn't require full kernel source for this.
> > > > 
> > > > That's right in theory, but I then get
> > > > 
> > > > $ make KDIR=/home/laurent/src/arm/kernel/
> > > > arm-none-linux-gnueabi-gcc -O2 -Wall -fpic -I. -
> > > > I/home/laurent/src/arm/kernel//include    -c -o media.o media.c
> > > > In file included from /opt/cs/arm-2009q1/bin/../arm-none-linux-
> > > > gnueabi/libc/usr/include/asm/types.h:4,
> > > >                  from
> > > > /home/laurent/src/arm/kernel//include/linux/types.h:4,
> > > >                  from
> > > > /home/laurent/src/arm/kernel//include/linux/videodev2.h:66,
> > > >                  from media.c:31:
> > > > /home/laurent/src/arm/kernel//include/asm-generic/int-ll64.h:11:29:
> > > > error: asm/bitsperlong.h: No such file or directory
> > > > make: *** [media.o] Error 1
> > > > 
> > > > when building against a kernel tree.
> > > 
> > > KDIR doesn't exist anymore.
> > > 
> > > By the result of your log, I don't see how that value got passed into
> > > the makefile... Are you sure you applied the patch correctly?
> > 
> > I haven't, I've just removed the arch include dir from KDIR in the
> > Makefile. The end result is the same.
> 
> Hmm..
> 
> I think this is expected, since the kernel headers folder generated with
> 
> make ARCH=arm INSTALL_HDR_PATH=<your-fs-root> headers_install
> 
> Is not the same as just reading the kernel source include folder.
> 
> Some #ifdef get resolved depending on the arch, and the headers are
> "rebuilt". See : Documentation/make/headers_install.txt
> 
> So, I guess it's not as simple as just removing the arch include folder.

Ideally the application should be built against installed kernel headers, bug 
given the early stage of development of the media controller, I expect most 
people to build it against a kernel tree. I would like to keep the Makefile 
as-is for now, and change it when the media controller patches will reach the 
mainline kernel.

-- 
Regards,

Laurent Pinchart
