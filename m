Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp17.mail.ru ([94.100.176.154]:40826 "EHLO smtp17.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1GSO4P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 10:56:15 -0400
Message-ID: <4E259B0C.90107@list.ru>
Date: Tue, 19 Jul 2011 18:56:12 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org>
In-Reply-To: <4E25906D.3020200@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

19.07.2011 18:10, Mauro Carvalho Chehab wrote:
> As this is an USB device, in general, people don't connect the line out
> pin. So, typically, in order to unmute this particular device for TV, one
> should unmute both AC97 MONO and AC97 VIDEO, and mute AC97 LINE IN.
>
> If the application latter changes to SVideo, the AC97 VIDEO should be
> muted, and AC97 LINE IN should be unmuted.
Unless I am missing the point, you need some mixer control
that will just unmute the "currently-configured things".
If you can unmute all the right things when an app just
starts capturing, then you can as well unmute the same
things by that _single_ mixer control.
And if the app changes the output to SVideo, as in your
example, you can first mute everything, and then unmute
the new lines, but only if the old lines were unmuted.
IMHO, that logic will not break the existing apps.

> Moving such logic to happen at userspace would be very complex, and will
> break existing applications.
If this is the case, then how does the simplest
xawtv's mute/unmute thing works with all these
boards right now? (not that I have checked it does,
but I hope so. :)
