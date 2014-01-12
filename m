Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38205 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALP0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 10:26:25 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so2725065eek.40
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 07:26:24 -0800 (PST)
Message-ID: <52D2B467.7040201@googlemail.com>
Date: Sun, 12 Jan 2014 16:27:35 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 2/3] [media] em28xx: cleanup I2C debug messages
References: <1389342820-12605-1-git-send-email-m.chehab@samsung.com> <1389342820-12605-3-git-send-email-m.chehab@samsung.com> <52D14298.1030503@googlemail.com> <20140111182244.2eb105f3@samsung.com>
In-Reply-To: <20140111182244.2eb105f3@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.01.2014 21:22, Mauro Carvalho Chehab wrote:
> Em Sat, 11 Jan 2014 14:09:44 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 10.01.2014 09:33, schrieb Mauro Carvalho Chehab:
>>> The I2C output messages is too polluted. Clean it a little
>>> bit, by:
>>> 	- use the proper core support for memory dumps;
>>> 	- hide most stuff under the i2c_debug umbrella;
>>> 	- add the missing KERN_CONT where needed;
>>> 	- use 2 levels or verbosity. Only the second one
>>> 	  will show the I2C transfer data.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>> ---
>>>   drivers/media/usb/em28xx/em28xx-i2c.c | 84 ++++++++++++++++++-----------------
>>>   1 file changed, 44 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> index 76f956635bd9..e8eb83160d36 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> @@ -41,7 +41,7 @@ MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
>>>   
>>>   static unsigned int i2c_debug;
>>>   module_param(i2c_debug, int, 0644);
>>> -MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
>>> +MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I2C transfers)");
>>>   
>>>   /*
>>>    * em2800_i2c_send_bytes()
>>> @@ -89,7 +89,8 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>   		}
>>>   		msleep(5);
>>>   	}
>>> -	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
>>> +	if (i2c_debug)
>>> +		em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
>>>   	return -ETIMEDOUT;
>>>   }
>>>   
>>> @@ -132,8 +133,11 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>   		}
>>>   		msleep(5);
>>>   	}
>>> -	if (ret != 0x84 + len - 1)
>>> -		em28xx_warn("read from i2c device at 0x%x timed out\n", addr);
>>> +	if (ret != 0x84 + len - 1) {
>>> +		if (i2c_debug)
>>> +			em28xx_warn("read from i2c device at 0x%x timed out\n",
>>> +				    addr);
>>> +	}
>>>   
>>>   	/* get the received message */
>>>   	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
>>> @@ -213,7 +217,9 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>>>   		 * (even with high payload) ...
>>>   		 */
>>>   	}
>>> -	em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n", addr, ret);
>>> +	if (i2c_debug)
>>> +		em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
>>> +			    addr, ret);
>>>   	return -ETIMEDOUT;
>>>   }
>>>   
>>> @@ -409,10 +415,6 @@ static inline int i2c_check_for_device(struct em28xx_i2c_bus *i2c_bus, u16 addr)
>>>   		rc = em2800_i2c_check_for_device(dev, addr);
>>>   	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
>>>   		rc = em25xx_bus_B_check_for_device(dev, addr);
>>> -	if (rc == -ENXIO) {
>>> -		if (i2c_debug)
>>> -			printk(" no device\n");
>>> -	}
>>>   	return rc;
>>>   }
>>>   
>>> @@ -421,7 +423,7 @@ static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
>>>   {
>>>   	struct em28xx *dev = i2c_bus->dev;
>>>   	u16 addr = msg.addr << 1;
>>> -	int byte, rc = -EOPNOTSUPP;
>>> +	int rc = -EOPNOTSUPP;
>>>   
>>>   	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
>>>   		rc = em28xx_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
>>> @@ -429,10 +431,6 @@ static inline int i2c_recv_bytes(struct em28xx_i2c_bus *i2c_bus,
>>>   		rc = em2800_i2c_recv_bytes(dev, addr, msg.buf, msg.len);
>>>   	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM25XX_BUS_B)
>>>   		rc = em25xx_bus_B_recv_bytes(dev, addr, msg.buf, msg.len);
>>> -	if (i2c_debug) {
>>> -		for (byte = 0; byte < msg.len; byte++)
>>> -			printk(" %02x", msg.buf[byte]);
>>> -	}
>>>   	return rc;
>>>   }
>>>   
>>> @@ -441,12 +439,8 @@ static inline int i2c_send_bytes(struct em28xx_i2c_bus *i2c_bus,
>>>   {
>>>   	struct em28xx *dev = i2c_bus->dev;
>>>   	u16 addr = msg.addr << 1;
>>> -	int byte, rc = -EOPNOTSUPP;
>>> +	int rc = -EOPNOTSUPP;
>>>   
>>> -	if (i2c_debug) {
>>> -		for (byte = 0; byte < msg.len; byte++)
>>> -			printk(" %02x", msg.buf[byte]);
>>> -	}
>>>   	if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM28XX)
>>>   		rc = em28xx_i2c_send_bytes(dev, addr, msg.buf, msg.len, stop);
>>>   	else if (i2c_bus->algo_type == EM28XX_I2C_ALGO_EM2800)
>>> @@ -491,7 +485,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>   	}
>>>   	for (i = 0; i < num; i++) {
>>>   		addr = msgs[i].addr << 1;
>>> -		if (i2c_debug)
>>> +		if (i2c_debug > 1)
>>>   			printk(KERN_DEBUG "%s at %s: %s %s addr=%02x len=%d:",
>>>   			       dev->name, __func__ ,
>>>   			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
>>> @@ -503,25 +497,41 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>   			 * This code is only called during device probe.
>>>   			 */
>>>   			rc = i2c_check_for_device(i2c_bus, addr);
>>> -			if (rc == -ENXIO) {
>>> +			if (rc < 0) {
>>> +				if (rc == -ENXIO) {
>>> +					if (i2c_debug > 1)
>>> +						printk(KERN_CONT " no device\n");
>>> +					rc = -ENODEV;
>>> +				} else {
>>> +					if (i2c_debug > 1)
>>> +						printk(KERN_CONT " ERROR: %i\n", rc);
>>> +				}
>> This introduces unnecessary double warnings.
> Again, this is called only during device probing time. The "no device" message
> should be the expected one, for an error there, if probing at the wrong I2C
> address.
>
> However, a different error code there likely means a bug at the driver
> (too short timeouts, lack of a msleep(), ...).
???
Why do you want to warn twice about the same error ?

>
>>
>>>   				rt_mutex_unlock(&dev->i2c_bus_lock);
>>> -				return -ENODEV;
>>> +				return rc;
>>>   			}
>>>   		} else if (msgs[i].flags & I2C_M_RD) {
>>>   			/* read bytes */
>>>   			rc = i2c_recv_bytes(i2c_bus, msgs[i]);
>>> +
>>> +			if (i2c_debug > 1 && rc >= 0)
>>> +				printk(KERN_CONT " %*ph",
>>> +				       msgs[i].len, msgs[i].buf);
>>>   		} else {
>>> +			if (i2c_debug > 1)
>>> +				printk(KERN_CONT " %*ph",
>>> +				       msgs[i].len, msgs[i].buf);
>>> +
>>>   			/* write bytes */
>>>   			rc = i2c_send_bytes(i2c_bus, msgs[i], i == num - 1);
>>>   		}
>>>   		if (rc < 0) {
>>> -			if (i2c_debug)
>>> -				printk(" ERROR: %i\n", rc);
>>> +			if (i2c_debug > 1)
>>> +				printk(KERN_CONT " ERROR: %i\n", rc);
>>>   			rt_mutex_unlock(&dev->i2c_bus_lock);
>>>   			return rc;
>>>   		}
>>> -		if (i2c_debug)
>>> -			printk("\n");
>>> +		if (i2c_debug > 1)
>>> +			printk(KERN_CONT "\n");
>>>   	}
>>>   
>>>   	rt_mutex_unlock(&dev->i2c_bus_lock);
>> I've been thinking about this for a while again and why we decided to
>> clean-up / remove the i2c_debug levels 1 year ago.
>> The idea was, that any errors except -ENXIO are unusal and should always
>> be be printed to the system log.
>> As a result, there was no longer a need for three i2c_debug levels.
>> The current levels are
>> i2c_debug = 0: warn on real/severe i2c errors
>> i2c_debug = 1: also print debug messages about -ENXIO errorr, display
>> the whole i2c traffic (messages)
>>
>> What do you think, isn't that still sane ?
> I don't think so. Well, for sure the highest log level should be to
> show all I2C traffic, but, as we're not displaying part of the I2C
> errors at the logs anymore, we need an intermediate level.
...
>
>> The question is now, what to do with clock stretching timeouts.
>> I would keep them at level 0, too, because it's an error that should not
>> occur and needs to fixed.
> I think we should either show all I2C errors or hide everything.
>
> It should be noticed that the I2C client drivers will likely show the
> same errors there. So, those logs are actually a way to get more
> details of the errors.
Ok, at this point I'm changing my mind.
I2c errors should indeed not be reported by both, the adapter and the 
client (at least with debug disabled).
So the actual question here is, who should display them, the i2c adapter 
or the client driver ?
The arguments are the same as with the "automatic retries by the i2c 
adapter - yes or no ?" question,
so I think it should be up to the client drivers to decide whether or 
not an error is normal or critical and if it should be printed to the 
syslog.

Hence, 3 debug levels make sense. :)

>
>> Another thing you're doing with this patch is to move the debugging code
>> from
>> i2c_check_for_device(), i2c_recv_device() and i2c_send_device() back to
>> to em28xx_i2c_xfer().
>> I have nothing against that, although I think we had decided to do this
>> opposite in the past.
>> IIRC, the main reason was to reduce the size of em28xx_i2c_xfer(). And I
>> think there was also an output formatting reason...
> It is complex to analyze the KERNEL_CONT messages if they're not at the
> same function. That's why I decided to move them back.
>
>> So IMHO, the only thing which should be changed here is to add the
>> missing KERN_CONT prefix.
>>
>>> @@ -604,7 +614,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>>>   	 * calculation and returned device dataset. Simplifies the code a lot,
>>>   	 * but we might have to deal with multiple sizes in the future !
>>>   	 */
>>> -	int i, err;
>>> +	int err;
>>>   	struct em28xx_eeprom *dev_config;
>>>   	u8 buf, *data;
>>>   
>>> @@ -635,20 +645,14 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>>>   		goto error;
>>>   	}
>>>   
>>> -	/* Display eeprom content */
>>> -	for (i = 0; i < len; i++) {
>>> -		if (0 == (i % 16)) {
>>> -			if (dev->eeprom_addrwidth_16bit)
>>> -				em28xx_info("i2c eeprom %04x:", i);
>>> -			else
>>> -				em28xx_info("i2c eeprom %02x:", i);
>>> -		}
>>> -		printk(" %02x", data[i]);
>>> -		if (15 == (i % 16))
>>> -			printk("\n");
>>> +	if (i2c_debug) {
>>> +		/* Display eeprom content */
>>> +		print_hex_dump(KERN_INFO, "eeprom ", DUMP_PREFIX_OFFSET,
>>> +			       16, 1, data, len, true);
>>> +
>>> +		if (dev->eeprom_addrwidth_16bit)
>>> +			em28xx_info("eeprom %06x: ... (skipped)\n", 256);
>> That's a good change.
>>
>>>   	}
>>> -	if (dev->eeprom_addrwidth_16bit)
>>> -		em28xx_info("i2c eeprom %04x: ... (skipped)\n", i);
>> The idea here was to signal that 16 bit eeproms are larger than 256 Bytes.
>> So you may want to keep this line.
> This log is already on the previous change.
Yes, beat me ! Sorry for the noise.

>
>>>   
>>>   	if (dev->eeprom_addrwidth_16bit &&
>>>   	    data[0] == 0x26 && data[3] == 0x00) {
>

