Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1GQLv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 07:51:59 -0400
Message-ID: <4E22CCC0.8030803@infradead.org>
Date: Sun, 17 Jul 2011 08:51:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>,
	Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru>
In-Reply-To: <4E22AF12.4020600@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stas,

Em 17-07-2011 06:44, Stas Sergeev escreveu:
> 15.07.2011 05:38, Mauro Carvalho Chehab wrote:
>> If you want, feel free to propose a patch fixing that logic at saa7134, instead
>> of just removing it.
> Hi, I've just verified that pulseaudio indeed does
> the sound capturing on startup:
> ---
> saa7134[0]/alsa: saa7134[0] at 0xfe8fb800 irq 22 registered as card 2
> saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
> saa7134[0]/alsa: irq: field oops [even]

(Added Lennart to the c/c list)

If pulseaudio is starting sound capture at startup, then it is either
a pulseaudio miss-configuration or a bug there. I fail to understand
why pulseaudio would start capturing sound from a V4L audio at startup.

I think that this is not the default for pulseaudio, though, as 
you're the only one complaining about that, and I never saw such
behavior in the time I was using pulseaudio here.

I don't know enough about pulseaudio to help on this issue,
nor I'm using it currently, so I can't test anything pulsaudio-related.

Lennart,

Could you please help us with this issue?

Thanks!
Mauro

> ---
> 
> So your proposal is not going to fix anything at all.
> 
> Can we get back to discussing/applying mine then?
> And if the other drivers has that autounmute logic,
> then I suggest removing it there as well. You have
> not named any use-case for it, so I think there is none.
> I also think that the whole auto-unmute logic in your
> drivers is entirely flawed: for instance, I don't think
> recording from the sound card will automatically
> unmute its line-in or something else, so you are probably
> not following the generic alsa style here.
> I am adding alsa-devel to CC to find out what they
> think about that whole auto-unmute question.

