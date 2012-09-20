Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab2ITLmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 07:42:05 -0400
Date: Thu, 20 Sep 2012 07:41:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>,
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
Message-ID: <20120920114148.GH17666@opensource.wolfsonmicro.com>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
 <201209200739.34899.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209200739.34899.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2012 at 07:39:34AM +0000, Arnd Bergmann wrote:

> The first five branches are scheduled to go through the arm-soc tree, so
> I'm fine with that. For the sound/for-3.7 branch, I'd like to know when
> to expect that hitting mainline. If it always gets in very early during the
> merge window, it's probably ok to put the imx/multi-platform patches into
> the same branch as the other ones in arm-soc and wait for the sound stuff
> to hit mainline first, otherwise I'd suggest we start a second
> next/multiplatform-2 branch for imx and send the first part early on
> but then wait with the second batch before sound gets in.

It's usually pretty early but Takashi will be on holiday this time so
I'm not sure if things might be different (he was going to send the pull
request from holiday).  I also didn't guarantee that it'll be stable
yet, can someone please tell me what the depenency is here?
