Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56269 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaLIJSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 04:18:41 -0500
Message-id: <5486BE6C.9010408@samsung.com>
Date: Tue, 09 Dec 2014 10:18:36 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 03/19] mfd: max77693: Modify flash cell name
 identifiers
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-4-git-send-email-j.anaszewski@samsung.com>
 <20141209085216.GS3951@x1>
In-reply-to: <20141209085216.GS3951@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2014 09:52 AM, Lee Jones wrote:
> On Wed, 03 Dec 2014, Jacek Anaszewski wrote:
>
>> Change flash cell identifiers from max77693-flash to max77693-led
>> to avoid confusion with NOR/NAND Flash.
>>
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
>
> This is fine by me, so long as you've been through the usual
> deprecation procedures or this platform is still WiP.

It was me who added of_compatible for max77693-flash, but the
related led driver has not been yet merged and there are no
other drivers depending on it.

Best Regards,
Jacek Anaszewski

