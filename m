Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:40110 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933993AbZGQCce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 22:32:34 -0400
Subject: Re: AVerMedia AVerTV GO 007 FM, no radio sound (with routing
	enabled)
From: hermann pitton <hermann-pitton@arcor.de>
To: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
Cc: Laszlo Kustan <lkustan@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <1247794346.3921.22.camel@AcerAspire4710>
References: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
	 <1247794346.3921.22.camel@AcerAspire4710>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 04:21:22 +0200
Message-Id: <1247797282.3187.47.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pham Thanh Nam,

you are exactly at the point!

Am Freitag, den 17.07.2009, 08:32 +0700 schrieb Pham Thanh Nam:
> I read somewhere that the radio had ever worked for this card but has
> stopped working with newer kernels. I had the same problem when I used
> my card (AverMedia AverTV GO 007 FM Plus) with card=57 before. Radio had
> worked with old kernel versions.
> Try this:
> hg clone http://linuxtv.org/hg/v4l-dvb
> Edit v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c, go to
> entry [SAA7134_BOARD_AVERMEDIA_GO_007_FM], in .radio = { ... },
> change .amux = LINE1 to .amux = TV
> make
> then
> sudo make install
> and reboot.
> I don't know why someone has changed it to LINE1. But if the
> modification works for you, I think we need to modify a bit.
> Please let us know if it works.

The AVerMedia AVerTV GO 007 FM was the first card ever reported working
with the new saa7131e chip, including the previously external tda8290
demodulator built into that chip, by Assaf Gillat.

This did include working radio on LINE* input.

No other later card does have such and all LINE* input for radio was not
working on all other later cards.

However, all later cards did use gpio21 to switch those stuff into radio
mode, having it either high or later also low. (vice versa/swapped)

That single gpio did trigger a cascade of further switches on later
cards, starting with selecting the right antenna input on a further
microscopic switch later in the row and routing the radio IF to the TV
input for decoding "on chip".

This did also include that the radio IF has to go over that
extra/special 7.5MHz ceramic filter on these cards, also present on the
007.

I can tell, that this huge ceramic filter on recent cards is not any
longer easily to identify, there are SMD replacements for it, and with
recent circuits for additional external LNAs, all looks even much more
interesting ;)

Fact is so far, with the previous reports the card should work with
kernels around 2.6.13,14,15.

Since all other later cards did not work for radio that way, Hartmut
introduced decoding from radio IF at amux TV (saa7133/35/31e only) and
that maybe did break this one.

Or the other way round, before he introduced that, it might have been
working. I don't have the specs, but as long nothing else is reported, I
can't exclude that the tda8275 in combination with a tda8290 can deliver
base band radio stereo sound to some pair of stereo LINE input of the
saa7131e.

Cheers,
Hermann








 

