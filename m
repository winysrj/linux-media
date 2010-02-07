Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:52723 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab0BGVWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 16:22:04 -0500
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
 filter
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Francesco Lavra <francescolavra@interfree.it>,
	Uwe Bugla <uwe.bugla@gmx.de>,
	Chicken Shack <chicken.shack@gmx.de>, obi@linuxtv.org,
	linux-media@vger.kernel.org
In-Reply-To: <1265555632.3063.42.camel@palomino.walls.org>
References: <1265546998.9356.4.camel@localhost>
	 <1265555632.3063.42.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sun, 07 Feb 2010 22:21:57 +0100
Message-Id: <1265577717.12843.47.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Am Sonntag, den 07.02.2010, 10:13 -0500 schrieb Andy Walls:
> On Sun, 2010-02-07 at 13:49 +0100, Francesco Lavra wrote:
> > A DVB demultiplexer device can be used to set up either a PES filter or
> > a section filter. In the former case, the ts field of the feed union of
> > struct dmxdev_filter is used, in the latter case the sec field of the
> > same union is used.
> > The ts field is a struct list_head, and is currently initialized in the
> > open() method of the demux device. When for a given demuxer a section
> > filter is set up, the sec field is played with, thus if a PES filter
> > needs to be set up after that the ts field will be corrupted, causing a
> > kernel oops.
> > This fix moves the list head initialization to
> > dvb_dmxdev_pes_filter_set(), so that the ts field is properly
> > initialized every time a PES filter is set up.
> > 
> > Signed-off-by: Francesco Lavra <francescolavra@interfree.it>
> > Cc: stable <stable@kernel.org>
> 
> 
> Reviewed-by: Andy Walls <awalls@radix.net>
Tested-by: hermann pitton <hermann-pitton@arcor.de>

> 
> This certainly helps.

Yes, as already confirmed by Uwe.

> It catches the case of setting a Section filter with DMX_SET_FILTER and
> then a PES filter with DMX_SET_PES_FILTER on the same file descriptor.
> This is exactly what alevt does.  See vbi.c:vbi_dvb_open() and
> vbi.c:dvb_get_table() in the alevt source code.
> 
> 
> Regards,
> Andy
> 
> > ---
> > 
> > --- a/drivers/media/dvb/dvb-core/dmxdev.c	2010-02-07 13:19:18.000000000 +0100
> > +++ b/drivers/media/dvb/dvb-core/dmxdev.c	2010-02-07 13:23:39.000000000 +0100
> > @@ -761,7 +761,6 @@ static int dvb_demux_open(struct inode *
> >  	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
> >  	dmxdevfilter->type = DMXDEV_TYPE_NONE;
> >  	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
> > -	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
> >  	init_timer(&dmxdevfilter->timer);
> >  
> >  	dvbdev->users++;
> > @@ -887,6 +886,7 @@ static int dvb_dmxdev_pes_filter_set(str
> >  	dmxdevfilter->type = DMXDEV_TYPE_PES;
> >  	memcpy(&dmxdevfilter->params, params,
> >  	       sizeof(struct dmx_pes_filter_params));
> > +	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
> >  
> >  	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_SET);
> >  
> > 

Many thanks to Francesco and all taking it up with this one.

Cheers,
Hermann


