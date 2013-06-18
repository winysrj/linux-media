Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:54055 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab3FRViP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 17:38:15 -0400
Message-ID: <51C0D342.6090801@gmail.com>
Date: Tue, 18 Jun 2013 23:38:10 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update S5P/Exynos FIMC driver entry
References: <1371487371-31143-1-git-send-email-s.nawrocki@samsung.com> <CAK9yfHxsNED-6Q8Kv=sO+D27q7LAfpfOn1y9Nutn9k-3YhUL-A@mail.gmail.com>
In-Reply-To: <CAK9yfHxsNED-6Q8Kv=sO+D27q7LAfpfOn1y9Nutn9k-3YhUL-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for your review.

On 06/18/2013 05:39 AM, Sachin Kamat wrote:
> Hi Sylwester,
>
> Just a couple of nits inline.
>
> On 17 June 2013 22:12, Sylwester Nawrocki<s.nawrocki@samsung.com>  wrote:
>> This change is mainly to update the driver's path changed from
>> drivers/media/platform/s5p-fimc to drivers/media/platform/exynos4-is/.
>> While at it, remove non-existent files rule, move the whole entry to
>> the Samsung drivers section and add the patch tracking system URL.
>
> How about adding git URL too (of your repo)?

Yes, I guess I should add it.

>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   MAINTAINERS |   17 ++++++++---------
>>   1 file changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3d7782b..d2c5618 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1153,15 +1153,6 @@ L:       linux-media@vger.kernel.org
>>   S:     Maintained
>>   F:     drivers/media/platform/s5p-g2d/
>>
>> -ARM/SAMSUNG S5P SERIES FIMC SUPPORT
>> -M:     Kyungmin Park<kyungmin.park@samsung.com>
>> -M:     Sylwester Nawrocki<s.nawrocki@samsung.com>
>> -L:     linux-arm-kernel@lists.infradead.org
>> -L:     linux-media@vger.kernel.org
>> -S:     Maintained
>> -F:     arch/arm/plat-samsung/include/plat/*fimc*
>> -F:     drivers/media/platform/s5p-fimc/
>> -
>>   ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
>
> Probably ARM could be removed from here too and may be other places if
> they exist just like below entry.

Yes, IMHO those driver entries are misplaced now. I guess the better
place would be at the Samsung entries section.

>>   M:     Kyungmin Park<kyungmin.park@samsung.com>
>>   M:     Kamil Debski<k.debski@samsung.com>
>> @@ -6930,6 +6921,14 @@ F:       drivers/regulator/s5m*.c
>>   F:     drivers/rtc/rtc-sec.c
>>   F:     include/linux/mfd/samsung/
>>
>> +SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
>> +M:     Kyungmin Park<kyungmin.park@samsung.com>
>> +M:     Sylwester Nawrocki<s.nawrocki@samsung.com>
>> +L:     linux-media@vger.kernel.org
>> +Q:     https://patchwork.linuxtv.org/project/linux-media/list/
>> +S:     Supported
>> +F:     drivers/media/platform/exynos4-is/
>> +
>
> Considering alphabetical order (now that ARM is removed), this block
> should come after SAMSUNG S3C24XX/S3C64XX...

Oops, right, thanks for spotting this.

>>   SAMSUNG S3C24XX/S3C64XX SOC SERIES CAMIF DRIVER
>>   M:     Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>>   L:     linux-media@vger.kernel.org

Regards,
Sylwester
