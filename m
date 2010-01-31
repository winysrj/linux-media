Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:60816 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907Ab0AaN2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 08:28:50 -0500
Message-ID: <4B658576.5000904@arcor.de>
Date: Sun, 31 Jan 2010 14:28:22 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
References: <4B547EBF.6080105@arcor.de> <4B5DAC3A.6000408@redhat.com> <4B5DC2EA.3090706@arcor.de> <4B5DF134.7080603@redhat.com> <4B5DF360.40808@arcor.de> <4B5DF73F.9030807@redhat.com> <4B5E06EA.40204@arcor.de> <4B6093E4.40706@arcor.de> <4B6094DE.4000204@arcor.de> <4B60A64E.3090106@redhat.com>
In-Reply-To: <4B60A64E.3090106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.01.2010 21:47, schrieb Mauro Carvalho Chehab:
> Stefan Ringel wrote:
>   
>> Hi,
>>
>> I have a problem with usb bulk transfer. After a while, as I scan digital channel (it found a few channel), it wrote this in the log:
>>
>> Jan 26 21:58:35 linux-v5dy kernel: [  548.756585] tm6000: status != 0
>>
>> I updated the tm6000_urb_received function so that I can read the Error code and it logged:
>>
>> Jan 27 17:41:28 linux-v5dy kernel: [ 3121.892793] tm6000: status = 0xffffffb5
>>     
> Probablt it is this error:
> #define EOVERFLOW       75      /* Value too large for defined data type */
>
> It would be good to make it display the error as a signed int.
>
> the tm6000-video error handler has some common causes for those status.
> In this particular case:
>
>         case -EOVERFLOW:
>                 errmsg = "Babble (bad cable?)";
>                 break;
>
> This looks the same kind of errors I was receiving during the development of the driver:
> a large amount of frames are got broken, even if the device is programmed with the exact
> values used on the original driver. On my tests, changing the URB size were changing
> the position where such errors were occurring.
>
>   
>> Can you help me? Who I can calculate urb size?
>>     
> Take a look on tm6000-video:
>
>         size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
>
>         if (size > dev->max_isoc_in)
>                 size = dev->max_isoc_in;
>
> It depends on the alternate interface used. The driver should select an alternate
> interface that is capable of receiving the entire size of a message. Maybe the tm6000
> driver is missing the code that selects this size. Take a look on em28xx-core, at
> em28xx_set_alternate() code for an example on how this should work.
>
> The calculated size there assumes that each pixel has 16 bits, and has some magic that
> were experimentally tested on that device.
>
> Cheers,
> Mauro.
>
>   
I know why it's going to overflow. It's not usb pipe calculating, it's
numbers of feeds that it's used. But then I cannot use more than one
filter! It's bad!!

Cheers

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>

