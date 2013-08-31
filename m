Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42160 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3HaUSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 16:18:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: media-workshop <media-workshop@linuxtv.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-media@vger.kernel.org,
	"benjamin.gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Date: Sat, 31 Aug 2013 22:19:44 +0200
Message-ID: <1590738.js4VoLrYFn@avalon>
In-Reply-To: <CACHYQ-qDD5S5FJvzT-oUBe+Y+S=CB_ZN+QNQPpu+BFE-ZPr45g@mail.gmail.com>
References: <201308301501.25164.hverkuil@xs4all.nl> <1440169.4erfBAv8If@avalon> <CACHYQ-qDD5S5FJvzT-oUBe+Y+S=CB_ZN+QNQPpu+BFE-ZPr45g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 31 August 2013 09:04:14 Pawel Osciak wrote:
> On Sat, Aug 31, 2013 at 9:03 AM, Laurent Pinchart wrote:
> > On Saturday 31 August 2013 08:58:41 Pawel Osciak wrote:
> > > On Sat, Aug 31, 2013 at 1:54 AM, Laurent Pinchart wrote:
> > > > On Friday 30 August 2013 10:31:23 Mauro Carvalho Chehab wrote:
> > > > > Em Fri, 30 Aug 2013 15:21:05 +0200 Oliver Schinagl escreveu:

[snip]

> > > > > > What about a hardware accelerated decoding API/framework? Is there
> > > > > > a proper framework for this at all? I see the broadcom module is
> > > > > > still in staging and may never come out of it, but how are other
> > > > > > video decoding engines handled that don't have cameras or
> > > > > > displays.
> > > > > > 
> > > > > > Reason for asking is that we from linux-sunxi have made some
> > > > > > positive progress in Reverse engineering the video decoder blob of
> > > > > > the Allwinner A10 and this knowledge will need a kernel side
> > > > > > driver in some framework.
> > > > > > 
> > > > > > I looked at the exynos video decoders and googling for linux-media
> > > > > > hardware accelerated decoding doesn't yield much either.
> > > > > > 
> > > > > > Anyway, just a thought; if you think it's the wrong place for it
> > > > > > to be discussed, that's ok :)
> > > > > 
> > > > > Well, the mem2mem V4L2 devices should provide all that would be
> > > > > needed for accelerated encoders/decoders. If not, then feel free to
> > > > > propose extensionsto fit your needs.
> > > > 
> > > > Two comments regarding this:
> > > > 
> > > > - V4L2 mem-to-mem is great for frame-based codecs, but SoCs sometimes
> > > >   only implement part of the codec in hardware, leaving the rest to
> > > >   the software.
> > > >
> > > > Encoded bistream parsing is one of those areas that are left to the
> > > > CPU, for instance on some ST SoCs (CC'ing Benjamin Gaignard).
> > > 
> > > This is an interesting topic for me as well, although I'm still not sure
> > > if I can make it to the workshop. Would it make sense to have v4l parser
> > > plugins hook up to qbuf and do the parsing there?
> > 
> > Do you mean in libv4l ?
> 
> Yes...

Let's discuss that in Edinburgh then. The major problem as I see it is that 
the hardware codec might consume and produce data that wouldn't fit the spirit 
of the current V4L2 API. We might end up with passing register lists in a V4L2 
buffer, which would be pretty ugly.

Benjamin, do you plan to attend the conference ?

> > > > - http://www.linuxplumbersconf.org/2013/ocw/sessions/1605

-- 
Regards,

Laurent Pinchart

