Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62064 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IBEmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 00:42:51 -0400
Received: by mail-wg0-f53.google.com with SMTP id n12so3272405wgh.8
        for <linux-media@vger.kernel.org>; Sun, 01 Sep 2013 21:42:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8szUWiURmmuWReyH1xWSheyn9COOgdGkfFTSkbOPh44FQ@mail.gmail.com>
References: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
 <CA+V-a8szUWiURmmuWReyH1xWSheyn9COOgdGkfFTSkbOPh44FQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 2 Sep 2013 10:12:30 +0530
Message-ID: <CA+V-a8vLpSWCAecvNEFB0jxoJ0=oXsB3LWEMbfN00LghkW4Egw@mail.gmail.com>
Subject: Re: [PATCH -next] [media] davinci: vpif_capture: fix error return
 code in vpif_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Fri, Aug 23, 2013 at 8:50 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Wei,
>
> I retract my Ack.
>
> On Fri, Aug 23, 2013 at 8:30 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return -ENODEV in the subdevice register error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Introduced by commit 873229e4fdf34196aa5d707957c59ba54c25eaba
>> ([media] media: davinci: vpif: capture: add V4L2-async support)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index 7fbde6d..e4b6a26 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -2160,6 +2160,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>>
>>                         if (!vpif_obj.sd[i]) {
>>                                 vpif_err("Error registering v4l2 subdevice\n");
>> +                               err = -ENOMEM;
>
> This should be err = -ENODEV
>
I assume you will fix it and repost this patch.

Regards,
--Prabhakar Lad
