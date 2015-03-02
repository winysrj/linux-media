Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:62405 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbbCBRSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:18:21 -0500
MIME-Version: 1.0
In-Reply-To: <E1YSTnH-0001JY-GT@rmk-PC.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
	<E1YSTnH-0001JY-GT@rmk-PC.arm.linux.org.uk>
Date: Mon, 2 Mar 2015 18:18:20 +0100
Message-ID: <CAMuHMdWJbLhVgWTqM8mC9AkqUKYYEh2Zv85mWizbHqoZNTxUMg@mail.gmail.com>
Subject: Re: [PATCH 02/10] SH: use clkdev_add_table()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: ALSA Development Mailing List <alsa-devel@alsa-project.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 2, 2015 at 6:06 PM, Russell King
<rmk+kernel@arm.linux.org.uk> wrote:
> We have always had an efficient way of registering a table of clock
> lookups - it's called clkdev_add_table().  However, some people seem
> to really love writing inefficient and unnecessary code.
>
> Convert SH to use the correct interface.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks, looks good.

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
