Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36471 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752844AbdHTNSX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 09:18:23 -0400
Subject: Re: [PATCH 4/5] stih-cec: use CEC_CAP_DEFAULTS
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
 <20170804104155.37386-5-hverkuil@xs4all.nl>
 <CA+M3ks4ZL4FXgWkuQkKvhUfou0S7a-u4LbJ0dPRfDuLkS8vM-A@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5ff56117-aa98-e48f-82f3-17c23fcd5404@xs4all.nl>
Date: Sun, 20 Aug 2017 15:18:16 +0200
MIME-Version: 1.0
In-Reply-To: <CA+M3ks4ZL4FXgWkuQkKvhUfou0S7a-u4LbJ0dPRfDuLkS8vM-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/2017 03:11 PM, Benjamin Gaignard wrote:
> 2017-08-04 12:41 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Use the new CEC_CAP_DEFAULTS define in this driver.
>> This also adds the CEC_CAP_RC capability which was missing here
>> (and this is also the reason for this new define, to avoid missing
>> such capabilities).
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Thanks!

Just in time for 4.14. Will make another pull request for cec fixes
tomorrow.

Regards,

	Hans

> 
>> ---
>>  drivers/media/platform/sti/cec/stih-cec.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
>> index ce7964c71b50..dc221527fd05 100644
>> --- a/drivers/media/platform/sti/cec/stih-cec.c
>> +++ b/drivers/media/platform/sti/cec/stih-cec.c
>> @@ -351,9 +351,7 @@ static int stih_cec_probe(struct platform_device *pdev)
>>         }
>>
>>         cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
>> -                       CEC_NAME,
>> -                       CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
>> -                       CEC_CAP_TRANSMIT, CEC_MAX_LOG_ADDRS);
>> +                       CEC_NAME, CEC_CAP_DEFAULTS, CEC_MAX_LOG_ADDRS);
>>         if (IS_ERR(cec->adap))
>>                 return PTR_ERR(cec->adap);
>>
>> --
>> 2.13.2
>>
> 
> 
> 
