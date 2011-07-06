Return-path: <mchehab@localhost>
Received: from smtp-out.google.com ([216.239.44.51]:44639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1GFUn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 16:43:57 -0400
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id p66KhuKR031995
	for <linux-media@vger.kernel.org>; Wed, 6 Jul 2011 13:43:56 -0700
Received: from pzk26 (pzk26.prod.google.com [10.243.19.154])
	by kpbe16.cbf.corp.google.com with ESMTP id p66Kh2nN023884
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Wed, 6 Jul 2011 13:43:55 -0700
Received: by pzk26 with SMTP id 26so326045pzk.38
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2011 13:43:54 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:43:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "JAIN, AMBER" <amber@ti.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB037BD02799@dbde02.ent.ti.com>
Message-ID: <alpine.DEB.2.00.1107061342380.2622@chino.kir.corp.google.com>
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com> <4E0E153F.5000303@redhat.com> <5A47E75E594F054BAF48C5E4FC4B92AB037BD02799@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Tue, 5 Jul 2011, JAIN, AMBER wrote:

> > > diff --git a/drivers/media/video/omap24xxcam.c
> > b/drivers/media/video/omap24xxcam.c
> > > index f6626e8..d92d4c6 100644
> > > --- a/drivers/media/video/omap24xxcam.c
> > > +++ b/drivers/media/video/omap24xxcam.c
> > > @@ -309,11 +309,11 @@ static int
> > omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
> > >  			order--;
> > >
> > >  		/* try to allocate as many contiguous pages as possible */
> > > -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > > +		page = alloc_pages(GFP_KERNEL, order);
> > >  		/* if allocation fails, try to allocate smaller amount */
> > >  		while (page == NULL) {
> > >  			order--;
> > > -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > > +			page = alloc_pages(GFP_KERNEL, order);
> > >  			if (page == NULL && !order) {
> > >  				err = -ENOMEM;
> > >  				goto out;
> > 
> > Hmm... the proper fix wouldn't be to define ZONE_DMA at OMAP?
> 
> I don't think so, my understanding for ZOME_DMA is that it is defined 
> for architectures that have restrictions on memory addresses that can be 
> used for DMA. OMAP doesn't have any such restriction and hence we should 
> not define ZONE_DMA.
> 

s/should not define/do not need to define/

Right, if omap does not have DMA restrictions then the GFP_DMA usage that 
is removed with this patch was incorrect.
