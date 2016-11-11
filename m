Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56750 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756531AbcKKNsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 08:48:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] media: i2c: max2175: Add MAX2175 support
Date: Fri, 11 Nov 2016 15:48:04 +0200
Message-ID: <1903855.3Xg5AI8ucK@avalon>
In-Reply-To: <46394837-c3f0-8487-750b-95dae7bcf859@xs4all.nl>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <46394837-c3f0-8487-750b-95dae7bcf859@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 11 Nov 2016 14:21:22 Hans Verkuil wrote:
> On 11/09/2016 04:44 PM, Ramesh Shanmugasundaram wrote:
> > This patch adds driver support for MAX2175 chip. This is Maxim
> > Integrated's RF to Bits tuner front end chip designed for software-defined
> > radio solutions. This driver exposes the tuner as a sub-device instance
> > with standard and custom controls to configure the device.
> > 
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com> ---
> > 
> >  .../devicetree/bindings/media/i2c/max2175.txt      |   61 +
> >  drivers/media/i2c/Kconfig                          |    4 +
> >  drivers/media/i2c/Makefile                         |    2 +
> >  drivers/media/i2c/max2175/Kconfig                  |    8 +
> >  drivers/media/i2c/max2175/Makefile                 |    4 +
> >  drivers/media/i2c/max2175/max2175.c                | 1558 +++++++++++++++
> >  drivers/media/i2c/max2175/max2175.h                |  108 ++
> >  7 files changed, 1745 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/i2c/max2175.txt
> >  create mode 100644 drivers/media/i2c/max2175/Kconfig
> >  create mode 100644 drivers/media/i2c/max2175/Makefile
> >  create mode 100644 drivers/media/i2c/max2175/max2175.c
> >  create mode 100644 drivers/media/i2c/max2175/max2175.h
> 
> <snip>
> 
> > diff --git a/drivers/media/i2c/max2175/max2175.c
> > b/drivers/media/i2c/max2175/max2175.c new file mode 100644
> > index 0000000..ec45b52
> > --- /dev/null
> > +++ b/drivers/media/i2c/max2175/max2175.c
> > @@ -0,0 +1,1558 @@
> 
> <snip>
> 
> > +/* Read/Write bit(s) on top of regmap */
> > +static int max2175_read(struct max2175 *ctx, u8 idx, u8 *val)
> > +{
> > +	u32 regval;
> > +	int ret = regmap_read(ctx->regmap, idx, &regval);
> > +
> > +	if (ret)
> > +		v4l2_err(ctx->client, "read ret(%d): idx 0x%02x\n", ret, idx);

By the way, I think I've seen a proposal to get rid of v4l2_err() in favour of 
dev_err(), was I dreaming or should this patch use dev_err() already ?

> > +
> > +	*val = regval;
> 
> Does regmap_read initialize regval even if it returns an error? If not,
> then I would initialize regval to 0 to prevent *val being uninitialized.

Better than that the error should be propagated to the caller and handled.

> > +	return ret;
> > +}

[snip]

> > +static int max2175_band_from_freq(u32 freq)
> > +{
> > +	if (freq >= 144000 && freq <= 26100000)
> > +		return MAX2175_BAND_AM;
> > +	else if (freq >= 65000000 && freq <= 108000000)
> > +		return MAX2175_BAND_FM;
> > +	else
> 
> No need for these 'else' keywords.

Indeed by in my opinion they improve readability :-)

> > +		return MAX2175_BAND_VHF;
> > +}

[snip]

> > +static const struct v4l2_ctrl_config max2175_na_rx_mode = {
> > +	.ops = &max2175_ctrl_ops,
> > +	.id = V4L2_CID_MAX2175_RX_MODE,
> > +	.name = "RX MODE",
> > +	.type = V4L2_CTRL_TYPE_MENU,
> > +	.max = ARRAY_SIZE(max2175_ctrl_na_rx_modes) - 1,
> > +	.def = 0,
> > +	.qmenu = max2175_ctrl_na_rx_modes,
> > +};
> 
> Please document all these controls better. This is part of the public API,
> so you need to give more information what this means exactly.

Should that go to Documentation/media/v4l-drivers/ ? If so "[PATCH v4 3/4] 
v4l: Add Renesas R-Car FDP1 Driver" can be used as an example.

[snip]

-- 
Regards,

Laurent Pinchart

