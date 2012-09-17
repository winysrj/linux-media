Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2IQLij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 07:38:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 00/34] i.MX multi-platform support
Date: Mon, 17 Sep 2012 11:38:13 +0000
Cc: Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>,
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
	Javier Martin <javier.martin@vista-silicon.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org> <20120917075138.GN6180@pengutronix.de>
In-Reply-To: <20120917075138.GN6180@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171138.13327.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 17 September 2012, Sascha Hauer wrote:
> On Mon, Sep 17, 2012 at 01:34:29PM +0800, Shawn Guo wrote:
> > The series enables multi-platform support for imx.  Since the required
> > frameworks (clk, pwm) and spare_irq have already been adopted on imx,
> > the series is all about cleaning up mach/* headers.  Along with the
> > changes, arch/arm/plat-mxc gets merged into arch/arm/mach-imx.
> > 
> > It's based on a bunch of branches (works from others), Rob's initial
> > multi-platform series, Arnd's platform-data and smp_ops (Marc's) and
> > imx 3.7 material (Sascha and myself).
> > 
> > It's available on branch below.
> > 
> >   git://git.linaro.org/people/shawnguo/linux-2.6.git imx/multi-platform
> > 
> > It's been tested on imx5 and imx6, and only compile-tested on imx2 and
> > imx3, so testing on imx2/3 are appreciated.
> 
> Great work! This really pushes the i.MX architecture one step closer to
> a clean code base.

I agree, this series is wonderful, I thought it would take much longer
to get this far.

Two small comments on the last two patches from me, but overall I really
love it.

Acked-by: Arnd Bergmann <arnd@arndb.de>
