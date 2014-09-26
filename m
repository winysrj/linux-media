Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39792 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbaIZNAw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 09:00:52 -0400
Message-ID: <5425637F.8050707@iki.fi>
Date: Fri, 26 Sep 2014 16:00:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 02/12] cx231xx: use own i2c_client for eeprom access
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org> <1411621684-8295-2-git-send-email-zzam@gentoo.org> <54242D8D.8080401@iki.fi> <5424EBD0.1020300@gentoo.org> <54255CBF.9040303@iki.fi>
In-Reply-To: <54255CBF.9040303@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I decided to check how eeprom I2C interface works from datasheet. Chip 
keeps internally current address value and read operations are done for 
that. Basically both reads works, as chip keeps count of current read 
address internally.

That datasheet has nice figures from use cases:
http://www.atmel.com/Images/doc8700.pdf

Figure 9-1. Byte Write
Figure 9-2. Page Write
Figure 9-3. Current Address Read
Figure 9-4. Random Read
Figure 9-5. Sequential Read

regards
Antti

On 09/26/2014 03:31 PM, Antti Palosaari wrote:
> yes, of course :) If you has only one message, there is nothing to start
> again. Sending one message using i2c_transfer() means same than using
> i2c_master_send(), but the later one is just aimed to send single
> message and it cannot be used to send multiple messages at once.
>
> Code is correct, but it triggered my sensors when reading it and I have
> to check it many times whats going there.
>
> regards
> Antti
>
> On 09/26/2014 07:30 AM, Matthias Schwarzott wrote:
>> Hi Antti,
>>
>> I think that i2c_transfer sens no repeated start when sending only one
>> message per call.
>>
>> At least the received eeprom content looks correct.
>>
>> Regards
>> Matthias
>>
>> On 25.09.2014 16:58, Antti Palosaari wrote:
>>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>>>
>>> Please add commit description (why and how).
>>>
>>> Some notes for further development:
>>> It sends single messages, so you could (or even should) use
>>> i2c_master_send/i2c_master_recv (i2c_transfer is aimed for sending
>>> multiple messages using REPEATED START condition).
>>>
>>> I am not sure though if these eeprom chips uses REPEATED START condition
>>> for reads (means it could be broken even now).
>>>
>>> regards
>>> Antti
>>>
>>> On 09/25/2014 08:07 AM, Matthias Schwarzott wrote:
>>>> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
>>>> ---
>>>>    drivers/media/usb/cx231xx/cx231xx-cards.c | 24
>>>> +++++++++++++-----------
>>>>    1 file changed, 13 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c
>>>> b/drivers/media/usb/cx231xx/cx231xx-cards.c
>>>> index 791f00c..092fb85 100644
>>>> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
>>>> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
>>>> @@ -980,23 +980,20 @@ static void cx231xx_config_tuner(struct cx231xx
>>>> *dev)
>>>>
>>>>    }
>>>>
>>>> -static int read_eeprom(struct cx231xx *dev, u8 *eedata, int len)
>>>> +static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
>>>> +               u8 *eedata, int len)
>>>>    {
>>>>        int ret = 0;
>>>> -    u8 addr = 0xa0 >> 1;
>>>>        u8 start_offset = 0;
>>>>        int len_todo = len;
>>>>        u8 *eedata_cur = eedata;
>>>>        int i;
>>>> -    struct i2c_msg msg_write = { .addr = addr, .flags = 0,
>>>> +    struct i2c_msg msg_write = { .addr = client->addr, .flags = 0,
>>>>            .buf = &start_offset, .len = 1 };
>>>> -    struct i2c_msg msg_read = { .addr = addr, .flags = I2C_M_RD };
>>>> -
>>>> -    /* mutex_lock(&dev->i2c_lock); */
>>>> -    cx231xx_enable_i2c_port_3(dev, false);
>>>> +    struct i2c_msg msg_read = { .addr = client->addr, .flags =
>>>> I2C_M_RD };
>>>>
>>>>        /* start reading at offset 0 */
>>>> -    ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_write, 1);
>>>> +    ret = i2c_transfer(client->adapter, &msg_write, 1);
>>>>        if (ret < 0) {
>>>>            cx231xx_err("Can't read eeprom\n");
>>>>            return ret;
>>>> @@ -1006,7 +1003,7 @@ static int read_eeprom(struct cx231xx *dev, u8
>>>> *eedata, int len)
>>>>            msg_read.len = (len_todo > 64) ? 64 : len_todo;
>>>>            msg_read.buf = eedata_cur;
>>>>
>>>> -        ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_read, 1);
>>>> +        ret = i2c_transfer(client->adapter, &msg_read, 1);
>>>>            if (ret < 0) {
>>>>                cx231xx_err("Can't read eeprom\n");
>>>>                return ret;
>>>> @@ -1062,9 +1059,14 @@ void cx231xx_card_setup(struct cx231xx *dev)
>>>>            {
>>>>                struct tveeprom tvee;
>>>>                static u8 eeprom[256];
>>>> +            struct i2c_client client;
>>>> +
>>>> +            memset(&client, 0, sizeof(client));
>>>> +            client.adapter = &dev->i2c_bus[1].i2c_adap;
>>>> +            client.addr = 0xa0 >> 1;
>>>>
>>>> -            read_eeprom(dev, eeprom, sizeof(eeprom));
>>>> -            tveeprom_hauppauge_analog(&dev->i2c_bus[1].i2c_client,
>>>> +            read_eeprom(dev, &client, eeprom, sizeof(eeprom));
>>>> +            tveeprom_hauppauge_analog(&client,
>>>>                            &tvee, eeprom + 0xc0);
>>>>                break;
>>>>            }
>>>>
>>>
>>
>

-- 
http://palosaari.fi/
