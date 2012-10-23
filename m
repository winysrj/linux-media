Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40081 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2JWBCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 21:02:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
Date: Tue, 23 Oct 2012 03:03:35 +0200
Message-ID: <2105402.EQpZdH2E13@avalon>
In-Reply-To: <201210221406.06388.hverkuil@xs4all.nl>
References: <201210221035.56897.hverkuil@xs4all.nl> <58737434.GCQXfamyaa@avalon> <201210221406.06388.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 October 2012 14:06:06 Hans Verkuil wrote:
> On Mon October 22 2012 13:18:46 Laurent Pinchart wrote:
> > On Monday 22 October 2012 12:53:02 Sylwester Nawrocki wrote:
> > > On 10/22/2012 12:39 PM, Laurent Pinchart wrote:
> > > > On Monday 22 October 2012 10:35:56 Hans Verkuil wrote:
> > > >> Hi all,
> > > >> 
> > > >> This is the tentative agenda for the media workshop on November 8,
> > > >> 2012. If you have additional things that you want to discuss, or
> > > >> something is wrong or incomplete in this list, please let me know so
> > > >> I can update the list.
> > > > 
> > > > Thank you Hans for taking care of the agenda.
> > > > 
> > > >> - Explain current merging process (Mauro)
> > > >> - Open floor for discussions on how to improve it (Mauro)
> > > >> - Write down minimum requirements for new V4L2 (and DVB?) drivers,
> > > >>   both for staging and mainline acceptance: which frameworks to use,
> > > >>   v4l2-compliance,
> > > >> 
> > > >> etc. (Hans Verkuil)
> > > >> - V4L2 ambiguities (Hans Verkuil)
> > > >> - TSMux device (a mux rather than a demux): Alain Volmat
> > > >> - dmabuf status, esp. with regards to being able to test
> > > >> (Mauro/Samsung)
> > > >> - Device tree support (Guennadi, not known yet whether this topic is
> > > >> needed) - Creating/selecting contexts for hardware that supports this
> > > >> (Samsung, only if time is available)
> > > > 
> > > > This last topic will likely require lots of brainstorming, and thus
> > > > time. If the schedule permits, would anyone be interested in meeting
> > > > earlier during the week already ?
> > > 
> > > My intention was to also possibly discuss it with others before the
> > > actual media workshop. Would be nice if we could have arranged such a
> > > meeting. I'm not sure about the room conditions though. It's probably
> > > not a big issue, unless there is really many people interested in that
> > > topic.
> > 
> > A small room with a projector would be nice if possible, although not
> > required. Who would be interested in attending a brainstorming session on
> > contexts ?
> 
> I would be, but the problem is that the conference is also interesting.

More interesting than a brainstorming session about hardware contexts ? ;-) 
There's of course talks I want to attend, but I can probably skip some of 
them.

> The only day I have really available is the Friday *after* the summit.

We'll probably need several brainstorming sessions anyway. I'd like to 
organize one before the media summit though, as we'll have limited time to 
discuss the topic during the summit, which doesn't suit brainstorming sessions 
very well.

-- 
Regards,

Laurent Pinchart

