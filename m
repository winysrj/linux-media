Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49303 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbeDTTEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 15:04:22 -0400
Date: Fri, 20 Apr 2018 21:04:10 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 02/12] media: ov5640: Add light frequency control
Message-ID: <20180420190410.v34fjtmcs57otbcg@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-3-maxime.ripard@bootlin.com>
 <1757295.VWosiQ25QR@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1757295.VWosiQ25QR@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Apr 19, 2018 at 12:44:18PM +0300, Laurent Pinchart wrote:
> On Monday, 16 April 2018 15:36:51 EEST Maxime Ripard wrote:
> > From: Mylène Josserand <mylene.josserand@bootlin.com>
> > 
> > Add the light frequency control to be able to set the frequency
> > to manual (50Hz or 60Hz) or auto.
> > 
> > Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  drivers/media/i2c/ov5640.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index a33e45f8e2b0..28122341fc35 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -189,6 +189,7 @@ struct ov5640_ctrls {
> >  	};
> >  	struct v4l2_ctrl *auto_focus;
> >  	struct v4l2_ctrl *brightness;
> > +	struct v4l2_ctrl *light_freq;
> >  	struct v4l2_ctrl *saturation;
> >  	struct v4l2_ctrl *contrast;
> >  	struct v4l2_ctrl *hue;
> > @@ -2163,6 +2164,21 @@ static int ov5640_set_ctrl_focus(struct ov5640_dev
> > *sensor, int value) BIT(1), value ? BIT(1) : 0);
> >  }
> > 
> > +static int ov5640_set_ctl_light_freq(struct ov5640_dev *sensor, int value)
> 
> To stay consistent with the other functions, I propose calling this 
> ov5640_set_ctrl_light_freq().
> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Consider it fixed in the next iteration, thanks!
Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
