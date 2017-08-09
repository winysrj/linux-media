Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr40118.outbound.protection.outlook.com ([40.107.4.118]:53435
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751972AbdHIOnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 10:43:11 -0400
Subject: Re: [PATCH 3/3] [media] cx231xx: only unregister successfully
 registered i2c adapters
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20170731133852.8013-1-peda@axentia.se>
 <20170731133852.8013-4-peda@axentia.se> <20170809112741.36427eb0@vento.lan>
From: Peter Rosin <peda@axentia.se>
Message-ID: <24c02947-3812-1a1b-f6b7-dc5a3ff69d66@axentia.se>
Date: Wed, 9 Aug 2017 16:43:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170809112741.36427eb0@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-08-09 16:27, Mauro Carvalho Chehab wrote:
> Em Mon, 31 Jul 2017 15:38:52 +0200
> Peter Rosin <peda@axentia.se> escreveu:
> 
>> This prevents potentially scary debug messages from the i2c core.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
>> ---
>>  drivers/media/usb/cx231xx/cx231xx-core.c | 3 +++
>>  drivers/media/usb/cx231xx/cx231xx-i2c.c  | 3 ++-
>>  2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
>> index 46646ecd2dbc..f372ad3917a8 100644
>> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
>> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
>> @@ -1311,6 +1311,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
>>  	dev->i2c_bus[0].i2c_period = I2C_SPEED_100K;	/* 100 KHz */
>>  	dev->i2c_bus[0].i2c_nostop = 0;
>>  	dev->i2c_bus[0].i2c_reserve = 0;
>> +	dev->i2c_bus[0].i2c_rc = -ENODEV;
>>  
>>  	/* External Master 2 Bus */
>>  	dev->i2c_bus[1].nr = 1;
>> @@ -1318,6 +1319,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
>>  	dev->i2c_bus[1].i2c_period = I2C_SPEED_100K;	/* 100 KHz */
>>  	dev->i2c_bus[1].i2c_nostop = 0;
>>  	dev->i2c_bus[1].i2c_reserve = 0;
>> +	dev->i2c_bus[1].i2c_rc = -ENODEV;
>>  
>>  	/* Internal Master 3 Bus */
>>  	dev->i2c_bus[2].nr = 2;
>> @@ -1325,6 +1327,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
>>  	dev->i2c_bus[2].i2c_period = I2C_SPEED_100K;	/* 100kHz */
>>  	dev->i2c_bus[2].i2c_nostop = 0;
>>  	dev->i2c_bus[2].i2c_reserve = 0;
>> +	dev->i2c_bus[2].i2c_rc = -ENODEV;
>>  
>>  	/* register I2C buses */
>>  	errCode = cx231xx_i2c_register(&dev->i2c_bus[0]);
>> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
>> index 3e49517cb5e0..8ce6b815d16d 100644
>> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
>> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
>> @@ -553,7 +553,8 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
>>   */
>>  void cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
>>  {
>> -	i2c_del_adapter(&bus->i2c_adap);
>> +	if (!bus->i2c_rc)
>> +		i2c_del_adapter(&bus->i2c_adap);
> 
> That doesn't sound right. what happens if i2c_rc is 1 or 2?
> 
> IMHO, the right would would be, instead:
> 
> 	if (bus->i2c_rc >= 0)
> 		i2c_del_adapter(&bus->i2c_adap);

In theory, yes. But in practice i2c_add_adapter never returns >0, and is
also documented so.

Let me know if you still want an update. In that case I'll also fix the
precedent present in the context of patch 1/3, i.e.

	if (0 != bus->i2c_rc)
		...

Cheers,
peda
