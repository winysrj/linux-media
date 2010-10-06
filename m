Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60867 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0JFMZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 08:25:25 -0400
Received: by wwj40 with SMTP id 40so7033134wwj.1
        for <linux-media@vger.kernel.org>; Wed, 06 Oct 2010 05:25:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim0HrykiHrB1U18yZ3njqCeDNtXavu-tJc2EDjV@mail.gmail.com>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
	<AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
	<4CA9FCB0.40502@gmail.com>
	<AANLkTim0HrykiHrB1U18yZ3njqCeDNtXavu-tJc2EDjV@mail.gmail.com>
Date: Wed, 6 Oct 2010 14:25:22 +0200
Message-ID: <AANLkTim2a0zGzFP=e0ShJfaovJXjWw5S6M-TAUUB2pht@mail.gmail.com>
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
From: Giorgio <mywing81@gmail.com>
To: Dejan Rodiger <dejan.rodiger@gmail.com>
Cc: hermann-pitton@arcor.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2010/10/6 Dejan Rodiger <dejan.rodiger@gmail.com>:
> Hi Giorgio,
>
>>
>> Dejan,
>>
>> I have the exact same card:
>>
>> # sudo lpci -vnn
>> 02:07.0 Multimedia controller [0480]: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>>        Subsystem: ASUSTeK Computer Inc. Device [1043:4876]
>>        Flags: bus master, medium devsel, latency 64, IRQ 20
>>        Memory at fbfff800 (32-bit, non-prefetchable) [size=2K]
>>        Capabilities: [40] Power Management version 2
>>        Kernel driver in use: saa7134
>>        Kernel modules: saa7134
>>
>> and I can confirm you that it's autodetected and works very well (both the
>> analog and the digital part) on 2.6.35.
>> 2.6.32 has a problem with dvb-t reception, but I have reported it and hopefully
>> it will be fixed soon upstream: http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/23604
>>
>> If you want to test the analog part, install MPlayer and run the following command:
>>
>> mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL:input=0:chanlist=europe-west
>
> This is working OK. I have also experimented more with tvtime and both
> versions work, but I have to do little more fine tuning and then I
> have better picture. So I will probably have to manually find exact
> stations frequencies and enter them in mythtv. But I first have to
> figure how and where to enter them.
>
>
>> and then press 'k' or 'h' to select previous/next channel (after you switch
>> channel, wait some seconds until the card tunes, for some channels I need
>> 5 seconds here, for others about 1 second). Now, with some patience, explore
>> all the channels and you should be able to find your local tv stations.
>> Also, you might need to adjust mplayer options, like norm= or chanlist=
>> (you could try chanlist=europe-east).
>>
>> The command line above doesn't grab audio though, so you won't hear a thing.
>> If you want to hear the audio you need to make sure saa7134-alsa is loaded
>> and run something like:
>>
>> mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL:input=0:alsa:adevice=hw.1,0:amode=1:immediatemode=0:chanlist=europe-west
>
> saa7134-alsa is loaded automatically, but I am unable to get any sound
> from mplayer or tvtime. I see on google, that I am not the only one.
> I have also noticed that about 8-10% of the frames are lost.

Hmm...things you can try:
1) Tell pulseaudio not to use the saa7134-alsa soundcard (click on
sound preferences (top panel, on the right, near the clock) and
disable saa7134 soundcard).
2) Run "cat /proc/asound/card" or "arecord -l" and make sure you're
using the right device on the MPlayer command line (the
"adevice=hw.1,0" part).
3) Add "audiorate=32000" like this:
mplayer tv:// -tv
driver=v4l2:device=/dev/video0:norm=PAL:input=0:alsa:adevice=hw.1,0:amode=1:audiorate=32000:immediatemode=0:chanlist=europe-west
4) See if MPlayer reports any error with alsa/audio.

Lastly, I think tvtime only works with a patch audio cable (which is
cable that connects the tv-card "audio out" to the soundcard "line
in"). So you can try to start tvtime and then run:

arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -

this way you record from the saa7134 audio device and play it back to
your speakers.

>
>> (make sure you select the right alsa device in adevice=)
>>
>> The wiki has a good page about MPlayer:
>>
>> http://www.linuxtv.org/wiki/index.php/MPlayer
>>
>> and of course the MPlayer man page explain all the options too.
>>
>> These pages are also useful (but some things might be a bit outdated):
>>
>> http://www.linuxtv.org/wiki/index.php/ASUS_My_Cinema-P7131_Hybrid
>> http://www.linuxtv.org/wiki/index.php/Saa7134-alsa
>>
>> I hope this can help you and others reading this ML.
>>
>> Regards,
>> Giorgio Vazzana
>>
>>> Thanks
>>> --
>>> Dejan Rodiger
>

Cheers,
Giorgio Vazzana
