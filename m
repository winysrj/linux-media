Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.197.25]:40682 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751131AbdFTWph (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 18:45:37 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 1E63D1CCA9
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 16:57:57 -0500 (CDT)
Date: Tue, 20 Jun 2017 16:57:56 -0500
Message-ID: <20170620165756.Horde.6UeLYFz_bJ0D0W_butfuJS9@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [media-pci-cx25821] question about value overwrite
References: <20170518170709.Horde.zKHvDFB0L61Od1t7GtHytpR@gator4166.hostgator.com>
 <b170bdc6-8c36-936a-a960-2dcde3b64bc5@xs4all.nl>
In-Reply-To: <b170bdc6-8c36-936a-a960-2dcde3b64bc5@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Quoting Hans Verkuil <hverkuil@xs4all.nl>:

> On 05/19/2017 12:07 AM, Gustavo A. R. Silva wrote:
>>
>> Hello everybody,
>>
>> While looking into Coverity ID 1226903 I ran into the following piece
>> of code at drivers/media/pci/cx25821/cx25821-medusa-video.c:393:
>>
>> 393int medusa_set_videostandard(struct cx25821_dev *dev)
>> 394{
>> 395        int status = 0;
>> 396        u32 value = 0, tmp = 0;
>> 397
>> 398        if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm &  
>> V4L2_STD_PAL_DK)
>> 399                status = medusa_initialize_pal(dev);
>> 400        else
>> 401                status = medusa_initialize_ntsc(dev);
>> 402
>> 403        /* Enable DENC_A output */
>> 404        value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_A_REG_4, &tmp);
>> 405        value = setBitAtPos(value, 4);
>> 406        status = cx25821_i2c_write(&dev->i2c_bus[0],  
>> DENC_A_REG_4, value);
>> 407
>> 408        /* Enable DENC_B output */
>> 409        value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_B_REG_4, &tmp);
>> 410        value = setBitAtPos(value, 4);
>> 411        status = cx25821_i2c_write(&dev->i2c_bus[0],  
>> DENC_B_REG_4, value);
>> 412
>> 413        return status;
>> 414}
>>
>> The issue is that the value stored in variable _status_ at lines 399
>> and 401 is overwritten by the one stored at line 406 and then at line
>> 411, before it can be used.
>>
>> My question is if the original intention was to ORed the return
>> values, something like in the following patch:
>>
>> index 0a9db05..226d14f 100644
>> --- a/drivers/media/pci/cx25821/cx25821-medusa-video.c
>> +++ b/drivers/media/pci/cx25821/cx25821-medusa-video.c
>> @@ -403,12 +403,12 @@ int medusa_set_videostandard(struct cx25821_dev *dev)
>>          /* Enable DENC_A output */
>>          value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_A_REG_4, &tmp);
>>          value = setBitAtPos(value, 4);
>> -       status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_A_REG_4, value);
>> +       status |= cx25821_i2c_write(&dev->i2c_bus[0], DENC_A_REG_4, value);
>>
>>          /* Enable DENC_B output */
>>          value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_B_REG_4, &tmp);
>>          value = setBitAtPos(value, 4);
>> -       status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_B_REG_4, value);
>> +       status |= cx25821_i2c_write(&dev->i2c_bus[0], DENC_B_REG_4, value);
>>
>>          return status;
>>   }
>
> This is a crappy driver, they just couldn't be bothered to check the  
> error from
> cx25821_i2c_read/write.
>
> Strictly speaking the return value should be checked after every  
> read/write and
> returned in case of an error.
>

Yeah, the same happens in functions medusa_initialize_pal() and  
medusa_initialize_ntsc()

> Not sure whether it is worth the effort fixing this.
>

Thank you for your reply.
--
Gustavo A. R. Silva
