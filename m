Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:58396 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbZBYIXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 03:23:55 -0500
Received: from [195.7.61.7] (cozumel.koala.ie [195.7.61.7])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n1P8Nq0h006542
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 08:23:52 GMT
Message-ID: <49A50018.40708@koala.ie>
Date: Wed, 25 Feb 2009 08:23:52 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
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
> _: No
>   
No
> Optional question:
>
> Why:
>
>   
i don't have a vote as i'm only a user and not a developer

but i thought i would just make one point

as far as i can see, the v4l-dvb tree exists to create support for a 
particular class of hardware within the linux kernel
the separate tree is very useful to lots of people (i include myself in 
that) - but it is a byproduct of the development methodology

so if you think this group's mission is to provide support for 
distributions then you should vote no
and if you think this group's mission is to provide support for the 
linux kernel then you should vote yes

>
> Thanks,
>
> 	Hans
>
>   

