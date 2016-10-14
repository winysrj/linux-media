Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52250 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753574AbcJNPsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:48:52 -0400
Message-ID: <1476460130.11834.44.camel@pengutronix.de>
Subject: Re: [PATCH 18/22] [media] imx-ipuv3-csi: support downsizing
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Marek Vasut <marex@denx.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
Date: Fri, 14 Oct 2016 17:48:50 +0200
In-Reply-To: <51b1da71-720f-1c82-a42b-74be35992054@denx.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-19-p.zabel@pengutronix.de>
         <51b1da71-720f-1c82-a42b-74be35992054@denx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 07.10.2016, 21:01 +0200 schrieb Marek Vasut:
> On 10/07/2016 06:01 PM, Philipp Zabel wrote:
> > Add support for the CSI internal horizontal and vertical downsizing.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/imx/imx-ipuv3-csi.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
> > index 699460e6..e8a6a7b 100644
> > --- a/drivers/media/platform/imx/imx-ipuv3-csi.c
> > +++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
> > @@ -167,8 +167,16 @@ static int ipucsi_subdev_set_format(struct v4l2_subdev *sd,
> >  		width = clamp_t(unsigned int, sdformat->format.width, 16, 8192);
> >  		height = clamp_t(unsigned int, sdformat->format.height, 16, 4096);
> >  	} else {
> > -		width = ipucsi->format_mbus[0].width;
> > -		height = ipucsi->format_mbus[0].height;
> > +		if (sdformat->format.width <
> > +		    (ipucsi->format_mbus[0].width * 3 / 4))
> > +			width = ipucsi->format_mbus[0].width / 2;
> > +		else
> > +			width = ipucsi->format_mbus[0].width;
> > +		if (sdformat->format.height <
> > +		    (ipucsi->format_mbus[0].height * 3 / 4))
> > +			height = ipucsi->format_mbus[0].height / 2;
> > +		else
> > +			height = ipucsi->format_mbus[0].height;
> >  	}
> >  
> >  	mbusformat = __ipucsi_get_pad_format(sd, cfg, sdformat->pad,
> > @@ -212,14 +220,14 @@ static int ipucsi_subdev_s_stream(struct v4l2_subdev *sd, int enable)
> >  		window.width = fmt[0].width;
> >  		window.height = fmt[0].height;
> >  		ipu_csi_set_window(ipucsi->csi, &window);
> > +		ipu_csi_set_downsize(ipucsi->csi,
> > +				     fmt[0].width == 2 * fmt[1].width,
> > +				     fmt[0].height == 2 * fmt[1].height);
> >  
> >  		/* Is CSI data source MCT (MIPI)? */
> >  		mux_mct = (mbus_config.type == V4L2_MBUS_CSI2);
> > -
> >  		ipu_set_csi_src_mux(ipucsi->ipu, ipucsi->id, mux_mct);
> > -		if (mux_mct)
> > -			ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0,
> > -						  &fmt[0]);
> > +		ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0, &fmt[0]);
> 
> This probably needs fixing , so that the correct VC is passed in ?

Absolutely, right now I don't know how though.
We are still missing API to set the MIPI CSI-2 virtual channel.

regards
Philipp

