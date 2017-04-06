Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54510 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933624AbdDFOGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 10:06:39 -0400
Date: Thu, 6 Apr 2017 15:05:33 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH] [media] imx: csi: retain current field order and
 colorimetry setting as default
Message-ID: <20170406140533.GF17774@n2100.armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-22-git-send-email-steve_longerbeam@mentor.com>
 <1491486929.2392.29.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491486929.2392.29.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 06, 2017 at 03:55:29PM +0200, Philipp Zabel wrote:
> +
> +	/* Retain current field setting as default */
> +	if (sdformat->format.field == V4L2_FIELD_ANY)
> +		sdformat->format.field = fmt->field;
> +
> +	/* Retain current colorspace setting as default */
> +	if (sdformat->format.colorspace == V4L2_COLORSPACE_DEFAULT) {
> +		sdformat->format.colorspace = fmt->colorspace;
> +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT)
> +			sdformat->format.xfer_func = fmt->xfer_func;
> +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> +			sdformat->format.ycbcr_enc = fmt->ycbcr_enc;
> +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT)
> +			sdformat->format.quantization = fmt->quantization;
> +	} else {
> +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT) {
> +			sdformat->format.xfer_func =
> +				V4L2_MAP_XFER_FUNC_DEFAULT(
> +						sdformat->format.colorspace);
> +		}
> +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
> +			sdformat->format.ycbcr_enc =
> +				V4L2_MAP_YCBCR_ENC_DEFAULT(
> +						sdformat->format.colorspace);
> +		}
> +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT) {
> +			sdformat->format.quantization =
> +				V4L2_MAP_QUANTIZATION_DEFAULT(
> +						cc->cs != IPUV3_COLORSPACE_YUV,
> +						sdformat->format.colorspace,
> +						sdformat->format.ycbcr_enc);
> +		}
> +	}

Would it make sense for this to be a helper function?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
