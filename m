Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:36895 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347Ab0BBQPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 11:15:07 -0500
Message-ID: <4B684F6A.6010902@arcor.de>
Date: Tue, 02 Feb 2010 17:14:34 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] - tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de>	 <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>	 <4B67464B.3020801@arcor.de> <829197381002011344g1c640c4fufa057071b8527d55@mail.gmail.com> <4B674EF9.3020800@arcor.de> <4B675E52.5040306@redhat.com>
In-Reply-To: <4B675E52.5040306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.02.2010 00:05, schrieb Mauro Carvalho Chehab:
> Stefan Ringel wrote:
>   
>> Am 01.02.2010 22:44, schrieb Devin Heitmueller:
>>     
>>> On Mon, Feb 1, 2010 at 4:23 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>>>   
>>>       
>>>>> You should start by breaking it down into a patch series, so that the
>>>>> incremental changes can be reviewed.  That will allow you to explain
>>>>> in the patch descriptions why all the individual changes you have made
>>>>> are required.
>>>>>
>>>>>
>>>>>       
>>>>>           
>>>> how can I generate it?
>>>>     
>>>>         
>>> You can use quilt to break it up into a patch series, or create a
>>> local hg clone of v4l-dvb.
>>>
>>>   
>>>       
>>>>> Why did you define a new callback for changing the tuner mode?  We
>>>>> have successfully provided infrastructure on other bridges to toggle
>>>>> GPIOs when changing modes.  For example, the em28xx has fields in the
>>>>> board profile that allow you to toggle GPIOs when going back and forth
>>>>> between digital and analog mode.
>>>>>
>>>>>
>>>>>       
>>>>>           
>>>> I don't know, how you mean it. I'm amateur programmer.
>>>>     
>>>>         
>>> Look at how the ".dvb_gpio" and ".gpio" fields are used in the board
>>> profiles in em28xx-cards.c.  We toggle the GPIOs when switching the
>>> from analog to digital mode, without the tuner having to do any sort
>>> of callback.
>>>
>>>   
>>>       
>> It's a bad example. em28xx use a reg-set, but tm6000 not !! It use a
>> gpio usb request.
>>
>> tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_5, 1);
>>
>>
>> I don't know, that it with the ".gpio" fields works. And when it switch
>> from analog to digital, I don't see the way.
>>     
> All devices with Xceive tuners need to reset the chip via GPIO, in order to load
> the firmware. On em28xx, I wrote a patch that moved all specific init code to
> a struct (basically used by gpio's), and a generic code to do the reset. It basically
> contains what GPIO pins are used, and how many time it should wait.
>
> For example:
>
> /* Board Hauppauge WinTV HVR 900 digital */
> static struct em28xx_reg_seq hauppauge_wintv_hvr_900_digital[] = {
>         {EM28XX_R08_GPIO,       0x2e,   ~EM_GPIO_4,     10},
>         {EM2880_R04_GPO,        0x04,   0x0f,           10},
>         {EM2880_R04_GPO,        0x0c,   0x0f,           10},
>         { -1,                   -1,     -1,             -1},
> };
>
> The first line of the above code will execute this logic:
> 	a = read(EM28XXR08_GPIO) & ~0x2e;
> 	write (a & ~EM_GPIO_4);
> 	msleep(10);
>
>
> So, it will basically preserve bits 8,7,6,4 and 1 of register 8,
> and will clear bit 4 (EM_GPIO_4 is 1 << 4 - e. g. bit 4).
> After that, it will sleep for 10 miliseconds, and will then do a
> reset on bit 3 of Register 4 (writing 0, then 1 to the bit).
>   

reset example :

static struct tm6010_seq terratec[] = {
            {TM6010_GPIO_2,    1,    60},  /* GPIO 2 going to high */
            {TM6010_GPIO_2,    0,    75},  /* GPIO 2 going to lo */
            {TM6010_GPIO_2,    1,    60},  /* GPIO 2 going to high */
            { -1         ,    -1,    -1},
}

Is that correct?


>>     
>>>>> What function does the "tm6000" member in the zl10353 config do?  It
>>>>> doesn't seem to be used anywhere.
>>>>>
>>>>>
>>>>>       
>>>>>           
>>>> I'll switch it next week to demodulator module.
>>>>     
>>>>         
>>> Are you saying the zl10353 isn't working right now in your patch?  I'm
>>> a bit confused.  If it doesn't work, then your patch title is a bit
>>> misleading since it suggests that your patch provides DVB support for
>>> the tm6000.  If it does work, then the tm6000 member shouldn't be
>>> needed at all in the zl10353 config.
>>>
>>>   
>>>       
>> I'm emulating it in hack.c and the zl10353 module doesn't work, if I
>> switch to it.
>>     
> the hack.c needs to be validated against the zl10353, in order to identify
> what are the exact needs for tm6000. Some devices require serial mode, while
> others require parallel mode.
>
> I bet that playing with zl10353_config, we'll find the proper init values 
> required by tm6000.
>
>   

I have separately write in the hack.c the value from terratec hybrid
stick. The older value I haven't clean.

-- 
Stefan Ringel <stefan.ringel@arcor.de>

