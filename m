Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:39362 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZGYP4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 11:56:15 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1217351qwh.37
        for <linux-media@vger.kernel.org>; Sat, 25 Jul 2009 08:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248415576.3245.16.camel@pc07.localdom.local>
References: <1f8bbe3c0907232102t5c658d66o571571707ecdb1f4@mail.gmail.com>
	 <1248411383.3247.18.camel@pc07.localdom.local>
	 <1f8bbe3c0907232218g45c89eeapc4b86e9d07217037@mail.gmail.com>
	 <1248415576.3245.16.camel@pc07.localdom.local>
Date: Sat, 25 Jul 2009 21:26:15 +0530
Message-ID: <1f8bbe3c0907250856h6c059658m6caa838a0ac6f9c2@mail.gmail.com>
Subject: Re: Problem with My Tuner card
From: unni krishnan <unnikrishnan.a@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi hermann,

I have recompiled the kernel and it is working now, thanks.

I have used :

modprobe saa7134 card=3

But there are two problems now :

1. My speakers will produce the channel sound even after closing
tvtime and I need to remove the module using rmmod saa7134 to solve
that, is there any solution for that ?

2. In Linux I am not getting all the channels that I can get in
windows using this tuner card. I have scanned all the channels using
tvtime scanner but some channels are missing, is there anything we can
do to resolve it ?


On Fri, Jul 24, 2009 at 11:36 AM, hermann pitton<hermann-pitton@arcor.de> wrote:
> Hi,
>
> Am Freitag, den 24.07.2009, 10:48 +0530 schrieb unni krishnan:
>> > Hi Unni,
>> Hi Hermann,
>>
>> >
>> > we have lots of saa7130 cards without eeprom on it providing not at
>> > least a valid PCI subvendor and subdevice, so we can't know what it is
>> > at all, neither for the tuner type and also not for how video and audio
>> > inputs are connected.
>> >
>> > If you can tell a card with working video and another one with working
>> > audio, it should not be hard to get something together for both on TV
>> > from the tuner as a start.
>>
>> The option
>>
>> modprobe saa7134 card=3 tuner=55
>>
>> gives me sound without much noise but no video
>
> You need the external audio mux gpio switching of the FlyVideo2000
> card=3.
>
>> This gives me video, but no audio
>>
>> modprobe saa7134 card=37 tuner=55
>>
>
> But you also need the vmux=3 of card=37 for it.
> Change the vmux of card = 3 in saa7134-cards.c from one to 3 and
> recompile and install and try again with your "maybe" tuner.
>
>
>        [SAA7134_BOARD_FLYVIDEO2000] = {
>                /* "TC Wan" <tcwan@cs.usm.my> */
>                .name           = "LifeView/Typhoon FlyVIDEO2000",
>                .audio_clock    = 0x00200000,
>                .tuner_type     = TUNER_LG_PAL_NEW_TAPC,
>                .radio_type     = UNSET,
>                .tuner_addr     = ADDR_UNSET,
>                .radio_addr     = ADDR_UNSET,
>
>                .gpiomask       = 0xe000,
>                .inputs         = {{
>                        .name = name_tv,
>                        .vmux = 1,        <--change to vmux = 3
>                        .amux = LINE2,
>                        .gpio = 0x0000,
>                        .tv   = 1,
>                },{
>                        .name = name_comp1,
>                        .vmux = 0,
>                        .amux = LINE2,
>                        .gpio = 0x4000,
>                },{
>                        .name = name_comp2,
>                        .vmux = 3,
>                        .amux = LINE2,
>                        .gpio = 0x4000,
>                },{
>                        .name = name_svideo,
>                        .vmux = 8,
>                        .amux = LINE2,
>                        .gpio = 0x4000,
>                }},
>                .radio = {
>                        .name = name_radio,
>                        .amux = LINE2,
>                        .gpio = 0x2000,
>                },
>                .mute = {
>                        .name = name_mute,
>                        .amux = LINE2,
>                        .gpio = 0x8000,
>                },
>        },
>
>
>> >
>> > Also, if you do a cold boot without forcing any card, there might be a
>> > slight chance, that the gpio configuration on card init has been seen
>> > previously.
>>
>> Sorry, do you want me to just reboot the system ? I have already
>> rebooted the system many times. Is there any other thing that I need
>> to do before/after reboot ? I am new to Linux devices
>>
>
> If you tried different cards with different gpio configurations
> previously, those settings are not cleared, except you take care for it.
>
> Easiest is to do a cold boot, to see the card coming up untouched on
> gpios.
>
> I did not care yet, if we have it already duplicate, but likely try to
> look it up in the evening here.
>
> Cheers,
> Hermann
>
>
>



-- 
---------------------
With regards,
Unni

"A candle loses nothing by lighting another candle"
