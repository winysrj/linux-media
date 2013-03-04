Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62702 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab3CDVaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 16:30:30 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so4164318eek.11
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 13:30:28 -0800 (PST)
Message-ID: <513512A6.1020605@googlemail.com>
Date: Mon, 04 Mar 2013 22:31:18 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] em28xx: add support for em25xx i2c bus B read/write/check
 device operations
References: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com> <1362339661-3446-2-git-send-email-fschaefer.oss@googlemail.com> <20130304172005.58590d43@redhat.com> <20130304172341.630de7e6@redhat.com>
In-Reply-To: <20130304172341.630de7e6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.03.2013 21:23, schrieb Mauro Carvalho Chehab:
> Em Mon, 4 Mar 2013 17:20:05 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>
>> Em Sun,  3 Mar 2013 20:40:57 +0100
>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
...
>>> @@ -277,7 +386,9 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>  			   struct i2c_msg msgs[], int num)
>>>  {
>>>  	struct em28xx *dev = i2c_adap->algo_data;
>>> -	int addr, rc, i, byte;
>>> +	int addr, i, byte;
>>> +	int rc = -EOPNOTSUPP;
>>> +	enum em28xx_i2c_algo_type algo_type = dev->i2c_algo_type;
>>>  
>>>  	if (num <= 0)
>>>  		return 0;
>>> @@ -290,10 +401,13 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>  			       i == num - 1 ? "stop" : "nonstop",
>>>  			       addr, msgs[i].len			     );
>>>  		if (!msgs[i].len) { /* no len: check only for device presence */
>>> -			if (dev->board.is_em2800)
>>> -				rc = em2800_i2c_check_for_device(dev, addr);
>>> -			else
>>> +			if (algo_type == EM28XX_I2C_ALGO_EM28XX) {
>>>  				rc = em28xx_i2c_check_for_device(dev, addr);
>>> +			} else if (algo_type == EM28XX_I2C_ALGO_EM2800) {
>>> +				rc = em2800_i2c_check_for_device(dev, addr);
>>> +			} else if (algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
>>> +				rc = em25xx_bus_B_check_for_device(dev, addr);
>>> +			}
>> That seems too messy. 
>>
>> IMO, the best is to create 3 different em28xx_i2c_xfer() routines:
>> one for em2800, one for "standard" I2c protocol, and another one for
>> this em25xx one. Then, all you need to do is to embed 
>> static struct i2c_algorithm into struct em28xx and fill
>> em28xx_algo.master_transfer to point to the correct xfer.
>>
>> That makes the code more readable and remove a little faster by removing
>> the unneeded ifs from the code.

Hmmm.... that's how I did it initially.
But IIRC correctly, it also duplicates lots of code, making it much
bigger...

I will take a look at it again tomorrow evening.


>>>  			if (rc == -ENODEV) {
>>>  				if (i2c_debug)
>>>  					printk(" no device\n");
>>> @@ -301,14 +415,19 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>  			}
>>>  		} else if (msgs[i].flags & I2C_M_RD) {
>>>  			/* read bytes */
>>> -			if (dev->board.is_em2800)
>>> -				rc = em2800_i2c_recv_bytes(dev, addr,
>>> +			if (algo_type == EM28XX_I2C_ALGO_EM28XX) {
>>> +				rc = em28xx_i2c_recv_bytes(dev, addr,
>>>  							   msgs[i].buf,
>>>  							   msgs[i].len);
>>> -			else
>>> -				rc = em28xx_i2c_recv_bytes(dev, addr,
>>> +			} else if (algo_type == EM28XX_I2C_ALGO_EM2800) {
>>> +				rc = em2800_i2c_recv_bytes(dev, addr,
>>>  							   msgs[i].buf,
>>>  							   msgs[i].len);
>>> +			} else if (algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
>>> +				rc = em25xx_bus_B_recv_bytes(dev, addr,
>>> +							    msgs[i].buf,
>>> +							    msgs[i].len);
>>> +			}
>>>  			if (i2c_debug) {
>>>  				for (byte = 0; byte < msgs[i].len; byte++)
>>>  					printk(" %02x", msgs[i].buf[byte]);
>>> @@ -319,15 +438,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>  				for (byte = 0; byte < msgs[i].len; byte++)
>>>  					printk(" %02x", msgs[i].buf[byte]);
>>>  			}
>>> -			if (dev->board.is_em2800)
>>> -				rc = em2800_i2c_send_bytes(dev, addr,
>>> -							   msgs[i].buf,
>>> -							   msgs[i].len);
>>> -			else
>>> +			if (algo_type == EM28XX_I2C_ALGO_EM28XX) {
>>>  				rc = em28xx_i2c_send_bytes(dev, addr,
>>>  							   msgs[i].buf,
>>>  							   msgs[i].len,
>>>  							   i == num - 1);
>>> +			} else if (algo_type == EM28XX_I2C_ALGO_EM2800) {
>>> +				rc = em2800_i2c_send_bytes(dev, addr,
>>> +							   msgs[i].buf,
>>> +							   msgs[i].len);
>>> +			} else if (algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B) {
>>> +				rc = em25xx_bus_B_send_bytes(dev, addr,
>>> +							    msgs[i].buf,
>>> +							    msgs[i].len);
>>> +			}
>>>  		}
>>>  		if (rc < 0) {
>>>  			if (i2c_debug)
>>> @@ -589,10 +713,16 @@ error:
>>>  static u32 functionality(struct i2c_adapter *adap)
>>>  {
>>>  	struct em28xx *dev = adap->algo_data;
>>> -	u32 func_flags = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>>> -	if (dev->board.is_em2800)
>>> -		func_flags &= ~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
>>> -	return func_flags;
>>> +
>>> +	if ((dev->i2c_algo_type == EM28XX_I2C_ALGO_EM28XX) ||
>>> +	    (dev->i2c_algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)) {
>>> +		return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>>> +	} else if (dev->i2c_algo_type == EM28XX_I2C_ALGO_EM2800)  {
>>> +		return (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL) &
>>> +			~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
>>> +	}
>>> +
>>> +	return 0; /* BUG */
>> Please create a separate I2C register logic for bus B. It was a mistake
>> to reuse the existing I2C bus for logic for both buses (ok, actually,
>> no device currently uses 2 buses, as they simply don't read eeproms on
>> 2 bus devices). 
>>
>> Btw, cx231xx has a similar issue: it has 3 buses. See how it was solved there:
>>
>> drivers/media/usb/cx231xx/cx231xx-core.c: cx231xx_i2c_register(&dev->i2c_bus[0]);
>> drivers/media/usb/cx231xx/cx231xx-core.c: cx231xx_i2c_register(&dev->i2c_bus[1]);
>> drivers/media/usb/cx231xx/cx231xx-core.c: cx231xx_i2c_register(&dev->i2c_bus[2]);
>>
>> Of course, the em28xx-cards will need to tell on what bus the tuner and
>> demods are. The em28xx I2C logic will also need to write to EM28XX_R06_I2C_CLK
>> if the bus is different - the windows driver is just stupid: it just precedes all
>> I2C writes by a write at reg 0x06 - we can certainly do better than that ;).
>>
>> If you're in doubt on how to do it, I can seek for some time to address it
>> properly.

See my previous mail concerning this.

> FYI, The other patches in this series are OK. I'm tagging them as
> changes_requested just because they depend on this one.

Ok, thanks.
These patches can wait until the VAD Laplace webcam is finally supported
(which I hope will be the case in a few weeks).
I don't expect this chip to appear in one of the devices with the
currently supported generic IDs.
What I'm trying to do is grouping ready patches and sending them as
smaller series to make reviewing easier.

Regards,
Frank

> Regards,
> Mauro

