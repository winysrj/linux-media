Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33703 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbcBOJWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 04:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <1455242450-24493-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1455242450-24493-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 15 Feb 2016 10:22:22 +0100
Message-ID: <CAMuHMdVoZ31hA6hitMhjWxizoEAPdYM1rubx4LRg275Lvz2Duw@mail.gmail.com>
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 12, 2016 at 3:00 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The parent clock isn't documented in the datasheet, use S2D1 as a best
> guess for now.

Looks like a good guess...
I assume the driver doesn't depend on the clock rate?

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
