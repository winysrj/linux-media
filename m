Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0KIK4g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 05:56:36 -0500
Message-ID: <4CD928E0.5090100@redhat.com>
Date: Tue, 09 Nov 2010 08:56:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Florian Klink <flokli@flokli.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: Terratec Grabby no sound
References: <f9fc4355b0c721744c6522a720ee2df7@flokli.de> <4CC5BE39.70206@redhat.com> <d8211f823d481e2991821b5dfc4e8b84@flokli.de> <4CC5EDC3.3020506@redhat.com> <0346874f2869b186cbe1224baeef5462@flokli.de> <4CC61058.7090205@redhat.com> <d1e3b54f6aca1dcdf74041ef2d8e9463@flokli.de>
In-Reply-To: <d1e3b54f6aca1dcdf74041ef2d8e9463@flokli.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-10-2010 10:58, Florian Klink escreveu:
> Hi,
> 
>> The sound comes from alsa device. Several em28xx types provide
>> standard USB audio. So,
>> snd-usb-audio handles it. That's why you need
>> alsa:adevice=hw.2,0:forceaudio at mplayer.
> 
> ... but thats my problem.
> sound doesn't appear inside mplayer, even with the command line options set to use the "external" alsa device. However, "arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE | aplay -" plays the sound, but only before mplayer tried to access the sound card

Have you tried my patch?

If you're using alsa:adevice=hw.2,0:forceaudio at mplayer, you should not be running arecord/aplay. You need
to use one solution or the other.
> 
> When trying to play sound with arecord again after mplayer tried to access it, I have to re-plug the card to get it playing sound over arecord again, video only seems to not break it. There is no error message or something in arecord when it's not playing anything, just silence and the same command line output.
> 
> Is there maybe anything with the sample format S16_LE or something that confuses mplayer/the driver/whatever?
> 
> Strange problem...
> 
> mplayer output (mplayer -v -tv driver=v4l2:input=0:device=/dev/video1:alsa:adevice=hw.2,0:forceaudio tv://):
> http://pastebin.com/yTV300iG
> 
> Florian
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

