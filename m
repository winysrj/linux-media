Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:47535 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1GSMfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 08:35:40 -0400
Date: Tue, 19 Jul 2011 14:25:33 +0200
From: Lennart Poettering <mznyfn@0pointer.de>
To: Stas Sergeev <stsp@list.ru>
Cc: ALSA devel <alsa-devel@alsa-project.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [patch][saa7134] do not change mute state for
 	capturing audio
Message-ID: <20110719122533.GD8224@tango.0pointer.de>
References: <4E19D2F7.6060803@list.ru>
 <4E1E05AC.2070002@infradead.org>
 <4E1E0A1D.6000604@list.ru>
 <4E1E1571.6010400@infradead.org>
 <4E1E8108.3060305@list.ru>
 <4E1F9A25.1020208@infradead.org>
 <4E22AF12.4020600@list.ru>
 <4E22CCC0.8030803@infradead.org>
 <4E24BEB8.4060501@redhat.com>
 <4E2524DF.7070502@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2524DF.7070502@list.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19.07.11 10:31, Stas Sergeev (stsp@list.ru) wrote:

> 2. "Even if it sucks in general". In this case, what solution
> would you propose to get the problem of the white
> noise fixed?

Well, for removing the probing in PA we'd need a way to reliably figure
out in which combinations of input and output we can open a sound
card. i.e. we want to know if we can run surround 5.1 output and spdif
output at the same time, or surround 5.1 output and stereo input and so
on. And we'd need a lot of other attrbites about the sound card, and all
that without having to open any PCM device. 

But that would be really hard to do, the current format neagotiation in
ALSA PCM works very differently. And that's the reason why so far nobody
has bothered with getting this right.

The current code in PA to figure this out is somewhat ugly. It's slow,
since we open the card in a lot of different combinations to test what
works. It's fragile, since if somebody else has opened the soundcard we
get an EBUSY which we take as hint that a specific combination didn't
work, and so on.

It's a hard problem,

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
