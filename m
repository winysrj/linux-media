Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:37368 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZFQM0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 08:26:31 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] zl10353 and qt1010: fix stack corruption bug
Date: Wed, 17 Jun 2009 14:26:28 +0200
Cc: Jan Nikitenko <jan.nikitenko@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
References: <4A28CEAD.9000000@gmail.com> <20090616155937.3f5d869d@pedra.chehab.org> <4A38DA79.70707@gmail.com>
In-Reply-To: <4A38DA79.70707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171426.29468.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mittwoch, 17. Juni 2009, Jan Nikitenko wrote:
>
> Or we could use sizeof, like this:
>     char buf[sizeof("00: ") - 1 + 16 * (sizeof("00 ") - 1) + 1]
> or
>     char buf[sizeof("00: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
> ")] but it is not very readable in my opinion either.
>
> Maybe the best way would be to avoid the need for temporal buffer
> completely by directly using printk in a loop, that is only the first
> printk with KERN_DEBUG, followed by sequence of printk with registers dump
> and final printk with end of line (but isn't a printk without KERN_
> facility coding style problem as well?).
>

Exactly for this case, line continuation, there is KERN_CONT defined.

Regards
Matthias
