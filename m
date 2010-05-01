Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610Ab0EAAsc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 20:48:32 -0400
Message-ID: <4BDB7A5B.7070204@redhat.com>
Date: Fri, 30 Apr 2010 21:48:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-media@vger.kernel.org
Subject: Re: [OT] preferred video apps?
References: <20100430095721.b1da05af.rdunlap@xenotime.net>
In-Reply-To: <20100430095721.b1da05af.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> Hi,
> 
> Sorry for a non-kernel question, but I'd like to get some suggestions
> on video recording and editing software, please.
> 
> If it matters, this is mostly for recording & editing sports events (matches).
> 
> Reply privately if you prefer ...

Please, _do_not_ reply privately ;) 

We should build a relation of the userspace applications we need to care when 
testing for regressions, so, this is not OT. It would be nice to hear what are
the preferred open source applications.

>From my side, those are the applications I use:
	analog: xawtv 3, xawtv 4, tvtime, mencoder, ffmpeg

Only mencoder and ffmpeg can record - but xawtv (and xdtv) call them.

On digital side, I use kaffeine, gnutv and vlc. Kaffeine and gnutv can record. 
Not sure about vlc.

mplayer is capable of working with both analog and digital (and, by consequence,
mencoder).

Although I don't use, mythtv and vdr are also very popular applications. AFAIK,
both have record support.

-- 

Cheers,
Mauro
