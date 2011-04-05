Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1DEM5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:57:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:58:24 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <201104051434.57489.hansverk@cisco.com> <Pine.LNX.4.64.1104051449140.14419@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104051449140.14419@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051458.24483.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 05 April 2011 14:52:20 Guennadi Liakhovetski wrote:
> On Tue, 5 Apr 2011, Hans Verkuil wrote:
> > On Tuesday, April 05, 2011 14:21:03 Laurent Pinchart wrote:
> > > On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:
> [snip]
> 
> > > >  /*
> > > >  
> > > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> > > >   *
> > > > 
> > > > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> > > > 
> > > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > > > 
> > > > v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V',
> > > > 91, struct v4l2_event_subscription)
> > > > 
> > > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct
> > > > v4l2_create_buffers) +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93,
> > > > struct v4l2_buffer_span) +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94,
> > > > int)
> > > > +
> > > 
> > > In case we later need to pass other information (such as flags) to
> > > VIDIOC_SUBMIT_BUF, you should use a structure instead of an int.
> > 
> > I would just pass struct v4l2_buffer to this ioctl, just like QBUF/DQBUF
> > do.
> 
> Why??? You do not need all that extra information. Well, we could, of
> course, make a struct with reserved fields... but it seems nice to me to
> have the clarity here - this ioctl() _only_ gives buffer ownership to the
> kernel. No more configuration...

Right now you're correct. In the future we might need extra fields, so we need 
a structure with reserved fields.

-- 
Regards,

Laurent Pinchart
