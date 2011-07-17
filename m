Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp8.mail.ru ([94.100.176.53]:57635 "EHLO smtp8.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1GQJti (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 05:49:38 -0400
Message-ID: <4E22AF12.4020600@list.ru>
Date: Sun, 17 Jul 2011 13:44:50 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org>
In-Reply-To: <4E1F9A25.1020208@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

15.07.2011 05:38, Mauro Carvalho Chehab wrote:
> If you want, feel free to propose a patch fixing that logic at saa7134, instead
> of just removing it.
Hi, I've just verified that pulseaudio indeed does
the sound capturing on startup:
---
saa7134[0]/alsa: saa7134[0] at 0xfe8fb800 irq 22 registered as card 2
saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=1  =>  fmt=0xcd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0xdd swap=-
saa7134[0]/alsa: irq: field oops [even]
---

So your proposal is not going to fix anything at all.

Can we get back to discussing/applying mine then?
And if the other drivers has that autounmute logic,
then I suggest removing it there as well. You have
not named any use-case for it, so I think there is none.
I also think that the whole auto-unmute logic in your
drivers is entirely flawed: for instance, I don't think
recording from the sound card will automatically
unmute its line-in or something else, so you are probably
not following the generic alsa style here.
I am adding alsa-devel to CC to find out what they
think about that whole auto-unmute question.
