Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3394 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaFPJtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 05:49:06 -0400
Message-ID: <539EBD6F.1040704@xs4all.nl>
Date: Mon, 16 Jun 2014 11:48:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] [media] davinci: vpif: missing unlocks on error
References: <CA+V-a8vhEyNdQRqNrzRV=t-D+uh6rCEY5-qLjTOWDfHwUai1Kg@mail.gmail.com> <20140612070145.GA18563@mwanda> <CA+V-a8tGf8EAVV=OGEofJczN09X5FKPqLa8G+ZMg=j72rpDyCA@mail.gmail.com>
In-Reply-To: <CA+V-a8tGf8EAVV=OGEofJczN09X5FKPqLa8G+ZMg=j72rpDyCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prabhakar,

Are you going to make a pull request for this, or shall I take it? Should it be applied
to 3.16?

Regards,

	Hans

On 06/13/2014 08:13 PM, Prabhakar Lad wrote:
> On Thu, Jun 12, 2014 at 8:01 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> We recently changed some locking around so we need some new unlocks on
>> the error paths.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Applied!
> 
> Thanks,
> --Prabhakar Lad
> 
>> ---
>> v2: move the unlock so the list_for_each_entry_safe() loop is protected
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index a7ed164..1e4ec69 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -269,6 +269,7 @@ err:
>>                 list_del(&buf->list);
>>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>>         }
>> +       spin_unlock_irqrestore(&common->irqlock, flags);
>>
>>         return ret;
>>  }
>> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
>> index 5bb085b..b431b58 100644
>> --- a/drivers/media/platform/davinci/vpif_display.c
>> +++ b/drivers/media/platform/davinci/vpif_display.c
>> @@ -233,6 +233,7 @@ err:
>>                 list_del(&buf->list);
>>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>>         }
>> +       spin_unlock_irqrestore(&common->irqlock, flags);
>>
>>         return ret;
>>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

