Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:61110 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab3AHRaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 12:30:00 -0500
Received: by mail-la0-f44.google.com with SMTP id fr10so769884lab.3
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 09:29:58 -0800 (PST)
Message-ID: <50EC57AE.7050305@googlemail.com>
Date: Tue, 08 Jan 2013 18:30:22 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some IR fixes for I2C devices on em28xx
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com> <50E82900.9060701@googlemail.com> <20130105130647.75c96994@redhat.com> <50E9DC8F.4060902@googlemail.com> <20130107150410.5f39a42c@redhat.com>
In-Reply-To: <20130107150410.5f39a42c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.01.2013 18:04, schrieb Mauro Carvalho Chehab:
> Em Sun, 06 Jan 2013 21:20:31 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 05.01.2013 16:06, schrieb Mauro Carvalho Chehab:
>>> Em Sat, 05 Jan 2013 14:22:08 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> Am 04.01.2013 22:15, schrieb Mauro Carvalho Chehab:
>>>>> Frank pointed that IR was not working with I2C devices. So, I took some
>>>>> time to fix them.
>>>>>
>>>>> Tested with Hauppauge WinTV USB2.
>>>>>
>>>>> Mauro Carvalho Chehab (4):
>>>>>   [media] em28xx: initialize button/I2C IR earlier
>>>>>   [media] em28xx: autoload em28xx-rc if the device has an I2C IR
>>>>>   [media] em28xx: simplify IR names on I2C devices
>>>>>   [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
>>>>>
>>>>>  drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
>>>>>  drivers/media/usb/em28xx/em28xx-input.c | 29 ++++++++++++++++-------------
>>>>>  2 files changed, 17 insertions(+), 14 deletions(-)
>>>>>
>>>> While these patches make I2C IR remote controls working again, they
>>>> leave several issues unaddressed which should really be fixed:
>>>> 1) the i2c client isn't unregistered on module unload. This was the
>>>> reason for patch 2 in my series. There is also a FIXME comment about
>>>> this in em28xx_release_resources() (although this is the wrong place to
>>>> do it).
>>> AFAIKT, this is not really needed, as the I2C clients are unregistered
>>> when the I2C bus is unregistered.
>>>
>>> So, a device disconnect will release it. Also, an em28xx driver unload.
>>>
>>> The only difference might be if just ir-kbd-i2c and em28xx-rc are
>>> unloaded, but em28xx is still loaded, but I think that, even on this
>>> case, calling the .release code for an I2C bus will release it.
>>>
>>> So, I don't see any need for such patch. I might be wrong, of course, but,
>>> in order to proof that a release code is needed, you'll need to check if
>>> some memory are lost after module load/unload.
>> Mauro, just because code luckily 'works' in the current constellation,
>> it isn't necessarily good code.
> It doesn't luckly 'works'. It is rock solid. 

I disagree here.

> There were really few bug
> reports for ir-kbd-i2c during all those years.

Yeah, but not because the code is so good. ;)
Getting no bug reports doesn't mean that the code is good quality / bug
free (in fact is was broken for a long time).
The 3 main reasons are
1) noone uses the hardware (because it's old, because it's completely
broken, ...)
2) noone want's to report bugs (because they don't know where, think
it's a waste of time, ...)
3) the bugs are reported somewhere else (distros) but not processed /
forwared properly

>> It's this kind of issues that can easily cause regressions if the code
>> changes somewhere else.
> Nah. What causes regression is touching on a code that works for no
> good reason and without enough testing.
>
> Btw, I was told that audio on HVR-950 seemed to stop working.

Yes, and there was another similar bug report recently...

> Not sure what broke it, but, as I tested it some time ago, I suspect
> was due to one of those recent patches (v4l2-compliance, vb2 or your
> patches - we need to bisect to discover what broke it). 

I don't think it was one of those changes.
AFAICS, the bug reports arrived before thes patches were applied.

> None of those
> touched on em28xx-alsa directly, but perhaps one of the patches had
> a bad side effect.

I've done a quick test with my devices but can't reproduce it. And I
didn't look into the audio code too deep yet.
We should ask for further details.


[...]

>>>> 3) All RC maps should be assigned at the same place, no matter if the
>>>> receiver/demodulator is built in or external. Spreading them over the
>>>> code is inconsistent and makes the code bug prone.
>>> I don't agree. It is better to keep RC maps for those devices together
>>> with the RC protocol setting, get_key config, etc. At boards config,
>>> it is very easy to identify I2C IR's, as there's an special field there
>>> to mark those devices (has_ir_i2c). So, if the board has_ir_i2c, the
>>> IR config is inside em28xx-input. 
>> ... which is exactly what made it so easy to cause this regression !!!
>>
>> It's not obvious for programmers that no RC map has to be specified for
>> i2c RCs in the board data.
>> It's also not obvious that em28xx-input silently overwrites the rc-map
>> assigned at board level.
>> In general, it's not obvious that two completely different code areas
>> have to be touched for these devices.
>> That's why we really should avoid those board specific code parts spread
>> all over the driver as much as possible.
>> In case of the RC map it's really easy.
>>
>> I also fail to see what you would loose in em28xx-input. We would still
>> assign the RC map to dev->init_data.
>> If you prefer seeing the used RC map in the em28xx-input code directly,
>> then the same should apply for devices with built-in IR
>> recceiver/decoder (which means moving all rc-map assignments to
>> em28xx-input).
>> You could also get rid of field ir_codes this way.
> I don't agree with the changes you're proposing, for the already explained
> reasons. Your arguments are, IMHO, weak, as there are really few devices
> with I2C IRs, and I doubt that we'll have a sudden burst of patches
> adding new I2C IRs.
...
>
>>
>>> That's the same logic that it is
>>> there for has_dvb: if this field is true, the DVB specifics is inside
>>> em28xx-dvb.
>> Different case.
>> Avoiding board specific code parts there likely isn't possible (and
>> reasonable), although it should be the goal.
> It is possible. We did it on tm6000. Yet, just like IR's, there are
> board-specific functions to initialize DVB device-specific code.
>
> The thing is: on both I2C IR and DVB, you can't specify completely a
> board at em28xx cards structure.

It seems like you still don't understand me. :(
The explanation is a few lines above (and in the parts you skipped). We
don't disagree here.

The ir_codes field is already there an we use it. I don't want to change
that (remove it) and I assume you agree here.
I just don't want to specify the RC maps that should be used for a board
at two completely different code locations without a real need. And I
can't see the need here.
IMHO, this is bad coding style and - more important - it's dangerous.

Take a look at the fix you've applied:

> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index f5cac47..e17be07 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2912,7 +2912,7 @@ static void request_module_async(struct work_struct *work)
>  
>  	if (dev->board.has_dvb)
>  		request_module("em28xx-dvb");
> -	if (dev->board.ir_codes && !disable_ir)
> +	if ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir)
>  		request_module("em28xx-rc");
>  #endif /* CONFIG_MODULES */
>  }

You see what had happened ? ;)


>>
>> Mauro,
>> I would like to repeat what I've already said above: just because code
>> 'works' in a specific constellation, it isn't necessarily good code.
>> The fact that this code has been suffering from a big fat regression for
>> a long time should really draw our attention !
>> So let's try to avoid this happening again by fixing the issues the code
>> has, so that it becomes much more robust.
>> I'm offering to send patches.
> The regression is there just because it is a code that most people don't
> use or even care: only very few boards have buttons; only 4 boards use
> I2C IRs. Also, because developers didn't test the new code with those
> very old hardware (6 years or more) that use I2C IR's.

Yeah, sure, that's the main problem. Likely because they didn't have
this legacy hardware anymore for testing.
+1 reason for making the code bullet proof ! ;)

Regards,
Frank

