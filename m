Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3883 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbZCITrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 15:47:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: V4L2 spec
Date: Mon, 9 Mar 2009 20:47:16 +0100
Cc: wk <handygewinnspiel@gmx.de>, linux-media@vger.kernel.org
References: <200903061523.15766.hverkuil@xs4all.nl> <49B14D3C.3010001@gmx.de> <alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
In-Reply-To: <alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903092047.16329.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 09 March 2009 12:08:39 Mauro Carvalho Chehab wrote:
> On Fri, 6 Mar 2009, wk wrote:
> > Hans Verkuil wrote:
> >>  Hi Mauro,
> >>
> >>  I noticed that there is an ancient V4L2 spec in our tree in the
> >> v4l/API directory. Is that spec used in any way? I don't think so, so
> >> I suggest that it is removed.
>
> OK.
>
> >>  The V4L1 spec that is there should probably be moved to the v4l2-spec
> >>  directory as that is where people would look for it. We can just keep
> >> it there for reference.
>
> Nah. Let's just strip and point to some place where V4L1 doc is
> available, adding some warning that the API is outdated and will be
> removed from kernel soon.

I don't think we should remove the doc from the repo until all drivers are 
converted to v4l2.

> >>  The documentation on www.linuxtv.org is also out of date. How are we
> >> going to update that?
>
> Make a proposal. I'll then updade it acordingly.

Can you just update it with the latest version compiled from v4l-dvb?

> >>  I think that a good schedule would be right after a kernel merge
> >> window closes. The spec at that moment is the spec for that new kernel
> >> and that's a good moment to update the website.

Updating it whenever a merge window closes seems to make sense to me, so I 
propose that we do that.

> >>  The current spec is really old, though, and should be updated asap.
> >>
> >>  Note that the specs from the daily build are always available from
> >>  www.xs4all.nl/~hverkuil/spec. I've modified the build to upload the
> >>  dvbapi.pdf as well.
>
> Maybe we can add a script to daily update at linuxtv.org for the specs as
> well.

That would be a good plan.

Regards,

	Hans


> > Wouldn't it make sense to merge both apis, v4l2 and dvb together?
> >
> > - dvb api is completely outdated, would be good to be rewritten anyway.
> > - v4l2 and dvb share the same hg
> > - v4l2 and dvb share the same wiki
> > - a lot of developers are active in both topics
> > - any person interested in video and tv could be directed to the same
> > file
> >
> > Just some thoughts to the topic..
>
> I think so. The better would be to convert DVB api to docbook (as used by
> all other kernel documents), and add a developers document for the kernel
> API for both at the kernel documentation structure).
>
> However, this is a huge task that someone should volunteer for doing,
> otherwise, it won't happen.
>
> Cheers,
> Mauro



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
