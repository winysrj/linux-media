Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57295 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3EBFRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 01:17:38 -0400
Received: by mail-oa0-f45.google.com with SMTP id o17so168792oag.32
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 22:17:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5180E13A.8050008@gmail.com>
References: <1367227499-543-1-git-send-email-sachin.kamat@linaro.org>
	<5180E13A.8050008@gmail.com>
Date: Thu, 2 May 2013 10:47:37 +0530
Message-ID: <CAK9yfHw34weW3mDtk1O1pcC04=nYnHzRfGLBdXT1TFjj_t9A9Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
 in hdmi_drv.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	s.nawrocki@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 1 May 2013 15:02, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
> On 04/29/2013 11:24 AM, Sachin Kamat wrote:
>>
>> NULL check on clocks obtained using common clock APIs should not
>> be done. Use IS_ERR only.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>> ---
>>   drivers/media/platform/s5p-tv/hdmi_drv.c |   10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c
>> b/drivers/media/platform/s5p-tv/hdmi_drv.c
>> index 4e86626..b3344cb 100644
>> --- a/drivers/media/platform/s5p-tv/hdmi_drv.c
>> +++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
>> @@ -765,15 +765,15 @@ static void hdmi_resources_cleanup(struct
>> hdmi_device *hdev)
>>                 regulator_bulk_free(res->regul_count, res->regul_bulk);
>>         /* kfree is NULL-safe */
>>         kfree(res->regul_bulk);
>> -       if (!IS_ERR_OR_NULL(res->hdmiphy))
>> +       if (!IS_ERR(res->hdmiphy))
>>                 clk_put(res->hdmiphy);
>> -       if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
>> +       if (!IS_ERR(res->sclk_hdmiphy))
>>                 clk_put(res->sclk_hdmiphy);
>> -       if (!IS_ERR_OR_NULL(res->sclk_pixel))
>> +       if (!IS_ERR(res->sclk_pixel))
>>                 clk_put(res->sclk_pixel);
>> -       if (!IS_ERR_OR_NULL(res->sclk_hdmi))
>> +       if (!IS_ERR(res->sclk_hdmi))
>>                 clk_put(res->sclk_hdmi);
>> -       if (!IS_ERR_OR_NULL(res->hdmi))
>> +       if (!IS_ERR(res->hdmi))
>>                 clk_put(res->hdmi);
>>         memset(res, 0, sizeof(*res));
>>   }
>
>
> I think this patch is incomplete. You need to ensure all the clock pointers
> are initially set to an invalid value. This is currently done with
> memsetting
> whole hdmi_resource structure to 0. But now some ERR_PTR() value needs to be
> used instead. Same applies to your subsequent patch.

Yes you are right.
Initialised the clocks to invalid value and sent v2 of both these patches.

-- 
With warm regards,
Sachin
