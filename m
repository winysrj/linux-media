Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab2JJBF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 21:05:56 -0400
Date: Tue, 9 Oct 2012 22:05:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Michael West <michael@iposs.co.nz>,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement
 .get_frame_desc subdev callback
Message-ID: <20121009220530.2025b1af@redhat.com>
In-Reply-To: <201210081503.36502.hverkuil@xs4all.nl>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
	<DCBB30B3D32C824F800041EE82CABAAE03203D63BB2A@duckworth.iposs.co.nz>
	<507163E0.7040602@gmail.com>
	<201210081503.36502.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 Oct 2012 15:03:36 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Sun October 7 2012 13:13:36 Sylwester Nawrocki wrote:
> > On 10/07/2012 03:19 AM, Michael West wrote:
> > > This patch changes versions.txt and disables  VIDEO_M5MOLS which 
> > > fixed the build for my 3.2 kernel but looking at the logs it looks
> > > like this is not the way to fix it as it's not just a 3.6+ problem
> > > as it does not build on 3.6 as well...  So probably best to find 
> > > why it doesn't build on the current kernel first.
> > 
> > To fix the build on kernels 3.6+ <linux/sizes.h> just needs to be 
> > inclcuded in m5mols.h. This is what my patch from previous message 
> > in this thread does. But this will break again on kernel versions 
> > _3.5 and lower_ where <linux/sizes.h> doesn't exist. I thought
> > originally it could have been simply replaced there with <asm/sizes.h>, 
> > but not all architectures have it
> > 
> > $ git grep  "#define SZ_1M" v2.6.32
> > v2.6.32:arch/arm/include/asm/sizes.h:#define SZ_1M                           0x00100000
> > v2.6.32:arch/sh/include/asm/sizes.h:#define SZ_1M                           0x00100000
> > 
> > $ git grep  "#define SZ_1M" v3.6-rc5
> > v3.6-rc5:drivers/base/dma-contiguous.c:#define SZ_1M (1 << 20)
> > v3.6-rc5:include/linux/sizes.h:#define SZ_1M                            0x00100000
> > 
> > 
> > Let's just use the below patch to solve this build break, this way
> > there is no need to touch anything at media_build.
> > 
> > From 11adc6956f3fe87c897aa6add08f8437422969a8 Mon Sep 17 00:00:00 2001
> > From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> > Date: Sun, 7 Oct 2012 13:04:37 +0200
> > Subject: [PATCH] m5mols: Replace SZ_1M with explicit value
> > 
> > SZ_1M macro definition was introduced in commit ab7ef22419927
> > "[media] m5mols: Implement .get_frame_desc subdev callback"
> > but required <linux/sizes.h> header was not included. To prevent
> > build errors with older kernels where <linux/sizes.h> doesn't exist
> > use explicit value rather than SZ_1M.
> > 
> > Reported-by: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
> > Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Note: until this patch is merged I am disabling this driver in media_build
> since right now it doesn't compile at all. Please notify me when this is
> fixed in media_tree.git so that I can enable it again.
> 
> Regards,
> 
> 	Hans
> 
> > ---
> >  drivers/media/i2c/m5mols/m5mols.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/m5mols/m5mols.h b/drivers/media/i2c/m5mols/m5mols.h
> > index 4ab8b37..30654f5 100644
> > --- a/drivers/media/i2c/m5mols/m5mols.h
> > +++ b/drivers/media/i2c/m5mols/m5mols.h
> > @@ -24,7 +24,7 @@
> >   * determined by CAPP_JPEG_SIZE_MAX register.
> >   */
> >  #define M5MOLS_JPEG_TAGS_SIZE		0x20000
> > -#define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * SZ_1M)
> > +#define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * 1024 * 1024)

Nah! Please don't do that! we shouldn't be patching a driver upstream
just because it broke media_build. Also, fixing it there is as simple as
adding something similar to this at compat.h:

#ifndef SZ_1M
	#define SZ_1m (1024 * 1024)
#endif

> >  
> >  extern int m5mols_debug;
> >  
> > > ---
> > >   v4l/versions.txt |    2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/v4l/versions.txt b/v4l/versions.txt
> > > index 328651e..349695c 100644
> > > --- a/v4l/versions.txt
> > > +++ b/v4l/versions.txt
> > > @@ -4,6 +4,8 @@
> > >   [3.6.0]
> > >   # needs devm_clk_get, clk_enable, clk_disable
> > >   VIDEO_CODA
> > > +# broken add reason here
> > > +VIDEO_M5MOLS
> > 
> > This was supposed to be under [3.5.0].
> > 
> > > 
> > >   [3.4.0]
> > >   # needs devm_regulator_bulk_get
> > > -- 1.7.9.5
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
