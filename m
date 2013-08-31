Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36488 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3HaACH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 20:02:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: media-workshop@linuxtv.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-media@vger.kernel.org, benjamin.gaignard@linaro.org
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Date: Sat, 31 Aug 2013 02:03:32 +0200
Message-ID: <1440169.4erfBAv8If@avalon>
In-Reply-To: <CACHYQ-qyuP+MjWNc7bVHhUa0xxzQHEmb3JFe+9n6C0GzOnj54A@mail.gmail.com>
References: <201308301501.25164.hverkuil@xs4all.nl> <3906204.pByWntDMrc@avalon> <CACHYQ-qyuP+MjWNc7bVHhUa0xxzQHEmb3JFe+9n6C0GzOnj54A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Saturday 31 August 2013 08:58:41 Pawel Osciak wrote:
> On Sat, Aug 31, 2013 at 1:54 AM, Laurent Pinchart wrote:
> > On Friday 30 August 2013 10:31:23 Mauro Carvalho Chehab wrote:
> > > Em Fri, 30 Aug 2013 15:21:05 +0200 Oliver Schinagl escreveu:
> > > > On 30-08-13 15:01, Hans Verkuil wrote:
> > > > > OK, I know, we don't even know yet when the mini-summit will be held
> > > > > but I thought I'd just start this thread to collect input for the
> > > > > agenda.
> > > > > 
> > > > > I have these topics (and I *know* that I am forgetting a few):
> > > > > 
> > > > > - Discuss ideas/use-cases for a property-based API. An initial
> > > > >   discussion appeared in this thread:
> > > > >   
> > > > >   http://permalink.gmane.org/gmane.linux.drivers.video-input-> > > > >   infrastructure/65195
> > > > >
> > > > > - What is needed to share i2c video transmitters between drm and
> > > > >   v4l? Hopefully we will know more after the upcoming LPC.
> > > > > 
> > > > > - Decide on how v4l2 support libraries should be organized. There is
> > > > >   code for handling raw-to-sliced VBI decoding, ALSA looping,
> > > > >   finding associated video/alsa nodes and for TV frequency tables.
> > > > >   We should decide how that should be organized into libraries and
> > > > >   how they should be documented. The first two aren't libraries at
> > > > >   the moment, but I think they should be. The last two are libraries
> > > > >   but they aren't installed. Some work is also being done on an
> > > > >   improved version of the 'associating nodes' library that uses the
> > > > >   MC if available.
> > > > > 
> > > > > - Define the interaction between selection API, ENUM_FRAMESIZES and
> > > > >   S_FMT. See this thread for all the nasty details:
> > > > >   
> > > > >   http://www.spinics.net/lists/linux-media/msg65137.html
> > > > > 
> > > > > Feel free to add suggestions to this list.
> > > 
> > > From my side, I'd like to discuss about a better integration between DVB
> > > and V4L2, including starting using the media controller API on DVB side
> > > too. Btw, it would be great if we could get a status about the media
> > > controller API usage on ALSA. I'm planning to work at such integration
> > > soon.
> > > 
> > > > What about a hardware accelerated decoding API/framework? Is there a
> > > > proper framework for this at all? I see the broadcom module is still
> > > > in staging and may never come out of it, but how are other video
> > > > decoding engines handled that don't have cameras or displays.
> > > > 
> > > > Reason for asking is that we from linux-sunxi have made some positive
> > > > progress in Reverse engineering the video decoder blob of the
> > > > Allwinner A10 and this knowledge will need a kernel side driver in
> > > > some framework.
> > > >
> > > > I looked at the exynos video decoders and googling for linux-media
> > > > hardware accelerated decoding doesn't yield much either.
> > > > 
> > > > Anyway, just a thought; if you think it's the wrong place for it to be
> > > > discussed, that's ok :)
> > > 
> > > Well, the mem2mem V4L2 devices should provide all that would be needed
> > > for accelerated encoders/decoders. If not, then feel free to propose
> > > extensionsto fit your needs.
> > 
> > Two comments regarding this:
> > 
> > - V4L2 mem-to-mem is great for frame-based codecs, but SoCs sometimes only
> > implement part of the codec in hardware, leaving the rest to the software.
> > Encoded bistream parsing is one of those areas that are left to the CPU,
> > for instance on some ST SoCs (CC'ing Benjamin Gaignard).
> 
> This is an interesting topic for me as well, although I'm still not sure if
> I can make it to the workshop. Would it make sense to have v4l parser
> plugins hook up to qbuf and do the parsing there?

Do you mean in libv4l ?

> > - http://www.linuxplumbersconf.org/2013/ocw/sessions/1605

-- 
Regards,

Laurent Pinchart

