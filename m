Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbdHILQy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 07:16:54 -0400
Subject: Re: [PATCH] media: i2c: adv748x: Export I2C device table entries as
 module aliases
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
References: <20170809093731.3572-1-javierm@redhat.com>
 <e446df61-defc-4c9e-0f5a-d7afce878156@ideasonboard.com>
 <a984305d-6ba2-5b1a-b68a-98a9bcd245df@redhat.com>
 <e055ec23-38f2-fa41-4ae2-fd01b18a8a87@ideasonboard.com>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <0d020435-c8a0-e56b-eb22-8d4ed8ec0ef2@redhat.com>
Date: Wed, 9 Aug 2017 13:16:50 +0200
MIME-Version: 1.0
In-Reply-To: <e055ec23-38f2-fa41-4ae2-fd01b18a8a87@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2017 01:05 PM, Kieran Bingham wrote:
> On 09/08/17 11:58, Javier Martinez Canillas wrote:
>> Hi Kieran,
>>
>> On 08/09/2017 12:29 PM, Kieran Bingham wrote:
>>> Hi Javier,
>>>
>>> Thankyou for the patch
>>
>> You are welcome.
>>  
>>> On 09/08/17 10:37, Javier Martinez Canillas wrote:
>>>> The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
>>>> device was registered via OF, and the driver is only exporting the OF ID
>>>> table entries as module aliases.
>>>>
>>>> So if the driver is built as module, autoload won't work since udev/kmod
>>>> won't be able to match the registered OF device with its driver module.
>>>
>>> Good catch, and perhaps I should have known better :D
>>>
>>> I've only worked on this driver as a built-in so far :-) #BadExcuses
>>>
>>
>> A better excuse I think is that after all these years, one would had thought
>> that the I2C OF modalias issue would had been finally fixed, but not yet :)
> 
> Quite! Let's try to bubble that back up the todo list.
> Now - where did I put my free time. I'm sure I left it around here somewhere :-)
> 

We are getting there though. I'm just waiting for the patches in this [0] series
to land and then I'll be able to post the I2C core uevent modalias patch.

I've asked Wolfram if he can at least pick the driver patches [1], but he didn't
answer me yet...

[0]: https://www.spinics.net/lists/arm-kernel/msg588431.html
[1]: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1457427.html

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
