Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab1IAIfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 04:35:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/9 v6] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Thu, 1 Sep 2011 10:35:48 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <20110831210615.GQ12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109010850560.21309@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109010850560.21309@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011035.48845.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 01 September 2011 09:03:52 Guennadi Liakhovetski wrote:
> On Thu, 1 Sep 2011, Sakari Ailus wrote:
> > On Wed, Aug 31, 2011 at 08:02:41PM +0200, Guennadi Liakhovetski wrote:

[snip]

> > > +
> > > 
> > >  /*
> > >  
> > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> > >   *
> > > 
> > > @@ -2182,6 +2194,9 @@ struct v4l2_dbg_chip_ident {
> > > 
> > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > >  v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V',
> > >  91, struct v4l2_event_subscription)
> > > 
> > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > > +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> > 
> > Does prepare_buf ever do anything that would need to return anything to
> > the user? I guess the answer is "no"?
> 
> Exactly, that's why it's an "_IOW" ioctl(), not an "_IOWR", or have I
> misunderstood you?

This caught my eyes as well. Do you think VIDIOC_PREPARE_BUF could need to 
return information to userspace in the future ?

-- 
Regards,

Laurent Pinchart
