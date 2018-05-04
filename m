Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:46725 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751819AbeEDW6N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 18:58:13 -0400
Received: by mail-lf0-f41.google.com with SMTP id v85-v6so33027953lfa.13
        for <linux-media@vger.kernel.org>; Fri, 04 May 2018 15:58:13 -0700 (PDT)
Date: Sat, 5 May 2018 00:58:10 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: i2c: adv748x: Fix pixel rate values
Message-ID: <20180504225809.GA26715@bigcity.dyn.berto.se>
References: <20180421124444.1652-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180424233642.GB3315@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180424233642.GB3315@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 2018-04-25 01:36:42 +0200, Niklas Söderlund wrote:
> Hi Laurent,
> 
> Thanks for your patch.
> 
> On 2018-04-21 15:44:44 +0300, Laurent Pinchart wrote:
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
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

I'm afraid I would like to revoke this review tag, please see bellow.

> 
> This patch uncovered a calculation error in rcar-csi2 which compensated 
> for the removing of the blanking in the adv748x, thanks for that! Good 
> thing that it's not merged yet, will include the fix in the next version 
> of the CSI-2 driver.
> 
> > ---
> >  drivers/media/i2c/adv748x/adv748x-afe.c  | 11 +++++------
> >  drivers/media/i2c/adv748x/adv748x-hdmi.c |  8 +-------
> >  2 files changed, 6 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> > index 61514bae7e5c..3e18d5ae813b 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> > @@ -321,17 +321,16 @@ static const struct v4l2_subdev_video_ops adv748x_afe_video_ops = {
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
> > +	 * The ADV748x samples analog video signals using an externally supplied
> > +	 * clock whose frequency is required to be 28.63636 MHz.
> > +	 */
> > +	return adv748x_csi2_set_pixelrate(tx, 28636360);

I believe this is wrong. The sampling rate of the AFE is 28.63636 MHz 
but the pixelrate output on the CSI-TXB might not be right? The adv7482 
is a complex and badly documented thing. But it's internal plumbing 
shows that the CVBS signal sampled by the AFE is passed to the SD core 
and then to the TXB CSI-2 transmitter.  

Reading the documentation we have such registers as LTA[1:0] which 
controls the delay between the chroma and luma samples. I do believe the 
adv748x is running with the default of AUTO_PDC_EN which indicates that 
the timings are automatically controlled by the adv748x hardware. And 
there are other registers in the SD core which to me looks like it can 
be configured to make use of the samples so that it won't correlate 1:1 
with the pixel rate.

Looking at the CSI-TXA and CSI-TXB cores which are particularly badly 
documented and the driver contains a lot of undocumented register 
writes. One that is documented and I find interesting in this context is 
EN_AUTOCALC_DPHY_PARAMS which is set 'yes' for the adv748x driver. This 
leads me to believe that the pixel rate output on the CSI-2 bus is not 
correlated with the AFE sampling clock. There are lots of holes in the 
documentation here but some stand out, the undocumented hole around 0xda 
which contains the few documented bits in that area, MIPI_PLL_LOCK_FLAG, 
MIPI_PLL_CLK_DET and MIPI_PLL_EN. Maybe the true link_freq or pixel_rate 
could be read from a undocumented register in that darkness :-)

The real reason I started to dig into this is that after you corrected 
my assumption about how to setup the R-Car CSI-2 receiver link freq this 
change breaks capture of CVBS for me. Looking at how I on your 
suggestion calculate link speed.

link_freq = (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)

pixel_rate = 28636360 (from the adv748x V4L2_CID_PIXEL_RATE)
bits_per_sample = 16 (adv748x reports MEDIA_BUS_FMT_UYVY8_2X8)
nr_of_lanes = 1 (Using TXB of the adv748x)

Gives a link_freq of 229Mhz or as the R-Car CSI-2 deals with in Mbps 
~460Mbps as CSI-2 is DDR. If I try to capture CVBS using such a high 
link speed capture fail. I tried using the lowest link speed R-Car CSI-2 
receiver supports of 80Mbps and then capture works perfectly. But 
settings as high as 235Mps still manage to capture.

I'm not sure how to proceed here and have the adv748x and rcar-csi2 to 
agree on the link speed. But I do think this is wrong.

The change for the adv748x HDMI pixel rate is tested and works for both 
capturing 640x480p and 1920x1080p. But the link speed per the above 
method is changed with this patch applied:

            640x480p    1920x1080p
Before:     110 Mbps    750 Mbps
After:      150 Mbps    900 Mbps

> >  }
> >  
> >  static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> > diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > index 10d229a4f088..aecc2a84dfec 100644
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
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> 
> -- 
> Regards,
> Niklas Söderlund

-- 
Regards,
Niklas Söderlund
