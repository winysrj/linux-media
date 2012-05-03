Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4582 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2ECHCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 03:02:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
Date: Thu, 3 May 2012 09:02:04 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, remi@remlab.net, nbowler@elliptictech.com,
	james.dutton@gmail.com
References: <20120502191324.GE852@valkosipuli.localdomain> <201205022245.22585.hverkuil@xs4all.nl> <20120502213915.GG852@valkosipuli.localdomain>
In-Reply-To: <20120502213915.GG852@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205030902.05011.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed May 2 2012 23:39:15 Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, May 02, 2012 at 10:45:22PM +0200, Hans Verkuil wrote:
> > On Wed May 2 2012 21:13:47 Sakari Ailus wrote:
> > > Replace enums in IOCTL structs by __u32. The size of enums is variable and
> > > thus problematic. Compatibility structs having exactly the same as original
> > > definition are provided for compatibility with old binaries with the
> > > required conversion code.
> > 
> > Does someone actually have hard proof that there really is a problem? You know,
> > demonstrate it with actual example code?
> > 
> > It's pretty horrible that you have to do all those conversions and that code
> > will be with us for years to come.
> > 
> > For most (if not all!) architectures sizeof(enum) == sizeof(u32), so there is
> > no need for any compat code for those.
> 
> Cases I know where this can go wrong are, but there may well be others:
> 
> - ppc64: int is 64 bits there, and thus also enums,

Are you really, really certain that's the case? If I look at
arch/powerpc/include/asm/types.h it includes either asm-generic/int-l64.h
or asm-generic/int-ll64.h and both of those headers define u32 as unsigned int.
Also, if sizeof(int) != 4, then how would you define u32?

Ask a ppc64 kernel maintainer what sizeof(int) and sizeof(enum) are in the kernel
before we start doing lots of work for no reason.

Looking at arch/*/include/asm/types.h it seems all architectures define sizeof(int)
as 4.

What sizeof(long) is will actually differ between architectures, but char, short
and int seem to be fixed everywhere.

Regards,

	Hans

> 
> - Enums are quite a different concept in C++ than in C --- the compiler may
>   make assumpton based on the value range of the enums --- videodev2.h should
>   be included with extern "C" in that case, though,
> 
> - C does not specify which integer type enums actually use; this is what GCC
>   manual says about it:
> 
>   <URL:http://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html#Enumerations>
> 
>   So a compiler other than GCC should use 16-bit enums and conform to C
>   while breaking V4L2. This might be a theoretical issue, though.
> 
> More discussion took place in this thread:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg46167.html>
> 
> Regards,
> 
> 
