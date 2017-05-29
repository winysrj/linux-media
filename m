Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47502 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750837AbdE2ICb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 04:02:31 -0400
Subject: Re: [patch, libv4l]: add sdlcam example for testing digital still
 camera functionality
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <20170424212914.GA20780@amd> <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd> <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd> <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd> <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170521103315.GA10716@amd> <57f24742-f039-dce3-8c8f-65b114dfd7d2@xs4all.nl>
 <20170529073227.GA11921@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c846164-a7aa-eb2f-a78f-c14685ab248f@xs4all.nl>
Date: Mon, 29 May 2017 10:02:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170529073227.GA11921@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2017 09:32 AM, Pavel Machek wrote:
> On Mon 2017-05-29 08:13:22, Hans Verkuil wrote:
>> Hi Pavel,
>>
>> On 05/21/2017 12:33 PM, Pavel Machek wrote:
>>> Add simple SDL-based application for capturing photos. Manual
>>> focus/gain/exposure can be set, flash can be controlled and
>>> autofocus/autogain can be selected if camera supports that.
>>>
>>> It is already useful for testing autofocus/autogain improvements to
>>> the libraries on Nokia N900.
>>>
>>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>
>> I think this is more suitable as a github project. To be honest, I feel that
>> v4l-utils already contains too many random utilities, so I prefer not to add
>> to that.
> 
>> On the other hand, there is nothing against sharing this as on github as it
>> certainly can be useful.
> 
> Can I get you to reconsider that?
> 
> Originally, I planed to keep the utility separate, but then I got
> comments from Mauro ( https://lkml.org/lkml/2017/4/24/457 ) explaining
> that hard sdl dependency is not acceptable etc, and how I should do
> automake.
> 
> So I had a lot of fun with automake integration, and generally doing
> things right.
> 
> So getting "we all ready have too many utilities" _now_ is quite an
> unwelcome surprise.

Too many *random* utilities.

Utilities like v4l2-ctl are tied closely to the kernel and are updated whenever
new APIs appear. But yet another viewer?

Mauro, I find that v4l-utils is a bit polluted with non-core utilities.
IMHO it should only contain the core libv4l2, core utilities and driver-specific
utilities. I wonder if we should make a media-utils-contrib for all the non-core
stuff.

What is your opinion?

Regards,

	Hans

> 
> Regards,
> 									Pavel
> 
