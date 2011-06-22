Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3085 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab1FVMs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 08:48:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: vb2: holding buffers until after start_streaming()
Date: Wed, 22 Jun 2011 14:48:08 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Pawel Osciak'" <pawel@osciak.com>, linux-media@vger.kernel.org
References: <20110617125713.293f484d@bike.lwn.net> <002801cc30c0$ceb89880$6c29c980$%szyprowski@samsung.com> <20110622063855.108194da@bike.lwn.net>
In-Reply-To: <20110622063855.108194da@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221448.08092.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 22, 2011 14:38:55 Jonathan Corbet wrote:
> On Wed, 22 Jun 2011 11:43:14 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > > Do you really need a flag?  If a driver absolutely cannot stream without
> > > buffers queued (and can't be fixed to start streaming for real when the
> > > buffers show up) it should just return -EINVAL from start_streaming() or
> > > some such.  The driver must be aware of its limitations regardless, but
> > > there's no need to push that awareness into vb2 as well.  
> > 
> > The main idea behind vb2 was to move all common error handling code to
> > the framework and provide simple functions that can be used by the driver
> > directly without the need for additional checks.
> 
> For stuff that's truly common, that makes sense.  As soon as you start
> adding driver-specific flags, things aren't quite so common anymore.  In
> this case, the driver writer can just as easily check the state of the
> buffer queue at streamon time, so I don't see what would be gained.
> Whatever, doesn't matter that much.
> 
> > > (FWIW, I wouldn't switch the order of operations in vb2_streamon(); I
> > > would just take out the "if (q->streaming)" test at the end of vb2_qbuf()
> > > and pass the buffers through directly.  But maybe that's just me.)  
> > 
> > I want to keep the current version of vb2_qbuf() and change the order of
> > operations in streamon().
> 
> I'm curious as to why?  As far as I can tell, there's no reason not to
> pass the buffers straight through when you get them?

I'm curious as well. I don't see the problem with that.

> > The only problem that still need to be resolved is what should happen with
> > the buffers if start_streaming() fails. The ownership for these buffers have
> > been already given to the driver, but they might have been in dirty state.
> > Probably vb2 should assume that the buffers are lost and reinitialize them.
> 
> You already grab them back at stop_streaming() time, right?  I'd think
> that a failed start_streaming() should leave things in exactly the same
> state as a start/stop_streaming() sequence.

I think so too. vb2 can just call queue_cancel, I think.

Regards,

	Hans

> 
> Thanks,
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
