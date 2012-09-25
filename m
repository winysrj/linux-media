Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42028 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2IYP2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 11:28:03 -0400
Received: by qadc26 with SMTP id c26so1879924qad.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 08:28:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5061B3FE.1030103@samsung.com>
References: <1348571944-7139-1-git-send-email-sachin.kamat@linaro.org>
	<5061B3FE.1030103@samsung.com>
Date: Tue, 25 Sep 2012 20:58:02 +0530
Message-ID: <CAK9yfHxa2PDjMtrsSH+Ocg6tRDnn9-G3HGY=6RgGimHy7Lndsw@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-fimc: Fix incorrect condition in fimc_lite_reqbufs()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 25 September 2012 19:09, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 09/25/2012 01:19 PM, Sachin Kamat wrote:
>> When precedence rules are applied, the condition always evaluates
>> to be false which was not the intention. Adding the missing braces
>> for correct evaluation of the expression and subsequent functionality.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/s5p-fimc/fimc-lite.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
>> index 9289008..20e5e24 100644
>> --- a/drivers/media/platform/s5p-fimc/fimc-lite.c
>> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
>> @@ -825,7 +825,7 @@ static int fimc_lite_reqbufs(struct file *file, void *priv,
>>
>>       reqbufs->count = max_t(u32, FLITE_REQ_BUFS_MIN, reqbufs->count);
>>       ret = vb2_reqbufs(&fimc->vb_queue, reqbufs);
>> -     if (!ret < 0)
>> +     if (!(ret < 0))
>>               fimc->reqbufs_count = reqbufs->count;
>
> Thanks for the catch. It looks like my search/replace oversight..
> I think it's better to just make it
>
>         if (!ret)
>                 fimc->reqbufs_count = reqbufs->count;
>
> Since this bug is relatively harmless I could queue it for v3.7, with the
> above change if you are OK with that. Or would you like to resend this
> patch with changed summary ?

Either option is OK with me :)
Anyway I will update the patch as suggested by you and resend with a
simple 1 line summary.

>
>>
>>       return ret;
>
> Regards,
> Sylwester



-- 
With warm regards,
Sachin
