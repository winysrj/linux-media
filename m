Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48690 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2JCDlj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 23:41:39 -0400
Received: by vcbfo13 with SMTP id fo13so7761682vcb.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 20:41:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <048f01cd9a21$97daa760$c78ff620$%szyprowski@samsung.com>
References: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
	<048f01cd9a21$97daa760$c78ff620$%szyprowski@samsung.com>
Date: Wed, 3 Oct 2012 09:11:38 +0530
Message-ID: <CAK9yfHyW3dsByJXNQE=NUdcKpfw7EBomR6S1CUturgRvjoGPKw@mail.gmail.com>
Subject: Re: [PATCH 1/4] [media] mem2mem_testdev: Fix incorrect location of v4l2_m2m_release()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: mchehab@infradead.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This series has been acked by Marek.
Please include this in your tree for 3.7.

On 24 September 2012 12:25, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Monday, September 24, 2012 8:18 AM Sachin Kamat wrote:
>
>> v4l2_m2m_release() was placed after the return statement and outside
>> any of the goto labels and hence was not getting executed under the
>> error exit path. This patch moves it under the exit path label.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
>> ---
>>  drivers/media/platform/mem2mem_testdev.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/mem2mem_testdev.c
>> b/drivers/media/platform/mem2mem_testdev.c
>> index 771a84f..fc95559 100644
>> --- a/drivers/media/platform/mem2mem_testdev.c
>> +++ b/drivers/media/platform/mem2mem_testdev.c
>> @@ -1067,8 +1067,8 @@ static int m2mtest_probe(struct platform_device *pdev)
>>
>>       return 0;
>>
>> -     v4l2_m2m_release(dev->m2m_dev);
>>  err_m2m:
>> +     v4l2_m2m_release(dev->m2m_dev);
>>       video_unregister_device(dev->vfd);
>>  rel_vdev:
>>       video_device_release(vfd);
>> --
>> 1.7.4.1
>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
>
>



-- 
With warm regards,
Sachin
