Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:55934 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754085AbdJIQSV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 12:18:21 -0400
Received: by mail-wm0-f42.google.com with SMTP id u138so25061473wmu.4
        for <linux-media@vger.kernel.org>; Mon, 09 Oct 2017 09:18:20 -0700 (PDT)
Subject: Re: [PATCH] [media] ov5645: I2C address change
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
 <edc2f078-0896-d9c7-f52a-e5d0604fdeea@linaro.org>
 <20171009093425.ftxgckycj2nuumle@valkosipuli.retiisi.org.uk>
 <2363273.DvfkURjy3A@avalon>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <c28fa305-1725-5faa-3246-3609cf9e391e@linaro.org>
Date: Mon, 9 Oct 2017 19:18:17 +0300
MIME-Version: 1.0
In-Reply-To: <2363273.DvfkURjy3A@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent :)

On  9.10.2017 15:52, Laurent Pinchart wrote:
> Hello,
> 
> On Monday, 9 October 2017 12:34:26 EEST Sakari Ailus wrote:
>> On Mon, Oct 09, 2017 at 11:36:01AM +0300, Todor Tomov wrote:
>>> On  4.10.2017 13:47, Laurent Pinchart wrote:
>>>> CC'ing the I2C mainling list and the I2C maintainer.
>>>>
>>>> On Wednesday, 4 October 2017 13:30:08 EEST Sakari Ailus wrote:
>>>>> On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
>>>>>> As soon as the sensor is powered on, change the I2C address to the one
>>>>>> specified in DT. This allows to use multiple physical sensors
>>>>>> connected to the same I2C bus.
>>>>>>
>>>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>>>>
>>>>> The smiapp driver does something similar and I understand Laurent might
>>>>> be interested in such functionality as well.
>>>>>
>>>>> It'd be nice to handle this through the I²C framework instead and to
>>>>> define how the information is specified through DT. That way it could
>>>>> be made generic, to work with more devices than just this one.
>>>>>
>>>>> What do you think?
>>>
>>> Thank you for this suggestion.
>>>
>>> The way I have done it is to put the new I2C address in the DT and the
>>> driver programs the change using the original I2C address. The original
>>> I2C address is hardcoded in the driver. So maybe we can extend the DT
>>> binding and the I2C framework so that both addresses come from the DT and
>>> avoid hiding the original I2C address in the driver. This sounds good to
>>> me.
>>
>> Agreed.
>>
>> In this case the address is known but in general that's not the case it's
>> not that simple. There are register compatible devices that have different
>> addresses even if they're the same devices.
>>
>> It might be a good idea to make this explicit.
> 
> Yes, in the general case we need to specify the original address in DT, as the 
> chip could have a non-fixed boot-up I2C address.
> 
> In many cases the value of the new I2C address doesn't matter much, as long as 
> it's unique on the bus. I was thinking about implementing a dynamic allocator 
> for I2C addresses, but after discussing it with Wolfram we concluded that it 
> would probably not be a good idea. There could be other I2C devices on the bus 
> that Linux isn't aware of, in which case the dynamic allocator could create 
> address conflicts. Specifying the new address in DT is likely a better idea, 
> even if it could feel a bit more of system configuration information than a 
> pure hardware description.
> 
>>> Then changing the address could be device specific and also this must be
>>> done right after power on so that there are no address conflicts. So I
>>> don't think that we can support this through the I2C framework only, the
>>> drivers that we want to do that will have to be expanded with this
>>> functionality. Or do you have any other idea?
>>
>> Yes, how the address is changed is always hardware specific. This would be
>> most conveniently done in driver's probe or PM runtime_resume functions.
> 
> This patch modifies client->addr directly, which I don't think is a good idea. 
> I'd prefer making the I2C core aware of the address change through an explicit 
> API call. This would allow catching I2C adress conflicts for instance.
> 
>> It could be as simple as providing an adapter specific mutex to serialise
>> address changes on the bus so that no two address changes are taking place
>> at the same time. Which is essentially the impliementation you had, only
>> the mutex would be for the I²C adapter, not the driver. An helper functions
>> for acquiring and releasing the mutex.
> 
> Why do you need to serialize address changes ?

Correct me if I'm wrong, but if you power on more than one device with the
same I2C address and issue a command to change it, then all devices will
recognize this command as addressed to them. The only solution (which I know
about) to avoid this is to serialize the power on and address change (as a whole!)
for these devices.

I think it would be better to move the mutex out of the driver - to avoid all
client drivers which will change I2C address to add a global variable mutex 
for this. We just have to find a better place for it :)

> 
>> I wonder what others think.
> 

-- 
Best regards,
Todor Tomov
