Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33313 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965760AbdAKONf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 09:13:35 -0500
Received: by mail-vk0-f52.google.com with SMTP id 137so380711850vkl.0
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2017 06:13:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8e391d70-1b4c-3bb9-08d9-409bb139ef7e@kaa.org.ua>
References: <20170111100819.2190-1-oleg@kaa.org.ua> <CALzAhNXJYtg+wpmq48DKzznyO2NvmrQYONxK_-Ajb_UESEXrCg@mail.gmail.com>
 <8e391d70-1b4c-3bb9-08d9-409bb139ef7e@kaa.org.ua>
From: Steven Toth <stoth@kernellabs.com>
Date: Wed, 11 Jan 2017 09:13:33 -0500
Message-ID: <CALzAhNWdJRvVLRcv05eZugSR3bYZ9Tmrd+tfMGab=VadTOngJA@mail.gmail.com>
Subject: Re: [PATCH] [media] cx231xx: Initial support Evromedia USB Full
 Hybrid Full HD
To: Oleh Kravchenko <oleg@kaa.org.ua>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Jacob Johan (Hans) Verkuil" <hverkuil@xs4all.nl>,
        Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 11, 2017 at 9:00 AM, Oleh Kravchenko <oleg@kaa.org.ua> wrote:
> On 11.01.17 15:53, Steven Toth wrote:
>>> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
>>> index 35e9acf..60412ec 100644
>>> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
>>> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
>>> @@ -171,6 +171,43 @@ static int cx231xx_i2c_send_bytes(struct i2c_adapter *i2c_adap,
>>>                 bus->i2c_nostop = 0;
>>>                 bus->i2c_reserve = 0;
>>>
>>> +       } else if (dev->model == CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD
>>> +               && msg->addr == dev->tuner_addr
>>> +               && msg->len > 4) {
>>> +               /* special case for Evromedia USB Full Hybrid Full HD tuner chip */
>>> +               size = msg->len;
>>> +               saddr_len = 1;
>>> +
>>> +               /* adjust the length to correct length */
>>> +               size -= saddr_len;
>>> +
>>> +               buf_ptr = (u8*)(msg->buf + 1);
>>> +
>>> +               do {
>>> +                       /* prepare xfer_data struct */
>>> +                       req_data.dev_addr = msg->addr;
>>> +                       req_data.direction = msg->flags;
>>> +                       req_data.saddr_len = saddr_len;
>>> +                       req_data.saddr_dat = msg->buf[0];
>>> +                       req_data.buf_size = size > 4 ? 4 : size;
>>> +                       req_data.p_buffer = (u8*)(buf_ptr + loop * 4);
>>> +
>>> +                       bus->i2c_nostop = (size > 4) ? 1 : 0;
>>> +                       bus->i2c_reserve = (loop == 0) ? 0 : 1;
>>> +
>>> +                       /* usb send command */
>>> +                       status = dev->cx231xx_send_usb_command(bus, &req_data);
>>> +                       loop++;
>>> +
>>> +                       if (size >= 4) {
>>> +                               size -= 4;
>>> +                       } else {
>>> +                               size = 0;
>>> +                       }
>>> +               } while (size > 0);
>>> +
>>> +               bus->i2c_nostop = 0;
>>> +               bus->i2c_reserve = 0;
>>>         } else {                /* regular case */
>>>
>>>                 /* prepare xfer_data struct */
>> If the i2c functionality is broken in some way, I suggest its fixed
>> first, along with a correct patch description, as a separate piece of
>> work. Lets not group this in with a board profile.
>>
>> Almost certainly we should never see a "if board == X" in any i2c
>> implementation without proper discussion.
>>
> I'm interested in accepting this patch :) What I should do?

Lets start the conversion with what's wrong with the current
implementation that prevents it from working with the new design.
Lets discuss the I2C needs of the parts you need to communicate with,
and why the current design is broken.

Then, lets think about a better solution.

A BOARD == X is the wrong solution to the problem.


-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
