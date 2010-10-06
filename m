Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33077 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab0JFH1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 03:27:38 -0400
Received: by fxm4 with SMTP id 4so971957fxm.19
        for <linux-media@vger.kernel.org>; Wed, 06 Oct 2010 00:27:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CA9FCB0.40502@gmail.com>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
 <AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com> <4CA9FCB0.40502@gmail.com>
From: Dejan Rodiger <dejan.rodiger@gmail.com>
Date: Wed, 6 Oct 2010 09:27:16 +0200
Message-ID: <AANLkTim0HrykiHrB1U18yZ3njqCeDNtXavu-tJc2EDjV@mail.gmail.com>
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
To: Giorgio <mywing81@gmail.com>
Cc: hermann-pitton@arcor.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Giorgio,

>
> Dejan,
>
> I have the exact same card:
>
> # sudo lpci -vnn
> 02:07.0 Multimedia controller [0480]: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>        Subsystem: ASUSTeK Computer Inc. Device [1043:4876]
>        Flags: bus master, medium devsel, latency 64, IRQ 20
>        Memory at fbfff800 (32-bit, non-prefetchable) [size=2K]
>        Capabilities: [40] Power Management version 2
>        Kernel driver in use: saa7134
>        Kernel modules: saa7134
>
> and I can confirm you that it's autodetected and works very well (both the
> analog and the digital part) on 2.6.35.
> 2.6.32 has a problem with dvb-t reception, but I have reported it and hopefully
> it will be fixed soon upstream: http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/23604
>
> If you want to test the analog part, install MPlayer and run the following command:
>
> mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL:input=0:chanlist=europe-west

This is working OK. I have also experimented more with tvtime and both
versions work, but I have to do little more fine tuning and then I
have better picture. So I will probably have to manually find exact
stations frequencies and enter them in mythtv. But I first have to
figure how and where to enter them.


> and then press 'k' or 'h' to select previous/next channel (after you switch
> channel, wait some seconds until the card tunes, for some channels I need
> 5 seconds here, for others about 1 second). Now, with some patience, explore
> all the channels and you should be able to find your local tv stations.
> Also, you might need to adjust mplayer options, like norm= or chanlist=
> (you could try chanlist=europe-east).
>
> The command line above doesn't grab audio though, so you won't hear a thing.
> If you want to hear the audio you need to make sure saa7134-alsa is loaded
> and run something like:
>
> mplayer tv:// -tv driver=v4l2:device=/dev/video0:norm=PAL:input=0:alsa:adevice=hw.1,0:amode=1:immediatemode=0:chanlist=europe-west

saa7134-alsa is loaded automatically, but I am unable to get any sound
from mplayer or tvtime. I see on google, that I am not the only one.
I have also noticed that about 8-10% of the frames are lost.


> (make sure you select the right alsa device in adevice=)
>
> The wiki has a good page about MPlayer:
>
> http://www.linuxtv.org/wiki/index.php/MPlayer
>
> and of course the MPlayer man page explain all the options too.
>
> These pages are also useful (but some things might be a bit outdated):
>
> http://www.linuxtv.org/wiki/index.php/ASUS_My_Cinema-P7131_Hybrid
> http://www.linuxtv.org/wiki/index.php/Saa7134-alsa
>
> I hope this can help you and others reading this ML.
>
> Regards,
> Giorgio Vazzana
>
>> Thanks
>> --
>> Dejan Rodiger
