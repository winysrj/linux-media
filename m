Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49030 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640Ab2ITMrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:47:15 -0400
Date: Thu, 20 Sep 2012 08:47:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	alsa-devel@alsa-project.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, Chris Ball <cjb@laptop.org>,
	linux-mmc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	rtc-linux@googlegroups.com,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	linux-mtd@lists.infradead.org,
	Wolfram Sang <w.sang@pengutronix.de>,
	linux-i2c@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
	linux-watchdog@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@linux.intel.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH v2 00/34] i.MX multi-platform support
Message-ID: <20120920124709.GN17666@opensource.wolfsonmicro.com>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
 <201209200739.34899.arnd@arndb.de>
 <20120920114148.GH17666@opensource.wolfsonmicro.com>
 <20120920115213.GF2450@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920115213.GF2450@S2101-09.ap.freescale.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2012 at 07:52:15PM +0800, Shawn Guo wrote:
> On Thu, Sep 20, 2012 at 07:41:50AM -0400, Mark Brown wrote:

> > It's usually pretty early but Takashi will be on holiday this time so
> > I'm not sure if things might be different (he was going to send the pull
> > request from holiday).  I also didn't guarantee that it'll be stable
> > yet, can someone please tell me what the depenency is here?

> We need the patch to have all imx drivers mach/* inclusion free,
> so that we can enable multi-platform support for imx, which is the
> whole point of the series.

That doesn't answer the question.  What is the dependency - what is it
about this patch that something else depends on?  Your cover letters
just say you'd like to do this but don't mention dependencies at all and
when I asked the question last night you said the same thing.  I've not
seen the rest of the series...

> If your for-3.7 is not stable anyway, I guess the easiest the way

It probably *is* stable but I'm not enthused about people pulling
unsigned tags.  I might rebase, though - I'm going to finalise the tree
in the next few days.

> to do it might be you drop the patch "ASoC: mx27vis: retrieve gpio
> numbers from platform_data" from your tree and I have it be part of
> the series to go via arm-soc tree as a whole.  (This is the original
> plan that I mentioned in v1 cover letter)

You just mentioned it as a preference (you said it's something you'd
like to do), please if you're doing this sort of cross tree thing be
explicit about what the inter-tree relationships are.  If things need to
go in via the same tree say so explicitly (and ideally say way this is).

The main reason I applied it straight away was that Javier mentioned
that it was a bug fix and it's near the merge window and these random
ARM cleanup serieses never seem to go in quickly.
