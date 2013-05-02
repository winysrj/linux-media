Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36775 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3EBEUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 00:20:00 -0400
Received: by mail-ob0-f172.google.com with SMTP id xk17so135133obc.17
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 21:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5180E117.1020006@gmail.com>
References: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
	<5180E117.1020006@gmail.com>
Date: Thu, 2 May 2013 09:50:00 +0530
Message-ID: <CAK9yfHzPuWPyuOM9V+AU4TTp52d_Svsq8azzmvsQr4vVCxBtiw@mail.gmail.com>
Subject: Re: [PATCH 1/4] [media] s3c-camif: Remove redundant NULL check
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 May 2013 15:02, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
> On 04/30/2013 08:16 AM, Sachin Kamat wrote:
>>
>> clk_unprepare checks for NULL pointer. Hence convert IS_ERR_OR_NULL
>> to IS_ERR only.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>> ---
>>   drivers/media/platform/s3c-camif/camif-core.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/s3c-camif/camif-core.c
>> b/drivers/media/platform/s3c-camif/camif-core.c
>> index 0d0fab1..2449f13 100644
>> --- a/drivers/media/platform/s3c-camif/camif-core.c
>> +++ b/drivers/media/platform/s3c-camif/camif-core.c
>> @@ -341,7 +341,7 @@ static void camif_clk_put(struct camif_dev *camif)
>>         int i;
>>
>>         for (i = 0; i<  CLK_MAX_NUM; i++) {
>> -               if (IS_ERR_OR_NULL(camif->clock[i]))
>> +               if (IS_ERR(camif->clock[i]))
>>                         continue;
>>                 clk_unprepare(camif->clock[i]);
>>                 clk_put(camif->clock[i]);
>
>
> Patch applied for 3.11 with following chunk squashed to it:

Thanks Sylwester.


-- 
With warm regards,
Sachin
