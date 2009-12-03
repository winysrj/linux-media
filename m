Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:32167 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZLCRZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 12:25:01 -0500
Date: Thu, 3 Dec 2009 09:24:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David T. L. Wong" <davidtlwong@gmail.com>
Cc: linux-next@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] max2165 32bit build patch
Message-Id: <20091203092433.0f9b60b8.randy.dunlap@oracle.com>
In-Reply-To: <4B17C311.6050500@gmail.com>
References: <20091130175346.3f3345ed.sfr@canb.auug.org.au>
	<4B1409D9.1050901@oracle.com>
	<20091202100406.e25b2322.randy.dunlap@oracle.com>
	<4B17C311.6050500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 03 Dec 2009 21:54:25 +0800 David T. L. Wong wrote:

> Randy Dunlap wrote:
> > On Mon, 30 Nov 2009 10:07:21 -0800 Randy Dunlap wrote:
> > 
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20091127:
> >>>
> >>> The v4l-dvb tree lost its conflict.
> >>
> >> on i386 (X86_32):
> >>
> >> a 'double' variable is used, causing:
> >>
> >> ERROR: "__floatunsidf" [drivers/media/common/tuners/max2165.ko] undefined!
> >> ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
> >> ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!
> > 
> > 
> > linux-next-20091202:
> > 
> > still have this one (above) and similar with
> > drivers/media/dvb/frontends/atbm8830.c:
> > 
> > drivers/built-in.o: In function `atbm8830_init':
> > atbm8830.c:(.text+0x9012f9): undefined reference to `__udivdi3'
> > atbm8830.c:(.text+0x901384): undefined reference to `__floatunsidf'
> > atbm8830.c:(.text+0x901395): undefined reference to `__muldf3'
> > atbm8830.c:(.text+0x9013a5): undefined reference to `__floatunsidf'
> > atbm8830.c:(.text+0x9013b2): undefined reference to `__divdf3'
> > atbm8830.c:(.text+0x9013c3): undefined reference to `__muldf3'
> > atbm8830.c:(.text+0x9013cd): undefined reference to `__fixunsdfsi'
> > 
> > ---
> 
> This patch drops usage of floating point variable for 32bit build
> 
> Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Please generate patches so that they can be applied by using
$ patch -p1
at the top of the kernel source tree.

Thanks.
---
~Randy
