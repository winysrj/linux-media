Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:40330 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaIAQc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 12:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <25174054.f3JtKIKjvH@amdc1032>
References: <25174054.f3JtKIKjvH@amdc1032>
Date: Mon, 1 Sep 2014 18:32:56 +0200
Message-ID: <CAMuHMdX3UX-XL8g1qQ-aJeRy_iT1uUvcGHyWF2gci+rnPZx4BA@mail.gmail.com>
Subject: Re: [PATCH] v4l: vsp1: fix driver dependencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 1, 2014 at 3:18 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Renesas VSP1 Video Processing Engine support should be available
> only on Renesas ARM SoCs.

Thanks!

> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
