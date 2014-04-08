Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53502 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756628AbaDHMoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Apr 2014 08:44:03 -0400
Date: Tue, 8 Apr 2014 13:43:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Carikli <denis@eukrea.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12][ 03/12] imx-drm: Correct BGR666 and the board's
	dts that use them.
Message-ID: <20140408124317.GF16119@n2100.arm.linux.org.uk>
References: <1396874691-27954-1-git-send-email-denis@eukrea.com> <1396874691-27954-3-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396874691-27954-3-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 07, 2014 at 02:44:42PM +0200, Denis Carikli wrote:
>  arch/arm/boot/dts/imx51-apf51dev.dts    |    2 +-
>  arch/arm/boot/dts/imx53-m53evk.dts      |    2 +-
>  drivers/staging/imx-drm/imx-ldb.c       |    4 ++--
>  drivers/staging/imx-drm/ipu-v3/ipu-dc.c |    4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx51-apf51dev.dts b/arch/arm/boot/dts/imx51-apf51dev.dts
> index c5a9a24..7b3851d 100644
> --- a/arch/arm/boot/dts/imx51-apf51dev.dts
> +++ b/arch/arm/boot/dts/imx51-apf51dev.dts
> @@ -18,7 +18,7 @@
>  
>  	display@di1 {
>  		compatible = "fsl,imx-parallel-display";
> -		interface-pix-fmt = "bgr666";
> +		interface-pix-fmt = "rgb666";

...

>  	/* bgr666 */
>  	ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
> -	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 5, 0xfc); /* blue */
> +	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 17, 0xfc); /* blue */
>  	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /* green */
> -	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 17, 0xfc); /* red */
> +	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 5, 0xfc); /* red */

arm-soc people have become very obtuse with respect to changes to any
patches to arch/arm/boot/dts, and complain loudly if any changes to
that directory do not go through them as separate patches.

What this means is that your patch is unacceptable and needs to be split
up.

The choices seem to be to either break imx-drm by splitting the patch in
two, thereby ending up with the two dependent changes being merged
entirely separate, resulting in breakage while one or other is merged,
or to add the RGB666 support, wait for that to hit mainline, then
update the DT files, wait for that to hit mainline, then fix the BGR666
support.  That'll take around six to nine months (two to three months
per release cycle.)

Or arm-soc could come to their senses and realise that they do not have
sole ownership over arch/arm/boot/dts.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
