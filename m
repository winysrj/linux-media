Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38552 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3EMMke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 08:40:34 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so2470351bkc.0
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 05:40:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44148472.RS4fqJslTV@harkonnen>
References: <CAPgLHd8UFD4p=PAK+Ukno8qvmvaxVxvSrrZw=qpUtERCyP7hpg@mail.gmail.com>
	<44148472.RS4fqJslTV@harkonnen>
Date: Mon, 13 May 2013 20:40:33 +0800
Message-ID: <CAPgLHd87Pzp=OCzOb__5nTv0dy-_hbVeZv6buz__uv-sfYiuww@mail.gmail.com>
Subject: Re: [PATCH] [media] sta2x11_vip: fix error return code in sta2x11_vip_init_one()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: federico.vaga@gmail.com
Cc: mchehab@redhat.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, prabhakar.csengg@gmail.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/13/2013 08:19 PM, Federico Vaga wrote:
> Hello,
>
> I agree with the content of the patch, but I disagree with the commit message. 
> >From the commit message it seems that you fixed a bug about the error code, 
> but the aim of this patch is to uniform the code style. I suggest something 
> like: "uniform code style in sta2x11_vip_init_one()"

The orig code will release all the resources if v4l2_device_register()
failed and return 0.
But what we need in this case is to return an negative error code
to let the caller known we are failed. So the patch save the return
value of v4l2_device_register() to 'ret' and return it when error.


>
> On Monday 13 May 2013 13:59:45 Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return a negative error code from the error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  drivers/media/pci/sta2x11/sta2x11_vip.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c
>> b/drivers/media/pci/sta2x11/sta2x11_vip.c index 7005695..77edc11 100644
>> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
>> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
>> @@ -1047,7 +1047,8 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
>>  	ret = sta2x11_vip_init_controls(vip);
>>  	if (ret)
>>  		goto free_mem;
>> -	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
>> +	ret = v4l2_device_register(&pdev->dev, &vip->v4l2_dev);
>> +	if (ret)
>>  		goto free_mem;
>>
>>  	dev_dbg(&pdev->dev, "BAR #0 at 0x%lx 0x%lx irq %d\n",


