Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1GSOLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 10:11:03 -0400
Message-ID: <4E25906D.3020200@infradead.org>
Date: Tue, 19 Jul 2011 11:10:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>,
	lennart@poettering.net
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru>
In-Reply-To: <4E258B60.6010007@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-07-2011 10:49, Stas Sergeev escreveu:
> 19.07.2011 17:00, Mauro Carvalho Chehab wrote:
>> Several video boards have the option of plugging a loop cable between
>> the device output pin and the motherboard line in pin. So, if you start
>> capturing, you'll also enabling the output of such pin, as the kernel
>> driver has no way to know if the user decided to use a wire cable,
>> instead
>> of the ALSA PCM stream.
>> So, if users with such cables are lucky, it will play something, but,
>> on most cases, it will just tune into a non-existing station, and it will
>> produce a white noise.
> This needs to be clarified a bit (for Lennart).
> Initially, before the board is tuned to some station,
> the sound is wisely muted. It is muted for both the
> capturing and the pass-through cable.
> As far as I can tell, if you want to probe the card by
> capturing, you can capture the silence, you don't need
> any real sound to record.
> The problem here is that the particular driver has a
> "nice code" (or a hack) that unmutes both the capturing
> and the pass-through cable when you capture anything.

It is not something for "a particular driver". All v4l alsa drivers have 
similar logic: they assume that, if some application is streaming, the
device should be unmuted, otherwise capture won't work.

> From my POV, exactly that leads to the problem. Simply
> removing that piece of code makes the peace in the world:
> the app that tunes the board, also unmutes the sound anyway.

It is not clear, from an application POV, to know what audio pin
should be unmuted. Some devices, like, for example, em28xx may 
have an ac97 connected on it, with lots of muxes on it. For each
different video input port, a different mixer set should be used, 
and the configuration is board-dependent.

For example, on Prolink PlayTV USB2, this is wired as:

	AC97 mono volume => PCM output
	AC97 master volume => Line out pin
	AC97 video volume => TV tuner input
	AC97 line in volume => Svideo or composite input

As this is an USB device, in general, people don't connect the line out
pin. So, typically, in order to unmute this particular device for TV, one
should unmute both AC97 MONO and AC97 VIDEO, and mute AC97 LINE IN.

If the application latter changes to SVideo, the AC97 VIDEO should be
muted, and AC97 LINE IN should be unmuted.

There's no way for an userspace application to know that, since:
	1) The device internal connections are not visible on userspace;
	2) This is board-dependent. For example, Supercomp USB 2.0 TV
	   has just the opposite setup for TV/svideo:
		AC97 video volume => Svideo or Composite Input
		AC97 line in volume => TV Input
	   and doesn't have any output volume connected.
	3) On some cases, there are two or even three mutes that need to
	   be changed.

Moving such logic to happen at userspace would be very complex, and will
break existing applications.

Cheers,
Mauro.

> 
> My question was and still is: do we need to search for
> any other solution at all? Do we need to modify PA, if
> it is entirely fine with capturing the silence for probing audio?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

