Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55187 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbcARWo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 17:44:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-renesas-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update mailing list for Renesas SoC Development
Date: Tue, 19 Jan 2016 00:44:44 +0200
Message-ID: <12016344.fKDjJZKU1J@avalon>
In-Reply-To: <1453079073-30937-1-git-send-email-horms+renesas@verge.net.au>
References: <1453079073-30937-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thank you for the patch.

On Monday 18 January 2016 10:04:33 Simon Horman wrote:
> Update the mailing list used for development of support for
> Renesas SoCs and related drivers.
> 
> Up until now the linux-sh mailing list has been used, however,
> Renesas SoCs are now much wider than the SH architecture and there
> is some desire from some for the linux-sh list to refocus on
> discussion of the work on the SH architecture.
> 
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> ---
> * This patch applies on top of Linus's tree where currently the head commit
>   is 984065055e6e ("Merge branch 'drm-next' of
>   git://people.freedesktop.org/~airlied/linux")
> 
>   This has been used as a base instead of v4.4 so that it is based on the
>   following two commits which affect it:
>   - 1a4ca6dd3dc8 ("MAINTAINERS: Add co-maintainer for Renesas Pin
> Controllers")
>   - 3e46c3973cba ("MAINTAINERS: add Renesas usb2 phy driver")
> ---
>  MAINTAINERS | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d23f701489c..52a6ba79fa3f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1531,9 +1531,9 @@ F:	drivers/media/platform/s5p-jpeg/
>  ARM/SHMOBILE ARM ARCHITECTURE
>  M:	Simon Horman <horms@verge.net.au>
>  M:	Magnus Damm <magnus.damm@gmail.com>
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  W:	http://oss.renesas.com
> -Q:	http://patchwork.kernel.org/project/linux-sh/list/
> +Q:	http://patchwork.kernel.org/project/linux-renesas-soc/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git 
next
> S:	Supported
>  F:	arch/arm/boot/dts/emev2*
> @@ -3745,7 +3745,7 @@
> F:	Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.tx
> t DRM DRIVERS FOR RENESAS
>  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:	dri-devel@lists.freedesktop.org
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  T:	git git://people.freedesktop.org/~airlied/linux
>  S:	Supported
>  F:	drivers/gpu/drm/rcar-du/
> @@ -6858,7 +6858,7 @@ F:	drivers/iio/potentiometer/mcp4531.c
>  MEDIA DRIVERS FOR RENESAS - VSP1
>  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:	linux-media@vger.kernel.org
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Supported
>  F:	Documentation/devicetree/bindings/media/renesas,vsp1.txt
> @@ -8235,7 +8235,7 @@ F:	drivers/pci/host/pci-dra7xx.c
>  PCI DRIVER FOR RENESAS R-CAR
>  M:	Simon Horman <horms@verge.net.au>
>  L:	linux-pci@vger.kernel.org
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  S:	Maintained
>  F:	drivers/pci/host/*rcar*
> 
> @@ -8413,7 +8413,7 @@ F:	drivers/pinctrl/intel/
>  PIN CONTROLLER - RENESAS
>  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  M:	Geert Uytterhoeven <geert+renesas@glider.be>
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  S:	Maintained
>  F:	drivers/pinctrl/sh-pfc/
> 
> @@ -9019,13 +9019,13 @@ F:	include/linux/rpmsg.h
>  RENESAS ETHERNET DRIVERS
>  R:	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>  L:	netdev@vger.kernel.org
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  F:	drivers/net/ethernet/renesas/
>  F:	include/linux/sh_eth.h
> 
>  RENESAS USB2 PHY DRIVER
>  M:	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> -L:	linux-sh@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
>  S:	Maintained
>  F:	drivers/phy/phy-rcar-gen3-usb2.c

-- 
Regards,

Laurent Pinchart

