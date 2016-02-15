Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33482 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbcBOJYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 04:24:03 -0500
MIME-Version: 1.0
In-Reply-To: <1455242450-24493-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1455242450-24493-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 15 Feb 2016 10:24:02 +0100
Message-ID: <CAMuHMdVFHjn6A9i8xK_D9M2fmaq8gVOh5d3V7-ULJ6amnz6uGA@mail.gmail.com>
Subject: Re: [PATCH/RFC 2/9] clk: shmobile: r8a7795: Add LVDS module clock
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 12, 2016 at 3:00 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The parent clock hasn't been validated yet.

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
