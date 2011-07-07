Return-path: <mchehab@localhost>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47176 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1GGFzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 01:55:10 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: David Rientjes <rientjes@google.com>, "JAIN, AMBER" <amber@ti.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 7 Jul 2011 11:25:00 +0530
Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
Message-ID: <19F8576C6E063C45BE387C64729E739404E3486239@dbde02.ent.ti.com>
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
 <4E0E153F.5000303@redhat.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037BD02799@dbde02.ent.ti.com>
 <alpine.DEB.2.00.1107061342380.2622@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1107061342380.2622@chino.kir.corp.google.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Thursday, July 07, 2011 2:14 AM
> To: JAIN, AMBER
> Cc: Mauro Carvalho Chehab; Hiremath, Vaibhav; linux-media@vger.kernel.org;
> Andrew Morton
> Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
> 
> On Tue, 5 Jul 2011, JAIN, AMBER wrote:
> 
> > > > diff --git a/drivers/media/video/omap24xxcam.c
> > > b/drivers/media/video/omap24xxcam.c
> > > > index f6626e8..d92d4c6 100644
> > > > --- a/drivers/media/video/omap24xxcam.c
> > > > +++ b/drivers/media/video/omap24xxcam.c
> > > > @@ -309,11 +309,11 @@ static int
> > > omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
> > > >  			order--;
> > > >
> > > >  		/* try to allocate as many contiguous pages as possible
> */
> > > > -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > > > +		page = alloc_pages(GFP_KERNEL, order);
> > > >  		/* if allocation fails, try to allocate smaller amount
> */
> > > >  		while (page == NULL) {
> > > >  			order--;
> > > > -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > > > +			page = alloc_pages(GFP_KERNEL, order);
> > > >  			if (page == NULL && !order) {
> > > >  				err = -ENOMEM;
> > > >  				goto out;
> > >
> > > Hmm... the proper fix wouldn't be to define ZONE_DMA at OMAP?
> >
> > I don't think so, my understanding for ZOME_DMA is that it is defined
> > for architectures that have restrictions on memory addresses that can be
> > used for DMA. OMAP doesn't have any such restriction and hence we should
> > not define ZONE_DMA.
> >
> 
> s/should not define/do not need to define/
> 
> Right, if omap does not have DMA restrictions then the GFP_DMA usage that
> is removed with this patch was incorrect.
[Hiremath, Vaibhav] I did not understand your comment; can you please help me to understand here?

Thanks,
Vaibhav
