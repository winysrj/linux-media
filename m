Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.mail.ru ([94.100.176.129]:45127 "EHLO smtp1.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab1GQM33 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 08:29:29 -0400
Message-ID: <4E22D489.7030103@list.ru>
Date: Sun, 17 Jul 2011 16:24:41 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>,
	Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org>
In-Reply-To: <4E22CCC0.8030803@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

17.07.2011 15:51, Mauro Carvalho Chehab wrote:
> (Added Lennart to the c/c list)
> If pulseaudio is starting sound capture at startup, then it is either
> a pulseaudio miss-configuration or a bug there.
Why?

> I think that this is not the default for pulseaudio, though, as
> you're the only one complaining about that, and I never saw such
> behavior in the time I was using pulseaudio here.
I've seen such a problem mentioned on the russion
linux resource a few years ago... The reason why it
was never mentioned on that list, is probably that
noone tracked it down to the saa7134_alsa driver yet.
But maybe the reason is different, ok, lets see what
Lennart thinks.
