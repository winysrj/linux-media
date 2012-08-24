Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab2HXRE5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 13:04:57 -0400
Message-ID: <5037B425.2030706@redhat.com>
Date: Fri, 24 Aug 2012 14:04:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media summit at the Kernel Summit - was: Fwd:
 Re: [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
References: <20120713173708.GB17109@thunk.org> <503759F7.8040907@redhat.com> <Pine.LNX.4.64.1208241406010.20710@axis700.grange> <1833523.h2Fu1nApC7@avalon> <Pine.LNX.4.64.1208241437120.20710@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1208241437120.20710@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-08-2012 09:41, Guennadi Liakhovetski escreveu:
> Hi Laurent
> 
> On Fri, 24 Aug 2012, Laurent Pinchart wrote:
> 
>> Hi Guennadi,
>>
>> On Friday 24 August 2012 14:11:58 Guennadi Liakhovetski wrote:
>>> On Fri, 24 Aug 2012, Mauro Carvalho Chehab wrote:
>>>> Em 22-08-2012 18:39, Naveen KRISHNAMURTHY escreveu:
>>>>> Hi Mauro,
>>>>>
>>>>> Can you please provide the schedule for the linuxTV discussions this
>>>>> time at San Diego? Which day will it be on? If you have a detailed
>>>>> schedule, please pass on. I am planning to be in only on that day as I
>>>>> cannot stay back more than that this time around.> 
>>>>
>>>> The media workshop will be at Tuesday, August 28th, with the following
>>>> agenda, for the ones that got the invitation:
>>>>     morning:
>>>>            V4L2 API ambiguities + v4l2 compliance tool: 60 min
>>>>            Media Controller library: 30 min
>>>>            ALSA and V4L/Media Controller: 30 min
>>>>            ARM and needed features for V4L/DVB: 30 min
>>>>     
>>>>     - after lunch:
>>>>            SoC Vendors feedback – how to help them to go upstream: 45 min
>>>>            V4L2/DVB issues from userspace perspective: 45 min
>>>>            Android's V4L2 cam library: 30 min
>>>
>>> Wow, this is interesting... Have I proposed this? :-) Or is anyone else
>>> working on an alternative solution?... I don't mind talking about this, if
>>> indeed my work is meant, just really cannot remember discussing taking
>>> this topic to the KS... I might have forgotten though... /me confused :-)

It was proposed by someone ;) I think you said you would be giving this
talk, if I'm not mistaken, on the discussions we had. So, we're counting
on you ;)


>>>
>>>>            HDMI CEC: 30 min
>>>>            Synchronization, shared resource and optimizations: 30 min
>>>
>>> What happened to the V4L DT topic? I believe, Sylwester and I have been
>>> discussing this pretty intensively over the last couple of weeks and,
>>> hopefully, are just about to submit an example V4L .dts fragment.

There was some discussions about having a DT summit or BoF there, so
it was left away from the media workshop, due to the lack of time for all
panels there (and since this is really a DT-specific theme). I didn't
track if the DT workshop got actually scheduled or not.
>>
>> I believe it was deemed to be a too complex topic that would take too much 
>> time to fit in the schedule. I will be free on Monday to discuss this, should 
>> we organize a (informal) meeting ?
> 
> Sure, everyone is most welcome to join me on the plane;-) I should arrive 
> to the airport at 18:15, so, if anyone would like to talk to me after a 
> 13.5-hour trip - we can try that:-)

I'm sure you'll be able to find some time along the week to do such
meeting. In my case, I don't feel I need to be on such discussions,
as this is not directly related to the media API, and such patches go
though other trees (or though media tree, but with DT maintainers
acks). Yet, I'd like to know about the end results of such discussions, 
in order to keep track of it.

Regards,
Mauro
