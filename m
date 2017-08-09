Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54245 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdHILFI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 07:05:08 -0400
Subject: Re: [PATCH] media: i2c: adv748x: Export I2C device table entries as
 module aliases
To: Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20170809093731.3572-1-javierm@redhat.com>
 <e446df61-defc-4c9e-0f5a-d7afce878156@ideasonboard.com>
 <a984305d-6ba2-5b1a-b68a-98a9bcd245df@redhat.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e055ec23-38f2-fa41-4ae2-fd01b18a8a87@ideasonboard.com>
Date: Wed, 9 Aug 2017 12:05:03 +0100
MIME-Version: 1.0
In-Reply-To: <a984305d-6ba2-5b1a-b68a-98a9bcd245df@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/17 11:58, Javier Martinez Canillas wrote:
> Hi Kieran,
> 
> On 08/09/2017 12:29 PM, Kieran Bingham wrote:
>> Hi Javier,
>>
>> Thankyou for the patch
> 
> You are welcome.
>  
>> On 09/08/17 10:37, Javier Martinez Canillas wrote:
>>> The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
>>> device was registered via OF, and the driver is only exporting the OF ID
>>> table entries as module aliases.
>>>
>>> So if the driver is built as module, autoload won't work since udev/kmod
>>> won't be able to match the registered OF device with its driver module.
>>
>> Good catch, and perhaps I should have known better :D
>>
>> I've only worked on this driver as a built-in so far :-) #BadExcuses
>>
> 
> A better excuse I think is that after all these years, one would had thought
> that the I2C OF modalias issue would had been finally fixed, but not yet :)

Quite! Let's try to bubble that back up the todo list.
Now - where did I put my free time. I'm sure I left it around here somewhere :-)

--
Kieran
