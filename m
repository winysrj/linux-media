Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:48747
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0CQWu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 18:50:26 -0400
From: Arnout Vandecappelle <arnout@mind.be>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
Date: Wed, 17 Mar 2010 23:50:08 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
References: <201003031512.45428.arnout@mind.be> <1267718451-24961-2-git-send-email-arnout@mind.be> <4BA1422E.4030601@maxwell.research.nokia.com>
In-Reply-To: <4BA1422E.4030601@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003172350.09212.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wednesday 17 March 2010 21:57:18, Sakari Ailus wrote:
> Arnout Vandecappelle wrote:
> > diff --git a/drivers/media/video/videobuf-dma-sg.c
> > b/drivers/media/video/videobuf-dma-sg.c index da1790e..3b6f1b8 100644
> > --- a/drivers/media/video/videobuf-dma-sg.c
> > +++ b/drivers/media/video/videobuf-dma-sg.c
> > @@ -244,7 +244,7 @@ int videobuf_dma_map(struct videobuf_queue* q,
> > struct videobuf_dmabuf *dma)
> > 
> >  	}
> >  	if (!dma->bus_addr) {
> >  	
> >  		dma->sglen = dma_map_sg(q->dev, dma->sglist,
> > 
> > -					dma->nr_pages, dma->direction);
> > +					dma->sglen, dma->direction);
> > 
> >  		if (0 == dma->sglen) {
> >  		
> >  			printk(KERN_WARNING
> >  			
> >  			       "%s: videobuf_map_sg failed\n",__func__);
> 
> Where is dma->sglen actually set?
> 
> videobuf_dma_map() is used in __videobuf_iolock
> (drivers/media/video/videobuf-dma-sg.c) but neither
> videobuf_dma_init_kernel() nor videobuf_dma_init_user() seem to set it.
> This apparently leaves the value uninitialised.
> 
> I definitely think it should be assigned somewhere. :-)

 It's assigned there exactly - nr_pages shouldn't have been replaced there.

 Updated patches follow.

 Regards,
 Arnout

-- 
Arnout Vandecappelle                               arnout at mind be
Senior Embedded Software Architect                 +32-16-286540
Essensium/Mind                                     http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium                BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  31BB CF53 8660 6F88 345D  54CC A836 5879 20D7 CF43
