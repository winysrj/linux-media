Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:37112 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaHPT1H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 15:27:07 -0400
Message-ID: <53EFB080.50905@gentoo.org>
Date: Sat, 16 Aug 2014 21:26:56 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	"olli.salonen" <olli.salonen@iki.fi>
Subject: Re: [PATCH] m88ts2022: fix high symbol rate transponders missing
 on 32bit platform.
References: <201408161412275930052@gmail.com> <20140816093854.39be5017.m.chehab@samsung.com> <53EF5457.5080808@iki.fi>
In-Reply-To: <53EF5457.5080808@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16.08.2014 14:53, Antti Palosaari wrote:
> 
> 
> I will look that more carefully on end of next week, go through possible
> symbol rates and rounding errors.
> 
> Maybe it should be something like that (didn't test any way, may not
> even compile):
> f_3db_hz = div_u64((u64) (c->symbol_rate * 135), 200);
> 
In this case c->symbol_rate * 135 is still 32bits wide, but maybe signed
because 135 is signed.
So there will be an overflow on 32bit platforms at symbol rates equal to
15907287.
So better cast symbol_rate to u64 before.

Matthias

