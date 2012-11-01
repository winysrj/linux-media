Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1548 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844Ab2KAQBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 12:01:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
Date: Thu, 1 Nov 2012 17:01:02 +0100
Cc: media-workshop@linuxtv.org,
	"linux-media" <linux-media@vger.kernel.org>
References: <201210221035.56897.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210222313490.32591@axis700.grange> <Pine.LNX.4.64.1210311408300.12173@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210311408300.12173@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211011701.02482.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 31 2012 14:12:05 Guennadi Liakhovetski wrote:
> Hi all
> 
> On Mon, 22 Oct 2012, Guennadi Liakhovetski wrote:
> 
> > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > 
> > > Hi all,
> > > 
> > > This is the tentative agenda for the media workshop on November 8, 2012.
> > > If you have additional things that you want to discuss, or something is wrong
> > > or incomplete in this list, please let me know so I can update the list.
> > > 
> > > - Explain current merging process (Mauro)
> > > - Open floor for discussions on how to improve it (Mauro)
> > > - Write down minimum requirements for new V4L2 (and DVB?) drivers, both for
> > >   staging and mainline acceptance: which frameworks to use, v4l2-compliance,
> > >   etc. (Hans Verkuil)
> > > - V4L2 ambiguities (Hans Verkuil)
> > > - TSMux device (a mux rather than a demux): Alain Volmat
> > > - dmabuf status, esp. with regards to being able to test (Mauro/Samsung)
> > > - Device tree support (Guennadi, not known yet whether this topic is needed)
> > 
> > + asynchronous probing, I guess. It's probably implicitly included though.
> 
> As the meeting approaches, it would be good to have a decision - do we 
> want to discuss DT / async or not? My flights this time are not quite long 
> enough to prepare for the discussion on them;-)

Looking at the current discussions I think discussing possible async solutions
would be very useful. The DT implementation itself seems to be OK, at least I
haven't seen any big discussions regarding that.

Regards,

	Hans
