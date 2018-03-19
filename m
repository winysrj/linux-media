Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55494 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932487AbeCSLLW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 07:11:22 -0400
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com> <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl> <20170509110440.GC28248@amd>
 <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl> <20170516124519.GA25650@amd>
 <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl> <20180316205512.GA6069@amd>
 <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl> <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
Date: Mon, 19 Mar 2018 12:11:11 +0100
MIME-Version: 1.0
In-Reply-To: <20180319074715.5b700405@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2018 11:47 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 19 Mar 2018 11:23:54 +0100
> Pavel Machek <pavel@ucw.cz> escreveu:
> 
>> Hi!
>>
>>> I really don't want to add functions for this to libv4l2. That's just a
>>> quick hack. The real solution is to parse this from a config
>>> file. But  
>>
>> No, this is not a quick hack. These are functions that will eventually
>> be used by the config parser. (Oh and they allow me to use camera on
>> complex hardware, but...).
>>
>> Hmm, I have mentioned that already. See quoted text below. 
>>
>>> that is a lot more work and it is something that needs to be designed
>>> properly.
>>>
>>> And that requires someone to put in the time and effort...  
>>
>> Which is what I'm trying to do. But some cooperation from your side is
>> needed, too. I acknowledged some kind of parser is needed. I can
>> do that. Are you willing to cooperate?
>>
>> But I need your feedback on the parts below. We can bikeshed about the
>> parser later.
>>
>> Do they look acceptable? Did I hook up right functions in acceptable
>> way?
>>
>> If so, yes, I can proceed with parser.
>>
>> Best regards,
>> 							Pavel
> 
> 
> Pavel,
> 
> I appreciate your efforts of adding support for mc-based devices to
> libv4l.
> 
> I guess the main poin that Hans is pointing is that we should take
> extra care in order to avoid adding new symbols to libv4l ABI/API
> without being sure that they'll be needed in long term, as removing
> or changing the API is painful for app developers, and keeping it
> ABI compatible with apps compiled against previous versions of the
> library is very painful for us.

Indeed. Sorry if I wasn't clear on that.

> The hole idea is that generic applications shouldn't notice
> if the device is using a mc-based device or not.

What is needed IMHO is an RFC that explains how you want to solve this
problem, what the parser would look like, how this would configure a
complex pipeline for use with libv4l-using applications, etc.

I.e., a full design.

And once everyone agrees that that design is solid, then it needs to be
implemented.

I really want to work with you on this, but I am not looking for partial
solutions.

I think a proper solution is a fair amount of work. If you are willing to
take that on, then that would be fantastic.

Regards,

	Hans
