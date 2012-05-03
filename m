Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:13800 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2ECOMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 10:12:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
Date: Thu, 3 May 2012 16:12:07 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, remi@remlab.net,
	nbowler@elliptictech.com, james.dutton@gmail.com
References: <20120502191324.GE852@valkosipuli.localdomain> <201205030902.05011.hverkuil@xs4all.nl> <4FA28B56.1070801@redhat.com>
In-Reply-To: <4FA28B56.1070801@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205031612.07952.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 May 2012 15:42:46 Mauro Carvalho Chehab wrote:
> Em 03-05-2012 04:02, Hans Verkuil escreveu:
> > On Wed May 2 2012 23:39:15 Sakari Ailus wrote:
> >> Hi Hans,
> >>
> >> On Wed, May 02, 2012 at 10:45:22PM +0200, Hans Verkuil wrote:
> >>> On Wed May 2 2012 21:13:47 Sakari Ailus wrote:
> >>>> Replace enums in IOCTL structs by __u32. The size of enums is variable and
> >>>> thus problematic. Compatibility structs having exactly the same as original
> >>>> definition are provided for compatibility with old binaries with the
> >>>> required conversion code.
> >>>
> >>> Does someone actually have hard proof that there really is a problem? You know,
> >>> demonstrate it with actual example code?
> >>>
> >>> It's pretty horrible that you have to do all those conversions and that code
> >>> will be with us for years to come.
> >>>
> >>> For most (if not all!) architectures sizeof(enum) == sizeof(u32), so there is
> >>> no need for any compat code for those.
> >>
> >> Cases I know where this can go wrong are, but there may well be others:
> >>
> >> - ppc64: int is 64 bits there, and thus also enums,
> > 
> > Are you really, really certain that's the case? If I look at
> > arch/powerpc/include/asm/types.h it includes either asm-generic/int-l64.h
> > or asm-generic/int-ll64.h and both of those headers define u32 as unsigned int.
> > Also, if sizeof(int) != 4, then how would you define u32?
> > 
> > Ask a ppc64 kernel maintainer what sizeof(int) and sizeof(enum) are in the kernel
> > before we start doing lots of work for no reason.
> > 
> > Looking at arch/*/include/asm/types.h it seems all architectures define sizeof(int)
> > as 4.
> > 
> > What sizeof(long) is will actually differ between architectures, but char, short
> > and int seem to be fixed everywhere.
> 
> Yes, it seems that, inside the Kernel, "int" it will always be 32 bits. It doesn't
> necessarily means that "enum" will be 32 bits.

Actually, I believe it is. It is my understanding that --short-enums is not allowed
inside the kernel and so enums are the same size as int. But I'd like to have some
confirmation about that first. That compiler option isn't used anywhere in the kernel
in any case and gcc on ARM will default to int-sized enums on linux.

So just changing all the enums in videodev2.h to u32 should almost certainly be all
we need to do.

> Also, as it is recommended to not use "int/unsigned int/long/unsigned long" at 
> kernel<->userspace API, I bet that this will cause problems on userspace (maybe
> with non-gcc compilers?)

'long' is certainly known to change size depending on the compiler. 'int' can be
two bytes on *really* old hardware/compilers.

struct v4l2_jpegcompression is the only place where int is still used. I wouldn't
mind if that changes to u32 at the same time (those ints should have been unsigned
anyway).

Regards,

	Hans
