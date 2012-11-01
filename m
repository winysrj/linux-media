Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49173 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KAQEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 12:04:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: media-workshop@linuxtv.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
Date: Thu, 01 Nov 2012 17:05:12 +0100
Message-ID: <31457466.htZuxY1j9H@avalon>
In-Reply-To: <201211011701.02482.hverkuil@xs4all.nl>
References: <201210221035.56897.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210311408300.12173@axis700.grange> <201211011701.02482.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 November 2012 17:01:02 Hans Verkuil wrote:
> On Wed October 31 2012 14:12:05 Guennadi Liakhovetski wrote:
> > On Mon, 22 Oct 2012, Guennadi Liakhovetski wrote:
> > > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > > Hi all,
> > > > 
> > > > This is the tentative agenda for the media workshop on November 8,
> > > > 2012. If you have additional things that you want to discuss, or
> > > > something is wrong or incomplete in this list, please let me know so I
> > > > can update the list.
> > > > 
> > > > - Explain current merging process (Mauro)
> > > > - Open floor for discussions on how to improve it (Mauro)
> > > > - Write down minimum requirements for new V4L2 (and DVB?) drivers,
> > > >   both for staging and mainline acceptance: which frameworks to use,
> > > >   v4l2-compliance, etc. (Hans Verkuil)
> > > > 
> > > > - V4L2 ambiguities (Hans Verkuil)
> > > > - TSMux device (a mux rather than a demux): Alain Volmat
> > > > - dmabuf status, esp. with regards to being able to test
> > > > (Mauro/Samsung)
> > > > - Device tree support (Guennadi, not known yet whether this topic is
> > > > needed)
> > > 
> > > + asynchronous probing, I guess. It's probably implicitly included
> > > though.
> > 
> > As the meeting approaches, it would be good to have a decision - do we
> > want to discuss DT / async or not? My flights this time are not quite long
> > enough to prepare for the discussion on them;-)
> 
> Looking at the current discussions I think discussing possible async
> solutions would be very useful. The DT implementation itself seems to be
> OK, at least I haven't seen any big discussions regarding that.

Agreed.

-- 
Regards,

Laurent Pinchart

