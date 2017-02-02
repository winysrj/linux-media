Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47912
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751096AbdBBMV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 07:21:57 -0500
Subject: Re: [PATCH] [media] exynos-gsc: Avoid spamming the log on
 VIDIOC_TRY_FMT
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org
References: <1485294146-7467-1-git-send-email-javier@osg.samsung.com>
 <276f85b5-d224-41fd-3363-f2a671bdd176@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <3c0cd187-7e1d-d522-b7fc-b02e6a2f4b29@osg.samsung.com>
Date: Thu, 2 Feb 2017 09:21:47 -0300
MIME-Version: 1.0
In-Reply-To: <276f85b5-d224-41fd-3363-f2a671bdd176@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On 02/01/2017 11:25 PM, Shuah Khan wrote:
> On 01/24/2017 02:42 PM, Javier Martinez Canillas wrote:
>> There isn't an ioctl to enum the supported field orders, so a user-space
>> application can call VIDIOC_TRY_FMT using different field orders to know
>> if one is supported. For example, GStreamer does this so during playback
>> dozens of the following messages appear in the kernel log buffer:
>>
>> [ 442.143393] Not supported field order(4)
>>
>> Instead of printing this as an error, just keep it as debug information.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>>  drivers/media/platform/exynos-gsc/gsc-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
>> index 8524fe15fa80..678b600f0500 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
>> @@ -408,7 +408,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
>>  	if (pix_mp->field == V4L2_FIELD_ANY)
>>  		pix_mp->field = V4L2_FIELD_NONE;
>>  	else if (pix_mp->field != V4L2_FIELD_NONE) {
>> -		pr_err("Not supported field order(%d)\n", pix_mp->field);
>> +		pr_debug("Not supported field order(%d)\n", pix_mp->field);
> 
> It make sense to leave it as an error, but print only once perhaps.
> The down side to making this debug is that it becomes harder to
> figure out when we run into this case.
>

I disagree. User-space trying different field orders doesn't sound like an
error to me since as mentioned there isn't an ioctl to enum supported ones.

In fact other drivers don't print anything in their try_fmt handler for the
same case, for example [0] and [1].

> thanks,
> -- Shuah
> 

[0]: http://lxr.free-electrons.com/source/drivers/media/platform/mx2_emmaprp.c#L496
[1]: http://lxr.free-electrons.com/source/drivers/media/platform/exynos4-is/fimc-m2m.c#L297

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
