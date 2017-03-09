Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:25362 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932261AbdCILzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 06:55:54 -0500
Message-ID: <58C14136.8060703@bfs.de>
Date: Thu, 09 Mar 2017 12:49:10 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "Wu, Songjun" <Songjun.Wu@microchip.com>,
        Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] atmel-isc: fix off-by-one comparison and out
 of bounds read issue
References: <20170307143047.30082-1-colin.king@canonical.com> <5dc9d025-31d5-b129-09df-5de19758e886@microchip.com> <b84a5576-7b29-728b-b7c2-9929069a2b35@xs4all.nl>
In-Reply-To: <b84a5576-7b29-728b-b7c2-9929069a2b35@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 09.03.2017 11:57, schrieb Hans Verkuil:
> Hi Songjun,
> 
> On 08/03/17 03:25, Wu, Songjun wrote:
>> Hi Colin,
>>
>> Thank you for your comment.
>> It is a bug, will be fixed in the next patch.
> 
> Do you mean that you will provide a new patch for this? Is there anything
> wrong with this patch? It seems reasonable to me.
> 
> Regards,
> 
> 	Hans
> 



perhaps he will make it a bit more readable, like:

*hist_count += i * (*hist_entry++);

*hist_count += hist_entry[i]*i;


re,
 wh
>>
>> On 3/7/2017 22:30, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> The are only HIST_ENTRIES worth of entries in  hist_entry however the
>>> for-loop is iterating one too many times leasing to a read access off
>>> the end off the array ctrls->hist_entry.  Fix this by iterating by
>>> the correct number of times.
>>>
>>> Detected by CoverityScan, CID#1415279 ("Out-of-bounds read")
>>>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  drivers/media/platform/atmel/atmel-isc.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>>> index b380a7d..7dacf8c 100644
>>> --- a/drivers/media/platform/atmel/atmel-isc.c
>>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>>> @@ -1298,7 +1298,7 @@ static void isc_hist_count(struct isc_device *isc)
>>>      regmap_bulk_read(regmap, ISC_HIS_ENTRY, hist_entry, HIST_ENTRIES);
>>>
>>>      *hist_count = 0;
>>> -    for (i = 0; i <= HIST_ENTRIES; i++)
>>> +    for (i = 0; i < HIST_ENTRIES; i++)
>>>          *hist_count += i * (*hist_entry++);
>>>  }
>>>
>>>
> 




> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
