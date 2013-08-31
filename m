Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3HaUXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 16:23:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: media-workshop@linuxtv.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Date: Sat, 31 Aug 2013 22:25:14 +0200
Message-ID: <1914410.cJBkn24AFZ@avalon>
In-Reply-To: <Pine.LNX.4.64.1308312020020.26694@axis700.grange>
References: <201308301501.25164.hverkuil@xs4all.nl> <52219093.7080409@xs4all.nl> <Pine.LNX.4.64.1308312020020.26694@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 31 August 2013 20:38:54 Guennadi Liakhovetski wrote:
> On Sat, 31 Aug 2013, Hans Verkuil wrote:
> > On 08/30/2013 03:01 PM, Hans Verkuil wrote:
> > > OK, I know, we don't even know yet when the mini-summit will be held but
> > > I thought I'd just start this thread to collect input for the agenda.
> > > 
> > > I have these topics (and I *know* that I am forgetting a few):

[snip]

> > > Feel free to add suggestions to this list.
> > 
> > I got another one:
> > 
> > VIDIOC_TRY_FMT shouldn't return -EINVAL when an unsupported pixelformat is
> > provided, but in practice video capture board tend to do that, while
> > webcam drivers tend to map it silently to a valid pixelformat. Some
> > applications rely on the -EINVAL error code.
> > 
> > We need to decide how to adjust the spec. I propose to just say that some
> > drivers will map it silently and others will return -EINVAL and that you
> > don't know what a driver will do. Also specify that an unsupported
> > pixelformat is the only reason why TRY_FMT might return -EINVAL.
> > 
> > Alternatively we might want to specify explicitly that EINVAL should be
> > returned for video capture devices (i.e. devices supporting S_STD or
> > S_DV_TIMINGS) and 0 for all others.
> 
> Just to make sure I understand right - that kind of excludes cameras,
> right? Still, even for (other) video capture devices, like TV decoders, is
> there a real serious enough reason to _change_ the specs, which says
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-fmt.html
> 
> EINVAL
> 
>     The struct v4l2_format type field is invalid or the requested buffer
> type not supported.

I think Hans meant unsupported fmt.pix.pixelformat (or the equivalent for 
multiplane) values. For instance the uvcvideo driver will return a default 
fourcc if an application tries an unsupported fourcc, some other drivers 
return -EINVAL.

> If we have a spec, that says A, and some drivers drivers do A, but others
> do B, and we want to change the specs to B? Instead of either changing the
> (wrong) drivers to A (yes, some applications expect that wrong behaviour)
> or at least extending the spec to allow both A and B?

-- 
Regards,

Laurent Pinchart

