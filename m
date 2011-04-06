Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:57913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1DFQTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 12:19:24 -0400
Date: Wed, 6 Apr 2011 18:19:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <201104051434.57489.hansverk@cisco.com>
Message-ID: <Pine.LNX.4.64.1104061812560.22734@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1104011010530.9530@axis700.grange>
 <201104051421.03597.laurent.pinchart@ideasonboard.com>
 <201104051434.57489.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 5 Apr 2011, Hans Verkuil wrote:

> On Tuesday, April 05, 2011 14:21:03 Laurent Pinchart wrote:
> > On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:

[snip]

> > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> > >   *
> > > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > > v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91,
> > > struct v4l2_event_subscription)
> > > 
> > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> > > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct v4l2_buffer_span)
> > > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
> > > +
> > 
> > In case we later need to pass other information (such as flags) to 
> > VIDIOC_SUBMIT_BUF, you should use a structure instead of an int.
> 
> I would just pass struct v4l2_buffer to this ioctl, just like QBUF/DQBUF do.

As I said, I didn't like this very much, because it involves redundant 
data, but if we want to call .buf_prepare() from it, then we need 
v4l2_buffer...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
