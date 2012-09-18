Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62459 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2IRIUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 04:20:43 -0400
Received: by pbbrr13 with SMTP id rr13so10578482pbb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 01:20:42 -0700 (PDT)
Date: Tue, 18 Sep 2012 16:20:58 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@linux.intel.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH 00/34] i.MX multi-platform support
Message-ID: <20120918082055.GD6377@S2101-09.ap.freescale.net>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <20120917075138.GN6180@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917075138.GN6180@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 09:51:38AM +0200, Sascha Hauer wrote:
> I gave it a test on i.MX1, i.MX27, i.MX31 and i.MX35. All run fine, but
> the last patch breaks the imx_v4_v5_defconfig: Somehow it now defaults
> to ARMv7 based machines. I haven't looked into it, just reenabled
> ARMv4/ARMv5 and the boards again -> works. The config should be updated
> with the last patch.
> 
Yes, I will rework the patch with all these and Arnd's comment on the
last patch taken into account.

> I'm fine with the changes to mx2-camera, but Javier should give his ok
> to it, he has worked on it quite a lot recently.
> 
> One other issue related to imx-dma, see comment to that patch.
> 
> Otherwise:
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
Thanks a lot.

Shawn
