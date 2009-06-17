Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765796AbZFQNSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 09:18:50 -0400
Date: Wed, 17 Jun 2009 10:18:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org,
	Jan Nikitenko <jan.nikitenko@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [PATCH] zl10353 and qt1010: fix stack corruption bug
Message-ID: <20090617101845.425f9249@pedra.chehab.org>
In-Reply-To: <200906171426.29468.zzam@gentoo.org>
References: <4A28CEAD.9000000@gmail.com>
	<20090616155937.3f5d869d@pedra.chehab.org>
	<4A38DA79.70707@gmail.com>
	<200906171426.29468.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 14:26:28 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> On Mittwoch, 17. Juni 2009, Jan Nikitenko wrote:
> >
> > Or we could use sizeof, like this:
> >     char buf[sizeof("00: ") - 1 + 16 * (sizeof("00 ") - 1) + 1]
> > or
> >     char buf[sizeof("00: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
> > ")] but it is not very readable in my opinion either.
> >
> > Maybe the best way would be to avoid the need for temporal buffer
> > completely by directly using printk in a loop, that is only the first
> > printk with KERN_DEBUG, followed by sequence of printk with registers dump
> > and final printk with end of line (but isn't a printk without KERN_
> > facility coding style problem as well?).
> >
> 
> Exactly for this case, line continuation, there is KERN_CONT defined.

There are some functions meant for printing hex dumps at kernel.h:

extern void hex_dump_to_buffer(const void *buf, size_t len,
                                int rowsize, int groupsize,
                                char *linebuf, size_t linebuflen, bool ascii);
extern void print_hex_dump(const char *level, const char *prefix_str,
                                int prefix_type, int rowsize, int groupsize,
                                const void *buf, size_t len, bool ascii);
extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
                        const void *buf, size_t len);

Also, it is possible to use kasprintf() to dynamically allocate a temporary
buffer. If you use it, you'll need to do a kfree after its usage.



Cheers,
Mauro
