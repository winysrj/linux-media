Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppp250-191.static.internode.on.net ([203.122.250.191]:44792
	"EHLO wiggum.skunkworks.net.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752782AbZBYBVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 20:21:14 -0500
Message-ID: <49A49646.6000105@symons.net.au>
Date: Wed, 25 Feb 2009 11:22:22 +1030
From: Ant <ant@symons.net.au>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi all,
>
> There are lot's of discussions, but it can be hard sometimes to actually 
> determine someone's opinion.
>
> So here is a quick poll, please reply either to the list or directly to me 
> with your yes/no answer and (optional but welcome) a short explanation to 
> your standpoint. It doesn't matter if you are a user or developer, I'd like 
> to see your opinion regardless.
>
> Please DO NOT reply to the replies, I'll summarize the results in a week's 
> time and then we can discuss it further.
>
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
>   
Yes
> _: No
>
> Optional question:
>
> Why:
Firstly let me state that I am not a v4l developer. I have been lurking 
on this list and its predecessor for about 3 years as I find low level 
hardware programming very interesting. The main concern for the no camp 
seemed to be support for EL5. I use EL 3, 4 and 5 for different purposes 
to this day, and I would like to add my viewpoint. I know the older 
releases have inferior hardware support compared to the newer ones, but 
to me this is not a problem, just a consideration when selecting the 
hardware I wish to use. If v4l stops supporting kernels < 2.6.22 then it 
is not like EL5 based on 2.6.18 will instantly be useless. It just means 
that you will need to find a camera or dvr card that is already 
supported. I dont see that this is a problem, and think that this trade 
off is worth it so as to not complicate life for future development more 
than it needs to be.

Ant
