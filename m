Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:51955 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1GSNOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:14:31 -0400
Date: Tue, 19 Jul 2011 15:13:38 +0200
From: Lennart Poettering <mznyfn@0pointer.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: ALSA devel <alsa-devel@alsa-project.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Stas Sergeev <stsp@list.ru>, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [patch][saa7134] do not change mute state for
 	capturing audio
Message-ID: <20110719131338.GA7057@tango.0pointer.de>
References: <4E19D2F7.6060803@list.ru>
 <4E1E05AC.2070002@infradead.org>
 <4E1E0A1D.6000604@list.ru>
 <4E1E1571.6010400@infradead.org>
 <4E1E8108.3060305@list.ru>
 <4E1F9A25.1020208@infradead.org>
 <4E22AF12.4020600@list.ru>
 <4E22CCC0.8030803@infradead.org>
 <4E24BEB8.4060501@redhat.com>
 <4E257FF5.4040401@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E257FF5.4040401@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19.07.11 10:00, Mauro Carvalho Chehab (mchehab@infradead.org) wrote:

Heya,

> The thing is that starting capture on a video device has some side effects,
> as it will start capturing from a radio or TV station without specifying
> the desired frequency.
> 
> Several video boards have the option of plugging a loop cable between
> the device output pin and the motherboard line in pin. So, if you start
> capturing, you'll also enabling the output of such pin, as the kernel
> driver has no way to know if the user decided to use a wire cable, instead
> of the ALSA PCM stream.
> 
> So, if users with such cables are lucky, it will play something, but,
> on most cases, it will just tune into a non-existing station, and it will
> produce a white noise.
> 
> The right thing to do is to get rid of capturing on a video device, if you're
> not sure that the device is properly tuned.
> 
> It is easy to detect that an audio device is provided by a v4l device. All
> you need to do is to look at the parent device via sysfs.

So what we actually support in PA, is that you can disable the probing
for specific sound cards if you supply a file that describes what should
be exposed in PA for the sound card instead. We use that for a number of
pro audio cards, where we want to show nicer human readable strings for
specific configurations.

This is configured in /usr/share/pulseaudio/alsa-mixer/paths/,
/usr/share/pulseaudio/alsa-mixer/profile-sets/* and
/lib/udev/rules.d/90-pulseaudio.rules.

The udev rules files binds a profile set to a specific sound device. The
profile set then declares in which combinations a sound card can be
opened for input and output, and which mixer paths to expose.

Note that the profile sets/mixer paths are supposed to be
user-friendly. Hence instead of exposing all options they are designed
to expose only the minimum that is useful in the UI. And the emphasis is
on usefulness here, so the options the user can choose should be few,
not overwhlemingly many.

https://tango.0pointer.de/pipermail/pulseaudio-discuss/2009-June/004229.html

It might make sense to add that for your TV card to PA as well.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
