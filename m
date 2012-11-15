Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63666 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2KOFWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 00:22:07 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so1313447obb.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 21:22:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-jhj3+u4PN5ms7PrYLYe-DEKzHLnPqu3DPw0SH2n6uUg@mail.gmail.com>
References: <CAPgLHd-ivjzSDre+DMVK+mHNpNynoLWJXK36zGW5GRnU0Z4d3g@mail.gmail.com>
 <CA+V-a8vDjbmY-+c-aaaEcJ4JXv7Dm_ytUzGPD0eDDe_utB7kxQ@mail.gmail.com> <CAPgLHd-jhj3+u4PN5ms7PrYLYe-DEKzHLnPqu3DPw0SH2n6uUg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 15 Nov 2012 10:51:47 +0530
Message-ID: <CA+V-a8vmgbVFsTUabaWSdy4=CX+9doTqkWk-372iG9BG6AHFqw@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_display: fix return value check in vpif_reqbufs()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Mon, Nov 12, 2012 at 2:14 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> Hi Prabhakar,
>
> On 11/09/2012 08:33 PM, Prabhakar Lad wrote:
>> Hi Wei,
>>
>> Thanks for the patch.
>>
>> On Wed, Oct 24, 2012 at 4:59 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>
>>> In case of error, the function vb2_dma_contig_init_ctx() returns
>>> ERR_PTR() and never returns NULL. The NULL test in the return value
>>> check should be replaced with IS_ERR().
>>>
>>> dpatch engine is used to auto generate this patch.
>>> (https://github.com/weiyj/dpatch)
>>>
>>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>> ---
>>>  drivers/media/platform/davinci/vpif_display.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
>>> index b716fbd..5453bbb 100644
>>> --- a/drivers/media/platform/davinci/vpif_display.c
>>> +++ b/drivers/media/platform/davinci/vpif_display.c
>>> @@ -972,9 +972,9 @@ static int vpif_reqbufs(struct file *file, void *priv,
>>>         }
>>>         /* Initialize videobuf2 queue as per the buffer type */
>>>         common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
>>> -       if (!common->alloc_ctx) {
>>> +       if (IS_ERR(common->alloc_ctx)) {
>> Right check would be IS_ERR_OR_NULL(). Can you merge this
>> patch 'vpif_capture: fix return value check in vpif_reqbufs()' with
>> this one  and post a v2 with above changes ?
>
> I will merge those two patch into one.
> And I never see vb2_dma_contig_init_ctx() can return NULL as a return
> value, we still would using IS_ERR_OR_NULL()?
>
IS_ERR() should be Ok.

Regards,
--Prabhakar Lad

> ---------------------------------------------------
> void *vb2_dma_contig_init_ctx(struct device *dev)
> {
>        struct vb2_dc_conf *conf;
>
>        conf = kzalloc(sizeof *conf, GFP_KERNEL);
>        if (!conf)
>                  return ERR_PTR(-ENOMEM);
>
>        conf->dev = dev;
>
>        return conf;
> }
> ---------------------------------------------------
>
>
>
>
