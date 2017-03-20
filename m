Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:55656 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753404AbdCTIzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 04:55:23 -0400
Date: Mon, 20 Mar 2017 09:55:12 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Subject: Re: [PATCH 4/4] media: imx-media-capture: add frame sizes/interval
        enumeration
Message-ID: <20170320085512.GA20923@frolo.macqel>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk> <E1cpYOa-0006Eu-CL@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1cpYOa-0006Eu-CL@rmk-PC.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russel,

On Sun, Mar 19, 2017 at 10:49:08AM +0000, Russell King wrote:
> Add support for enumerating frame sizes and frame intervals from the
> first subdev via the V4L2 interfaces.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/staging/media/imx/imx-media-capture.c | 62 +++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
...
> +static int capture_enum_frameintervals(struct file *file, void *fh,
> +				       struct v4l2_frmivalenum *fival)
> +{
> +	struct capture_priv *priv = video_drvdata(file);
> +	const struct imx_media_pixfmt *cc;
> +	struct v4l2_subdev_frame_interval_enum fie = {
> +		.index = fival->index,
> +		.pad = priv->src_sd_pad,
> +		.width = fival->width,
> +		.height = fival->height,
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	int ret;
> +
> +	cc = imx_media_find_format(fival->pixel_format, CS_SEL_ANY, true);
> +	if (!cc)
> +		return -EINVAL;
> +
> +	fie.code = cc->codes[0];
> +
> +	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_interval, NULL, &fie);
> +	if (ret)
> +		return ret;
> +
> +	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +	fival->discrete = fie.interval;

For some parallel sensors (mine is a E2V ev76c560) "any" frame interval is possible,
and hence type should be V4L2_FRMIVAL_TYPE_CONTINUOUS.

see also https://www.spinics.net/lists/linux-media/msg98622.html,
https://patchwork.kernel.org/patch/9171201/ and
https://patchwork.kernel.org/patch/9171199/

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
