Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:35775 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033Ab0BAWA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 17:00:59 -0500
Message-ID: <4B674EF9.3020800@arcor.de>
Date: Mon, 01 Feb 2010 23:00:25 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] - tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de>	 <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>	 <4B67464B.3020801@arcor.de> <829197381002011344g1c640c4fufa057071b8527d55@mail.gmail.com>
In-Reply-To: <829197381002011344g1c640c4fufa057071b8527d55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.02.2010 22:44, schrieb Devin Heitmueller:
> On Mon, Feb 1, 2010 at 4:23 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>   
>>> You should start by breaking it down into a patch series, so that the
>>> incremental changes can be reviewed.  That will allow you to explain
>>> in the patch descriptions why all the individual changes you have made
>>> are required.
>>>
>>>
>>>       
>> how can I generate it?
>>     
> You can use quilt to break it up into a patch series, or create a
> local hg clone of v4l-dvb.
>
>   
>>> Why did you define a new callback for changing the tuner mode?  We
>>> have successfully provided infrastructure on other bridges to toggle
>>> GPIOs when changing modes.  For example, the em28xx has fields in the
>>> board profile that allow you to toggle GPIOs when going back and forth
>>> between digital and analog mode.
>>>
>>>
>>>       
>> I don't know, how you mean it. I'm amateur programmer.
>>     
> Look at how the ".dvb_gpio" and ".gpio" fields are used in the board
> profiles in em28xx-cards.c.  We toggle the GPIOs when switching the
> from analog to digital mode, without the tuner having to do any sort
> of callback.
>
>   
It's a bad example. em28xx use a reg-set, but tm6000 not !! It use a
gpio usb request.

tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_5, 1);


I don't know, that it with the ".gpio" fields works. And when it switch
from analog to digital, I don't see the way.

>>> What function does the "tm6000" member in the zl10353 config do?  It
>>> doesn't seem to be used anywhere.
>>>
>>>
>>>       
>> I'll switch it next week to demodulator module.
>>     
> Are you saying the zl10353 isn't working right now in your patch?  I'm
> a bit confused.  If it doesn't work, then your patch title is a bit
> misleading since it suggests that your patch provides DVB support for
> the tm6000.  If it does work, then the tm6000 member shouldn't be
> needed at all in the zl10353 config.
>
>   
I'm emulating it in hack.c and the zl10353 module doesn't work, if I
switch to it.
> Cheers,
>
> Devin
>
>   


-- 
Stefan Ringel <stefan.ringel@arcor.de>

