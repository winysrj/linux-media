Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56964 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaAGR1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:27:38 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so210356eek.36
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 09:27:37 -0800 (PST)
Message-ID: <52CC394D.3040700@googlemail.com>
Date: Tue, 07 Jan 2014 18:28:45 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 17/22] [media] em28xx-i2c: Fix error code for I2C error
 transfers
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-18-git-send-email-m.chehab@samsung.com> <52C9C346.6040602@googlemail.com> <20140106075515.645ed96c@samsung.com>
In-Reply-To: <20140106075515.645ed96c@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.01.2014 10:55, schrieb Mauro Carvalho Chehab:
> Em Sun, 05 Jan 2014 21:40:38 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
>>> The proper error code for I2C errors are EREMOTEIO. The em28xx driver
>>> is using EIO instead.
>>>
>>> Replace all occurrences of EIO at em28xx-i2c, in order to fix it.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>> ---
>>>  drivers/media/usb/em28xx/em28xx-i2c.c | 20 ++++++++++----------
>>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> index 9fa7ed51e5b1..8b35aa51b9bb 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> @@ -72,7 +72,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>  	if (ret != 2 + len) {
>>>  		em28xx_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
>>>  			    addr, ret);
>>> -		return (ret < 0) ? ret : -EIO;
>>> +		return (ret < 0) ? ret : -EREMOTEIO;
>>>  	}
>>>  	/* wait for completion */
>>>  	while (time_is_after_jiffies(timeout)) {
>>> @@ -91,7 +91,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>  		msleep(5);
>>>  	}
>>>  	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
>>> -	return -EIO;
>>> +	return -EREMOTEIO;
>>>  }
>>>  
>>>  /*
>>> @@ -115,7 +115,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>  	if (ret != 2) {
>>>  		em28xx_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
>>>  			    addr, ret);
>>> -		return (ret < 0) ? ret : -EIO;
>>> +		return (ret < 0) ? ret : -EREMOTEIO;
>>>  	}
>>>  
>>>  	/* wait for completion */
>>> @@ -142,7 +142,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>  	if (ret != len) {
>>>  		em28xx_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
>>>  			    addr, ret);
>>> -		return (ret < 0) ? ret : -EIO;
>>> +		return (ret < 0) ? ret : -EREMOTEIO;
>>>  	}
>>>  	for (i = 0; i < len; i++)
>>>  		buf[i] = buf2[len - 1 - i];
>>> @@ -162,7 +162,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
>>>  	ret = em2800_i2c_recv_bytes(dev, addr, &buf, 1);
>>>  	if (ret == 1)
>>>  		return 0;
>>> -	return (ret < 0) ? ret : -EIO;
>>> +	return (ret < 0) ? ret : -EREMOTEIO;
>>>  }
>>>  
>>>  /*
>>> @@ -191,7 +191,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>>>  		} else {
>>>  			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
>>>  				    len, addr, ret);
>>> -			return -EIO;
>>> +			return -EREMOTEIO;
>>>  		}
>>>  	}
>>>  
>>> @@ -219,7 +219,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>>>  	}
>>>  
>>>  	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
>>> -	return -EIO;
>>> +	return -EREMOTEIO;
>>>  }
>>>  
>>>  /*
>>> @@ -268,7 +268,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
>>>  	}
>>>  
>>>  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
>>> -	return -EIO;
>>> +	return -EREMOTEIO;
>>>  }
>>>  
>>>  /*
>>> @@ -283,7 +283,7 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
>>>  	ret = em28xx_i2c_recv_bytes(dev, addr, &buf, 1);
>>>  	if (ret == 1)
>>>  		return 0;
>>> -	return (ret < 0) ? ret : -EIO;
>>> +	return (ret < 0) ? ret : -EREMOTEIO;
>>>  }
>>>  
>>>  /*
>>> @@ -312,7 +312,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>>>  		} else {
>>>  			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
>>>  				    len, addr, ret);
>>> -			return -EIO;
>>> +			return -EREMOTEIO;
>>>  		}
>>>  	}
>>>  	/* Check success */
>> Why the hell -EREMOTEIO ???
>> See Documentation/i2c/fault-codes.
>> It's not even listed there !
>> What are you trying to fix here ?
> This is not a fixup patch.
>
> The idea of this path is to make em28xx more compliant with the Kernel
> error codes. 
>
> As em28xx was the first USB media driver, it doesn't follow the best 
> standards, despite all efforts we've made back in 2005, when the driver
> was merged, in order to follow the Kernel rules. We eventually fixed
> several things along the time, but we didn't took much care to fix the
> I2C error codes so far.
>
> Now that we're taking care of it, we should do it right.
>
> However, you're actually right here.
>
> Before 2011, all I2C drivers under drivers/i2c used to return EREMOTEIO,
> and the media drivers were moving to this error code since then.
Ok, that explains it.

> But it seems that we missed a series of patches that moved I2C away from
> EREMOTEIO:
> 	http://www.spinics.net/lists/linux-i2c/msg06395.html
> 	https://www.mail-archive.com/linux-i2c@vger.kernel.org/msg04819.html
>
> I'll rewrite this patch to return the right error codes, according with
> Documentation/i2c/fault-codes.
>
> It seems that the proper return codes are:
>
> 	- ETIMEDOUT - when reg 05 returns 0x10
I still don't agree here.
AFAICS an I2C timeout can only happen if clock stretching is used.
But we also get this when a slave device isn't present or doesn't
answer, which means it doesn't ACK the data.
So ETIMEDOUT is wrong.
Yes, 0x10 _could_ be a more general error. In that case EIO would be the
better choice.
But that's pure speculation as long as we don't have the datasheets.

After reading the i2c fault codes descriptions again, I would agree to
change it from ENODEV to ENXIO.
ENXIO seems to be the intended error code for NACK errors and it's a bit
more unspecific than ENODEV.

Would that be acceptable for you ?

> 	- ENXIO - when the device is not temporarily not responding
> 		  (e. g. reg 05 returning something not 0x10 or 0x00)
For those I would return just EIO.
I thought we agree here ?

> 	- EBUSY - when reg 05 returns 0x20 on em2874 and upper [1]
Yes, that's ok

> 	- EIO - for generic I/O errors that don't fit into the above.
I'm not sure what you mean with "generic", but yeah, that's ok, too.

> [1] According with a post that Devin made on IRC sometime ago, bit 5
> indicates that the I2C is busy when the master tries to use it, but it
> exists only on em2874 (and likely newer chips).
Can give me a pointer to this post ?

Regards,
Frank

> Cheers,
> Mauro

