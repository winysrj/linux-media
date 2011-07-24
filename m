Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1GXSgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 14:36:49 -0400
Message-ID: <4E2C6638.2040707@infradead.org>
Date: Sun, 24 Jul 2011 15:36:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru>
In-Reply-To: <4E2C5A35.9030404@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-07-2011 14:45, Stas Sergeev escreveu:
> 23.07.2011 19:09, Mauro Carvalho Chehab wrote:
>> >  In this case, it will not be autounmuted after tuning.
>> Hard to tell about your solution without seeing a patch.
> OK, it turns out the automute code is already there,
> but it doesn't work. The driver for some reasons
> starts the scan on initialization, finds the carrier:
> ---
> saa7134[0]/audio: found PAL main sound carrier @ 6.000 MHz [3969/324]
> ---
> and, because of that, disables the automute. If the
> real mute is not enabled at that point, you get the
> white noise right away.

The automute code works fine. Maybe you have a strong interference
at the default tuning frequency, leading into saa7134 miss-detection.

For saa7134 driver:
	1) There is an audio carrier;
	2) an application wants to listen audio;
	3) the device is at automute mode. So, when there's
	   an audio carrier, it will unmute the audio at
	   streaming start.

The driver is doing the _right_ thing by letting the audio to flow
to PA, when it starts the capture.

Unfortunately, on your specific device, starting audio
capture also enables audio at the audio output pin. So,
you're noticing a problem.

People with a saa7134 device without alsa stream won't notice
it (old devices). People with alsa stream without anything
connected to the LINE OUT people aren't noticing it, if PA is
not copying the saa7134 PCM IN stream to the sound card PCM out
device (the default, for PA).

So, only people that has saa7134 with alsa stream that opted
to wire the saa7134 device to the sound card, and with a strong
interference at the default tunning frequency (400 MHz) would
notice a problem.

> Since I have no idea why it finds some carrier, I can't
> fix that in any way. Or, maybe, not to call the scan
> on driver init? What will that break?

Analog tuners need to be tuned at the device init on a high frequency
according with their datasheets, otherwise the PLL may fail.

> Anyway, as long as the automute code is broken,
> we should either start fixing it, or fix PA, or fix mplayer...

As I always said, the fix should be at PA, as it makes no sense
to start capturing at saa7134 without first configuring it.
So, or PA should be converted into a V4L2-aware application, in
order to properly init the device (with seems to be the wrong
approach) or it _SHOULD_NOT_ automatically enable capture on those
devices, as this may cause undesired side effects, on the devices
that have the capture pin directly wired to the output pin, witch 
seems to be the case of your device.

PS.: it seems that you've removed Lennart/alsa people from the c/c.
I'm re-adding them, as I'm expecting a fix from their side.

> Dunno. I wonder how come so many bugs left unfixed
> for so long, resulting in a white noise to people...

You're the first one that reported it, and the code is there for _years_.
So, this is not a commonly noticed problem at all.

Mauro.
