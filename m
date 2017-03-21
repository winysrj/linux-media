Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33393 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933121AbdCUX5C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 19:57:02 -0400
Subject: Re: [PATCH v5 38/39] media: imx: csi: fix crop rectangle reset in
 sink set_fmt
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
 <20170319152233.GW21222@n2100.armlinux.org.uk>
 <327d67d9-68c1-7f74-0c0f-f6aee1c4b546@gmail.com>
 <1490010926.2917.59.camel@pengutronix.de>
 <20170320120855.GH21222@n2100.armlinux.org.uk>
 <1490018451.2917.86.camel@pengutronix.de>
 <20170320141705.GL21222@n2100.armlinux.org.uk>
 <1490030604.2917.103.camel@pengutronix.de>
 <20170321112741.GV21222@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1d382b89-fac3-a413-55a3-06cd2b751322@gmail.com>
Date: Tue, 21 Mar 2017 16:56:52 -0700
MIME-Version: 1.0
In-Reply-To: <20170321112741.GV21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/21/2017 04:27 AM, Russell King - ARM Linux wrote:
> On Mon, Mar 20, 2017 at 06:23:24PM +0100, Philipp Zabel wrote:
>> @@ -1173,15 +1196,8 @@ static void csi_try_fmt(struct csi_priv *priv,
>>  		incc = imx_media_find_mbus_format(infmt->code,
>>  						  CS_SEL_ANY, true);
>>
>> -		if (sdformat->format.width < priv->crop.width * 3 / 4)
>> -			sdformat->format.width = priv->crop.width / 2;
>> -		else
>> -			sdformat->format.width = priv->crop.width;
>> -
>> -		if (sdformat->format.height < priv->crop.height * 3 / 4)
>> -			sdformat->format.height = priv->crop.height / 2;
>> -		else
>> -			sdformat->format.height = priv->crop.height;
>> +		sdformat->format.width = compose->width;
>> +		sdformat->format.height = compose->height;
>>
>>  		if (incc->bayer) {
>>  			sdformat->format.code = infmt->code;
>
> We need to do more in here, because right now setting the source pads
> overwrites the colorimetry etc information.  Maybe something like the
> below?

I'm thinking, to support propagating the colorimetry params, there
should be a util function

void imx_media_copy_colorimetry(struct v4l2_mbus_framefmt *out,
				struct v4l2_mbus_framefmt *in);

that can be used throughout the pipeline, that does exactly what
you add below.

>  I'm wondering if it would be a saner approach to copy the
> sink format and update the parameters that can be changed, rather than
> trying to list all the parameters that shouldn't be changed.

For CSI that is a bit difficult, because the source formats are
hardly related to the sink formats, so so much would have to be
modified after copying the sink format that it would be rather
pointless, except to forward the colorimetry params.

Steve

>  What if the format structure gains a new member?
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 1492b92e1970..756204ced53c 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1221,6 +1221,12 @@ static void csi_try_fmt(struct csi_priv *priv,
>  			sdformat->format.field =  (infmt->height == 480) ?
>  				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
>  		}
> +
> +		/* copy settings we can't change */
> +		sdformat->format.colorspace = infmt->colorspace;
> +		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
> +		sdformat->format.quantization = infmt->quantization;
> +		sdformat->format.xfer_func = infmt->xfer_func;
>  		break;
>  	case CSI_SINK_PAD:
>  		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
>
>
>
