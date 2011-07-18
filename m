Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1GRXQr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 19:16:47 -0400
Message-ID: <4E24BEB8.4060501@redhat.com>
Date: Tue, 19 Jul 2011 01:16:08 +0200
From: Lennart Poettering <lpoetter@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Stas Sergeev <stsp@list.ru>, linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>,
	lennart@poettering.net
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org>
In-Reply-To: <4E22CCC0.8030803@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heya,

On 17.07.2011 13:51, Mauro Carvalho Chehab wrote:

> If pulseaudio is starting sound capture at startup, then it is either
> a pulseaudio miss-configuration or a bug there. I fail to understand
> why pulseaudio would start capturing sound from a V4L audio at startup.
>
> I think that this is not the default for pulseaudio, though, as
> you're the only one complaining about that, and I never saw such
> behavior in the time I was using pulseaudio here.
>
> I don't know enough about pulseaudio to help on this issue,
> nor I'm using it currently, so I can't test anything pulsaudio-related.
>
> Lennart,
>
> Could you please help us with this issue?

ALSA doesn't really have a enumeration API which would allow us to get 
device properties without opening and configuring a device. In fact, we 
can't even figure out whether a device may be opened in duplex or 
simplex without opening it.

And that's why we have to probe audio devices, even if it sucks.

Lennart
