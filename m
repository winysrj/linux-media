Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:48864 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZBYMbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 07:31:35 -0500
Received: from [195.7.61.7] (cozumel.koala.ie [195.7.61.7])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n1PCVW8p011535
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 12:31:32 GMT
Message-ID: <49A53A24.5000304@koala.ie>
Date: Wed, 25 Feb 2009 12:31:32 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl> <49A50018.40708@koala.ie>
In-Reply-To: <49A50018.40708@koala.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simon Kenyon wrote:
> Hans Verkuil wrote:
>> Hi all,
>>
>> There are lot's of discussions, but it can be hard sometimes to 
>> actually determine someone's opinion.
>>
>> So here is a quick poll, please reply either to the list or directly 
>> to me with your yes/no answer and (optional but welcome) a short 
>> explanation to your standpoint. It doesn't matter if you are a user 
>> or developer, I'd like to see your opinion regardless.
>>
>> Please DO NOT reply to the replies, I'll summarize the results in a 
>> week's time and then we can discuss it further.
>>
>> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>>
>> _: Yes
>> _: No
>>   
> No
i am an idiot - i read the question backwards

that really should be "YES"
i don't think old kernels should be maintained within the v4l-dvb tree

that is the job of the distributions - for which people pay money
let the distribution vendors pick that one up

>> Optional question:
>>
>> Why:
>>
>>   
> i don't have a vote as i'm only a user and not a developer
>
> but i thought i would just make one point
>
> as far as i can see, the v4l-dvb tree exists to create support for a 
> particular class of hardware within the linux kernel
> the separate tree is very useful to lots of people (i include myself 
> in that) - but it is a byproduct of the development methodology
>
> so if you think this group's mission is to provide support for 
> distributions then you should vote no
> and if you think this group's mission is to provide support for the 
> linux kernel then you should vote yes
>
>>
>> Thanks,
>>
>>     Hans
>>
>>   
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

