Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2ITHjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 03:39:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 00/34] i.MX multi-platform support
Date: Thu, 20 Sep 2012 07:39:34 +0000
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
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209200739.34899.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 20 September 2012, Shawn Guo wrote:
> 
> Here is the second post, which should have addressed the comments that
> reviewers put on v1.
> 
> It's available on branch below.
> 
>   git://git.linaro.org/people/shawnguo/linux-2.6.git imx/multi-platform-v2
> 
> And it's based on the following branches.
> 
>   calxeda/multi-plat
>   arm-soc/multiplatform/platform-data
>   arm-soc/multiplatform/smp_ops
>   arm-soc/imx/cleanup
>   arm-soc/imx/dt
>   sound/for-3.7
> 
> Subsystem maintainers,
> 
> I plan to send the whole series for 3.7 via arm-soc tree.  Please let
> me know if you have problem with that.  Thanks.

The first five branches are scheduled to go through the arm-soc tree, so
I'm fine with that. For the sound/for-3.7 branch, I'd like to know when
to expect that hitting mainline. If it always gets in very early during the
merge window, it's probably ok to put the imx/multi-platform patches into
the same branch as the other ones in arm-soc and wait for the sound stuff
to hit mainline first, otherwise I'd suggest we start a second
next/multiplatform-2 branch for imx and send the first part early on
but then wait with the second batch before sound gets in.

	Arnd
