Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40891 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbATNBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 08:01:41 -0500
Message-id: <54BE51B2.8040209@samsung.com>
Date: Tue, 20 Jan 2015 14:01:38 +0100
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
 <20150120111719.GF13701@x1>
In-reply-to: <20150120111719.GF13701@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2015 12:17 PM, Lee Jones wrote:
> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>
>> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
>> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
>> from leds-max77693 driver.
>
> Off-by-one ay?  Wasn't the original code tested?

The driver using these macros is a part of LED / flash API integration
patch series, which still undergoes modifications and it hasn't
reached its final state yet, as there are many things to discuss.

>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>>   include/linux/mfd/max77693-private.h |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
>> index 08dae01..01799a9 100644
>> --- a/include/linux/mfd/max77693-private.h
>> +++ b/include/linux/mfd/max77693-private.h
>> @@ -113,8 +113,8 @@ enum max77693_pmic_reg {
>>   #define FLASH_EN_FLASH		0x1
>>   #define FLASH_EN_TORCH		0x2
>>   #define FLASH_EN_ON		0x3
>> -#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
>> -#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
>> +#define FLASH_EN_SHIFT(x)	(6 - (x) * 2)
>> +#define TORCH_EN_SHIFT(x)	(2 - (x) * 2)
>>
>>   /* MAX77693 MAX_FLASH1 register */
>>   #define MAX_FLASH1_MAX_FL_EN	0x80
>


-- 
Best Regards,
Jacek Anaszewski
