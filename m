Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47377 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2B2VaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 16:30:24 -0500
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 22:30:22 +0100
Message-ID: <CAMuHMdVmiqY9uh574_uTK76+28bvhEL0BPnzjDF-bf-0mgj4gg@mail.gmail.com>
Subject: rtl2830: __udivdi3 undefined
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

http://kisskb.ellerman.id.au/kisskb/buildresult/5759200/
ERROR: "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!

I didn't look too deeply into it, but I think it's caused by the "num
/= priv->cfg.xtal"
in rtl2830_init() (with num being u64).

Can't it use do_div() instead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
