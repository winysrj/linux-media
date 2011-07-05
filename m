Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:46883 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1GELep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:34:45 -0400
From: "JAIN, AMBER" <amber@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 5 Jul 2011 17:04:05 +0530
Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB037BD02799@dbde02.ent.ti.com>
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
 <4E0E153F.5000303@redhat.com>
In-Reply-To: <4E0E153F.5000303@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: Saturday, July 02, 2011 12:13 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; JAIN, AMBER; David Rientjes; Andrew
> Morton
> Subject: Re: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
> 
> Em 22-06-2011 16:32, hvaibhav@ti.com escreveu:
> > The following changes since commit
> af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
> >   Linus Torvalds (1):
> >         Merge branch 'x86-urgent-for-linus' of
> git://git.kernel.org/.../tip/linux-2.6-tip
> >
> > are available in the git repository at:
> >
> >   git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-
> linux-media
> >
> > Amber Jain (2):
> >       V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is not
> configured on OMAP
> >       OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not
> configured on OMAP
> 
> > From: Amber Jain <amber@ti.com>
> > Date: Tue May 31 11:45:36 2011 -0300
> >
> > OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on
> OMAP
> >
> > Remove GFP_DMA from the __get_free_pages() call from omap24xxcam as
> ZONE_DMA
> > is not configured on OMAP. Earlier the page allocator used to return a
> page
> > from ZONE_NORMAL even when GFP_DMA is passed and CONFIG_ZONE_DMA is
> disabled.
> > As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page
> allocator
> > returns null in such a scenario with a warning emitted to kernel log.
> >
> > Signed-off-by: Amber Jain <amber@ti.com>
> > Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > diff --git a/drivers/media/video/omap24xxcam.c
> b/drivers/media/video/omap24xxcam.c
> > index f6626e8..d92d4c6 100644
> > --- a/drivers/media/video/omap24xxcam.c
> > +++ b/drivers/media/video/omap24xxcam.c
> > @@ -309,11 +309,11 @@ static int
> omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
> >  			order--;
> >
> >  		/* try to allocate as many contiguous pages as possible */
> > -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > +		page = alloc_pages(GFP_KERNEL, order);
> >  		/* if allocation fails, try to allocate smaller amount */
> >  		while (page == NULL) {
> >  			order--;
> > -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > +			page = alloc_pages(GFP_KERNEL, order);
> >  			if (page == NULL && !order) {
> >  				err = -ENOMEM;
> >  				goto out;
> 
> Hmm... the proper fix wouldn't be to define ZONE_DMA at OMAP?

I don't think so, my understanding for ZOME_DMA is that it is defined for architectures that have restrictions on memory addresses that can be used for DMA. OMAP doesn't have any such restriction and hence we should not define ZONE_DMA.

Please let me know if I have missed some point.

Thanks,
Amber
> 
> Thanks,
> Mauro
