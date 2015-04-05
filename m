Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37304 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbDEOOL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2015 10:14:11 -0400
Date: Sun, 5 Apr 2015 15:13:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
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
Subject: Re: [PATCH 00/14] Fix fallout from per-user struct clk patches
Message-ID: <20150405141339.GF4027@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
 <CAMuHMdWue2Pw15j_2ikhSQWxOMGLLO4ojmmyxSvZ=9YwD_+14w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWue2Pw15j_2ikhSQWxOMGLLO4ojmmyxSvZ=9YwD_+14w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 05, 2015 at 11:04:56AM +0200, Geert Uytterhoeven wrote:
> Hi Russell,
> 
> On Fri, Apr 3, 2015 at 7:11 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Sorry for posting this soo close to the 4.1 merge window, I had
> > completely forgotten about this chunk of work I did earlier this
> > month.
> >
> > The per-user struct clk patches rather badly broke clkdev and
> > various other places.  This was reported, but was forgotten about.
> > Really, the per-user clk stuff should've been reverted, but we've
> > lived with it far too long for that.
> >
> > So, our only other option is to now rush these patches into 4.1
> > and hope for the best.
> >
> > The series cleans up quite a number of places too...
> 
> Thanks for your patches!
> 
> Can you please tell which are critical fixes for regressions, and which are
> cleanups? It's not so obvious to me from the patch descriptions.

The 5th one is the most important as far as fixing the regression caused
by the per-user clk patches.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
