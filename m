Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:60877 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKG6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 02:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <513CEFA1.3030809@gmail.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
	<1362570838-4737-5-git-send-email-shaik.ameer@samsung.com>
	<513CEFA1.3030809@gmail.com>
Date: Mon, 11 Mar 2013 12:28:02 +0530
Message-ID: <CAOD6ATqa2QDsOmSe48zaOokdwb0cjuhoAigz1QBZm7hj-EE+rA@mail.gmail.com>
Subject: Re: [RFC 04/12] s5p-csis: Adding Exynos5250 compatibility
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Mar 11, 2013 at 2:10 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
>
> Please don't leave the change log empty. I'll apply this patch.
> I'm just wondering, if there aren't any further changes needed
> to make the driver really working on exynos5250 ?
>

There was nothing from driver side to change for making it work
for Exynos5250. May be I need to update the S5P_INTMASK_EN_ALL
to include all interrupts.

Regards,
Shaik Ameer Basha

>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   drivers/media/platform/s5p-fimc/mipi-csis.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c
>> b/drivers/media/platform/s5p-fimc/mipi-csis.c
>> index df4411c..debda7c 100644
>> --- a/drivers/media/platform/s5p-fimc/mipi-csis.c
>> +++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
>> @@ -1002,6 +1002,7 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
>>   static const struct of_device_id s5pcsis_of_match[] __devinitconst = {
>>         { .compatible = "samsung,exynos3110-csis" },
>>         { .compatible = "samsung,exynos4210-csis" },
>> +       { .compatible = "samsung,exynos5250-csis" },
>>         { /* sentinel */ },
>>   };
>>   MODULE_DEVICE_TABLE(of, s5pcsis_of_match);
