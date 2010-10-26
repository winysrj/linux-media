Return-path: <mchehab@pedra>
Received: from flokli.de ([78.46.104.9]:34594 "EHLO asterix.flokli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0JZM66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Oct 2010 08:58:58 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: em28xx: Terratec Grabby no sound
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Oct 2010 14:58:56 +0200
From: Florian Klink <flokli@flokli.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4CC61058.7090205@redhat.com>
References: <f9fc4355b0c721744c6522a720ee2df7@flokli.de>
 <4CC5BE39.70206@redhat.com> <d8211f823d481e2991821b5dfc4e8b84@flokli.de>
 <4CC5EDC3.3020506@redhat.com> <0346874f2869b186cbe1224baeef5462@flokli.de>
 <4CC61058.7090205@redhat.com>
Message-ID: <d1e3b54f6aca1dcdf74041ef2d8e9463@flokli.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 Hi,

> The sound comes from alsa device. Several em28xx types provide
> standard USB audio. So,
> snd-usb-audio handles it. That's why you need
> alsa:adevice=hw.2,0:forceaudio at mplayer.

 ... but thats my problem.
 sound doesn't appear inside mplayer, even with the command line options 
 set to use the "external" alsa device. However, "arecord -D hw:2,0 -r 
 32000 -c 2 -f S16_LE | aplay -" plays the sound, but only before mplayer 
 tried to access the sound card

 When trying to play sound with arecord again after mplayer tried to 
 access it, I have to re-plug the card to get it playing sound over 
 arecord again, video only seems to not break it. There is no error 
 message or something in arecord when it's not playing anything, just 
 silence and the same command line output.

 Is there maybe anything with the sample format S16_LE or something that 
 confuses mplayer/the driver/whatever?

 Strange problem...

 mplayer output (mplayer -v -tv 
 driver=v4l2:input=0:device=/dev/video1:alsa:adevice=hw.2,0:forceaudio 
 tv://):
 http://pastebin.com/yTV300iG

 Florian
