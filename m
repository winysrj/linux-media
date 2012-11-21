Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:61307 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2KUL7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 06:59:23 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so1698612dak.19
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2012 03:59:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50AA915D.5020304@gmail.com>
References: <1352588276-16260-1-git-send-email-sylvester.nawrocki@gmail.com>
	<50AA915D.5020304@gmail.com>
Date: Wed, 21 Nov 2012 17:29:22 +0530
Message-ID: <CAOD6ATqSw8xTKZ8OfVW3J44qczpPu_WisiUgt8x6tmk_kxPDsA@mail.gmail.com>
Subject: Re: [PATCH] exynos-gsc: Add missing video device vfl_dir flag initialization
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sw0312.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

I applied this patch and tested exynos-gsc driver basic features on exynos5250.
It's working fine for me.

Thanks,
Shaik Ameer Basha

On Tue, Nov 20, 2012 at 1:36 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Shaik,
>
> Could you let us know if the driver is working fine with this patch
> applied ? I have no exynos5 based board to test it. And this patch
> qualifies as an important fix that should be applied for v3.7, where
> the driver's first appeared.
>
> Thanks,
> Sylwester
>
>
> On 11/10/2012 11:57 PM, Sylwester Nawrocki wrote:
>>
>> vfl_dir should be set to VFL_DIR_M2M so valid ioctls for this
>> mem-to-mem device can be properly determined in the v4l2 core.
>>
>> Cc: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>> ---
>> I didn't run-time test this patch.
>>
>>   drivers/media/platform/exynos-gsc/gsc-m2m.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> b/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> index 3c7f005..88642a8 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
>> @@ -732,6 +732,7 @@ int gsc_register_m2m_device(struct gsc_dev *gsc)
>>         gsc->vdev.ioctl_ops     =&gsc_m2m_ioctl_ops;
>>         gsc->vdev.release       = video_device_release_empty;
>>         gsc->vdev.lock          =&gsc->lock;
>>
>> +       gsc->vdev.vfl_dir       = VFL_DIR_M2M;
>>         snprintf(gsc->vdev.name, sizeof(gsc->vdev.name), "%s.%d:m2m",
>>                                         GSC_MODULE_NAME, gsc->id);
>>
>> --
>> 1.7.4.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
