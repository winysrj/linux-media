Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BGP53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 10:57:29 -0500
Message-ID: <4D501656.5000309@redhat.com>
Date: Mon, 07 Feb 2011 13:57:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>	 <4D4FDED0.7070008@redhat.com>	 <20110207120234.GE10564@opensource.wolfsonmicro.com>	 <4D4FEA03.7090109@redhat.com>	 <20110207131045.GG10564@opensource.wolfsonmicro.com>	 <4D4FF821.4010701@redhat.com> <1297087744.15320.56.camel@masi.mnp.nokia.com>
In-Reply-To: <1297087744.15320.56.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-02-2011 12:09, Matti J. Aaltonen escreveu:
> On Mon, 2011-02-07 at 11:48 -0200, ext Mauro Carvalho Chehab wrote:
>> Em 07-02-2011 11:10, Mark Brown escreveu:
>>> On Mon, Feb 07, 2011 at 10:48:03AM -0200, Mauro Carvalho Chehab wrote:
>>>> Em 07-02-2011 10:02, Mark Brown escreveu:
>>>>> On Mon, Feb 07, 2011 at 10:00:16AM -0200, Mauro Carvalho Chehab wrote:
>>>
>>>>>> the MFD part (for example, wl1273_fm_read_reg/wl1273_fm_write_cmd/wl1273_fm_write_data). 
>>>>>> The logic that are related to control the radio (wl1273_fm_set_audio,  wl1273_fm_set_volume,
>>>>>> etc) are not related to access the device via the MFD bus. They should be at
>>>>>> the media part of the driver, where they belong.
>>>
>>>>> Those functions are being used by the audio driver.
>>>
>>>> Not sure if I understood your comments. Several media drivers have alsa drivers:
>>>
>>> There is an audio driver for this chip and it is using those functions.
>>
>> Where are the other drivers that depend on it?
> 
> There's the MFD driver driver/mfd/wl1273-core.c, which is to offer the
> (I2C) I/O functions to the child drivers:
> drivers/media/radio/radio-wl1273.c and sound/soc/codecs/wl1273.c.
> 
> Both children depend on the MFD driver for I/O and the codec also
> depends on the presence of the radio-wl1273 driver because without the
> v4l2 part nothing can be done...

I think that the better would be to move the audio part (sound/soc/codecs/wl1273.c)
as drivers/media/radio/wl1273/wl1273-alsa.c. Is there any problem on moving it, or
the alsa driver is also tightly coupled on the rest of the sound/soc stuff?

I remember that, in the past, there were someone that proposed to move /sound into
/media/sound, and move some common stuff between them into /media/common.

Btw, there are(where?) some problems between -alsa and -media subsystems: basically, 
the audio core needs to be initialized before the drivers. However, this sometimes
don't happen (I can't remember the exact situation - perhaps builtin compilations?),
but we ended by needing to explicitly delaying the init of some drivers with:
	late_initcall(saa7134_alsa_init); 
To avoid some OOPS conditions.

> 
> Matti
> 
>>
>> Mauro
>>
> 
> 

