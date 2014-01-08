Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:53149 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbaAHLzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:55:49 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ2003RFZT07960@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 06:55:48 -0500 (EST)
Date: Wed, 08 Jan 2014 09:55:43 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 17/22] [media] em28xx-i2c: Fix error code for I2C error
 transfers
Message-id: <20140108095543.1b9d0ba2@samsung.com>
In-reply-to: <52CC394D.3040700@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-18-git-send-email-m.chehab@samsung.com>
 <52C9C346.6040602@googlemail.com> <20140106075515.645ed96c@samsung.com>
 <52CC394D.3040700@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 07 Jan 2014 18:28:45 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 06.01.2014 10:55, schrieb Mauro Carvalho Chehab:
> > Em Sun, 05 Jan 2014 21:40:38 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> >>> The proper error code for I2C errors are EREMOTEIO. The em28xx driver
> >>> is using EIO instead.
> >>>
> >>> Replace all occurrences of EIO at em28xx-i2c, in order to fix it.
> >>>
> >>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >>> ---
> >>>  drivers/media/usb/em28xx/em28xx-i2c.c | 20 ++++++++++----------
> >>>  1 file changed, 10 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> >>> index 9fa7ed51e5b1..8b35aa51b9bb 100644
> >>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> >>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> >>> @@ -72,7 +72,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >>>  	if (ret != 2 + len) {
> >>>  		em28xx_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
> >>>  			    addr, ret);
> >>> -		return (ret < 0) ? ret : -EIO;
> >>> +		return (ret < 0) ? ret : -EREMOTEIO;
> >>>  	}
> >>>  	/* wait for completion */
> >>>  	while (time_is_after_jiffies(timeout)) {
> >>> @@ -91,7 +91,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >>>  		msleep(5);
> >>>  	}
> >>>  	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> >>> -	return -EIO;
> >>> +	return -EREMOTEIO;
> >>>  }
> >>>  
> >>>  /*
> >>> @@ -115,7 +115,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >>>  	if (ret != 2) {
> >>>  		em28xx_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
> >>>  			    addr, ret);
> >>> -		return (ret < 0) ? ret : -EIO;
> >>> +		return (ret < 0) ? ret : -EREMOTEIO;
> >>>  	}
> >>>  
> >>>  	/* wait for completion */
> >>> @@ -142,7 +142,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >>>  	if (ret != len) {
> >>>  		em28xx_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
> >>>  			    addr, ret);
> >>> -		return (ret < 0) ? ret : -EIO;
> >>> +		return (ret < 0) ? ret : -EREMOTEIO;
> >>>  	}
> >>>  	for (i = 0; i < len; i++)
> >>>  		buf[i] = buf2[len - 1 - i];
> >>> @@ -162,7 +162,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
> >>>  	ret = em2800_i2c_recv_bytes(dev, addr, &buf, 1);
> >>>  	if (ret == 1)
> >>>  		return 0;
> >>> -	return (ret < 0) ? ret : -EIO;
> >>> +	return (ret < 0) ? ret : -EREMOTEIO;
> >>>  }
> >>>  
> >>>  /*
> >>> @@ -191,7 +191,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >>>  		} else {
> >>>  			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
> >>>  				    len, addr, ret);
> >>> -			return -EIO;
> >>> +			return -EREMOTEIO;
> >>>  		}
> >>>  	}
> >>>  
> >>> @@ -219,7 +219,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >>>  	}
> >>>  
> >>>  	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> >>> -	return -EIO;
> >>> +	return -EREMOTEIO;
> >>>  }
> >>>  
> >>>  /*
> >>> @@ -268,7 +268,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >>>  	}
> >>>  
> >>>  	em28xx_warn("unknown i2c error (status=%i)\n", ret);
> >>> -	return -EIO;
> >>> +	return -EREMOTEIO;
> >>>  }
> >>>  
> >>>  /*
> >>> @@ -283,7 +283,7 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
> >>>  	ret = em28xx_i2c_recv_bytes(dev, addr, &buf, 1);
> >>>  	if (ret == 1)
> >>>  		return 0;
> >>> -	return (ret < 0) ? ret : -EIO;
> >>> +	return (ret < 0) ? ret : -EREMOTEIO;
> >>>  }
> >>>  
> >>>  /*
> >>> @@ -312,7 +312,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >>>  		} else {
> >>>  			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
> >>>  				    len, addr, ret);
> >>> -			return -EIO;
> >>> +			return -EREMOTEIO;
> >>>  		}
> >>>  	}
> >>>  	/* Check success */
> >> Why the hell -EREMOTEIO ???
> >> See Documentation/i2c/fault-codes.
> >> It's not even listed there !
> >> What are you trying to fix here ?
> > This is not a fixup patch.
> >
> > The idea of this path is to make em28xx more compliant with the Kernel
> > error codes. 
> >
> > As em28xx was the first USB media driver, it doesn't follow the best 
> > standards, despite all efforts we've made back in 2005, when the driver
> > was merged, in order to follow the Kernel rules. We eventually fixed
> > several things along the time, but we didn't took much care to fix the
> > I2C error codes so far.
> >
> > Now that we're taking care of it, we should do it right.
> >
> > However, you're actually right here.
> >
> > Before 2011, all I2C drivers under drivers/i2c used to return EREMOTEIO,
> > and the media drivers were moving to this error code since then.
> Ok, that explains it.
> 
> > But it seems that we missed a series of patches that moved I2C away from
> > EREMOTEIO:
> > 	http://www.spinics.net/lists/linux-i2c/msg06395.html
> > 	https://www.mail-archive.com/linux-i2c@vger.kernel.org/msg04819.html
> >
> > I'll rewrite this patch to return the right error codes, according with
> > Documentation/i2c/fault-codes.
> >
> > It seems that the proper return codes are:
> >
> > 	- ETIMEDOUT - when reg 05 returns 0x10
> I still don't agree here.
> AFAICS an I2C timeout can only happen if clock stretching is used.

It can also happen if the I2C gate is closed, for example, or when
a device is not powered.

This is likely the most common error when someone didn't properly
mapped the GPIOs for switching to analog mode or to digital mode.

> But we also get this when a slave device isn't present or doesn't
> answer, which means it doesn't ACK the data.
> So ETIMEDOUT is wrong.

It is still a timeout: the device didn't answer in time.

> Yes, 0x10 _could_ be a more general error. In that case EIO would be the
> better choice.
> But that's pure speculation as long as we don't have the datasheets.

The datasheet will not tell what are the corresponding Linux error codes.

ETIMEDOUT is better than the generic unspecific EIO.

> After reading the i2c fault codes descriptions again, I would agree to
> change it from ENODEV to ENXIO.
> ENXIO seems to be the intended error code for NACK errors and it's a bit
> more unspecific than ENODEV.
> 
> Would that be acceptable for you ?

Yes.

> > 	- ENXIO - when the device is not temporarily not responding
> > 		  (e. g. reg 05 returning something not 0x10 or 0x00)
> For those I would return just EIO.
> I thought we agree here ?

No. With em28xx/xc3028/tvp5150, we've got some temporary not responding
errors with return code 0x02 or 0x04, before fixing that xc3028 power down
bug.

What I suspect is that codes 0x02 and 0x04 are related to I2C stretching,
and that's why they need to be retried up to a software given timeout.

I prefer to use EIO only when we got an error while writing to reg 0x04
or when the read operation didn't return the number of requested bytes.

So, the better seems to return ETIMEDOUT for return codes different
than 0x00/0x10/0x20.

> 
> > 	- EBUSY - when reg 05 returns 0x20 on em2874 and upper [1]
> Yes, that's ok
> 
> > 	- EIO - for generic I/O errors that don't fit into the above.
> I'm not sure what you mean with "generic", but yeah, that's ok, too.
> 
> > [1] According with a post that Devin made on IRC sometime ago, bit 5
> > indicates that the I2C is busy when the master tries to use it, but it
> > exists only on em2874 (and likely newer chips).
> Can give me a pointer to this post ?

Unfortunately, the IRC logs weren't working on May, 27.

If you agree with this proposal, I'll rewrite 
https://patchwork.linuxtv.org/patch/21481/ accordingly.

Regards,
Mauro
