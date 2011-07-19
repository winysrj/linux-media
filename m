Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.mail.ru ([94.100.176.152]:41335 "EHLO smtp10.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1GSNta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:49:30 -0400
Message-ID: <4E258B60.6010007@list.ru>
Date: Tue, 19 Jul 2011 17:49:20 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Lennart Poettering <lpoetter@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>,
	lennart@poettering.net
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org>
In-Reply-To: <4E257FF5.4040401@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

19.07.2011 17:00, Mauro Carvalho Chehab wrote:
> Several video boards have the option of plugging a loop cable between
> the device output pin and the motherboard line in pin. So, if you start
> capturing, you'll also enabling the output of such pin, as the kernel
> driver has no way to know if the user decided to use a wire cable,
> instead
> of the ALSA PCM stream.
> So, if users with such cables are lucky, it will play something, but,
> on most cases, it will just tune into a non-existing station, and it will
> produce a white noise.
This needs to be clarified a bit (for Lennart).
Initially, before the board is tuned to some station,
the sound is wisely muted. It is muted for both the
capturing and the pass-through cable.
As far as I can tell, if you want to probe the card by
capturing, you can capture the silence, you don't need
any real sound to record.
The problem here is that the particular driver has a
"nice code" (or a hack) that unmutes both the capturing
and the pass-through cable when you capture anything.
>From my POV, exactly that leads to the problem. Simply
removing that piece of code makes the peace in the world:
the app that tunes the board, also unmutes the sound anyway.

My question was and still is: do we need to search for
any other solution at all? Do we need to modify PA, if
it is entirely fine with capturing the silence for probing audio?
