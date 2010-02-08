Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:39994 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab0BHRa7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 12:30:59 -0500
Message-ID: <4B704A2D.5000100@arcor.de>
Date: Mon, 08 Feb 2010 18:30:21 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 5/12] tm6000: update init table and sequence for tm6010
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de> <4B6FF3C9.2010804@redhat.com>
In-Reply-To: <4B6FF3C9.2010804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.02.2010 12:21, schrieb Mauro Carvalho Chehab:
> Hi Stefan,
>
> First, a few comments about your patch series:
>
> I've committed almost of your patches, and added an extra patch to make the
> driver to compile it with -git. There were other broken things when compiling
> against -git.
>
> Several of your patches are adding leading whitespaces. Please review them before
> submitting. On -git, those whitespaces are shown with a red background color.
>
> I've re-made most of the patch descriptions. Please take a look on them and try
> to improve on a next time.
>
> We've got 2 submission for each patches. I just discarded the older one.
>
> I've removed the two BEHOLDER board descriptions from one of your patches. It is
> not related to your board, but it is another compilation fix.
>
> From your series, I didn't merge those 3 patches:
>
> [5/12] tm6000: update init table and sequence for tm6010                http://patchwork.kernel.org/patch/77451
> [6/12] tm6000: tuner reset timeing optimation                           http://patchwork.kernel.org/patch/77459
> [11/12] tm6000: bugfix firmware xc3028L-v36.fw used with Zarlink and    http://patchwork.kernel.org/patch/77462
>
> I'll send you separate comments why I didn't merge them, in reply to each email you've sent,
> starting with this one (patch 5/12).
>
>
> stefan.ringel@arcor.de wrote:
>   
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> ---
>>  drivers/staging/tm6000/tm6000-core.c |  179 ++++++++++++++++++++++++----------
>>  1 files changed, 128 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
>> index 7ec13d5..a2e2af5 100644
>> --- a/drivers/staging/tm6000/tm6000-core.c
>> +++ b/drivers/staging/tm6000/tm6000-core.c
>> @@ -414,7 +414,15 @@ struct reg_init tm6010_init_tab[] = {
>>  	{ REQ_07_SET_GET_AVREG, 0x3f, 0x00 },
>>  
>>  	{ REQ_05_SET_GET_USBREG, 0x18, 0x00 },
>> -
>> +	
>> +	/* additional from Terratec Cinergy Hybrid XE */
>> +	{ REQ_07_SET_GET_AVREG, 0xdc, 0xaa },
>> +	{ REQ_07_SET_GET_AVREG, 0xdd, 0x30 },
>> +	{ REQ_07_SET_GET_AVREG, 0xde, 0x20 },
>> +	{ REQ_07_SET_GET_AVREG, 0xdf, 0xd0 },
>> +	{ REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
>> +	{ REQ_07_SET_GET_AVREG, 0xd8, 0x2f },
>> +	
>>  	/* set remote wakeup key:any key wakeup */
>>  	{ REQ_07_SET_GET_AVREG,  0xe5,  0xfe },
>>  	{ REQ_07_SET_GET_AVREG,  0xda,  0xff },
>> @@ -424,6 +432,7 @@ int tm6000_init (struct tm6000_core *dev)
>>  {
>>  	int board, rc=0, i, size;
>>  	struct reg_init *tab;
>> +	u8 buf[40];
>>  
>>  	if (dev->dev_type == TM6010) {
>>  		tab = tm6010_init_tab;
>> @@ -444,61 +453,129 @@ int tm6000_init (struct tm6000_core *dev)
>>  		}
>>  	}
>>  
>> -	msleep(5); /* Just to be conservative */
>> -
>> -	/* Check board version - maybe 10Moons specific */
>> -	board=tm6000_get_reg16 (dev, 0x40, 0, 0);
>> -	if (board >=0) {
>> -		printk (KERN_INFO "Board version = 0x%04x\n",board);
>> -	} else {
>> -		printk (KERN_ERR "Error %i while retrieving board version\n",board);
>> -	}
>> -
>> +	/* hack */
>>  	if (dev->dev_type == TM6010) {
>> -		/* Turn xceive 3028 on */
>> -		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
>> -		msleep(11);
>> -	}
>>     
> The above is board-specific. It is needed for the tm6010 device I have here
> (HVR900H), otherwise no xc3028 command will be handled.
>
> The better here is to add a setup routine to tm6000-cards and move all 
> those GPIO codes to it. Then, add there your board-specific setup.
>
> I've added a patch that moves those GPIO board-specific setup to tm6000-cards:
> tm6000_cards_setup(). Please move your board specific GPIO init to there.
>
>
>   
>> -
>> -	/* Reset GPIO1 and GPIO4. */
>> -	for (i=0; i< 2; i++) {
>> -		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> -					dev->tuner_reset_gpio, 0x00);
>> -		if (rc<0) {
>> -			printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
>> -			return rc;
>> -		}
>> -
>> -		msleep(10); /* Just to be conservative */
>> -		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> -					dev->tuner_reset_gpio, 0x01);
>> -		if (rc<0) {
>> -			printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
>> -			return rc;
>> -		}
>> -
>> -		msleep(10);
>> -		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
>> -		if (rc<0) {
>> -			printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
>> -			return rc;
>> -		}
>> -
>> -		msleep(10);
>> -		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
>> -		if (rc<0) {
>> -			printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
>> -			return rc;
>> -		}
>> -
>> -		if (!i) {
>> -			rc=tm6000_get_reg16(dev, 0x40,0,0);
>> -			if (rc>=0) {
>> -				printk ("board=%d\n", rc);
>> +		
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_4, 0);
>> +		msleep(15);
>> +				
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_1, 0);
>> +	
>> +		msleep(50);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_1, 1);
>> +		
>>     
> The above reflects the timing needed by your device. Depending on the board,
> the sleep time may eventually be different.
>
>   
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x0010, 0x4400, buf, 2);
>> +		
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
>> +	
>> +		msleep(15);
>> +		buf[0] = 0x12;
>> +		buf[1] = 0x34;
>> +		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf432, 0x0000, buf, 2);
>> +	
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
>> +	
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x0032, 0x0000, buf, 2);
>> +
>> +		msleep(15);
>> +		buf[0] = 0x00;
>> +		buf[1] = 0x01;
>> +		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
>> +	
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x00c0, 0x0000, buf, 39);
>> +	
>> +		msleep(15);
>> +		buf[0] = 0x00;
>> +		buf[1] = 0x00;
>> +		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
>> +	
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x7f1f, 0x0000, buf, 2);
>> +//		printk(KERN_INFO "buf %#x %#x \n", buf[0], buf [1]);
>> +		msleep(15);
>>     
>
> At the above, you're just trying to reproduce whatever the original driver does,
> instead of relying on the i2c drivers.
>
> At the Linux drivers, we don't just send random i2c sequences in the middle of
> the setup. Instead, we let each i2c driver to do the initialization they need
> to do. 
>
> If you take a look on each call, for example:
> 		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
>
> The first value determines the USB direction: 0x40 is write; 0xc0 is read;
> The second value is the request. Both 0x0e (REQ_14) and 0x10 (REQ_16) are used for
> i2c. From the past experiences, REQ_16 works better when the size is 1, where REQ_14
> works better for bigger sizes.
>
> The third value gives the first byte of a write message and the i2c address. The lower
> 8 bits is the i2c address. The above sequence is playing with several different 
> i2c devices, at addresses 0x10, 0x32, 0xc0 and 0x1f.
>
> Most of the calls there are read (0xc0). I don't know any device that requires
> a read for it to work. I suspect that the above code is just probing to check
> what i2c devices are found at the board. The writes are to a device at address
> 0x32 (in i2c 8 bit notation - or 0x19 at i2c 7bit notation).
>
> I suspect that the probe sequence noticed something at the address 0x32 and is
> sending some init sequence for it. As this is not the tuner nor the demod, you
> don't need those setup for your device to work. Also, this address is not typical
> for eeprom. Without taking a look at the hardware, we can only guess what's there.
> My guess is that it is for some i2c-based remote controller chip. We don't need
> this for now. After having the rest working, we may need to return on it when
> patching ir-kbd.i2c.
>
>   
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_4, 1);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +	    			TM6010_GPIO_0, 1);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_7, 0);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_5, 1);
>> +	
>> +		msleep(15);
>> +	
>> +		for (i=0; i< size; i++) {
>> +			rc= tm6000_set_reg (dev, tab[i].req, tab[i].reg, tab[i].val);
>> +			if (rc<0) {
>> +				printk (KERN_ERR "Error %i while setting req %d, "
>> +						 "reg %d to value %d\n", rc,
>> +						 tab[i].req,tab[i].reg, tab[i].val);
>> +				return rc;
>>  			}
>>  		}
>> +			
>> +		msleep(15);
>> +	
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_4, 0);
>> +		msleep(15);
>> +
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_1, 0);
>> +	
>> +		msleep(50);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_1, 1);
>> +		
>> +		msleep(15);
>> +		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
>> +//		printk(KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_2, 1);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_2, 0);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_2, 1);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_2, 1);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_2, 0);
>> +		msleep(15);
>> +		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> +				TM6010_GPIO_2, 1);
>> +		msleep(15);
>>  	}
>> +	/* hack end 
>>     
> The above sequence is device-specific. Please add your code after I patch
> tm6000-cards.
>
> */
>   
>> +	
>> +	msleep(5); /* Just to be conservative */
>>  
>> +	/* Check board version - maybe 10Moons specific */
>> +	if (dev->dev_type == TM5600) {
>> +		 board=tm6000_get_reg16 (dev, 0x40, 0, 0);
>> +		if (board >=0) {
>> +			printk (KERN_INFO "Board version = 0x%04x\n",board);
>> +		} else {
>> +			printk (KERN_ERR "Error %i while retrieving board version\n",board);
>> +		}
>> +	}
>> +	
>>  	msleep(50);
>>  
>>  	return 0;
>>     
>
>   

I have a question, how can I implemented the reinit after activating
demodulator when it use tm6000_cards_setup().

-- 
Stefan Ringel <stefan.ringel@arcor.de>

