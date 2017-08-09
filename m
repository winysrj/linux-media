Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751872AbdHIK6V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 06:58:21 -0400
Subject: Re: [PATCH] media: i2c: adv748x: Export I2C device table entries as
 module aliases
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20170809093731.3572-1-javierm@redhat.com>
 <e446df61-defc-4c9e-0f5a-d7afce878156@ideasonboard.com>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <a984305d-6ba2-5b1a-b68a-98a9bcd245df@redhat.com>
Date: Wed, 9 Aug 2017 12:58:18 +0200
MIME-Version: 1.0
In-Reply-To: <e446df61-defc-4c9e-0f5a-d7afce878156@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 08/09/2017 12:29 PM, Kieran Bingham wrote:
> Hi Javier,
> 
> Thankyou for the patch
>

You are welcome.
 
> On 09/08/17 10:37, Javier Martinez Canillas wrote:
>> The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
>> device was registered via OF, and the driver is only exporting the OF ID
>> table entries as module aliases.
>>
>> So if the driver is built as module, autoload won't work since udev/kmod
>> won't be able to match the registered OF device with its driver module.
> 
> Good catch, and perhaps I should have known better :D
> 
> I've only worked on this driver as a built-in so far :-) #BadExcuses
>

A better excuse I think is that after all these years, one would had thought
that the I2C OF modalias issue would had been finally fixed, but not yet :)
 
>> Before this patch:
>>
>> $ modinfo drivers/media/i2c/adv748x/adv748x.ko | grep alias
>> alias:          of:N*T*Cadi,adv7482C*
>> alias:          of:N*T*Cadi,adv7482
>> alias:          of:N*T*Cadi,adv7481C*
>> alias:          of:N*T*Cadi,adv7481
>>
>> After this patch:
>>
>> modinfo drivers/media/i2c/adv748x/adv748x.ko | grep alias
>> alias:          of:N*T*Cadi,adv7482C*
>> alias:          of:N*T*Cadi,adv7482
>> alias:          of:N*T*Cadi,adv7481C*
>> alias:          of:N*T*Cadi,adv7481
>> alias:          i2c:adv7482
>> alias:          i2c:adv7481
>>
>> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 

Thanks!

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
