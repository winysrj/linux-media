Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44045 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbATM5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 07:57:21 -0500
Message-id: <54BE50AD.7080801@samsung.com>
Date: Tue, 20 Jan 2015 13:57:17 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 05/19] mfd: max77693: Modify flash cell name
 identifiers
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-6-git-send-email-j.anaszewski@samsung.com>
 <20150120111346.GD13701@x1>
In-reply-to: <20150120111346.GD13701@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2015 12:13 PM, Lee Jones wrote:
> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>
>> Change flash cell identifiers from max77693-flash to max77693-led
>> to avoid confusion with NOR/NAND Flash.
>
> This is okay by me, but aren't these ABI yet?

No, the led driver using it hasn't been merged yet.

>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>>   drivers/mfd/max77693.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
>> index a159593..cb14afa 100644
>> --- a/drivers/mfd/max77693.c
>> +++ b/drivers/mfd/max77693.c
>> @@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
>>   		.of_compatible = "maxim,max77693-haptic",
>>   	},
>>   	{
>> -		.name = "max77693-flash",
>> -		.of_compatible = "maxim,max77693-flash",
>> +		.name = "max77693-led",
>> +		.of_compatible = "maxim,max77693-led",
>>   	},
>>   };
>>
>


-- 
Best Regards,
Jacek Anaszewski
