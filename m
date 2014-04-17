Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23306 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaDQJ3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:29:06 -0400
Message-id: <534F9EDC.4030202@samsung.com>
Date: Thu, 17 Apr 2014 11:29:00 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 4/5] exynos4-is: Remove requirement for "simple-bus"
 compatible
References: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
 <1397583272-28295-5-git-send-email-s.nawrocki@samsung.com>
 <CAL_Jsq+VRGpVZwFs1QwCz6YY8WmPUO7ZJtWQ3kVY8p1jWe0LGg@mail.gmail.com>
 <534EBB88.9020109@samsung.com>
 <CAL_JsqKH8o-0H4+2jv-6xh96Twh9UCXZV+LtmiUGHJmhUxCUVA@mail.gmail.com>
In-reply-to: <CAL_JsqKH8o-0H4+2jv-6xh96Twh9UCXZV+LtmiUGHJmhUxCUVA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(restoring the Cc list I cleared accidentally in previous reply)

On 16/04/14 21:29, Rob Herring wrote:
> On Wed, Apr 16, 2014 at 12:19 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> On 16/04/14 17:34, Rob Herring wrote:
>>> On Tue, Apr 15, 2014 at 12:34 PM, Sylwester Nawrocki
>>> <s.nawrocki@samsung.com> wrote:
>>>>> This patch makes the driver instantiating its child devices itself,
>>>>> rather than relying on an OS to instantiate devices as children
>>>>> of "simple-bus". This removes an incorrect usage of "simple-bus"
>>>>> compatible.
>>>
>>> Good, but why can't you use of_platform_populate with the root being
>>> the "samsung,fimc" node? The code to instantiate the devices belongs
>>> in the core OF code.
>>
>> As I mentioned in other thread, I couldn't see anything like
>> of_platform_unpopulate(), which would allow to destroy any created
>> devices. I can't have of_platform_populate() called as last thing
>> in probe() as some drivers do, so at least deferred probe works.
>> Anyway, it wouldn't be a solution since on a driver removal the
>> created devices must be unregistered.
> 
> I think the deferred probe will get fixed in 3.16, but I'm not
> following how deferred probe is relevant here.

What I meant was that when something fails in the middle of probe() 
callback and of_platform_populate() was already called any devices 
created by it must be destroyed before returning an error from probe().
And some drivers seem to never free their devices created by 
of_platform_populate().

>> I read through thread [1] and I didn't immediately have an idea how
>> to fix the core OF code. So I thought I'd come up with this partial
>> solution.
>>
>> I was wondering if creating functions like of_platform_device_delete(),
>> of_amba_device_delete() and a function that would walk device tree and
>> call them would be a way to go ? I could spend some time on that, any
>> suggestions would be appreciated.
> 
> I need to look at the other removal case, but perhaps the way you did
> using children of the struct device parent is the right way. I'm fine
> with that, but I just want to see this in the core code.

All right, I'll have a closer look then if it can be done that way.
 
> Rob
> 
>>
>> --
>> Regards,
>> Sylwester
>>
>> [1] http://www.spinics.net/lists/linux-omap/msg94484.html

--
Thanks,
Sylwester
