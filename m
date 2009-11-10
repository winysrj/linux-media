Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:20529 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZKJHlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 02:41:22 -0500
Received: by ey-out-2122.google.com with SMTP id 4so139942eyf.19
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 23:41:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091109160058.7ef4a0ea@pedra.chehab.org>
References: <885896af0911090019p6e0c784fq5b3e8f20e00d479c@mail.gmail.com>
	 <20091109160058.7ef4a0ea@pedra.chehab.org>
Date: Tue, 10 Nov 2009 08:41:26 +0100
Message-ID: <885896af0911092341l7408a888v4fee7c43b2350a02@mail.gmail.com>
Subject: Re: v4l-dvb status
From: Giacomo <delleceste@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks!

2009/11/9 Mauro Carvalho Chehab <mchehab@infradead.org>:
> Hi Giacomo,
>
> Em Mon, 9 Nov 2009 09:19:05 +0100
> Giacomo <delleceste@gmail.com> escreveu:
>
>> good morning to all in the list.
>>
>> I have a few questions, back trying to install v4l-dvb kernel drivers
>> after some time.
>>
>> 1. Is the project going to support kernel 2.6.31?
>
> Huh? This project is for upstream kernel drivers. All drivers produced go to
> kernel.

Yes, I imagined.. but since still it does not compile on 2.6.31... I
just wanted to know..
anyway I managed compiling the drivers commenting inside a Makefile
the driver that
refused to..

>
>> 2. I used to use tvtime + sox for the usb audio, with big problems
>> causing audio
>>    desynchronization with large delay with respect to the video: do
>> the (new) drivers
>>    solve the issue?
>>   -  I also remember that there was an integrated version of
>> tvtime/usb audio in hg repositories,
>>      is it still maintained? is there a particular version to download
>> to correctly build it?
>
> tvtime stopped being maintained on 2005. You may find a few patches for it on
> some places, but there are some issues on those patches.
>
> Currently, you'll find a good support for V4L2 with mplayer. It generally
> synchronizes audio and video well.

I'll try it! Anyway, just yesterday playing with sox I found out a
satisfying configuration
for audio and video synchronization... the fact is that in most of
forums the posted information
is often wrong, and there is a lack of good `official' documentation,
leaving these kind of things
only for out-and-out specialists!

Thanks for your attention!

ciao Giacomo

>
>> 3. It's two years since I first installed v4l-dvb drivers, and still I
>> encounter problems to find all
>>    the channels with tvtime.
>>    Is there some module parameter to provide for the module em28xx for
>> Pinnacle PCTV USB2,
>>    for the Italian standards?
>
> You should be sure to select the proper video standard used in Italy. Maybe your
> device tuner is different than the one configured at the driver. Different tuners
> generally have different cut-off frequencies between the 3 bands (low VHF, high VHF,
> UHF). If you are using a different tuner, you may not be able to see the channels that
> are close to the cut-off frequencies.
>
> Currently, there are two variants of PCTV:
>
>        [EM2820_BOARD_PINNACLE_USB_2] = {
>                .name         = "Pinnacle PCTV USB 2",
>                .tuner_type   = TUNER_LG_PAL_NEW_TAPC,
>
>        [EM2820_BOARD_PINNACLE_USB_2_FM1216ME] = {
>                .name         = "Pinnacle PCTV USB 2 (Philips FM1216ME)",
>                .tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
>
> Each with a different tuner. The better way is to open your device and see
> what's labeled at the metal can inside it, to be sure what variant are you
> using.
>
> You may also play with the tuner by passing a parameter to the kernel driver specifying your
> tuner model, based on the numbers at:
>
>        linux/Documentation/video4linux/CARDLIST.tuner
>>
>> Thanks in advance for any hint and the great work done on v4l-dvb project
>>
>> Giacomo
>>
>
>
>
>
> Cheers,
> Mauro
>



-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
