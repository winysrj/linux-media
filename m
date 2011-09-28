Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1I1O7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 10:59:30 -0400
Date: Wed, 28 Sep 2011 16:59:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v9] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <4E832241.7030501@iki.fi>
Message-ID: <Pine.LNX.4.64.1109281658260.19957@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <201109271306.21095.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271417280.5816@axis700.grange>
 <201109271540.52649.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271847310.7004@axis700.grange>
 <Pine.LNX.4.64.1109281502380.30317@axis700.grange> <4E832241.7030501@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

On Wed, 28 Sep 2011, Sakari Ailus wrote:

> Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of a snapshot
> > mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > VIDIOC_PREPARE_BUF and defines respective data structures.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Hi Guennadi,
> 
> Thanks for the patch and your tireless efforts on this!
> 
> VIDIOC_PREPARE_BUF is actually _IOW (rather than _IOWR) in this patch. I
> guess it shouldn't be this way, or have I failed to understand
> something? :-)

hm, yeah, sure, thanks for catching.

Guennadi

> 
> [clip]
> 
> > @@ -2189,6 +2202,11 @@ struct v4l2_dbg_chip_ident {
> >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
> >  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
> >  
> > +/* Experimental, the below two ioctls may change over the next couple of kernel
> > +   versions */
> > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> > +
> >  /* Reminder: when adding new ioctls please add support for them to
> >     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> >  
> 
> 
> -- 
> Sakari Ailus
> sakari.ailus@iki.fi
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
