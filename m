Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZCILIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 07:08:46 -0400
Date: Mon, 9 Mar 2009 08:08:39 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: wk <handygewinnspiel@gmx.de>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: V4L2 spec
In-Reply-To: <49B14D3C.3010001@gmx.de>
Message-ID: <alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
References: <200903061523.15766.hverkuil@xs4all.nl> <49B14D3C.3010001@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009, wk wrote:

> Hans Verkuil wrote:
>>  Hi Mauro,
>>
>>  I noticed that there is an ancient V4L2 spec in our tree in the v4l/API
>>  directory. Is that spec used in any way? I don't think so, so I suggest
>>  that it is removed.

OK.

>>  The V4L1 spec that is there should probably be moved to the v4l2-spec
>>  directory as that is where people would look for it. We can just keep it
>>  there for reference.

Nah. Let's just strip and point to some place where V4L1 doc is 
available, adding some warning that the API is outdated and will be 
removed from kernel soon.

>>  The documentation on www.linuxtv.org is also out of date. How are we going
>>  to update that?

Make a proposal. I'll then updade it acordingly.

>>  I think that a good schedule would be right after a kernel merge window
>>  closes. The spec at that moment is the spec for that new kernel and that's
>>  a good moment to update the website.
>>
>>  The current spec is really old, though, and should be updated asap.
>>
>>  Note that the specs from the daily build are always available from
>>  www.xs4all.nl/~hverkuil/spec. I've modified the build to upload the
>>  dvbapi.pdf as well.

Maybe we can add a script to daily update at linuxtv.org for the specs as
well.

> Wouldn't it make sense to merge both apis, v4l2 and dvb together?
>
> - dvb api is completely outdated, would be good to be rewritten anyway.
> - v4l2 and dvb share the same hg
> - v4l2 and dvb share the same wiki
> - a lot of developers are active in both topics
> - any person interested in video and tv could be directed to the same file
>
> Just some thoughts to the topic..

I think so. The better would be to convert DVB api to docbook (as used by 
all other kernel documents), and add a developers document for the kernel 
API for both at the kernel documentation structure).

However, this is a huge task that someone should volunteer for doing, 
otherwise, it won't happen.

Cheers,
Mauro
