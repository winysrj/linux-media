Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:37165 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbeEELUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 07:20:23 -0400
Received: by mail-lf0-f47.google.com with SMTP id b23-v6so34365946lfg.4
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 04:20:22 -0700 (PDT)
Date: Sat, 5 May 2018 13:20:20 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: i2c: adv748x: Fix pixel rate values
Message-ID: <20180505112020.GB26715@bigcity.dyn.berto.se>
References: <20180421124444.1652-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180424233642.GB3315@bigcity.dyn.berto.se>
 <20180504225809.GA26715@bigcity.dyn.berto.se>
 <3996889.XrhRBEqfUL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3996889.XrhRBEqfUL@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 2018-05-05 12:48:58 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> On Saturday, 5 May 2018 01:58:10 EEST Niklas Söderlund wrote:
> > On 2018-04-25 01:36:42 +0200, Niklas Söderlund wrote:
> > > On 2018-04-21 15:44:44 +0300, Laurent Pinchart wrote:
> > >> The pixel rate, as reported by the V4L2_CID_PIXEL_RATE control, must
> > >> include both horizontal and vertical blanking. Both the AFE and HDMI
> > >> receiver program it incorrectly:
> > >> 
> > >> - The HDMI receiver goes to the trouble of removing blanking to compute
> > >> the rate of active pixels. This is easy to fix by removing the
> > >> computation and returning the incoming pixel clock rate directly.
> > >> 
> > >> - The AFE performs similar calculation, while it should simply return
> > >> the fixed pixel rate for analog sources, mandated by the ADV748x to be
> > >> 28.63636 MHz.
> > >> 
> > >> Signed-off-by: Laurent Pinchart
> > >> <laurent.pinchart+renesas@ideasonboard.com>
> > > 
> > > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > I'm afraid I would like to revoke this review tag, please see bellow.
> > 
> > > This patch uncovered a calculation error in rcar-csi2 which compensated
> > > for the removing of the blanking in the adv748x, thanks for that! Good
> > > thing that it's not merged yet, will include the fix in the next version
> > > of the CSI-2 driver.
> > > 
> > >> ---
> > >> 
> > >>  drivers/media/i2c/adv748x/adv748x-afe.c  | 11 +++++------
> > >>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  8 +-------
> > >>  2 files changed, 6 insertions(+), 13 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c
> > >> b/drivers/media/i2c/adv748x/adv748x-afe.c index
> > >> 61514bae7e5c..3e18d5ae813b 100644
> > >> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> > >> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> > >> @@ -321,17 +321,16 @@ static const struct v4l2_subdev_video_ops
> > >> adv748x_afe_video_ops = {> > 
> > >>  static int adv748x_afe_propagate_pixelrate(struct adv748x_afe *afe)
> > >>  {
> > >>  	struct v4l2_subdev *tx;
> > >> -	unsigned int width, height, fps;
> > >> 
> > >>  	tx = adv748x_get_remote_sd(&afe->pads[ADV748X_AFE_SOURCE]);
> > >>  	if (!tx)
> > >>  		return -ENOLINK;
> > >> 
> > >> -	width = 720;
> > >> -	height = afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> > >> -	fps = afe->curr_norm & V4L2_STD_525_60 ? 30 : 25;
> > >> -
> > >> -	return adv748x_csi2_set_pixelrate(tx, width * height * fps);
> > >> +	/*
> > >> +	 * The ADV748x samples analog video signals using an externally
> > >> supplied
> > >> +	 * clock whose frequency is required to be 28.63636 MHz.
> > >> +	 */
> > >> +	return adv748x_csi2_set_pixelrate(tx, 28636360);
> > 
> > I believe this is wrong. The sampling rate of the AFE is 28.63636 MHz
> > but the pixelrate output on the CSI-TXB might not be right?
> 
> There are only two ways that would allow the pixel rate output of the CSI-TXB 
> to be different than the sampling frequency. The SD core or TXB would need to 
> either resample or buffer the signal. Resampling would change the resolution 
> so that's out of question. Buffering would require a memory buffer large 
> enough to hold one line of data, which would be quite expensive in terms of 
> silicon, and is thus unlikely.

I'm the first to admit I have much to learn here :-) I tried reading up 
and with my limited understanding it seems possible that different 
components are sampled at different rates, and normal pixel clock for 
PAL and NTSC which kept popping up in my research was:

    Digital video is a sampled form of analog video. The most common 
    sampling schemes in use today are:

                      Pixel Clock   Horiz    Horiz    Vert
                       Rate         Total    Active
    NTSC square pixel  12.27 MHz    780      640      525
    NTSC CCIR-601      13.5  MHz    858      720      525
    NTSC 4FSc          14.32 MHz    910      768      525
    PAL  square pixel  14.75 MHz    944      768      625
    PAL  CCIR-601      13.5  MHz    864      720      625
    PAL  4FSc          17.72 MHz   1135      948      625

    For the CCIR-601 standards, the sampling is based on a static 
    orthogonal sampling grid. The luminance component (Y) is sampled at 
    13.5 MHz, while the two color difference signals, Cr and Cb are 
    sampled at half that, or 6.75 MHz. The Cr and Cb samples are 
    colocated with alternate Y samples, and they are taken at the same 
    position on each line, such that one sample is coincident with the 
    50% point of the falling edge of analog sync. The samples are coded 
    to either 8 or 10 bits per component. 

    ftp://ftp.sgi.com/sgi/video/rld/vidpage/sampling.html

Looking at timing diagrams it seems the VSYNC pulse is quiet long and 
that is AFIK represented by a short package on the CSI-2 bus so I feel 
the sampling clock can't be 1:1 mapped to the pixel rate of the CSI-2 
bus.

Also with this change applied the adv748x reports a pixel rate of 151 
Mbps for HDMI 640x480p and a pixel rate of 458 Mbps for 720x240i CVBS 
which seems odd :-)

> 
> > The adv7482 is a complex and badly documented thing. But it's internal
> > plumbing shows that the CVBS signal sampled by the AFE is passed to the SD
> > core and then to the TXB CSI-2 transmitter.
> > 
> > Reading the documentation we have such registers as LTA[1:0] which
> > controls the delay between the chroma and luma samples. I do believe the
> > adv748x is running with the default of AUTO_PDC_EN which indicates that
> > the timings are automatically controlled by the adv748x hardware. And
> > there are other registers in the SD core which to me looks like it can
> > be configured to make use of the samples so that it won't correlate 1:1
> > with the pixel rate.
> > 
> > Looking at the CSI-TXA and CSI-TXB cores which are particularly badly
> > documented and the driver contains a lot of undocumented register
> > writes. One that is documented and I find interesting in this context is
> > EN_AUTOCALC_DPHY_PARAMS which is set 'yes' for the adv748x driver. This
> > leads me to believe that the pixel rate output on the CSI-2 bus is not
> > correlated with the AFE sampling clock. There are lots of holes in the
> > documentation here but some stand out, the undocumented hole around 0xda
> > which contains the few documented bits in that area, MIPI_PLL_LOCK_FLAG,
> > MIPI_PLL_CLK_DET and MIPI_PLL_EN. Maybe the true link_freq or pixel_rate
> > could be read from a undocumented register in that darkness :-)
> > 
> > The real reason I started to dig into this is that after you corrected
> > my assumption about how to setup the R-Car CSI-2 receiver link freq this
> > change breaks capture of CVBS for me. Looking at how I on your
> > suggestion calculate link speed.
> > 
> > link_freq = (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)
> > 
> > pixel_rate = 28636360 (from the adv748x V4L2_CID_PIXEL_RATE)
> > bits_per_sample = 16 (adv748x reports MEDIA_BUS_FMT_UYVY8_2X8)
> > nr_of_lanes = 1 (Using TXB of the adv748x)
> > 
> > Gives a link_freq of 229Mhz or as the R-Car CSI-2 deals with in Mbps
> > ~460Mbps as CSI-2 is DDR.
> 
> Could you measure the frequency of the CSI-2 clock signal with a scope ?

I tried looking at the schematics and I can't find anywhere to attach a 
scope to measure it :-(

> 
> > If I try to capture CVBS using such a high link speed capture fail. I tried
> > using the lowest link speed R-Car CSI-2 receiver supports of 80Mbps and then
> > capture works perfectly. But settings as high as 235Mps still manage to
> > capture.
> 
> I assume that the CSI-2 receiver clock frequency-dependent settings control 
> the PLL and/or clock filters. You could try to get more information from 
> Renesas to find out how this operates, it could give us a clue as to what is 
> happening.

Will do.

> 
> > I'm not sure how to proceed here and have the adv748x and rcar-csi2 to
> > agree on the link speed. But I do think this is wrong.
> 
> If capture fails something is definitely wrong :-) The easiest way to find 
> out, in my opinion, would be to measure the CSI-2 clock frequency, as that 
> would tell us on which side the problem lies.

I agree that a measurement of that value would be valuable. I just can't 
figure out how to get it.

> 
> > The change for the adv748x HDMI pixel rate is tested and works for both
> > capturing 640x480p and 1920x1080p. But the link speed per the above
> > method is changed with this patch applied:
> > 
> >             640x480p    1920x1080p
> > Before:     110 Mbps    750 Mbps
> > After:      150 Mbps    900 Mbps
> > 
> > >>  }
> > >>  
> > >>  static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> > >> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > >> b/drivers/media/i2c/adv748x/adv748x-hdmi.c index
> > >> 10d229a4f088..aecc2a84dfec 100644
> > >> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > >> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> > >> @@ -402,8 +402,6 @@ static int adv748x_hdmi_propagate_pixelrate(struct
> > >> adv748x_hdmi *hdmi)
> > >>  {
> > >>  	struct v4l2_subdev *tx;
> > >>  	struct v4l2_dv_timings timings;
> > >> -	struct v4l2_bt_timings *bt = &timings.bt;
> > >> -	unsigned int fps;
> > >> 
> > >>  	tx = adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
> > >>  	if (!tx)
> > >> @@ -411,11 +409,7 @@ static int adv748x_hdmi_propagate_pixelrate(struct
> > >> adv748x_hdmi *hdmi)
> > >>  	adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
> > >> 
> > >> -	fps = DIV_ROUND_CLOSEST_ULL(bt->pixelclock,
> > >> -				    V4L2_DV_BT_FRAME_WIDTH(bt) *
> > >> -				    V4L2_DV_BT_FRAME_HEIGHT(bt));
> > >> -
> > >> -	return adv748x_csi2_set_pixelrate(tx, bt->width * bt->height * fps);
> > >> +	return adv748x_csi2_set_pixelrate(tx, timings.bt.pixelclock);
> > >>  }
> > >>  
> > >>  static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Regards,
Niklas Söderlund
