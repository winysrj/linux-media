Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754119AbZCFQUS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 11:20:18 -0500
Message-ID: <49B14D3C.3010001@gmx.de>
Date: Fri, 06 Mar 2009 17:20:12 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: V4L2 spec
References: <200903061523.15766.hverkuil@xs4all.nl>
In-Reply-To: <200903061523.15766.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Mauro,
>
> I noticed that there is an ancient V4L2 spec in our tree in the v4l/API 
> directory. Is that spec used in any way? I don't think so, so I suggest 
> that it is removed.
>
> The V4L1 spec that is there should probably be moved to the v4l2-spec 
> directory as that is where people would look for it. We can just keep it 
> there for reference.
>
> The documentation on www.linuxtv.org is also out of date. How are we going 
> to update that?
>
> I think that a good schedule would be right after a kernel merge window 
> closes. The spec at that moment is the spec for that new kernel and that's 
> a good moment to update the website.
>
> The current spec is really old, though, and should be updated asap.
>
> Note that the specs from the daily build are always available from 
> www.xs4all.nl/~hverkuil/spec. I've modified the build to upload the 
> dvbapi.pdf as well.
>
> Regards,
>
> 	Hans
>
>   

Wouldn't it make sense to merge both apis, v4l2 and dvb together?

- dvb api is completely outdated, would be good to be rewritten anyway.
- v4l2 and dvb share the same hg
- v4l2 and dvb share the same wiki
- a lot of developers are active in both topics
- any person interested in video and tv could be directed to the same file

Just some thoughts to the topic..

--Winfried

