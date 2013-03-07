Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55441 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3CGXkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 18:40:14 -0500
Received: by mail-lb0-f180.google.com with SMTP id q12so907353lbc.11
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 15:40:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <015c01ce1b0a$6a7887f0$3f6997d0$%dae@samsung.com>
References: <1362641984-2706-1-git-send-email-vikas.sajjan@linaro.org>
 <1362641984-2706-3-git-send-email-vikas.sajjan@linaro.org> <015c01ce1b0a$6a7887f0$3f6997d0$%dae@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Fri, 8 Mar 2013 05:09:52 +0530
Message-ID: <CAD025yRHV-J=92e3az9D+XaAE6r1mh_4LJ08O+hFcHnM4CZsLw@mail.gmail.com>
Subject: Re: [PATCH v12 2/2] drm/exynos: enable OF_VIDEOMODE and
 FB_MODE_HELPERS for exynos drm fimd
To: Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, l.krishna@samsung.com, joshi@samsung.com,
	linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr. Dae,

On 7 March 2013 13:34, Inki Dae <inki.dae@samsung.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Vikas Sajjan
>> Sent: Thursday, March 07, 2013 4:40 PM
>> To: dri-devel@lists.freedesktop.org
>> Cc: linux-media@vger.kernel.org; kgene.kim@samsung.com;
>> inki.dae@samsung.com; l.krishna@samsung.com; joshi@samsung.com; linaro-
>> kernel@lists.linaro.org
>> Subject: [PATCH v12 2/2] drm/exynos: enable OF_VIDEOMODE and
>> FB_MODE_HELPERS for exynos drm fimd
>>
>> patch adds "select OF_VIDEOMODE" and "select FB_MODE_HELPERS" when
>> EXYNOS_DRM_FIMD config is selected.
>>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>>  drivers/gpu/drm/exynos/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/exynos/Kconfig
>> b/drivers/gpu/drm/exynos/Kconfig
>> index 046bcda..bb25130 100644
>> --- a/drivers/gpu/drm/exynos/Kconfig
>> +++ b/drivers/gpu/drm/exynos/Kconfig
>> @@ -25,6 +25,8 @@ config DRM_EXYNOS_DMABUF
>>  config DRM_EXYNOS_FIMD
>>       bool "Exynos DRM FIMD"
>>       depends on DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM
>
> Again, you missed 'OF' dependency. At least, let's have build testing surely
> before posting :)
>
 Surely will add " depends on OF && DRM_EXYNOS && !FB_S3C &&
!ARCH_MULTIPLATFORM "
and repost.

> Thanks,
> Inki Dae
>
>> +     select OF_VIDEOMODE
>> +     select FB_MODE_HELPERS
>>       help
>>         Choose this option if you want to use Exynos FIMD for DRM.
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks and Regards
 Vikas Sajjan
