Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48513 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728991AbeJWFlW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 01:41:22 -0400
Subject: Re: [RFC] Informal meeting during ELCE to discuss userspace support
 for stateless codecs
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        =?UTF-8?B?VsOtY3RvciBKw6FxdWV6?= <vjaquez@igalia.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
 <fe5f3088-84cc-b15d-a8a7-a9557aeb7246@xs4all.nl>
 <5266630e-d1f8-8613-98e7-5def3c34fb4a@xs4all.nl>
Message-ID: <e4f73bea-67a2-2020-bb5a-e4355af6fe70@xs4all.nl>
Date: Mon, 22 Oct 2018 22:21:04 +0100
MIME-Version: 1.0
In-Reply-To: <5266630e-d1f8-8613-98e7-5def3c34fb4a@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/22/2018 10:17 PM, Hans Verkuil wrote:
> A quick update:
> 
> As said in my previous email: we'll meet at 11 am at the registration desk.
> From there we go to the Platform 5 Cafe. If that's too crowded/noisy, then
> we'll try the Sheraton hotel.
> 
> Tomasz, I'll ping you on irc when we found a good spot and we can setup the
> Hangouts meeting.

I forgot to mention: the spec with the Request API and the stateful+stateless
codec API specification (latest patches from Tomasz and Alexandre) are available
here:

https://hverkuil.home.xs4all.nl/request-api/

Also CC-ed Alexandre and Phillip.

Regards,

	Hans

> 
> Hope to see you all tomorrow,
> 
> Regards,
> 
> 	Hans
> 
> On 10/10/2018 07:55 AM, Hans Verkuil wrote:
>> On 10/08/2018 01:53 PM, Hans Verkuil wrote:
>>> Hi all,
>>>
>>> I would like to meet up somewhere during the ELCE to discuss userspace support
>>> for stateless (and perhaps stateful as well?) codecs.
>>>
>>> It is also planned as a topic during the summit, but I would prefer to prepare
>>> for that in advance, esp. since I myself do not have any experience writing
>>> userspace SW for such devices.
>>>
>>> Nicolas, it would be really great if you can participate in this meeting
>>> since you probably have the most experience with this by far.
>>>
>>> Looking through the ELCE program I found two timeslots that are likely to work
>>> for most of us (because the topics in the program appear to be boring for us
>>> media types!):
>>>
>>> Tuesday from 10:50-15:50
>>
>> Let's do this Tuesday. Let's meet at the Linux Foundation Registration
>> Desk at 11:00. I'll try to figure out where we can sit the day before.
>> Please check your email Tuesday morning for any last minute changes.
>>
>> Tomasz, it would be nice indeed if we can get you and Paul in as well
>> using Hangouts on my laptop.
>>
>> I would very much appreciate it if those who have experience with the
>> userspace support think about this beforehand and make some requirements
>> list of what you would like to see.
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> or:
>>>
>>> Monday from 15:45 onward
>>>
>>> My guess is that we need 2-3 hours or so. Hard to predict.
>>>
>>> The basic question that I would like to have answered is what the userspace
>>> component should look like? libv4l-like plugin or a library that userspace can
>>> link with? Do we want more general support for stateful codecs as well that deals
>>> with resolution changes and the more complex parts of the codec API?
>>>
>>> I've mailed this directly to those that I expect are most interested in this,
>>> but if someone want to join in let me know.
>>>
>>> I want to keep the group small though, so you need to bring relevant experience
>>> to the table.
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>
> 
