Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50406 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754334AbeDWJIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:08:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: i2c: adv748x: Fix pixel rate values
Date: Mon, 23 Apr 2018 12:08:22 +0300
Message-ID: <19059407.fUISklDEzf@avalon>
In-Reply-To: <e5490bf5-38a0-4536-ed2d-c2d63edb6c39@ideasonboard.com>
References: <20180421124444.1652-1-laurent.pinchart+renesas@ideasonboard.com> <e5490bf5-38a0-4536-ed2d-c2d63edb6c39@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Monday, 23 April 2018 11:59:04 EEST Kieran Bingham wrote:
> On 21/04/18 13:44, Laurent Pinchart wrote:
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
> > 28.63636 MHz.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> This looks quite reasonable, and simplifies the code. Win win.
> 
> I presume this will have implications on the pixel receiver side (VIN in our
> case)... are there changes required there, or was it 'just wrong' here.

No change should be required on the VIN side. This patch was prompted by a BSP 
patch for VIN that aimed at fixing the same issue, but in the wrong location. 
See message 2461975.rTQ0tvdgNJ@avalon in the "[periperi] 2018-04-05 Multimedia 
group chat report" thread (Date: Sat, 21 Apr 2018 15:49:49 +0300).

> Either way,
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

As you maintain the adv748x driver, could you make sure this patch gets 
upstream ? :-)

> > ---
> > 
> >  drivers/media/i2c/adv748x/adv748x-afe.c  | 11 +++++------
> >  drivers/media/i2c/adv748x/adv748x-hdmi.c |  8 +-------
> >  2 files changed, 6 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c
> > b/drivers/media/i2c/adv748x/adv748x-afe.c index
> > 61514bae7e5c..3e18d5ae813b 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> > @@ -321,17 +321,16 @@ static const struct v4l2_subdev_video_ops
> > adv748x_afe_video_ops = {
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
> > +	 * The ADV748x samples analog video signals using an externally 
supplied
> > +	 * clock whose frequency is required to be 28.63636 MHz.
> > +	 */
> > +	return adv748x_csi2_set_pixelrate(tx, 28636360);
> >  }
> >  
> >  static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> > diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > b/drivers/media/i2c/adv748x/adv748x-hdmi.c index
> > 10d229a4f088..aecc2a84dfec 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > @@ -402,8 +402,6 @@ static int adv748x_hdmi_propagate_pixelrate(struct
> > adv748x_hdmi *hdmi)> 
> >  {
> >  	struct v4l2_subdev *tx;
> >  	struct v4l2_dv_timings timings;
> > -	struct v4l2_bt_timings *bt = &timings.bt;
> > -	unsigned int fps;
> > 
> >  	tx = adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
> >  	if (!tx)
> > @@ -411,11 +409,7 @@ static int adv748x_hdmi_propagate_pixelrate(struct
> > adv748x_hdmi *hdmi)
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

-- 
Regards,

Laurent Pinchart
