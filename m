Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33193 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPUMZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 15:12:25 -0500
Received: by mail-wm0-f65.google.com with SMTP id v77so4784912wmv.0
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 12:12:24 -0800 (PST)
Subject: Re: [PATCH 2/4] [media] em28xx: reduce stack usage in probe functions
To: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170202145318.3803805-1-arnd@arndb.de>
 <20170202145318.3803805-2-arnd@arndb.de>
 <12e52c0c-1e40-3276-7c24-43cc670f00a4@xs4all.nl>
Cc: linux-media@vger.kernel.org
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <2094edcd-65b2-0cd0-3777-0cf58e7f9cfc@googlemail.com>
Date: Thu, 16 Feb 2017 21:13:19 +0100
MIME-Version: 1.0
In-Reply-To: <12e52c0c-1e40-3276-7c24-43cc670f00a4@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Am 13.02.2017 um 15:00 schrieb Hans Verkuil:
> Hi Arnd,
>
> I'll take the others of this patch series, but will postpone this one until it has
> been tested.
>
> I've asked Frank to see if he can test it, if not, then it will have to wait until
> March when I have access to an omnivision-em28xx device.
>
> Regards,
>
> 	Hans
>
> On 02/02/2017 03:53 PM, Arnd Bergmann wrote:
>> The two i2c probe functions use a lot of stack since they put
>> an i2c_client structure in a local variable:
>>
>> drivers/media/usb/em28xx/em28xx-camera.c: In function 'em28xx_probe_sensor_micron':
>> drivers/media/usb/em28xx/em28xx-camera.c:205:1: error: the frame size of 1256 bytes is larger than 1152 bytes [-Werror=frame-larger-than=]
>> drivers/media/usb/em28xx/em28xx-camera.c: In function 'em28xx_probe_sensor_omnivision':
>> drivers/media/usb/em28xx/em28xx-camera.c:317:1: error: the frame size of 1248 bytes is larger than 1152 bytes [-Werror=frame-larger-than=]
>>
>> This cleans up both of the above by removing the need for those
>> structures, calling the lower-level i2c function directly.

in the past, it was necessary to keep dev->i2c_client[dev->def_i2c_bus] 
unmodified, otherwise bad things could have happened after sensor probing.
In the meantime many things have been refactored/fixed and this seems to 
be no longer true.
So we can go the simple way and just use a pointer to 
dev->i2c_client[dev->def_i2c_bus] instead.
But let me test that with another device this weekend to be 100% sure.

Regards,
Frank


>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>   drivers/media/usb/em28xx/em28xx-camera.c | 87 ++++++++++++++++++--------------
>>   1 file changed, 50 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
>> index 89c890ba7dd6..e64940f95a91 100644
>> --- a/drivers/media/usb/em28xx/em28xx-camera.c
>> +++ b/drivers/media/usb/em28xx/em28xx-camera.c
>> @@ -99,6 +99,25 @@ static int em28xx_initialize_mt9m001(struct em28xx *dev)
>>   	return 0;
>>   }
>>   
>> +/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
>> +static int em28xx_i2c_read_chip_id(struct em28xx *dev, u16 addr, u8 reg, void *buf)
>> +{
>> +	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
>> +	struct i2c_msg msg[2];
>> +
>> +	msg[0].addr = addr;
>> +	msg[0].flags = client->flags & I2C_M_TEN;
>> +	msg[0].len = 1;
>> +	msg[0].buf = &reg;
>> +	msg[1].addr = addr;
>> +	msg[1].flags = client->flags & I2C_M_TEN;
>> +	msg[1].flags |= I2C_M_RD;
>> +	msg[1].len = 2;
>> +	msg[1].buf = buf;
>> +
>> +	return i2c_transfer(client->adapter, msg, 2);
>> +}
>> +
>>   /*
>>    * Probes Micron sensors with 8 bit address and 16 bit register width
>>    */
>> @@ -106,48 +125,29 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>   {
>>   	int ret, i;
>>   	char *name;
>> -	u8 reg;
>>   	__be16 id_be;
>> +	u16 addr;
>>   	u16 id;
>>   
>> -	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
>> -
>>   	dev->em28xx_sensor = EM28XX_NOSENSOR;
>>   	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
>> -		client.addr = micron_sensor_addrs[i];
>> -		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
>> +		addr = micron_sensor_addrs[i];
>>   		/* Read chip ID from register 0x00 */
>> -		reg = 0x00;
>> -		ret = i2c_master_send(&client, &reg, 1);
>> +		ret = em28xx_i2c_read_chip_id(dev, addr, 0x00, &id_be);
>>   		if (ret < 0) {
>>   			if (ret != -ENXIO)
>>   				dev_err(&dev->intf->dev,
>>   					"couldn't read from i2c device 0x%02x: error %i\n",
>> -				       client.addr << 1, ret);
>> -			continue;
>> -		}
>> -		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
>> -		if (ret < 0) {
>> -			dev_err(&dev->intf->dev,
>> -				"couldn't read from i2c device 0x%02x: error %i\n",
>> -				client.addr << 1, ret);
>> +				       addr << 1, ret);
>>   			continue;
>>   		}
>>   		id = be16_to_cpu(id_be);
>>   		/* Read chip ID from register 0xff */
>> -		reg = 0xff;
>> -		ret = i2c_master_send(&client, &reg, 1);
>> +		ret = em28xx_i2c_read_chip_id(dev, addr, 0xff, &id_be);
>>   		if (ret < 0) {
>>   			dev_err(&dev->intf->dev,
>>   				"couldn't read from i2c device 0x%02x: error %i\n",
>> -				client.addr << 1, ret);
>> -			continue;
>> -		}
>> -		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
>> -		if (ret < 0) {
>> -			dev_err(&dev->intf->dev,
>> -				"couldn't read from i2c device 0x%02x: error %i\n",
>> -				client.addr << 1, ret);
>> +				addr << 1, ret);
>>   			continue;
>>   		}
>>   		/* Validate chip ID to be sure we have a Micron device */
>> @@ -197,13 +197,26 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>   			dev_info(&dev->intf->dev,
>>   				 "sensor %s detected\n", name);
>>   
>> -		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
>> +		dev->i2c_client[dev->def_i2c_bus].addr = addr;
>>   		return 0;
>>   	}
>>   
>>   	return -ENODEV;
>>   }
>>   
>> +/* like i2c_smbus_read_byte_data, but allows passing an addr */
>> +static int em28xx_smbus_read_byte(struct em28xx *dev, u16 addr, u8 command)
>> +{
>> +	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
>> +	union i2c_smbus_data data;
>> +	int status;
>> +
>> +	status = i2c_smbus_xfer(client->adapter, addr, client->flags,
>> +				I2C_SMBUS_READ, command,
>> +				I2C_SMBUS_BYTE_DATA, &data);
>> +	return (status < 0) ? status : data.byte;
>> +}
>> +
>>   /*
>>    * Probes Omnivision sensors with 8 bit address and register width
>>    */
>> @@ -212,31 +225,31 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
>>   	int ret, i;
>>   	char *name;
>>   	u8 reg;
>> +	u16 addr;
>>   	u16 id;
>> -	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
>>   
>>   	dev->em28xx_sensor = EM28XX_NOSENSOR;
>>   	/* NOTE: these devices have the register auto incrementation disabled
>>   	 * by default, so we have to use single byte reads !              */
>>   	for (i = 0; omnivision_sensor_addrs[i] != I2C_CLIENT_END; i++) {
>> -		client.addr = omnivision_sensor_addrs[i];
>> +		addr = omnivision_sensor_addrs[i];
>>   		/* Read manufacturer ID from registers 0x1c-0x1d (BE) */
>>   		reg = 0x1c;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = em28xx_smbus_read_byte(dev, addr, reg);
>>   		if (ret < 0) {
>>   			if (ret != -ENXIO)
>>   				dev_err(&dev->intf->dev,
>>   					"couldn't read from i2c device 0x%02x: error %i\n",
>> -					client.addr << 1, ret);
>> +					addr << 1, ret);
>>   			continue;
>>   		}
>>   		id = ret << 8;
>>   		reg = 0x1d;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = em28xx_smbus_read_byte(dev, addr, reg);
>>   		if (ret < 0) {
>>   			dev_err(&dev->intf->dev,
>>   				"couldn't read from i2c device 0x%02x: error %i\n",
>> -				client.addr << 1, ret);
>> +				addr << 1, ret);
>>   			continue;
>>   		}
>>   		id += ret;
>> @@ -245,20 +258,20 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
>>   			continue;
>>   		/* Read product ID from registers 0x0a-0x0b (BE) */
>>   		reg = 0x0a;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = em28xx_smbus_read_byte(dev, addr, reg);
>>   		if (ret < 0) {
>>   			dev_err(&dev->intf->dev,
>>   				"couldn't read from i2c device 0x%02x: error %i\n",
>> -				client.addr << 1, ret);
>> +				addr << 1, ret);
>>   			continue;
>>   		}
>>   		id = ret << 8;
>>   		reg = 0x0b;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = em28xx_smbus_read_byte(dev, addr, reg);
>>   		if (ret < 0) {
>>   			dev_err(&dev->intf->dev,
>>   				"couldn't read from i2c device 0x%02x: error %i\n",
>> -				client.addr << 1, ret);
>> +				addr << 1, ret);
>>   			continue;
>>   		}
>>   		id += ret;
>> @@ -309,7 +322,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
>>   			dev_info(&dev->intf->dev,
>>   				 "sensor %s detected\n", name);
>>   
>> -		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
>> +		dev->i2c_client[dev->def_i2c_bus].addr = addr;
>>   		return 0;
>>   	}
>>   
>>
