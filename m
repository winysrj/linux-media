Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.194]:29822 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752403AbdGGTnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 15:43:05 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 290CD6797A
        for <linux-media@vger.kernel.org>; Fri,  7 Jul 2017 14:42:57 -0500 (CDT)
Date: Fri, 07 Jul 2017 14:42:56 -0500
Message-ID: <20170707144256.Horde.L3eU_6Gq-zYR6kgxCBaZG8D@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: kieran.bingham@ideasonboard.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcar_fdp1: constify vb2_ops structure
References: <20170706202532.GA12160@embeddedgus>
 <76532629-9ab3-117a-d849-46c7ade8688c@ideasonboard.com>
In-Reply-To: <76532629-9ab3-117a-d849-46c7ade8688c@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Quoting Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>:

> Hi Gustavo,
>
> Thank you for the patch.
>

Absolutely, glad to help. :)

> On 06/07/17 21:25, Gustavo A. R. Silva wrote:
>> Check for vb2_ops structures that are only stored in the ops field of a
>> vb2_queue structure. That field is declared const, so vb2_ops structures
>> that have this property can be declared as const also.
>>
>> This issue was detected using Coccinelle and the following semantic patch:
>>
>> @r disable optional_qualifier@
>> identifier i;
>> position p;
>> @@
>> static struct vb2_ops i@p = { ... };
>>
>> @ok@
>> identifier r.i;
>> struct vb2_queue e;
>> position p;
>> @@
>> e.ops = &i@p;
>>
>> @bad@
>> position p != {r.p,ok.p};
>> identifier r.i;
>> struct vb2_ops e;
>> @@
>> e@i@p
>>
>> @depends on !bad disable optional_qualifier@
>> identifier r.i;
>> @@
>> static
>> +const
>> struct vb2_ops i = { ... };
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
>> ---
>>  drivers/media/platform/rcar_fdp1.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/rcar_fdp1.c  
>> b/drivers/media/platform/rcar_fdp1.c
>> index 3ee51fc..3245bc4 100644
>> --- a/drivers/media/platform/rcar_fdp1.c
>> +++ b/drivers/media/platform/rcar_fdp1.c
>> @@ -2032,7 +2032,7 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
>>  	}
>>  }
>>
>> -static struct vb2_ops fdp1_qops = {
>> +static const struct vb2_ops fdp1_qops = {
>>  	.queue_setup	 = fdp1_queue_setup,
>>  	.buf_prepare	 = fdp1_buf_prepare,
>>  	.buf_queue	 = fdp1_buf_queue,
>>

--
Gustavo A. R. Silva
