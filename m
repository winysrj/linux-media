Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48217 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbcBLW2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 17:28:44 -0500
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Tony Lindgren <tony@atomide.com>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi> <56BE57FC.3020407@osg.samsung.com>
 <20160212221352.GY3500@atomide.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56BE5C97.9070607@osg.samsung.com>
Date: Fri, 12 Feb 2016 19:28:39 -0300
MIME-Version: 1.0
In-Reply-To: <20160212221352.GY3500@atomide.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tony,

On 02/12/2016 07:13 PM, Tony Lindgren wrote:
> Hi,
>
> * Javier Martinez Canillas <javier@osg.samsung.com> [160212 14:10]:
>> Hello,
>>
>> On 02/08/2016 07:54 AM, Wolfram Sang wrote:
>>> On Wed, Feb 03, 2016 at 10:46:51AM -0300, Javier Martinez Canillas wrote:
>>>> Hello Wolfram,
>>>>
>>>> I've a issue with a I2C video decoder driver (drivers/media/i2c/tvp5150.c).
>>>>
>>>> In v4.5-rc1, the driver gets I2C read / writes timeouts when accessing the
>>>> device I2C registers:
>>>>
>>>> tvp5150 1-005c: i2c i/o error: rc == -110
>>>> tvp5150: probe of 1-005c failed with error -110
>>>>
>>>> The driver used to work up to v4.4 so this is a regression in v4.5-rc1:
>>>>
>>>> tvp5150 1-005c: tvp5151 (1.0) chip found @ 0xb8 (OMAP I2C adapter)
>>>> tvp5150 1-005c: tvp5151 detected.
>>>>
>>>> I tracked down to commit 9f924169c035 ("i2c: always enable RuntimePM for
>>>> the adapter device") and reverting that commit makes things to work again.
>>>>
>>>> The tvp5150 driver doesn't have runtime PM support but the I2C controller
>>>> driver does (drivers/i2c/busses/i2c-omap.c) FWIW.
>>>>
>>>> I tried adding runtime PM support to tvp5150 (basically calling pm_runtime
>>>> enable/get on probe before the first I2C read to resume the controller) but
>>>> that it did not work.
>>>>
>>>> Not filling the OMAP I2C driver's runtime PM callbacks does not help either.
>>>>
>>>> Any hints about the proper way to fix this issue?
>>>
>>> Asking linux-pm for help:
>>>
>>> The commit in question enables RuntimePM for the logical adapter device
>>> which sits between the HW I2C controller and the I2C client device. This
>>> adapter device has been used with pm_runtime_no_callbacks before
>>> enabling RPM. Now, Alan explained to me that "suspend events will
>>> propagate from the I2C clients all the way up to the adapter's parent."
>>> with RPM enabled for the adapter device. Which should be a no-op if the
>>> client doesn't do any PM at all? What do I miss?
>>
>> I'm adding Tony Lindgren to the cc list as well since he is the OMAP
>> maintainer and I see that has struggled lately with runtime PM issues
>> so maybe he has more ideas.
>
> Hmm yeah I wonder if this canned solution helps here too:
>
> 1. Check if the driver(s) are using pm_runtime_use_autosuspend()
>

By driver do you mean the OMAP GPIO driver or the tvp5150 I2C driver?
The latter does not have runtime PM support.

> 2. If so, you must use pm_runtime_dont_use_autosuspend() before
>     pm_runtime_put_sync() to make sure that pm_runtime_put_sync()
>     works.
>
> 3. Or you can use pm_runtime_put_sync_suspend() instead of
>     pm_runtime_put_sync() for sections of code where the clocks
>     need to be stopped.
>

I can check if the OMAP GPIO is following these and give a try but
don't have access to the board right now so I'll do it on Monday.

> Regards,
>
> Tony
>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
