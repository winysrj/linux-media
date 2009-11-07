Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46737 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZKGPer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 10:34:47 -0500
Received: by bwz27 with SMTP id 27so2110192bwz.21
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 07:34:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6174dfda0911070731q535e9027q3a0feb483515436e@mail.gmail.com>
References: <6174dfda0911061223k75f31fd5je33a8e75e9e3c391@mail.gmail.com>
	 <6174dfda0911061258u254ba6bbh4610291a904edc0a@mail.gmail.com>
	 <156a113e0911061716t758d7ee3ta709b406c2f074a1@mail.gmail.com>
	 <6174dfda0911070246v61b5b3f5rdea26406066e3fa4@mail.gmail.com>
	 <156a113e0911070435w4be2b9dfo17f8e9c910bab437@mail.gmail.com>
	 <829197380911070725y12c984bamb1d157419b991c9a@mail.gmail.com>
	 <6174dfda0911070731q535e9027q3a0feb483515436e@mail.gmail.com>
Date: Sat, 7 Nov 2009 16:34:49 +0100
Message-ID: <6174dfda0911070734m2e99408tfd5c92a50925ed3c@mail.gmail.com>
Subject: Fwd: em28xx based USB Hybrid (Analog & DVB-T) TV Tuner not supported
From: Johan Mutsaerts <johmut@gmail.com>
To: Magnus Alm <magnus.alm@gmail.com>, linux-media@vger.kernel.org
Cc: dheitmueller@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, forgot to reply all....


---------- Forwarded message ----------
From: Johan Mutsaerts <johmut@gmail.com>
Date: 2009/11/7
Subject: Re: em28xx based USB Hybrid (Analog & DVB-T) TV Tuner not supported
To: Devin Heitmueller <dheitmueller@kernellabs.com>


Hi,

Something caught my eye while examining em28xx-dvb.c

#include "mt352.h"
#include "mt352_priv.h" /* FIXME */

What's the FIXME about ? Could it be a clue ?

What do you suggest I try/text ?

Best Regards,
Johan

2009/11/7 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Sat, Nov 7, 2009 at 7:35 AM, Magnus Alm <magnus.alm@gmail.com> wrote:
>> Hi
>>
>> I read some where that trying different card types for a DVB tuner can
>> potentially cause damage to them.
>>
>> You are probably right about the firmare.
>> Do you have a link to the manufacture of your stick?
>> I tried to google the name of it but couldn't found an exact match.
>>
>> The EM2881_BOARD_PINNACLE_HYBRID_PRO uses it's XC3028 to getter with a
>> ZARLINK456
>> as you can see from the following line in em28xx-cards.c
>>
>> case EM2881_BOARD_PINNACLE_HYBRID_PRO:
>> � � � � � � � �ctl->demod = XC3028_FE_ZARLINK456;
>> � � � � � � � �break;
>>
>> It is probably not compliant with your �Zarlink MT352.
>>
>> There is a mt352 module tho, but I guess it doesn't get loaded when
>> you plug your stick in.
>>
>> I'll pooke around a bit.....
>>
>> PS
>> Use the "reply all", so others can see your mails, since I'm probably
>> one of the least competent guys/gals on this mailing list.
>> DS
>>
>>
>>
>> 2009/11/7 Johan Mutsaerts <johmut@gmail.com>:
>>> Hi Magnus,
>>>
>>> Thanks for a quick reply. Here is some more detailed information:
>>>
>>> My USB device ID is 0xeb1a:0x2881 it is eMPIA based.
>>>
>>> These are the components inside
>>> - Empia EM2880
>>> - Texas Instruments 5150AM1
>>> - XCeive XC3028
>>> - Empia EMP202
>>> - Zarlink MT352
>>>
>>> Difficult for me to get to the windows stuff....
>>>
>>> No /dev/dvb/.... is generated ? Could it have something to do with no Firmware ?
>>>
>>> I found my device to be quite similar to the Pinnacle Hybrid Pro so I tried
>>> sudo rmmod em28xx-dvb
>>> sudo rmmod em28xx-alsa
>>> sudo rmmod em28xx
>>> sudo modprobe em28xx card=53 and card=56
>>> sudo modprobe em28xx-alsa
>>> sudo modprobe em28xx-dvb
>>> However with not much success.
>>> Card=53 cased MeTV to see a tuner but no channels could be found....
>>>
>>> TIA for any assistance you can provide.
>>>
>>> Best Regards,
>>> Johan
>>>
>>> 2009/11/7 Magnus Alm <magnus.alm@gmail.com>:
>>>> Hi!
>>>>
>>>> The dmesg didn't reveal what tuner your stick/card has, it's probably
>>>> a XC2028/XC3028 or something like that.
>>>> Easiest way to find out would be if you could open the cover and have
>>>> a look inside.
>>>>
>>>> If you have access to windows and the pvr program that came with the
>>>> tuner you could do a usb-sniff.
>>>>
>>>> http://www.pcausa.com/Utilities/UsbSnoop/
>>>> or
>>>> http://benoit.papillault.free.fr/usbsnoop/
>>>>
>>>> Switch between different inputs while doing the log, like "dvb",
>>>> "analog" and if it has "svideo"/"composite" input.
>>>>
>>>> copy the windows log to unix and parse the output with parser.pl (I've
>>>> added is as an attachment.)
>>>> I think there is a new parser somewhere, but I forgot the name of it.
>>>>
>>>> I'm also not sure how I used it, but I think it was like this: perl
>>>> parser.pl < "your_windows_log" > "parsed_log"
>>>> That log is needed to �find out what "gpio" your tuner needs for
>>>> different settings.
>>>>
>>>> Don't be scared of the size of the windows log, it gets large, often a
>>>> few hundred MB.
>>>> The parsed log is much smaller, �a few hundred KB.
>>>>
>>>> That is all I can think about atm.
>>>>
>>>> /Magnus Alm
>>>>
>>>>
>>>> 2009/11/6 Johan Mutsaerts <johmut@gmail.com>:
>>>>> Hi,
>>>>>
>>>>> I have an iDream UTVHYL2 USB TV Tuner (with IR remote control) that I
>>>>> cannot get to work with Ubuntu (9.04, 2.6.28-16). I have successfully
>>>>> compiled and installed the em28xx-new driver from linuxtv.org. No
>>>>> /dev/dvb/adapter... is created and that is where it ends for me know.
>>>>> MyTV claims no adapter is detected.
>>>>>
>>>>> I have attached the output of lsusb and dmesg as requested...
>>>>>
>>>>> Please let me know what more I can do and what exactly it is you can do ?
>>>>>
>>>>> Thanks in advance and
>>>>> Best Regards,
>>>>> Johan (Belgium)
>
> I'm away from Internet access so I can't write an extended answer, but
> I can tell you that XC3028_FE_ZARLINK456 is appropriate for both the
> zarlink zl10353 and m352.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
