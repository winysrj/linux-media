Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48756 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753417AbdEDOmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 10:42:11 -0400
Date: Thu, 4 May 2017 17:41:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v4 12/27] rcar-vin: read subdevice format for crop only
 when needed
Message-ID: <20170504144132.GX7456@valkosipuli.retiisi.org.uk>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427224203.14611-13-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170427224203.14611-13-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Apr 28, 2017 at 12:41:48AM +0200, Niklas Söderlund wrote:
> Instead of caching the subdevice format each time the video device
> format is set read it directly when its needed. As it turns out the
> format is only needed when figuring out the max rectangle for cropping.
> 
> This simplify the code and makes it clearer what the source format is
> used for.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 76 ++++++++++++++++-------------
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 12 -----
>  2 files changed, 42 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 919040e40aec60f6..80421421625e6f6f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -90,6 +90,24 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
>   * V4L2
>   */
>  
> +static int rvin_get_sd_format(struct rvin_dev *vin, struct v4l2_pix_format *pix)
> +{
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	int ret;
> +
> +	fmt.pad = vin->digital.source_pad;

You can assign .pad in declaration, too.

> +
> +	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pix, &fmt.format);
> +
> +	return 0;
> +}

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
