Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49475 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbeDTTKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 15:10:54 -0400
Date: Fri, 20 Apr 2018 21:10:42 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 01/12] media: ov5640: Add auto-focus feature
Message-ID: <20180420191042.e5utxnj6bdqqtynd@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-2-maxime.ripard@bootlin.com>
 <1761345.E0v0rRdO8P@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1761345.E0v0rRdO8P@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2018 at 01:36:39PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
> 
> Thank you for the patch.
> 
> On Monday, 16 April 2018 15:36:50 EEST Maxime Ripard wrote:
> > From: Mylène Josserand <mylene.josserand@bootlin.com>
> > 
> > Add the auto-focus ENABLE/DISABLE feature as V4L2 control.
> > Disabled by default.
> > 
> > Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  drivers/media/i2c/ov5640.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index 852026baa2e7..a33e45f8e2b0 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -82,8 +82,9 @@
> >  #define OV5640_REG_POLARITY_CTRL00	0x4740
> >  #define OV5640_REG_MIPI_CTRL00		0x4800
> >  #define OV5640_REG_DEBUG_MODE		0x4814
> > -#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
> > +#define OV5640_REG_ISP_CTRL03		0x5003
> >  #define OV5640_REG_PRE_ISP_TEST_SET1	0x503d
> > +#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
> >  #define OV5640_REG_SDE_CTRL0		0x5580
> >  #define OV5640_REG_SDE_CTRL1		0x5581
> >  #define OV5640_REG_SDE_CTRL3		0x5583
> > @@ -186,6 +187,7 @@ struct ov5640_ctrls {
> >  		struct v4l2_ctrl *auto_gain;
> >  		struct v4l2_ctrl *gain;
> >  	};
> > +	struct v4l2_ctrl *auto_focus;
> >  	struct v4l2_ctrl *brightness;
> >  	struct v4l2_ctrl *saturation;
> >  	struct v4l2_ctrl *contrast;
> > @@ -2155,6 +2157,12 @@ static int ov5640_set_ctrl_test_pattern(struct
> > ov5640_dev *sensor, int value) 0xa4, value ? 0xa4 : 0);
> >  }
> > 
> > +static int ov5640_set_ctrl_focus(struct ov5640_dev *sensor, int value)
> > +{
> > +	return ov5640_mod_reg(sensor, OV5640_REG_ISP_CTRL03,
> > +			      BIT(1), value ? BIT(1) : 0);
> 
> According to the datasheet, bit 1 in register 0x5003 is "Draw window for AFC 
> enable". The draw window module is further documented as being "used to 
> display a window on top of live video. It is usually used by autofocus to 
> display a focus window". Are you sure the bit controls the autofocus itself ?
> 
> Furthermore, do all 0V5640 camera modules include a VCM ?

Hmmm, double checking in the datasheet, it indeed looks like this is
not what we want here. And I haven't found something to do this. I'll
drop this patch.

Thanks!
Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
