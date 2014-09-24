Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37367 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaIXLaf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 07:30:35 -0400
Date: Wed, 24 Sep 2014 08:30:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad
 demodulator
Message-ID: <20140924083030.3fdcfe3e@recife.lan>
In-Reply-To: <5422A779.8030901@gmail.com>
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>
	<1410196843-26168-4-git-send-email-tskd08@gmail.com>
	<20140923170730.4d5d167e@recife.lan>
	<542233E5.5070201@gmail.com>
	<20140924062812.6308f584@recife.lan>
	<5422A779.8030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Sep 2014 20:14:01 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> > Btw, please check if your driver is handling it well, as the valid
> > values for interleave are 0, 1, 2, 4 (actually, dib8000 also
> > supports interleaving equal to 8, if sound_broadcast).
> 
> I have no info on how to set time interleaving parameters,
> although I can read them as a part of TMCC info.

And TMCC returns it as 0, 1, 2, 3, 4, instead of 0, 1, 2, 4, 8.

> I guess I can also set them in the same registers, but I'm not sure.
> 
> Since the demod is intelligent and automatically reads TMCC and
> sets the related parameters accordingly,
> I think it is safe to ignore user settings and let the demod set it.

AFAIKT, that doesn't work in Sound Broadcast mode, as the demod won't
be able to read the TMCC (at least on most demods - don't have any
details about tc90522).

> If someone would get more info in the future,
> [s]he could set those parameters in advance and make a lock faster.
> 
> regards,
> akihiro
