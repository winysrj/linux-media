Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:39156 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751831AbdBMHiz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 02:38:55 -0500
From: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: Re: [PATCH 2/2] [media] cx231xx: Fix I2C on Internal Master 3 Bus
To: Antti Palosaari <crope@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steven Toth <stoth@kernellabs.com>,
        Jacob Johan Verkuil <hverkuil@xs4all.nl>
References: <20170207193514.14929-1-oleg@kaa.org.ua>
 <20170207193514.14929-2-oleg@kaa.org.ua>
 <b0809baf-5fca-4747-480d-b34784dc489b@iki.fi>
Message-ID: <f11dc206-04a7-4dc7-fb0d-771ce214499e@kaa.org.ua>
Date: Mon, 13 Feb 2017 09:38:51 +0200
MIME-Version: 1.0
In-Reply-To: <b0809baf-5fca-4747-480d-b34784dc489b@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 13.02.17 06:58, Antti Palosaari wrote:
> On 02/07/2017 09:35 PM, Oleh Kravchenko wrote:
>> Internal Master 3 Bus can send and receive only 4 bytes per time.
>>
>> Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
>> ---
>>  drivers/media/usb/cx231xx/cx231xx-core.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
>> index 550ec93..46646ec 100644
>> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
>> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
>> @@ -355,7 +355,12 @@ int cx231xx_send_vendor_cmd(struct cx231xx *dev,
>>       */
>>      if ((ven_req->wLength > 4) && ((ven_req->bRequest == 0x4) ||
>>                      (ven_req->bRequest == 0x5) ||
>> -                    (ven_req->bRequest == 0x6))) {
>> +                    (ven_req->bRequest == 0x6) ||
>> +
>> +                    /* Internal Master 3 Bus can send
>> +                     * and receive only 4 bytes per time
>> +                     */
>> +                    (ven_req->bRequest == 0x2))) {
>>          unsend_size = 0;
>>          pdata = ven_req->pBuff;
>>
>>
> 
> Good that you finally got i2c fixed properly and get rid of that ugly device specific hack.
> 
> That new comment still does not open for me, why you call i2c bus tuner sits as internal?
 
Because Sri Deevi called it:
        /* Internal Master 3 Bus */
        dev->i2c_bus[2].nr = 2;
        dev->i2c_bus[2].dev = dev;
        dev->i2c_bus[2].i2c_period = I2C_SPEED_100K;    /* 100kHz */
        dev->i2c_bus[2].i2c_nostop = 0;
        dev->i2c_bus[2].i2c_reserve = 0;

> There is now commands 2, 4, 5, and 6 that should be split to 4 byte long, is there any vendor command that could be longer? Maybe you could just add single comment which states what all those 4 commands are.

Those commands is I2C bus numbers, plus read flag:
	0 - write to I2C_0	0+4 - read from I2C_0
	1 - write to I2C_1	1+4 - read from I2C_1
	2 - write to I2C_2	2+4 - read from I2C_2
So I think my comment is good enough.
 
> Your patches are still on wrong order - you should first fix i2c and after that add device support.

Looks like I can't change this, it already merged into linux-next :)

> regards
> Antti

-- 
Best regards,
Oleh Kravchenko
