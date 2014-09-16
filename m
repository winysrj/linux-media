Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38780 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaIPMTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 08:19:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient buffer underruns
Date: Tue, 16 Sep 2014 15:19:12 +0300
Message-ID: <3482871.b5jpiHceq8@avalon>
In-Reply-To: <54181CA3.5010707@xs4all.nl>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <2160177.8xkXcAKlxC@avalon> <54181CA3.5010707@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 16 September 2014 13:18:59 Hans Verkuil wrote:
> On 09/16/14 12:29, Laurent Pinchart wrote:
> > On Monday 15 September 2014 13:14:51 Hans Verkuil wrote:
> >> On 06/06/2014 03:42 PM, Laurent Pinchart wrote:
> >>> On Friday 06 June 2014 11:58:18 Hans Verkuil wrote:
> >>>> On 06/06/2014 11:50 AM, Hans de Goede wrote:
> >>>>> On 06/05/2014 02:23 PM, Laurent Pinchart wrote:
> >>>>>> The V4L2 specification states that
> >>>>>> 
> >>>>>> "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet
> >>>>>> the poll() function succeeds, but sets the POLLERR flag in the
> >>>>>> revents field."
> >>>>>> 
> >>>>>> The vb2_poll() function sets POLLERR when the queued buffers list is
> >>>>>> empty, regardless of whether this is caused by the stream not being
> >>>>>> active yet, or by a transient buffer underrun.
> >>>>>> 
> >>>>>> Bring the implementation in line with the specification by returning
> >>>>>> POLLERR only when the queue is not streaming. Buffer underruns during
> >>>>>> streaming are not treated specially anymore and just result in poll()
> >>>>>> blocking until the next event.
> >>>>> 
> >>>>> After your patch the implementation is still not inline with the spec,
> >>>>> queuing buffers, then starting a thread doing the poll, then doing the
> >>>>> streamon in the main thread will still cause the poll to return
> >>>>> POLLERR, even though buffers are queued, which according to the spec
> >>>>> should be enough for the poll to block.
> >>>>> 
> >>>>> The correct check would be:
> >>>>> 
> >>>>> if (list_empty(&q->queued_list) && !vb2_is_streaming(q))
> >>>>> 
> >>>>> 	eturn res | POLLERR;
> >>>> 
> >>>> Good catch! I should have seen that :-(
> >> 
> >> Urgh. This breaks vbi capture tools like alevt and mtt. These rely on
> >> poll returning POLLERR if buffers are queued but STREAMON has not been
> >> called yet.
> > 
> > Then there's something I don't get. Before this commit, the implementation
> > was
> >     /*
> >      * There is nothing to wait for if no buffers have already been
> >      queued.
> >      */
> >     if (list_empty(&q->queued_list))
> >     
> >             return res | POLLERR;
> > 
> > If buffers are queued and STREAMON hasn't been called yet, vb2_poll()
> > would not return POLLERR.
> 
> You are right, I think this has been broken from the beginning. Most of
> the initial drivers that were converted to vb2 didn't use vbi. The first
> complaint came when saa7134 was converted. So it is not actually your
> commit that was wrong, it simply has always been wrong.

What a relief :-D
 
> >> See bug report https://bugzilla.kernel.org/show_bug.cgi?id=84401
> >> 
> >> The spec also clearly says that poll should return POLLERR if STREAMON
> >> was not called.
> > 
> > The V4L2 specification says
> > 
> > "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet the
> > poll() function succeeds, but sets the POLLERR flag in the revents field."
> > 
> > How about then
> > 
> > - adding a flag to vb2_queue that tells that no buffer has been queued
> > - clearing the flag when a buffer is queued
> > - setting the flag when the stream is stopped
> > - modifying the poll implementation to
> > 
> >     if (q->no_buffer || !vb2_is_streaming(q) || q->error)
> >             return res | POLLERR;
> 
> I thought about something like that as well, but I don't think this is a
> good idea. Mostly because you can call STREAMON without having queued
> buffers with vb2. In fact, that is pretty much necessary for video output
> so you don't have to queue up buffers with dummy contents.

Given that we will change both the code and the spec, let's take a minute to 
think about what will be the most beneficial implementation for userspace.

I believe poll() should not return POLLERR during transient buffer underruns, 
as that would put an unnecessary burden on all userspace applications that 
would need to explicitly handle that case. a list_empty() check alone is thus 
out of question.

We thus have three options regarding when to return POLLERR

1. At any time the queue isn't streaming (!vb2_is_streaming())
2. Only before buffers are queued for the first time (q->no_buffer)
3. When both 1. and 2. are true
4. When either 1. or 2. is true

(POLLERR should always be returned when q->error is set, let's skip that to 
keep the discussion simple)

I think we should always return POLLERR when the queue isn't streaming as 
there's nothing an application can possibly wait on in that case (with the 
exception of events, but those are handled separately, and POLLERR won't be 
returned if the application isn't interest in POLLIN and/or POLLOUT). This 
means that applications won't be able to poll() on a device before starting 
streaming, and multithreaded applications that start/stop streaming and poll 
in different threads will need to synchronize both. I don't see that as a 
problem, but feel free to disagree.

This thus rules out options 2. and 3., leaving 1. (your proposal) and 4. (my 
proposal). 4. has the advantage of complying with the V4L2 specification. 1. 
has the advantage of being simpler on both the kernel and application sides, 
as applications will be able to poll before the first buffer is queued. I 
don't really see a use case where an application would benefit from getting 
POLLERR after STREAMON when no buffer has been queued yet, but once again 
please feel free to be more creative than me :-)

If we go for option 1. I would like the patch to fix the specification.

-- 
Regards,

Laurent Pinchart

