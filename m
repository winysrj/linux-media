Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48702 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbATOL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 09:11:56 -0500
Message-id: <54BE6228.5070304@samsung.com>
Date: Tue, 20 Jan 2015 15:11:52 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
 <20150120111719.GF13701@x1> <54BE51B2.8040209@samsung.com>
In-reply-to: <54BE51B2.8040209@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2015 02:01 PM, Jacek Anaszewski wrote:
> On 01/20/2015 12:17 PM, Lee Jones wrote:
>> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>>
>>> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
>>> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
>>> from leds-max77693 driver.
>>
>> Off-by-one ay?  Wasn't the original code tested?
>
> The driver using these macros is a part of LED / flash API integration
> patch series, which still undergoes modifications and it hasn't
> reached its final state yet, as there are many things to discuss.

To be more precise: the original code had been tested and was working
properly with the header that is in the mainline. Nonetheless, because
of the modifications in the driver that was requested during code
review, it turned out that it would be more convenient to redefine the
macros.

I'd opt for just agreeing about the mfd related patches and merge
them no sooner than the leds-max77693 driver is merged.

-- 
Best Regards,
Jacek Anaszewski
