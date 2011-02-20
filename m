Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60122 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1BTR61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 12:58:27 -0500
Received: by wwa36 with SMTP id 36so5387719wwa.1
        for <linux-media@vger.kernel.org>; Sun, 20 Feb 2011 09:58:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimeuemRVt9MEm5nwVi+6Rszx0-s1xVvrhi-yi5v@mail.gmail.com>
References: <AANLkTikNESFqYNT7Gu2vE4yMeDhCCSu0BkeRhEmVbR3y@mail.gmail.com>
	<AANLkTimeuemRVt9MEm5nwVi+6Rszx0-s1xVvrhi-yi5v@mail.gmail.com>
Date: Sun, 20 Feb 2011 23:28:24 +0530
Message-ID: <AANLkTi=GXx3iFxQ21fabjmG4scG4j8He=bUQYLyCPO-t@mail.gmail.com>
Subject: Re: utv 330 : gadmei USB 2860 Device : No Audio
From: Pranjal Pandey <pranjal8128@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks Devin for a quick reply.

I guess I didn't convey the windows behavior properly in last mail.
Whats happening in windows is that I get the audio on the line out of
the card and I can directly connect it the speakers input. I can also
connect the line-out  to the sound card's line-in and get the sound.
I get the audio as long as the tv tuner software is active.

In Ubuntu however, when I start tvtime there is no signal produced
from the line-out of the tuner card.

Even if the card does not have audio over usb, there should still be
somethings to be done by the driver to enable audio on the line-out of
the card. I am saying this because the audio does not come from the
line-out of the card all the time, it comes (in windows) only when the
video is being accessed. So the player or the driver should enable
(may be by writing some register etc) this feature during playback.

Also, shouldn't the driver detect the card as one with some on board
audio rather than "No audio on board"??

Thanks
Pranjal



On Sun, Feb 20, 2011 at 8:57 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Hello Pranjal,
>
> On Sun, Feb 20, 2011 at 10:13 AM, Pranjal Pandey <pranjal8128@gmail.com> wrote:
>> I am trying to use UTV 330 tv tuner card to watch tv on my laptop. I
>> am using Ubuntu 10.10 with 2.6.35 kernel. To play the tv i use
>>
>> tvtime -d /dev/video1
>>
>> Tvtime plays the video properly but there is no audio.
>>
>> The output of dmesg is ::::
> <snip>
>> I have a lineout in the device. I have tried connecting earphone to
>> the lineout but there is no audio (seems like there is no signal). I
>> also used following with no improvements:
>> arecord -D hw:0,0 -c 2 -f S16_LE | aplay
>>
>> From the dmesg output i can see a few things wrongly detected. First
>> it says that there is no audio on board but the device has a lineout
>> and hence some codec (on board audio).
>
> The em2860 based devices do not have the ability to provide audio over
> the USB.  Your only option is to connect the device's line out to your
> sound card.  If you're getting audio with Windows without hooking up
> that line out cable, then there is something very strange going on.
>
>> The second thing is   that the board i detected as "Gadmei UTV330+" and not as "Gadmei UTV330".
>
> The board name should not relevant in this case.  It's the same core
> hardware design and the vendor was too dumb to make it easy to
> identify the correct model for the board (for example, by giving them
> unique USB IDs).
>
>> The output of lsusb is:
>> Bus 002 Device 004: ID eb1a:2860 eMPIA Technology, Inc.
>>
>> I checked the driver files. In em28xx-cards.c "Gadmei UTV330+"
>> corresponds to "EM2861_BOARD_GADMEI_UTV330PLUS" but from lsusb i know
>> that the device is em2860 and not em2861.
>
> Again, this doesn't matter.  There were no driver changes required to
> support the newer revision of the chip.
>
>> I have also checked the device in windows and it works fine. Does
>> anyone has any clue whats wrong here. Any suggestions ? Has anyone
>> successfully used this card in linux ?
>
> What exactly is your experience with Windows?  Are you able to get
> audio without having to hook up the line-out to your sound card?
>
> You should also try the composite/s-video input instead of the tuner
> and see if you get audio.  If you do, then we know the problem is
> specific to the onboard tuner chip and not something with the em2860
> bridge.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
