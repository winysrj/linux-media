Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51987 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaFPLIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 07:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <539EBD6F.1040704@xs4all.nl>
References: <CA+V-a8vhEyNdQRqNrzRV=t-D+uh6rCEY5-qLjTOWDfHwUai1Kg@mail.gmail.com>
 <20140612070145.GA18563@mwanda> <CA+V-a8tGf8EAVV=OGEofJczN09X5FKPqLa8G+ZMg=j72rpDyCA@mail.gmail.com>
 <539EBD6F.1040704@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 16 Jun 2014 12:07:44 +0100
Message-ID: <CA+V-a8stc6ZvjA72sPCRQPuad+vaN60wpBU4MLMdvYe_staP+g@mail.gmail.com>
Subject: Re: [patch v2] [media] davinci: vpif: missing unlocks on error
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 16, 2014 at 10:48 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Prabhakar,
>
> Are you going to make a pull request for this, or shall I take it? Should it be applied
> to 3.16?
>
As this is not a critical bug, I was planning to wait for v3.17 as
v3.16 is almost closed.

Regards,
--Prabhakar Lad

> Regards,
>
>         Hans
>
> On 06/13/2014 08:13 PM, Prabhakar Lad wrote:
>> On Thu, Jun 12, 2014 at 8:01 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>> We recently changed some locking around so we need some new unlocks on
>>> the error paths.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> Applied!
>>
>> Thanks,
>> --Prabhakar Lad
>>
>>> ---
>>> v2: move the unlock so the list_for_each_entry_safe() loop is protected
>>>
>>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>>> index a7ed164..1e4ec69 100644
>>> --- a/drivers/media/platform/davinci/vpif_capture.c
>>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>>> @@ -269,6 +269,7 @@ err:
>>>                 list_del(&buf->list);
>>>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>>>         }
>>> +       spin_unlock_irqrestore(&common->irqlock, flags);
>>>
>>>         return ret;
>>>  }
>>> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
>>> index 5bb085b..b431b58 100644
>>> --- a/drivers/media/platform/davinci/vpif_display.c
>>> +++ b/drivers/media/platform/davinci/vpif_display.c
>>> @@ -233,6 +233,7 @@ err:
>>>                 list_del(&buf->list);
>>>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>>>         }
>>> +       spin_unlock_irqrestore(&common->irqlock, flags);
>>>
>>>         return ret;
>>>  }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
