Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:59044 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3IDKsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Sep 2013 06:48:36 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSL006P9KOSFQ40@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Sep 2013 06:48:35 -0400 (EDT)
Date: Wed, 04 Sep 2013 07:48:29 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	hugues.fruchet@st.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <posciak@chromium.org>,
	media-workshop <media-workshop@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-media@vger.kernel.org
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Message-id: <20130904074829.7ea2bfa6@samsung.com>
In-reply-to: <CA+M3ks7whrGtkboVcstoEQBRTkiLGF7Hf9nEsYEkyUD6=QPG9w@mail.gmail.com>
References: <201308301501.25164.hverkuil@xs4all.nl> <1440169.4erfBAv8If@avalon>
 <CACHYQ-qDD5S5FJvzT-oUBe+Y+S=CB_ZN+QNQPpu+BFE-ZPr45g@mail.gmail.com>
 <1590738.js4VoLrYFn@avalon>
 <CA+M3ks7whrGtkboVcstoEQBRTkiLGF7Hf9nEsYEkyUD6=QPG9w@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin/Hugues,

Em Wed, 04 Sep 2013 10:26:01 +0200
Benjamin Gaignard <benjamin.gaignard@linaro.org> escreveu:

> Hi all,
> 
> Based on STM past experience we have seen variety of userland/kernel or
> CPU/DSP/Microcontroller split for video codecs.
> Each time we done proprietary kernel interface because of lack defacto
> kernel standard.
> Principal needs were: no memory copy, video codec interface (for example
> video encoder controls), frame base API, multiformat codecs.
> 
> In the past we have seen several hardware partitioning:
> a) basic CPU/hardware split: all the software run on CPU, basically it is
> bitstream parsing and preparation of hardware descriptors to call IPs.
> We made two different implementations:
> a.1) one fully in kernel embedded in kernel module the drawback was the
> proprietary API and the bitstream parsing stack reused from legacy project
> and no compliant to kernel coding guide lines.
> a.2) an other one was fully in userland with a minimal kernel drivers for
> write registers and catch interrupts, drawbacks were exposition of hardware
> registers in userland (no functional API but hardware specific API) and
> physical address exposed in userland.
> 
> b) DSP (or Microcontroller)/hardware split: the software partially run on
> coprocessor where the firmware handle the IP controls and the CPU do the
> bitstream parsing. On this implementation all the stack running on CPU was
> on userland with proprietary API for firmware communication.
> 
> After that Exynos S5P show up, with an interesting M2M interface very close
> to what was done by us on step a.1) and let us hope an incoming
> standardization for video codecs kernel API.
> The main benefit we see of this is a reduction of software diversity on top
> kernel being agnostic to hardware used, for example we could introduce then
> a unified gstreamer v4l2 decoder plugin or unified OMX decoder plugin.
> 
> For us it is important to keep the hardware details as low as possible is
> software stack (i.e. kernel drivers) instead of a collection of proprietary
> userland libraries.
> What we are doing now is trying to go this way for next products.
> 
> Regarding S5P MFC all codec software stack remains in firmware, so kernel
> driver deals only with power/interrupt/clock and firmware communication but
> no processing are done on input bitstream or output frames. Our split is
> different because bitstream parsing is left to CPU, it means we put in the
> kernel significant amount of code to do that. The questions is how to push
> that code ?
> 
> What we have seen also it that several software stacks (ffmpeg, G1, ...)
> are doing same operation on bitstream (it is logical because it is link to
> the standards), so what about making it generic to avoid to embed quite the
> same code on several v4l2 drivers ?

I think we need more discussions to understand exactly what kind of bitstream
operations are needed to be done on the codec for your hardware.

As already discussed, technically, there are two possible solutions:

	1) delegate those tasks to an userspace library (libv4l);

	2) do them in Kernel.

Both have vantages and disadvantages. Among others, one of the reasons why
we opted to handle different formats in userspace is because we don't do
floating point(FP) registers in Kernel. For some kind of codecs, that would 
be a need. 

While it would theoretically be possible to use FP inside the Kernel,
that would require lots of work (Kernel currently doesn't save FP status.
Also, as Kernel stacks is typically measured in a few KB, pushing them on
stack could be a problem).

Also, FP is very arch-dependent, and we try to make the drivers to not be so
tight on some specific architecture (of course, when this makes sense).
So, the solution would be to have a kernel library for FP, capable of
using the hardware registers for each specific arch, but writing it would
require lots of time and efforts.

Also, for a normal V4L2 input or output driver, handling the video format
on userspace works fine, and the FP issue is automatically solved by
gcc FP code.

Due to that, delegating the formats handling to userspace proofed to be the
best way for the current drivers. 

Yet, if it doesn't fit on your needs, we're open to discuss your proposal.

Btw, this is the kind of discussions that works best on a presencial
meeting, where you could show more about your problem and talk about
your proposals to address it.

Are you planning to go to the mini-summit? If so, how much time do you
need in order to do such discussions?

> 
> Benjamin (+Hugues in CC)
> 
> 
> 2013/8/31 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > On Saturday 31 August 2013 09:04:14 Pawel Osciak wrote:
> > > On Sat, Aug 31, 2013 at 9:03 AM, Laurent Pinchart wrote:
> > > > On Saturday 31 August 2013 08:58:41 Pawel Osciak wrote:
> > > > > On Sat, Aug 31, 2013 at 1:54 AM, Laurent Pinchart wrote:
> > > > > > On Friday 30 August 2013 10:31:23 Mauro Carvalho Chehab wrote:
> > > > > > > Em Fri, 30 Aug 2013 15:21:05 +0200 Oliver Schinagl escreveu:
> >
> > [snip]
> >
> > > > > > > > What about a hardware accelerated decoding API/framework? Is
> > there
> > > > > > > > a proper framework for this at all? I see the broadcom module
> > is
> > > > > > > > still in staging and may never come out of it, but how are
> > other
> > > > > > > > video decoding engines handled that don't have cameras or
> > > > > > > > displays.
> > > > > > > >
> > > > > > > > Reason for asking is that we from linux-sunxi have made some
> > > > > > > > positive progress in Reverse engineering the video decoder
> > blob of
> > > > > > > > the Allwinner A10 and this knowledge will need a kernel side
> > > > > > > > driver in some framework.
> > > > > > > >
> > > > > > > > I looked at the exynos video decoders and googling for
> > linux-media
> > > > > > > > hardware accelerated decoding doesn't yield much either.
> > > > > > > >
> > > > > > > > Anyway, just a thought; if you think it's the wrong place for
> > it
> > > > > > > > to be discussed, that's ok :)
> > > > > > >
> > > > > > > Well, the mem2mem V4L2 devices should provide all that would be
> > > > > > > needed for accelerated encoders/decoders. If not, then feel free
> > to
> > > > > > > propose extensionsto fit your needs.
> > > > > >
> > > > > > Two comments regarding this:
> > > > > >
> > > > > > - V4L2 mem-to-mem is great for frame-based codecs, but SoCs
> > sometimes
> > > > > >   only implement part of the codec in hardware, leaving the rest to
> > > > > >   the software.
> > > > > >
> > > > > > Encoded bistream parsing is one of those areas that are left to the
> > > > > > CPU, for instance on some ST SoCs (CC'ing Benjamin Gaignard).
> > > > >
> > > > > This is an interesting topic for me as well, although I'm still not
> > sure
> > > > > if I can make it to the workshop. Would it make sense to have v4l
> > parser
> > > > > plugins hook up to qbuf and do the parsing there?
> > > >
> > > > Do you mean in libv4l ?
> > >
> > > Yes...
> >
> > Let's discuss that in Edinburgh then. The major problem as I see it is that
> > the hardware codec might consume and produce data that wouldn't fit the
> > spirit
> > of the current V4L2 API. We might end up with passing register lists in a
> > V4L2
> > buffer, which would be pretty ugly.
> >
> > Benjamin, do you plan to attend the conference ?
> >
> > > > > > - http://www.linuxplumbersconf.org/2013/ocw/sessions/1605
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> >
> >
> 
> 


-- 

Cheers,
Mauro
