Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43630 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeKOG1M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 01:27:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Luis Oliveira <luis.oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        joao.pinto@synopsys.com, festevam@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Thierry Reding <treding@nvidia.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
Date: Wed, 14 Nov 2018 22:22:39 +0200
Message-ID: <1798955.5kaMj8jiTI@avalon>
In-Reply-To: <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com> <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,

Thank you for the patch.

On Friday, 19 October 2018 15:52:26 EET Luis Oliveira wrote:
> Add the Synopsys MIPI CSI-2 controller driver. This
> controller driver is divided in platform dependent functions
> and core functions. It also includes a platform for future
> DesignWare drivers.
> 
> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> ---
> Changelog
> v2-V3
> - exposed IPI settings to userspace

Could you please explain why you need this and can't use standard APIs ? 
Custom sysfs attributes are needed, they need to be documented in 
Documentation/ABI/.

> - fixed headers
> 
>  MAINTAINERS                              |  11 +
>  drivers/media/platform/dwc/Kconfig       |  30 +-
>  drivers/media/platform/dwc/Makefile      |   2 +
>  drivers/media/platform/dwc/dw-csi-plat.c | 699 ++++++++++++++++++++++++++++
>  drivers/media/platform/dwc/dw-csi-plat.h |  77 ++++
>  drivers/media/platform/dwc/dw-mipi-csi.c | 494 ++++++++++++++++++++++
>  drivers/media/platform/dwc/dw-mipi-csi.h | 202 +++++++++
>  include/media/dwc/dw-mipi-csi-pltfrm.h   | 102 +++++
>  8 files changed, 1616 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/platform/dwc/dw-csi-plat.c
>  create mode 100644 drivers/media/platform/dwc/dw-csi-plat.h
>  create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.c
>  create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.h
>  create mode 100644 include/media/dwc/dw-mipi-csi-pltfrm.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index da2e509..fd5f1fc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14032,6 +14032,16 @@ S:	Maintained
>  F:	drivers/dma/dwi-axi-dmac/
>  F:	Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.txt
> 
> +SYNOPSYS DESIGNWARE MIPI CSI-2 HOST VIDEO PLATFORM
> +M:	Luis Oliveira <luis.oliveira@synopsys.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/platform/dwc
> +F:	include/media/dwc/dw-mipi-csi-pltfrm.h
> +F:	Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
> +F:	Documentation/devicetree/bindings/phy/snps,dphy-rx.txt

These two lines belong to patches 1/4 and 3/4. Doesn't checkpatch.pl warn 
about this ? Now that I mentioned checkpatch.pl, I tried running it on this 
series, and it generates a fair number of warnings and errors. Could you 
please fix them ?

> +
>  SYNOPSYS DESIGNWARE DMAC DRIVER
>  M:	Viresh Kumar <vireshk@kernel.org>
>  R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> @@ -16217,3 +16227,4 @@ T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git S:	Buried
> alive in reporters
>  F:	*
>  F:	*/
> +

Stray new line.

[snip]

-- 
Regards,

Laurent Pinchart
