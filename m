Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36235 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbbDEJE5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2015 05:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
Date: Sun, 5 Apr 2015 11:04:56 +0200
Message-ID: <CAMuHMdWue2Pw15j_2ikhSQWxOMGLLO4ojmmyxSvZ=9YwD_+14w@mail.gmail.com>
Subject: Re: [PATCH 00/14] Fix fallout from per-user struct clk patches
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: ALSA Development Mailing List <alsa-devel@alsa-project.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Andrew Lunn <andrew@lunn.ch>, Daniel Mack <daniel@zonque.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Jason Cooper <jason@lakedaemon.net>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Turquette <mturquette@linaro.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Roland Stigge <stigge@antcom.de>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Takashi Iwai <tiwai@suse.de>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Fri, Apr 3, 2015 at 7:11 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> Sorry for posting this soo close to the 4.1 merge window, I had
> completely forgotten about this chunk of work I did earlier this
> month.
>
> The per-user struct clk patches rather badly broke clkdev and
> various other places.  This was reported, but was forgotten about.
> Really, the per-user clk stuff should've been reverted, but we've
> lived with it far too long for that.
>
> So, our only other option is to now rush these patches into 4.1
> and hope for the best.
>
> The series cleans up quite a number of places too...

Thanks for your patches!

Can you please tell which are critical fixes for regressions, and which are
cleanups? It's not so obvious to me from the patch descriptions.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
