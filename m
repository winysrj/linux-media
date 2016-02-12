Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48204 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbcBLWJM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 17:09:12 -0500
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Wolfram Sang <wsa@the-dreams.de>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Tony Lindgren <tony@atomide.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56BE57FC.3020407@osg.samsung.com>
Date: Fri, 12 Feb 2016 19:09:00 -0300
MIME-Version: 1.0
In-Reply-To: <20160208105417.GD2220@tetsubishi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 02/08/2016 07:54 AM, Wolfram Sang wrote:
> On Wed, Feb 03, 2016 at 10:46:51AM -0300, Javier Martinez Canillas wrote:
>> Hello Wolfram,
>>
>> I've a issue with a I2C video decoder driver (drivers/media/i2c/tvp5150.c).
>>
>> In v4.5-rc1, the driver gets I2C read / writes timeouts when accessing the
>> device I2C registers:
>>
>> tvp5150 1-005c: i2c i/o error: rc == -110
>> tvp5150: probe of 1-005c failed with error -110
>>
>> The driver used to work up to v4.4 so this is a regression in v4.5-rc1:
>>
>> tvp5150 1-005c: tvp5151 (1.0) chip found @ 0xb8 (OMAP I2C adapter)
>> tvp5150 1-005c: tvp5151 detected.
>>
>> I tracked down to commit 9f924169c035 ("i2c: always enable RuntimePM for
>> the adapter device") and reverting that commit makes things to work again.
>>
>> The tvp5150 driver doesn't have runtime PM support but the I2C controller
>> driver does (drivers/i2c/busses/i2c-omap.c) FWIW.
>>
>> I tried adding runtime PM support to tvp5150 (basically calling pm_runtime
>> enable/get on probe before the first I2C read to resume the controller) but
>> that it did not work.
>>
>> Not filling the OMAP I2C driver's runtime PM callbacks does not help either.
>>
>> Any hints about the proper way to fix this issue?
>
> Asking linux-pm for help:
>
> The commit in question enables RuntimePM for the logical adapter device
> which sits between the HW I2C controller and the I2C client device. This
> adapter device has been used with pm_runtime_no_callbacks before
> enabling RPM. Now, Alan explained to me that "suspend events will
> propagate from the I2C clients all the way up to the adapter's parent."
> with RPM enabled for the adapter device. Which should be a no-op if the
> client doesn't do any PM at all? What do I miss?
>
> Thanks,
>
>     Wolfram
>

I'm adding Tony Lindgren to the cc list as well since he is the OMAP
maintainer and I see that has struggled lately with runtime PM issues
so maybe he has more ideas.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
