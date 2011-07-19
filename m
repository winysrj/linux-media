Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp9.mail.ru ([94.100.176.54]:50745 "EHLO smtp9.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1GSGgs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 02:36:48 -0400
Message-ID: <4E2524DF.7070502@list.ru>
Date: Tue, 19 Jul 2011 10:31:59 +0400
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
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com>
In-Reply-To: <4E24BEB8.4060501@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

19.07.2011 03:16, Lennart Poettering wrote:
> ALSA doesn't really have a enumeration API which would allow us to get 
> device properties without opening and configuring a device. In fact, 
> we can't even figure out whether a device may be opened in duplex or 
> simplex without opening it.
>
> And that's why we have to probe audio devices, even if it sucks.
Hi Lennart, thanks for your opinion.

I am puzzled with the "even if it sucks" part, what
does it mean? I see 2 possible interpretations of it:

1. "Even if it sucks with some drivers that have bugs,
like the saa7134_alsa one". If that interpretation is
what you implied, then could you please also evaluate
the fix like this one:
  http://www.spinics.net/lists/linux-media/msg35237.html

2. "Even if it sucks in general". In this case, what solution
would you propose to get the problem of the white
noise fixed?
