Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42715 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753565AbdEHJhc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 05:37:32 -0400
Message-ID: <1494236207.3029.66.camel@pengutronix.de>
Subject: Re: [PATCH] [media] imx: csi: retain current field order and
 colorimetry setting as default
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
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
Date: Mon, 08 May 2017 11:36:47 +0200
In-Reply-To: <0632df59-10e7-1e03-c0f6-eb7c90b83c0d@xs4all.nl>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
         <1490661656-10318-22-git-send-email-steve_longerbeam@mentor.com>
         <1491486929.2392.29.camel@pengutronix.de>
         <0632df59-10e7-1e03-c0f6-eb7c90b83c0d@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2017-05-08 at 10:27 +0200, Hans Verkuil wrote:
> Hi Philipp,
> 
> Sorry for the very long delay, but I finally had some time to think about this.

Thank you for your thoughts.

> On 04/06/2017 03:55 PM, Philipp Zabel wrote:
> > If the the field order is set to ANY in set_fmt, choose the currently
> > set field order. If the colorspace is set to DEFAULT, choose the current
> > colorspace.  If any of xfer_func, ycbcr_enc or quantization are set to
> > DEFAULT, either choose the current setting, or the default setting for the
> > new colorspace, if non-DEFAULT colorspace was given.
> > 
> > This allows to let field order and colorimetry settings be propagated
> > from upstream by calling media-ctl on the upstream entity source pad,
> > and then call media-ctl on the sink pad to manually set the input frame
> > interval, without changing the already set field order and colorimetry
> > information.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > This is based on imx-media-staging-md-v14, and it is supposed to allow
> > configuring the pipeline with media-ctl like this:
> > 
> > 1) media-ctl --set-v4l2 "'tc358743 1-000f':0[fmt:UYVY8_1X16/1920x1080]"
> > 2) media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY8_1X16/1920x108]"
> > 3) media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080]"
> > 4) media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY8_1X16/1920x1080@1/60]"
> > 5) media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/1920x1080@1/30]"
> > 
> > Without having step 4) overwrite the colorspace and field order set on
> > 'ipu1_csi0':0 by the propagation in step 3).
> > ---
> >  drivers/staging/media/imx/imx-media-csi.c | 34 +++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> > index 64dc454f6b371..d94ce1de2bf05 100644
> > --- a/drivers/staging/media/imx/imx-media-csi.c
> > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > @@ -1325,6 +1325,40 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
> >  	csi_try_fmt(priv, sensor, cfg, sdformat, crop, compose, &cc);
> >  
> >  	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
> > +
> > +	/* Retain current field setting as default */
> > +	if (sdformat->format.field == V4L2_FIELD_ANY)
> > +		sdformat->format.field = fmt->field;
> 
> This is OK.

Would this be a "may" or a "should"? As in,
"If SUBDEV_S_FMT is called with field == ANY, the driver may/should set
field to the previously configured interlacing field order".

What would be the correct place to document this behaviour?
Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst?

> > +	/* Retain current colorspace setting as default */
> > +	if (sdformat->format.colorspace == V4L2_COLORSPACE_DEFAULT) {
> > +		sdformat->format.colorspace = fmt->colorspace;
> > +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT)
> > +			sdformat->format.xfer_func = fmt->xfer_func;
> > +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> > +			sdformat->format.ycbcr_enc = fmt->ycbcr_enc;
> > +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT)
> > +			sdformat->format.quantization = fmt->quantization;
> 
> If sdformat->format.colorspace == V4L2_COLORSPACE_DEFAULT, then you can just copy
> all four fields from fmt to sdformat->format. The other three fields are meaningless
> when colorspace == V4L2_COLORSPACE_DEFAULT.

Ok, good. Ignoring the transfer function / YCbCr encoding / quantization
range fields when colorspace is DEFAULT would simplify this part to:

	if (sdformat->format.colorspace == V4L2_COLORSPACE_DEFAULT) {
		sdformat->format.colorspace = fmt->colorspace;
		sdformat->format.xfer_func = fmt->xfer_func;
		sdformat->format.ycbcr_enc = fmt->ycbcr_enc;
		sdformat->format.quantization = fmt->quantization;
	}

Is that expectation already written down somewhere? If not, should we
add it to Documentation/media/uapi/v4l/pixfmt-006.rst?

> > +	} else {
> > +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT) {
> > +			sdformat->format.xfer_func =
> > +				V4L2_MAP_XFER_FUNC_DEFAULT(
> > +						sdformat->format.colorspace);
> > +		}
> > +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
> > +			sdformat->format.ycbcr_enc =
> > +				V4L2_MAP_YCBCR_ENC_DEFAULT(
> > +						sdformat->format.colorspace);
> > +		}
> > +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT) {
> > +			sdformat->format.quantization =
> > +				V4L2_MAP_QUANTIZATION_DEFAULT(
> > +						cc->cs != IPUV3_COLORSPACE_YUV,
> > +						sdformat->format.colorspace,
> > +						sdformat->format.ycbcr_enc);
> > +		}
> 
> Is this needed for validation? Currently these fields play no role in the
> default link validation. Which I think is actually the right thing to do,
> unless the subdev can do actual colorspace conversion.

The CSI subdevice can't do colorspace conversion, but exactly the same
applies to the IC subdevices, which can. Also I'd like this information
to be correct, as the /dev/videoX capture device takes its colorspace
information from the CSI source pad.

The problem I wanted to solve here initially was that if the colorspace
information was previously set correctly:

  media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY8_1X16/1920x1080@1/60 colorspace:rec709 xfer:709 ycbcr:709 quantization:lim-range]"
    ->
	V4L2_COLORSPACE_REC709
	V4L2_XFER_FUNC_709
	V4L2_YCBCR_ENC_709
	V4L2_QUANTIZATION_LIMITED_RANGE

A later media-ctl call to just change the frame interval would overwrite the colorspace information:

  media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY8_1X16/1920x1080@1/30]"
    ->
	V4L2_COLORSPACE_DEFAULT
	V4L2_XFER_FUNC_DEFAULT
	V4L2_YCBCR_ENC_DEFAULT
	V4L2_QUANTIZATION_DEFAULT

> I would just drop the whole 'else' here.

That would allow to set the actual colorspace information reported by
SUBDEV_G_FMT on both sink and source pads (and by extension, the
colorspace information reported by G_FMT on /dev/videoX) to
V4L2_{XFER_FUNC,YCBCR_ENC,QUANTIZATION}_DEFAULT.

  media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY8_1X16/1920x1080 colorspace:rec709]"
    ->
	V4L2_COLORSPACE_REC709
	V4L2_XFER_FUNC_DEFAULT
	V4L2_YCBCR_ENC_DEFAULT
	V4L2_QUANTIZATION_DEFAULT

I suppose that is acceptable as given the colorspace, the other DEFAULT
values have a unique meaning, but wouldn't it be nicer to show userspace
what these default inputs actually map to?

> Actually, wouldn't it be better to always just copy this information from
> fmt? This subdev doesn't do any colorspace conversion, it just passes on
> this information. I.e., you can't set it in any meaningful way.

csi_set_fmt on the sink pad is the function that actually sets fmt in
the first place. If we always copy colorspace information from fmt, it
can't be set to the correct value at all.

regards
Philipp
