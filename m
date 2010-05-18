Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0ERSKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 14:10:48 -0400
Message-ID: <4BF2D81B.5050804@redhat.com>
Date: Tue, 18 May 2010 15:10:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alexjan Carraturo <axjslack@gmail.com>
CC: CityK <cityk@rogers.com>, video4linux-list@redhat.com,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: Pinnacle PCTV DVB-T 70e
References: <AANLkTilbPB2DeJhah0XzSMYEOpXUTzt-v4-h9JsV1BP2@mail.gmail.com> 	<4BEEC5E5.9020805@rogers.com> <AANLkTilJ24ok_LzX_m3QvXz8tio0DIfarYp5Dj0hUc5o@mail.gmail.com>
In-Reply-To: <AANLkTilJ24ok_LzX_m3QvXz8tio0DIfarYp5Dj0hUc5o@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexjan Carraturo wrote:

> Why not? Because nobody can cure this entry? Or why the driver is not
> compatible with the version in the kernel now?

For someone to add support to a device, it needs to have that device (or
a similar one), and to be able to get access to the datasheets or to use
some reverse engineering technique. One important information is what
are the chips inside the device.

>> You can, however, look to see if you can add support for your device to
>> the existing v4l-dvb kernel driver. There are several developers that
>> are knowledgeable of the em28xx driver, and whom may be able to help you
>> in that regard, but you will have to gain there attention first.
>>
>>
> 
> I'm sorry, but even knowing a bit 'of the C programming language, I
> have never written a driver, I'm not able, and I honestly do not even
> capable.
> 
> You tell me to add support to the current driver, but I have no idea
> how to do. It is also good to clarify that the driver on the kernel
> vanulla charge in the presence of this card, but simply does not work,
> and does not create deivce (/dev/dvb/).

Take a look at linuxtv WIKI pages. It explains several useful things
on how to add support to a new device.

> So knowing that I'm not able to write the driver, I would say that
> this device is definitely dead and buried ... in this case would be at
> least that was not loaded em28xx module (the one in the kernel),
> avoiding giving the illusion that the driver functions.
> 
> I do not know if you can, but should be added, if any, in a sort of blacklist.

The USB ID used by your device is generic: all devices with em2870 without
eeprom will inform the same code (and even some with eeprom, but where
the vendor didn't care to write their own ID there).

What are the components used on your device?


-- 

Cheers,
Mauro
