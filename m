Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2ITP5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 11:57:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 00/34] i.MX multi-platform support
Date: Thu, 20 Sep 2012 15:56:56 +0000
Cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@linux.intel.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org> <201209200739.34899.arnd@arndb.de> <20120920145342.GI2450@S2101-09.ap.freescale.net>
In-Reply-To: <20120920145342.GI2450@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209201556.57171.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 20 September 2012, Shawn Guo wrote:
> 
> On Thu, Sep 20, 2012 at 07:39:34AM +0000, Arnd Bergmann wrote:
> > The first five branches are scheduled to go through the arm-soc tree, so
> > I'm fine with that. For the sound/for-3.7 branch, I'd like to know when
> > to expect that hitting mainline. If it always gets in very early during the
> > merge window, it's probably ok to put the imx/multi-platform patches into
> > the same branch as the other ones in arm-soc and wait for the sound stuff
> > to hit mainline first, otherwise I'd suggest we start a second
> > next/multiplatform-2 branch for imx and send the first part early on
> > but then wait with the second batch before sound gets in.
> > 
> It seems that we will have to go with next/multiplatform-2.  I just
> tried to merge the series with linux-next together, and got some
> non-trivial conflicts with media and mtd tree.  I might have to rebase
> my series on top of these trees to sort out those conflicts.  That said,
> I will have several dependencies outside arm-soc tree, and have to pend
> my series until all those trees get merged into mainline.

Ok, fair enough. I think we can put it in arm-soc/for-next as a staging
branch anyway to give it some exposure to linux-next, and then we can
decide whether a rebase is necessary before sending it to Linus.

	Arnd
