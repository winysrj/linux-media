Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38497 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2IRIFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 04:05:31 -0400
Received: by pbbrr13 with SMTP id rr13so10554472pbb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 01:05:31 -0700 (PDT)
Date: Tue, 18 Sep 2012 16:05:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: alsa-devel@alsa-project.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	linux-fbdev@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
	linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Chris Ball <cjb@laptop.org>, linux-media@vger.kernel.org,
	linux-watchdog@vger.kernel.org, rtc-linux@googlegroups.com,
	Rob Herring <rob.herring@calxeda.com>,
	linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Vinod Koul <vinod.koul@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
	Wolfram Sang <w.sang@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [alsa-devel] [PATCH 00/34] i.MX multi-platform support
Message-ID: <20120918080541.GA6377@S2101-09.ap.freescale.net>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <20120918075213.GD24458@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918075213.GD24458@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 09:52:13AM +0200, Sascha Hauer wrote:
> I just had a look at the remaining initcalls in arch-imx. Most of them
> are protected with a cpu_is_*, but this one should be fixed before i.MX
> is enabled for multi platform:
> 
> arch/arm/mach-imx/devices/devices.c:48:core_initcall(mxc_device_init);
> 
Ah, I missed that.  Thanks for reminding, Sascha.

Shawn
