Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3HaUgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 16:36:48 -0400
Date: Sat, 31 Aug 2013 22:36:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: media-workshop@linuxtv.org, Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
In-Reply-To: <1914410.cJBkn24AFZ@avalon>
Message-ID: <Pine.LNX.4.64.1308312231270.26694@axis700.grange>
References: <201308301501.25164.hverkuil@xs4all.nl> <52219093.7080409@xs4all.nl>
 <Pine.LNX.4.64.1308312020020.26694@axis700.grange> <1914410.cJBkn24AFZ@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 31 Aug 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Saturday 31 August 2013 20:38:54 Guennadi Liakhovetski wrote:
> > On Sat, 31 Aug 2013, Hans Verkuil wrote:
> > > On 08/30/2013 03:01 PM, Hans Verkuil wrote:
> > > > OK, I know, we don't even know yet when the mini-summit will be held but
> > > > I thought I'd just start this thread to collect input for the agenda.
> > > > 
> > > > I have these topics (and I *know* that I am forgetting a few):
> 
> [snip]
> 
> > > > Feel free to add suggestions to this list.
> > > 
> > > I got another one:
> > > 
> > > VIDIOC_TRY_FMT shouldn't return -EINVAL when an unsupported pixelformat is
> > > provided, but in practice video capture board tend to do that, while
> > > webcam drivers tend to map it silently to a valid pixelformat. Some
> > > applications rely on the -EINVAL error code.
> > > 
> > > We need to decide how to adjust the spec. I propose to just say that some
> > > drivers will map it silently and others will return -EINVAL and that you
> > > don't know what a driver will do. Also specify that an unsupported
> > > pixelformat is the only reason why TRY_FMT might return -EINVAL.
> > > 
> > > Alternatively we might want to specify explicitly that EINVAL should be
> > > returned for video capture devices (i.e. devices supporting S_STD or
> > > S_DV_TIMINGS) and 0 for all others.
> > 
> > Just to make sure I understand right - that kind of excludes cameras,
> > right? Still, even for (other) video capture devices, like TV decoders, is
> > there a real serious enough reason to _change_ the specs, which says
> > 
> > http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-fmt.html
> > 
> > EINVAL
> > 
> >     The struct v4l2_format type field is invalid or the requested buffer
> > type not supported.
> 
> I think Hans meant unsupported fmt.pix.pixelformat (or the equivalent for 
> multiplane) values.

Good, then I understood him correctly :)

> For instance the uvcvideo driver will return a default 
> fourcc if an application tries an unsupported fourcc,

Yes, that's what I would do too and that's what the spec dictates.

> some other drivers 
> return -EINVAL.

that just seems plain wrong to me. So, as I said, to not break the 
userspace we can extend the specs, but not prohibit the currently defined 
behaviour. So, that last option:

> > > Alternatively we might want to specify explicitly that EINVAL should be
> > > returned for video capture devices (i.e. devices supporting S_STD or
> > > S_DV_TIMINGS) and 0 for all others.

I'm not sure I like a lot, unless those drivers are very special and they 
all already behave like that.

Thanks
Guennadi

> > If we have a spec, that says A, and some drivers drivers do A, but others
> > do B, and we want to change the specs to B? Instead of either changing the
> > (wrong) drivers to A (yes, some applications expect that wrong behaviour)
> > or at least extending the spec to allow both A and B?
> 
> -- 
> Regards,
> 
> Laurent Pinchart

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
