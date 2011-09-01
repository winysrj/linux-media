Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab1IAIxR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 04:53:17 -0400
Date: Thu, 1 Sep 2011 10:53:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v6] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201109011035.48845.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109011044270.6316@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <20110831210615.GQ12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109010850560.21309@axis700.grange>
 <201109011035.48845.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Sep 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 01 September 2011 09:03:52 Guennadi Liakhovetski wrote:
> > On Thu, 1 Sep 2011, Sakari Ailus wrote:
> > > On Wed, Aug 31, 2011 at 08:02:41PM +0200, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > > > +
> > > > 
> > > >  /*
> > > >  
> > > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> > > >   *
> > > > 
> > > > @@ -2182,6 +2194,9 @@ struct v4l2_dbg_chip_ident {
> > > > 
> > > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > > >  v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V',
> > > >  91, struct v4l2_event_subscription)
> > > > 
> > > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > > > +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> > > 
> > > Does prepare_buf ever do anything that would need to return anything to
> > > the user? I guess the answer is "no"?
> > 
> > Exactly, that's why it's an "_IOW" ioctl(), not an "_IOWR", or have I
> > misunderstood you?
> 
> This caught my eyes as well. Do you think VIDIOC_PREPARE_BUF could need to 
> return information to userspace in the future ?

Let's see: "[PATCH 2/9 v6]," it has been an "_IOW" since v1, posted on 
01.04 - exactly 5 months ago, when it was still called SUBMIT_BUF. So, 
IIRC, since then noone has come up with even a doubt, that this might need 
to change in the future (until today), let alone an example, what might 
need to be given back.

But sure, I cannot look into the future, so, I'm all ears.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
