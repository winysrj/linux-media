Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38946 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab2BBDc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 22:32:27 -0500
Received: by qcqw6 with SMTP id w6so1139890qcq.19
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2012 19:32:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2996A9.2000809@gmail.com>
References: <1328089723-18482-1-git-send-email-sachin.kamat@linaro.org>
	<4F2996A9.2000809@gmail.com>
Date: Thu, 2 Feb 2012 09:02:26 +0530
Message-ID: <CAK9yfHx6wvAi+C1xY7uC5pUVdY08q-zmdc_60L8DpTJzEfqvhA@mail.gmail.com>
Subject: Re: [PATCH v4] [media] s5p-g2d: Add HFLIP and VFLIP support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, patches@linaro.org,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 2 February 2012 01:16, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Sachin,
>
> On 02/01/2012 10:48 AM, Sachin Kamat wrote:
>> Add support for flipping the image horizontally and vertically.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>> ---
>>   drivers/media/video/s5p-g2d/g2d-hw.c |    5 +++++
>>   drivers/media/video/s5p-g2d/g2d.c    |   27 ++++++++++++++++++++-------
>>   drivers/media/video/s5p-g2d/g2d.h    |    4 ++++
>>   3 files changed, 29 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/video/s5p-g2d/g2d-hw.c
>> index 39937cf..5b86cbe 100644
>> --- a/drivers/media/video/s5p-g2d/g2d-hw.c
>> +++ b/drivers/media/video/s5p-g2d/g2d-hw.c
>> @@ -77,6 +77,11 @@ void g2d_set_rop4(struct g2d_dev *d, u32 r)
>>       w(r, ROP4_REG);
>>   }
>>
>> +void g2d_set_flip(struct g2d_dev *d, u32 r)
>> +{
>> +     w(r, SRC_MSK_DIRECT_REG);
>> +}
>
> nit: This could be added instead to g2d.h as a "static inline" function.

ATM, i prefer to keep it this way in sync with other similar functions.

> Whether you decide to change it or not:
>
>  Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thanks Sylwester.


>
> I assume Kamil is going to add locking in subsequent patch(es).
>
> --
>
> Regards,
> Sylwester



-- 
With warm regards,
Sachin
