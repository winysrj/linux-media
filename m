Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51633 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2IYPZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 11:25:42 -0400
Received: by qadc26 with SMTP id c26so1877384qad.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 08:25:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5061BA88.8010201@samsung.com>
References: <20120925102839.2a90ab26@redhat.com>
	<5061BA88.8010201@samsung.com>
Date: Tue, 25 Sep 2012 20:55:41 +0530
Message-ID: <CAK9yfHz=s5rT3SSw0ZSx6gfymdHwV9Ljf1VS+BPKO8+Y-wH+HA@mail.gmail.com>
Subject: Re: Fw: [PATCH] [media] s5p-mfc: Remove unreachable code
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 25 September 2012 19:37, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Mauro, Sachin,
>
> On 09/25/2012 03:28 PM, Mauro Carvalho Chehab wrote:
>> Hi Sylwester,
>>
>> Please review.
>
> I checked it with Kamil and it seems the code being removed
> is required for proper driver operation. Thus please hold on
> with this patch. We will prepare a different fix after testing.
>
> Sachin, thanks for reporting that issue. The code below is needed
> to make sure the MFC is fully suspended after s5p_mfc_suspend()
> returns.

OK.

The "return s5p_mfc_sleep(m_dev);" probably just needs
> to be moved after the while loop.

Do you want me to make this change and re-send the patch?


>
>> Thanks!
>> Mauro
>>
>> Forwarded message:
>>
>> Date: Fri, 14 Sep 2012 14:50:17 +0530
>> From: Sachin Kamat <sachin.kamat@linaro.org>
>> To: linux-media@vger.kernel.org
>> Cc: mchehab@infradead.org, s.nawrocki@samsung.com, k.debski@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
>> Subject: [PATCH] [media] s5p-mfc: Remove unreachable code
>>
>>
>> Code after return statement never gets executed.
>> Hence can be deleted.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c |   21 +--------------------
>>  1 files changed, 1 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index e3e616d..56876be 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -1144,30 +1144,11 @@ static int s5p_mfc_suspend(struct device *dev)
>>  {
>>       struct platform_device *pdev = to_platform_device(dev);
>>       struct s5p_mfc_dev *m_dev = platform_get_drvdata(pdev);
>> -     int ret;
>>
>>       if (m_dev->num_inst == 0)
>>               return 0;
>> -     return s5p_mfc_sleep(m_dev);
>> -     if (test_and_set_bit(0, &m_dev->enter_suspend) != 0) {
>> -             mfc_err("Error: going to suspend for a second time\n");
>> -             return -EIO;
>> -     }
>>
>> -     /* Check if we're processing then wait if it necessary. */
>> -     while (test_and_set_bit(0, &m_dev->hw_lock) != 0) {
>> -             /* Try and lock the HW */
>> -             /* Wait on the interrupt waitqueue */
>> -             ret = wait_event_interruptible_timeout(m_dev->queue,
>> -                     m_dev->int_cond || m_dev->ctx[m_dev->curr_ctx]->int_cond,
>> -                     msecs_to_jiffies(MFC_INT_TIMEOUT));
>> -
>> -             if (ret == 0) {
>> -                     mfc_err("Waiting for hardware to finish timed out\n");
>> -                     return -EIO;
>> -             }
>> -     }
>> -     return 0;
>> +     return s5p_mfc_sleep(m_dev);
>>  }
>>
>>  static int s5p_mfc_resume(struct device *dev)
>
> --
>
> Thanks,
> Sylwester



-- 
With warm regards,
Sachin
