Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab2GCTzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jul 2012 15:55:14 -0400
Message-ID: <4FF34E0E.1090507@redhat.com>
Date: Tue, 03 Jul 2012 16:54:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi> <4FED2FE0.9010602@redhat.com> <4FED3714.2080901@iki.fi> <2601054.j5eSD2QU7J@dibcom294> <4FEDBB9B.9010400@redhat.com> <4FF21238.1000002@iki.fi> <4FF31CEB.3070707@redhat.com>
In-Reply-To: <4FF31CEB.3070707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-07-2012 13:25, Mauro Carvalho Chehab escreveu:
> Em 02-07-2012 18:27, Antti Palosaari escreveu:

>> OK, I have now played (too) many hours. Looking existing code and testing. But I cannot listen even simple FM-radio station. What are most famous / best radio applications ? I tried gnomeradio, gqradio and fmscan...
>>
>> That is USB radio based si470x chipset.
> 
> Well, I don't have any si470x device here.
> 
> It should be noticed that radio applications in general don't open the
> alsa devices to get audio, as old devices used to have a cable to wire
> at the audio adapter.
> 
> I bet that this device uses snd-usb-audio module for audio. So, you may
> need to use aplayer/arecord in order to listen, with a syntax similar to:
> 
> 	arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -
> 
> The -r 32000 is for 32 kHz.
> 
> 
> In my case, I prefer to use "radio" aplication that comes with xawtv.
> It shouldn't be hard to patch it to also create the audio playback command
> there, as the code for that is already there at xawtv3 tree, and it is
> used by xawtv.
> 
> I'll see if I can write a patch for that today.

Gah, worked on that just to discover that Hans de Goede had added it already...

Anyway, it is good to know that this got already fixed :)

Anyway, "radio" should do the proper alsa loopback handling:

	$ radio
	Using alsa loopback: cap: hw:2,0 (/dev/radio0), out: default

Regards,
Mauro
