Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:41112 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeELXFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 19:05:42 -0400
Received: by mail-lf0-f65.google.com with SMTP id m17-v6so7681544lfj.8
        for <linux-media@vger.kernel.org>; Sat, 12 May 2018 16:05:42 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sun, 13 May 2018 01:05:39 +0200
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] media: i2c: adv748x: Fix pixel rate values
Message-ID: <20180512230539.GN18974@bigcity.dyn.berto.se>
References: <20180511140434.19274-1-niklas.soderlund+renesas@ragnatech.se>
 <2585299a-07a7-5596-7df2-fe476b695dcb@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2585299a-07a7-5596-7df2-fe476b695dcb@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your feedback.

On 2018-05-12 09:04:18 +0100, Kieran Bingham wrote:
> Hi Niklas, Laurent,
> 
> Thanks for the updated patch and detailed investigation to get this right.
> 
> On 11/05/18 15:04, Niklas Söderlund wrote:
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > The pixel rate, as reported by the V4L2_CID_PIXEL_RATE control, must
> > include both horizontal and vertical blanking. Both the AFE and HDMI
> > receiver program it incorrectly:
> > 
> > - The HDMI receiver goes to the trouble of removing blanking to compute
> > the rate of active pixels. This is easy to fix by removing the
> > computation and returning the incoming pixel clock rate directly.
> > 
> > - The AFE performs similar calculation, while it should simply return
> > the fixed pixel rate for analog sources, mandated by the ADV748x to be
> > 14.3180180 MHz.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > [Niklas: Update AFE fixed pixel rate]
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks,

> 
> Does this still require changes to the CSI2 driver to be synchronised?
> (or does it not matter as the CSI2 isn't upstream yet)...

Yes and no :-)

All but v14 of the R-Car CSI-2 patches use the method to calculate the 
link speed which works with this patch. v15 I'm hoping to post early 
next week will go back to the v13 way of interpret the PIXEL_RATE so all 
is well. But for the latest renesas-drivers release the CSI-2 v14 is 
included so if you work on that base this patch will be troublesome for 
CVBS capture.

> 
> --
> Kieran
> 
> 
> > ---
> > 
> > * Changes since v1
> > - Update AFE fixed pixel rate.
> > ---
> >  drivers/media/i2c/adv748x/adv748x-afe.c  | 12 ++++++------
> >  drivers/media/i2c/adv748x/adv748x-hdmi.c |  8 +-------
> >  2 files changed, 7 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> > index 61514bae7e5ceb42..edd25e895e5dec3c 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> > @@ -321,17 +321,17 @@ static const struct v4l2_subdev_video_ops adv748x_afe_video_ops = {
> >  static int adv748x_afe_propagate_pixelrate(struct adv748x_afe *afe)
> >  {
> >  	struct v4l2_subdev *tx;
> > -	unsigned int width, height, fps;
> >  
> >  	tx = adv748x_get_remote_sd(&afe->pads[ADV748X_AFE_SOURCE]);
> >  	if (!tx)
> >  		return -ENOLINK;
> >  
> > -	width = 720;
> > -	height = afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> > -	fps = afe->curr_norm & V4L2_STD_525_60 ? 30 : 25;
> > -
> > -	return adv748x_csi2_set_pixelrate(tx, width * height * fps);
> > +	/*
> > +	 * The ADV748x ADC sampling frequency is twice the externally supplied
> > +	 * clock whose frequency is required to be 28.63636 MHz. It oversamples
> > +	 * with a factor of 4 resulting in a pixel rate of 14.3180180 MHz.
> > +	 */
> > +	return adv748x_csi2_set_pixelrate(tx, 14318180);
> >  }
> >  
> >  static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> > diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > index 10d229a4f08868f7..aecc2a84dfecbec8 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > @@ -402,8 +402,6 @@ static int adv748x_hdmi_propagate_pixelrate(struct adv748x_hdmi *hdmi)
> >  {
> >  	struct v4l2_subdev *tx;
> >  	struct v4l2_dv_timings timings;
> > -	struct v4l2_bt_timings *bt = &timings.bt;
> > -	unsigned int fps;
> >  
> >  	tx = adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
> >  	if (!tx)
> > @@ -411,11 +409,7 @@ static int adv748x_hdmi_propagate_pixelrate(struct adv748x_hdmi *hdmi)
> >  
> >  	adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
> >  
> > -	fps = DIV_ROUND_CLOSEST_ULL(bt->pixelclock,
> > -				    V4L2_DV_BT_FRAME_WIDTH(bt) *
> > -				    V4L2_DV_BT_FRAME_HEIGHT(bt));
> > -
> > -	return adv748x_csi2_set_pixelrate(tx, bt->width * bt->height * fps);
> > +	return adv748x_csi2_set_pixelrate(tx, timings.bt.pixelclock);
> >  }
> >  
> >  static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
> > 
> 




-- 
Regards,
Niklas Söderlund
