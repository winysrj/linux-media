Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45508 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbbCBRq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:46:29 -0500
Date: Mon, 2 Mar 2015 17:46:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: ALSA Development Mailing List <alsa-devel@alsa-project.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 05/10] clkdev: add clkdev_create() helper
Message-ID: <20150302174619.GD29584@n2100.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
 <E1YSTnW-0001Jk-Tm@rmk-PC.arm.linux.org.uk>
 <CAMuHMdWHAu+zDKce0+ianDb=RHYR59eeMoiYBDK4PC=YMY0JXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWHAu+zDKce0+ianDb=RHYR59eeMoiYBDK4PC=YMY0JXg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 02, 2015 at 06:22:31PM +0100, Geert Uytterhoeven wrote:
> On Mon, Mar 2, 2015 at 6:06 PM, Russell King
> <rmk+kernel@arm.linux.org.uk> wrote:
> > --- a/include/linux/clkdev.h
> > +++ b/include/linux/clkdev.h
> > @@ -37,6 +37,9 @@ struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
> >  void clkdev_add(struct clk_lookup *cl);
> >  void clkdev_drop(struct clk_lookup *cl);
> >
> > +struct clk_lookup *clkdev_create(struct clk *clk, const char *con_id,
> > +       const char *dev_fmt, ...);
> 
> __printf(3, 4)
> 
> While you're at it, can you please also add the __printf attribute to
> clkdev_alloc() and clk_register_clkdev()?

What's the behaviour of __printf() with a NULL format string?  The
clkdev interfaces permit that, normal printf() doesn't.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
