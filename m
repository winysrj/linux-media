Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39299 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2IUQxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 12:53:23 -0400
Received: by pbbrr4 with SMTP id rr4so3013395pbb.19
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2012 09:53:23 -0700 (PDT)
Date: Sat, 22 Sep 2012 00:53:08 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	linux-fbdev@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
	linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Chris Ball <cjb@laptop.org>, linux-media@vger.kernel.org,
	linux-watchdog@vger.kernel.org, rtc-linux@googlegroups.com,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-arm-kernel@lists.infradead.org,
	Vinod Koul <vinod.koul@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
	Wolfram Sang <w.sang@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [alsa-devel] [PATCH v2 00/34] i.MX multi-platform support
Message-ID: <20120921165305.GB5394@S2101-09.ap.freescale.net>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
 <201209200739.34899.arnd@arndb.de>
 <20120920145342.GI2450@S2101-09.ap.freescale.net>
 <201209201556.57171.arnd@arndb.de>
 <20120921080123.GM2450@S2101-09.ap.freescale.net>
 <CAOesGMi6CbvFikycJVdE8W-DxLD3W7+CyScz+YT103dxR31U9g@mail.gmail.com>
 <20120921164622.GA5394@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921164622.GA5394@S2101-09.ap.freescale.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 22, 2012 at 12:46:26AM +0800, Shawn Guo wrote:
> I just published the branch below with this series rebased on top of
> the necessary dependant branches.
> 
>   git://git.linaro.org/people/shawnguo/linux-2.6.git staging/imx-multiplatform
> 
> The dependant branches include:
> 

Forgot the base:

  * arm-soc/next/multiplatform

Shawn

> * arm-soc/multiplatform/platform-data
> 
> * arm-soc/multiplatform/smp_ops
> 
> * git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-3.7
> 
>   It contains dependant patch "ASoC: mx27vis: retrieve gpio numbers
>   from platform_data"
> 
> * git://git.infradead.org/mtd-2.6.git master
> 
>   The series is based on this tree to solve some non-trivial conflicts
>   on mxc_nand driver.  Because mtd tree completely missed 3.6 merge
>   window, having the series base on 3.6-rc actually means 3.5 code base
>   in term of mtd support.  There are currently two cycles changes
>   accumulated on mtd, and we need to base the series on it to sort out
>   the conflicts.
> 
> * git://linuxtv.org/mchehab/media-next.git master
> 
>   The media tree renames mx2/mx3 camera drivers twice.  I'm not sure
>   if git merge can detect them, so I just rebased the series on media
>   tree to solve that.  The bonus point is that a number of trivial
>   conflicts with imx27-coda support on media tree gets solved as well.
> 
> I'm not requesting you to pull the branch into arm-soc as a stable
> branch but staging one, because the external dependencies which might
> not be stable.  I attempt to use it for exposing the series on
> linux-next, so that we can send it to Linus for 3.7 if there is chance
> for us to (e.g. all the dependant branches hit mainline early during
> 3.7 merge window).
