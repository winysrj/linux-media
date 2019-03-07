Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EEEC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47C7B20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="lo4pjilP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfCGAWl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:22:41 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41497 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfCGAWk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:22:40 -0500
Received: by mail-lj1-f195.google.com with SMTP id z25so12605089ljk.8
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=OqePhN2lPcBdHfmeqD0Y19oY7n9hQSR8iem7TL4nUF4=;
        b=lo4pjilP4UmFgisQZgoxQWkmTLHoLQWoBM9sUxzpfMRfQT43JDWp0gCGsml6V/Ig05
         B4qMvyKPchpo1ZZ1acq94q/rHHxchB3jjlAvM5GuLEHBWdY+5vELI9OwvMmBMZTCSxkD
         +8EXj376AVU77GOpq1sXvxR8lakrZf3STxlXGLKXENqu0nOF9mLjRTRtUHAlu7ZHSHdh
         3BRtudZAL1IkgpDO9ngf/QR2GbTs2w0uQ8S9q98bVU9tg37KsvWEiDxciXU6Ka6iE0uy
         vrKon6NR7bOVYfAdvZPMn57rnvBPpGGjuizVljwYfnVoq2gmJaZi227DGPOtTs8Ox31V
         1NkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=OqePhN2lPcBdHfmeqD0Y19oY7n9hQSR8iem7TL4nUF4=;
        b=XPt8ApBF7XSMpTCerWl3doSQGMhb1PK3ZuAvkxCzbkyZv5RL8tks4xrK41tDB2L/9f
         q2Z48J9g9M6oElx1DwbYvFiGgX8KLk2TZusFL1AP3oYsCvrHptozZLRKKSdf/TW7FkeT
         9AkmeV+ohoVnnAmuGHESfnwc5U01OgUMc3VPkcte9c0dCVtHPEq+DKvv09X5MqtpXz3k
         n34VwUWTW77j4uK/T0fwgjzOpV+aLBg6/IOpzCAob15awoFARYP0Eb3g95/aqK+vbtBd
         FVc/trc1nbO0skoMz2hAUVzBa3wB7f1T6vuGH0jUMtm2CLf6T78wuGH4Ircn4eAApfuv
         y2Fg==
X-Gm-Message-State: APjAAAX1RMzhiZbI1KU1UzhtpkTSK8+lOSaFpQEBwWiCw/vO2i6pNqDE
        OQq1J9GRIFgjKZRgQVKlc/Ei/Q==
X-Google-Smtp-Source: APXvYqxXilF1z/V11zS2v9MJOWDQ6zQv04ag8FBoBQrBYmBfvaYBMViLlI9N0PF2tZPHFi/uQ+GOww==
X-Received: by 2002:a2e:19a:: with SMTP id f26mr3955611lji.26.1551918157160;
        Wed, 06 Mar 2019 16:22:37 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id j16sm610676lfh.81.2019.03.06.16.22.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:22:36 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:22:36 +0100
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: Allow configuring of video standard
Message-ID: <20190307002236.GJ9239@bigcity.dyn.berto.se>
References: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
 <20190307001318.GF4791@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190307001318.GF4791@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for your feedback.

On 2019-03-07 02:13:18 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Sat, Feb 16, 2019 at 11:57:58PM +0100, Niklas Söderlund wrote:
> > Allow the hardware to to do proper field detection for interlaced field
> > formats by implementing s_std() and g_std(). Depending on which video
> > standard is selected the driver needs to setup the hardware to correctly
> > identify fields.
> 
> I don't think this belongs to the CSI-2 receiver. Standards are really
> an analog concept, and should be handled by the analog front-end. At the
> CSI-2 level there's no concept of analog standard anymore.

I agree it should be handled by the analog front-end. This is patch just 
lets the user propagate the information in the pipeline. The driver 
could instead find its source subdevice in the media graph and ask which 
standard it's supplying.

I wrestled a bit with this and went with this approach as it then works 
the same as with other format information, such as dimensions and pixel 
format. If the driver acquires the standard by itself why should it no 
the same for the format? I'm willing to change this but I would like to 
understand where the divider for format propagating in kernel and 
user-space is :-)

Also what if there are subdevices between rcar-csi2 and the analog 
front-end which do not support the g_std operation?

> 
> > Later versions of the datasheet have also been updated to make it clear
> > that FLD register should be set to 0 when dealing with none interlaced
> > field formats.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 33 +++++++++++++++++++--
> >  1 file changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index f3099f3e536d808a..664d3784be2b9db9 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -361,6 +361,7 @@ struct rcar_csi2 {
> >  	struct v4l2_subdev *remote;
> >  
> >  	struct v4l2_mbus_framefmt mf;
> > +	v4l2_std_id std;
> >  
> >  	struct mutex lock;
> >  	int stream_count;
> > @@ -389,6 +390,22 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
> >  	iowrite32(data, priv->base + reg);
> >  }
> >  
> > +static int rcsi2_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> > +{
> > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > +
> > +	priv->std = std;
> > +	return 0;
> > +}
> > +
> > +static int rcsi2_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
> > +{
> > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > +
> > +	*std = priv->std;
> > +	return 0;
> > +}
> > +
> >  static void rcsi2_standby_mode(struct rcar_csi2 *priv, int on)
> >  {
> >  	if (!on) {
> > @@ -475,7 +492,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> >  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  {
> >  	const struct rcar_csi2_format *format;
> > -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> > +	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
> >  	unsigned int i;
> >  	int mbps, ret;
> >  
> > @@ -507,6 +524,15 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  			vcdt2 |= vcdt_part << ((i % 2) * 16);
> >  	}
> >  
> > +	if (priv->mf.field != V4L2_FIELD_NONE) {
> > +		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> > +
> > +		if (priv->std & V4L2_STD_525_60)
> > +			fld |= FLD_FLD_NUM(2);
> > +		else
> > +			fld |= FLD_FLD_NUM(1);
> > +	}
> > +
> >  	phycnt = PHYCNT_ENABLECLK;
> >  	phycnt |= (1 << priv->lanes) - 1;
> >  
> > @@ -519,8 +545,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  	rcsi2_write(priv, PHTC_REG, 0);
> >  
> >  	/* Configure */
> > -	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> > -		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> > +	rcsi2_write(priv, FLD_REG, fld);
> >  	rcsi2_write(priv, VCDT_REG, vcdt);
> >  	if (vcdt2)
> >  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> > @@ -662,6 +687,8 @@ static int rcsi2_get_pad_format(struct v4l2_subdev *sd,
> >  }
> >  
> >  static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
> > +	.s_std = rcsi2_s_std,
> > +	.g_std = rcsi2_g_std,
> >  	.s_stream = rcsi2_s_stream,
> >  };
> >  
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Regards,
Niklas Söderlund
