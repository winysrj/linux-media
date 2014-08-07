Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4607 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaHGGpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 02:45:24 -0400
Message-ID: <53E32077.2070709@xs4all.nl>
Date: Thu, 07 Aug 2014 08:45:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: fix compiler warnings
References: <53E080F6.30301@xs4all.nl> <53E0F5AE.2050903@googlemail.com>
In-Reply-To: <53E0F5AE.2050903@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2014 05:18 PM, Frank Schäfer wrote:
> Hi Hans,
> 
> Am 05.08.2014 um 09:00 schrieb Hans Verkuil:
>> Fix three compiler warnings:
>>
>> drivers/media/usb/em28xx/em28xx-input.c: In function ‘em28xx_i2c_ir_handle_key’:
>> drivers/media/usb/em28xx/em28xx-input.c:318:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>>   CC [M]  drivers/media/usb/em28xx/em28xx-dvb.o
>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_micron’:
>> drivers/media/usb/em28xx/em28xx-camera.c:199:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_omnivision’:
>> drivers/media/usb/em28xx/em28xx-camera.c:304:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
> Hmmm... I don't get these weird warnings.
> How can I reproduce them ?

I'm using gcc 4.9.1 and I'm compiling the kernel using just a regular make command.
In my .config I have CONFIG_FRAME_WARN=1024.

> 
>> Note: there is no way the code in em28xx_i2c_ir_handle_key() is correct: it's
>> using an almost completely uninitialized i2c_client struct with random flags,
>> dev and name fields. Can't this turned into a proper i2c_client struct in
>> struct em28xx? At least with this patch it's no longer random data.
> Why do you think the client setup is random ?

Well, this is the code:

	struct i2c_client client;
 
	client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
	client.addr = ir->i2c_dev_addr;

All other fields of the client struct are undefined, but it is used as is. That
can't be right. With my patch the i2c_client is either that that was used by the
probe, or it is all zero. Which is still better than having random values.

> Which fields do you think are wrong ? AFAICS this patch doesn't change
> any fields.
> 
> What's wrong with using local i2c_client variables ?

Nothing, except that they take a lot of stack space which the compiler complains about.
The stack in the kernel is limited, so this should be avoided.

> 
> Indeed, the way the driver currently tracks i2c clients / subdevices is
> ... let's say "improvable".
> But IMHO, we should go the opposite direction and get rid of the
> i2c_clients in the main device struct.
> They are in fact just temporary helpers and dangerous to use with
> devices with multiple i2c clients on the same bus.

Feel free to find another solution, but allocating i2c_client structs on the
stack is not the right solution.

If you are wondering why these warnings are not seen in the daily build: I'm
increasing the CONFIG_FRAME_WARN setting to 2048. I'll actually disable this
for the next daily build. See what happens. I don't think there are many of
these warnings left, a lot have been cleaned up over the years.

Regards,

	Hans

> 
> Regards,
> Frank
> 
> 
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
>> index 6d2ea9a..c8490ba 100644
>> --- a/drivers/media/usb/em28xx/em28xx-camera.c
>> +++ b/drivers/media/usb/em28xx/em28xx-camera.c
>> @@ -110,40 +110,40 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>  	__be16 id_be;
>>  	u16 id;
>>  
>> -	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
>> +	dev->tmp_i2c_client = dev->i2c_client[dev->def_i2c_bus];
>>  
>>  	dev->em28xx_sensor = EM28XX_NOSENSOR;
>>  	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
>> -		client.addr = micron_sensor_addrs[i];
>> +		dev->tmp_i2c_client.addr = micron_sensor_addrs[i];
>>  		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
>>  		/* Read chip ID from register 0x00 */
>>  		reg = 0x00;
>> -		ret = i2c_master_send(&client, &reg, 1);
>> +		ret = i2c_master_send(&dev->tmp_i2c_client, &reg, 1);
>>  		if (ret < 0) {
>>  			if (ret != -ENXIO)
>>  				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -					      client.addr << 1, ret);
>> +					      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>> -		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
>> +		ret = i2c_master_recv(&dev->tmp_i2c_client, (u8 *)&id_be, 2);
>>  		if (ret < 0) {
>>  			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -				      client.addr << 1, ret);
>> +				      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>>  		id = be16_to_cpu(id_be);
>>  		/* Read chip ID from register 0xff */
>>  		reg = 0xff;
>> -		ret = i2c_master_send(&client, &reg, 1);
>> +		ret = i2c_master_send(&dev->tmp_i2c_client, &reg, 1);
>>  		if (ret < 0) {
>>  			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -				      client.addr << 1, ret);
>> +				      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>> -		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
>> +		ret = i2c_master_recv(&dev->tmp_i2c_client, (u8 *)&id_be, 2);
>>  		if (ret < 0) {
>>  			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -				      client.addr << 1, ret);
>> +				      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>>  		/* Validate chip ID to be sure we have a Micron device */
>> @@ -191,7 +191,7 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>  		else
>>  			em28xx_info("sensor %s detected\n", name);
>>  
>> -		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
>> +		dev->i2c_client[dev->def_i2c_bus].addr = dev->tmp_i2c_client.addr;
>>  		return 0;
>>  	}
>>  
>> @@ -207,28 +207,29 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
>>  	char *name;
>>  	u8 reg;
>>  	u16 id;
>> -	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
>> +
>> +	dev->tmp_i2c_client = dev->i2c_client[dev->def_i2c_bus];
>>  
>>  	dev->em28xx_sensor = EM28XX_NOSENSOR;
>>  	/* NOTE: these devices have the register auto incrementation disabled
>>  	 * by default, so we have to use single byte reads !              */
>>  	for (i = 0; omnivision_sensor_addrs[i] != I2C_CLIENT_END; i++) {
>> -		client.addr = omnivision_sensor_addrs[i];
>> +		dev->tmp_i2c_client.addr = omnivision_sensor_addrs[i];
>>  		/* Read manufacturer ID from registers 0x1c-0x1d (BE) */
>>  		reg = 0x1c;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = i2c_smbus_read_byte_data(&dev->tmp_i2c_client, reg);
>>  		if (ret < 0) {
>>  			if (ret != -ENXIO)
>>  				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -					      client.addr << 1, ret);
>> +					      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>>  		id = ret << 8;
>>  		reg = 0x1d;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = i2c_smbus_read_byte_data(&dev->tmp_i2c_client, reg);
>>  		if (ret < 0) {
>>  			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -				      client.addr << 1, ret);
>> +				      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>>  		id += ret;
>> @@ -237,18 +238,18 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
>>  			continue;
>>  		/* Read product ID from registers 0x0a-0x0b (BE) */
>>  		reg = 0x0a;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = i2c_smbus_read_byte_data(&dev->tmp_i2c_client, reg);
>>  		if (ret < 0) {
>>  			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -				      client.addr << 1, ret);
>> +				      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>>  		id = ret << 8;
>>  		reg = 0x0b;
>> -		ret = i2c_smbus_read_byte_data(&client, reg);
>> +		ret = i2c_smbus_read_byte_data(&dev->tmp_i2c_client, reg);
>>  		if (ret < 0) {
>>  			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
>> -				      client.addr << 1, ret);
>> +				      dev->tmp_i2c_client.addr << 1, ret);
>>  			continue;
>>  		}
>>  		id += ret;
>> @@ -296,7 +297,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
>>  		else
>>  			em28xx_info("sensor %s detected\n", name);
>>  
>> -		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
>> +		dev->i2c_client[dev->def_i2c_bus].addr = dev->tmp_i2c_client.addr;
>>  		return 0;
>>  	}
>>  
>> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
>> index ed843bd..07069b6 100644
>> --- a/drivers/media/usb/em28xx/em28xx-input.c
>> +++ b/drivers/media/usb/em28xx/em28xx-input.c
>> @@ -298,12 +298,11 @@ static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
>>  	static u32 scancode;
>>  	enum rc_type protocol;
>>  	int rc;
>> -	struct i2c_client client;
>>  
>> -	client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>> -	client.addr = ir->i2c_dev_addr;
>> +	dev->tmp_i2c_client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>> +	dev->tmp_i2c_client.addr = ir->i2c_dev_addr;
>>  
>> -	rc = ir->get_key_i2c(&client, &protocol, &scancode);
>> +	rc = ir->get_key_i2c(&dev->tmp_i2c_client, &protocol, &scancode);
>>  	if (rc < 0) {
>>  		dprintk("ir->get_key_i2c() failed: %d\n", rc);
>>  		return rc;
>> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
>> index 84ef8ef..437ca08 100644
>> --- a/drivers/media/usb/em28xx/em28xx.h
>> +++ b/drivers/media/usb/em28xx/em28xx.h
>> @@ -630,6 +630,7 @@ struct em28xx {
>>  	struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
>>  	struct i2c_client i2c_client[NUM_I2C_BUSES];
>>  	struct em28xx_i2c_bus i2c_bus[NUM_I2C_BUSES];
>> +	struct i2c_client tmp_i2c_client;
>>  
>>  	unsigned char eeprom_addrwidth_16bit:1;
>>  	unsigned def_i2c_bus;	/* Default I2C bus */
> 

