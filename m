Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39132 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab3DZI5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 04:57:54 -0400
Received: by mail-ob0-f182.google.com with SMTP id dn14so3285729obc.41
        for <linux-media@vger.kernel.org>; Fri, 26 Apr 2013 01:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <517A4043.3040509@samsung.com>
References: <1366951447-6202-1-git-send-email-sachin.kamat@linaro.org>
	<517A4043.3040509@samsung.com>
Date: Fri, 26 Apr 2013 14:27:53 +0530
Message-ID: <CAK9yfHz-hj0rMMDd4hTfE93kEpgsfb-ZqyKTP_nV2jyUgzzo+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer
 dereference in mipi-csis.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 26 April 2013 14:22, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> On 04/26/2013 06:44 AM, Sachin Kamat wrote:
>> When 'node' is NULL, the print statement tries to dereference it.
>> Remove it from the error message.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/exynos4-is/mipi-csis.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
>> index a2eda9d..6ddc69f 100644
>> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
>> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
>> @@ -745,8 +745,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
>>
>>       node = v4l2_of_get_next_endpoint(node, NULL);
>>       if (!node) {
>> -             dev_err(&pdev->dev, "No port node at %s\n",
>> -                                     node->full_name);
>> +             dev_err(&pdev->dev, "Port node not available\n");
>
> Thanks Sachin. Could you instead do
> s/node->full_name/pdev->dev.of_node->full_name ?
>
> This way we won't loose any information and it would be easier to
> determine which node exactly is wrong.

Certainly. I too wanted to provide this information in print message
but could not think of an alternative way
immediately. Thanks for the tip.


-- 
With warm regards,
Sachin
