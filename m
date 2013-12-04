Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50523 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3LDU53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 15:57:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 7/9] vb2: add thread support
Date: Wed, 04 Dec 2013 21:57:35 +0100
Message-ID: <5480918.Kt3LeCSPWy@avalon>
In-Reply-To: <529F6073.4080308@xs4all.nl>
References: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl> <14003669.Z9DbBGJgYq@avalon> <529F6073.4080308@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 04 December 2013 18:03:47 Hans Verkuil wrote:
> On 12/04/2013 05:33 PM, Laurent Pinchart wrote:
> > On Wednesday 04 December 2013 08:47:25 Hans Verkuil wrote:
> >> On 12/04/2013 02:17 AM, Laurent Pinchart wrote:
> >>> On Tuesday 03 December 2013 10:56:07 Hans Verkuil wrote:
> >>>> On 11/29/13 19:21, Laurent Pinchart wrote:
> >>>>> On Friday 29 November 2013 10:58:42 Hans Verkuil wrote:
> >>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>>> 
> >>>>>> In order to implement vb2 DVB or ALSA support you need to be able to
> >>>>>> start a kernel thread that queues and dequeues buffers, calling a
> >>>>>> callback function for every captured/displayed buffer. This patch
> >>>>>> adds support for that.
> >>>>>> 
> >>>>>> It's based on drivers/media/v4l2-core/videobuf-dvb.c, but with all
> >>>>>> the DVB specific stuff stripped out, thus making it much more
> >>>>>> generic.
> >>>>> 
> >>>>> Do you see any use for this outside of videobuf2-dvb ? If not I wonder
> >>>>> whether the code shouldn't be moved there. The sync objects framework
> >>>>> being developed for KMS will in my opinion cover the other use cases,
> >>>>> and I'd like to discourage non-DVB drivers to use vb2 threads in the
> >>>>> meantime.
> >>>> 
> >>>> I'm using it for ALSA drivers which, at least in my case, require
> >>>> almost identical functionality as that needed by DVB.
> >>> 
> >>> You're using videobuf2 for audio ?
> >> 
> >> For this particular board the audio DMA is just another DMA channel.
> >> Handling audio DMA is identical to video DMA. Why reinvent the wheel?
> > 
> > videobuf2 is more about buffer management than DMA management. As the code
> > is based around a two-dimensional, possibly multiplanar, buffer it's
> > quite hackish to reuse it for audio.
> 
> I disagree with that. vb2 has all the right hooks to start/stop DMA and
> queue/dequeue buffers. It's used for VBI as well and can just as easily
> support meta data. For this particular board there is no difference
> between audio and video DMA.
> 
> > Doesn't ALSA offer a buffer management library?
> 
> Yes it does. But due to the peculiarities of the particular board it wasn't
> sufficient. Specifically I must copy the audio data from the alsa buffers to
> vb2 buffers since the layout of the data differs.
> 
> As mentioned I will also work on a different board where the audio DMA is
> much more standard (i.e. the same buffer layout can be used), and I want to
> investigate if using vb2 in that case makes sense or not.

Let's revisit the topic when you'll work on that board then.

> >> The board I developed this for has somewhat peculiar audio handling
> >> (sorry, it's an internal product and I can't go into details), but I'll
> >> do the same exercise for another board that I can open source and there
> >> audio handling is standard. I want to see if I can use that to develop a
> >> videobuf2-alsa.c module that takes care of most of the alsa complexity. I
> >> don't know yet how that will work out, I'll have to experiment a bit.
> >> 
> >>>> But regardless of that, I really don't like the way it was done in the
> >>>> old videobuf framework, mixing low-level videobuf calls/data structure
> >>>> accesses with DVB code. That should be separate.
> >>>> 
> >>>> The vb2 core framework should provide the low-level functionality that
> >>>> is needed by the videobuf2-dvb to build on.
> >>> 
> >>> Right, but I want to make sure that drivers will not start using this
> >>> directly.
> >> 
> >> What sort of use-cases were you thinking of, other than DVB and ALSA? I
> >> don't off-hand see one.
> > 
> > That's the thing, I don't see any valid use case, I just want to make sure
> > we won't get crazy use cases implemented with vb2 threads in the future
> > :-)
> >
> >>> It should be an internal videobuf2 API.
> >> 
> >> I happily add comments to the source and header mentioning that it is for
> >> core use only and that for any other uses the mailinglist should be
> >> contacted, but I really don't want to mix core vb2 code with DVB code.
> >> That should remain separate.
> > 
> > OK, that sounds good with me.
> > 
> > What about moving thread support to videobuf2-thread.c ?
> 
> I tried that originally, but in order to do that I had to make a number
> of low-level vb2 functions extern instead of static, and that was quite
> messy. So I decided against that. It's not that much code (106 lines),
> after all.

OK, fair enough. Please just add a comment to the header saying that drivers 
must not use that API then.

> That said, it might be interesting at some point to split off the fileio
> and thread handling into a separate file.

That would be nice indeed.

-- 
Regards,

Laurent Pinchart

