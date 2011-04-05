Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57867 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1DEMuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:50:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer management
Date: Tue, 5 Apr 2011 14:50:48 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <201104051421.03597.laurent.pinchart@ideasonboard.com> <201104051434.57489.hansverk@cisco.com>
In-Reply-To: <201104051434.57489.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051450.49306.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 05 April 2011 14:34:57 Hans Verkuil wrote:
> On Tuesday, April 05, 2011 14:21:03 Laurent Pinchart wrote:
> > On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:

[snip]

> > > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
> > > 
> > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
> > > 
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
> I would just pass struct v4l2_buffer to this ioctl, just like QBUF/DQBUF
> do.

v4l2_buffer has a single reserved field (we could reclaim the input field, 
it's not used by any in-tree driver). Shouldn't we a bit more future-proof ?

-- 
Regards,

Laurent Pinchart
