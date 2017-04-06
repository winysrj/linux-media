Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54978 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756064AbdDFOjw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 10:39:52 -0400
Date: Thu, 6 Apr 2017 15:38:56 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
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
Message-ID: <20170406143856.GG17774@n2100.armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-22-git-send-email-steve_longerbeam@mentor.com>
 <1491486929.2392.29.camel@pengutronix.de>
 <0f9690f8-c7f6-59ff-9e3e-123af9972d4b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9690f8-c7f6-59ff-9e3e-123af9972d4b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 06, 2017 at 04:20:21PM +0200, Hans Verkuil wrote:
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
> sdformat->format.field should never be FIELD_ANY. If it is, then that's a
> subdev bug and I'm pretty sure FIELD_NONE was intended.

Please explain further - sdformat->format.field is the field passed _in_
from userspace, and from what I can see, userspace is free to pass in
any value through the ioctl as check_format() does nothing to validate
that the various format.* fields are sane.

This patch is detecting that the user is requesting FIELD_ANY, and
fixing it up.  Surely that's the right thing to do, and is way more
preferable than just accepting the FIELD_ANY from userspace and
storing that value?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
