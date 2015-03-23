Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16079 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbCWNWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 09:22:43 -0400
Message-id: <5510139F.4030807@samsung.com>
Date: Mon, 23 Mar 2015 14:22:39 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v1 01/11] leds: Add support for max77693 mfd flash cell
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-2-git-send-email-j.anaszewski@samsung.com>
 <20150321224437.GD16613@valkosipuli.retiisi.org.uk>
In-reply-to: <20150321224437.GD16613@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On 03/21/2015 11:44 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Mar 20, 2015 at 04:03:21PM +0100, Jacek Anaszewski wrote:
>> This patch adds led-flash support to Maxim max77693 chipset.
>> A device can be exposed to user space through LED subsystem
>> sysfs interface. Device supports up to two leds which can
>> work in flash and torch mode. The leds can be triggered
>> externally or by software.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>
> Thanks for the update once again!
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>

There will be one more version of this patch due to some changes
around flash settings and v4l2-flash config initialization, requested
in the review of v4l2-flash helpers related patches.

-- 
Best Regards,
Jacek Anaszewski
