Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:54092 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab0BJRKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 12:10:32 -0500
Message-ID: <4B72E85E.3090303@arcor.de>
Date: Wed, 10 Feb 2010 18:09:50 +0100
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

The i2c address 0x32 isn't ir, but I think it sets the power or so. Ir
has vendor requests. see tm6000_regs.h . The i2c addresses 0x10 and 0xc0
cannot say what this is (check i2c address space or so). and the i2c
address 0x1f is the read address from demodulator.

-- 
Stefan Ringel <stefan.ringel@arcor.de>

