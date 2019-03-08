Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D42C10F09
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 16:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 003612133F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 16:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="rd0bQous"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfCHQLJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 11:11:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40397 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfCHQLI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 11:11:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id w6so17838717ljd.7
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 08:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YD4TdKrOiaDPzTp9Kviy/u0AedCVnsN48tPcDWU3934=;
        b=rd0bQous0iA7P5jWOA+MWeKtrBOQG2/76MGfNpa1Gq3FbqsCK8k5vM93v7gxImxRRC
         r4VbKSqvIPzC6xxNSLW9O/ybs6F0gfPIVJxJ33/BrZF2ASX3n1dlPY4WQFbdtTfQ9nqc
         NhZAnQTsZ7pvS8eu1uf8UlnnkJM2SSzbdGknYtBYvm9QDgvT8Sd2GFk/axPn6pyfbHb8
         d7CquXETz6X8Vf1YR9EEzES0/6DLVIL/0+wy9g9wcMxSyQc5p8zTq1VLyEbRPgMdPXCN
         llkB8kCD9brC5JTjaLbfdbN0xzvEkxOoiOuoyQKYezJYheVKhv1ahltaT2t7t38VCt4o
         cAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YD4TdKrOiaDPzTp9Kviy/u0AedCVnsN48tPcDWU3934=;
        b=Uet5dp7B4MpoGV+zjyROaYDz/s8Fo9ZnI4FtGtLWNNDM8eOSu4IhBqqI/kBwp2gPjE
         v/m6YQBrXVAFNpzByEYgvREd6eQCskTFQAMC+v/60f+9VaoSVNbneaJj8b6ceRKmSBJX
         cgg7XRP/JrYM1ZrU4nwyXMOz6U5J8faEUU2gqpF879wRVeiOGztsfkMHAmvb4tu4C6S2
         f8zRyLmL9kVMsgtWpKoyTcY4Og9x/fAao5rt7xQvUfyIycg6PpyAY5at9HOZDdPrHap4
         vpIBTdu/Kw0Lmb2tszptRUNVTjYdywKuJ1vQ/XZUCyk/b9kNPORQdk3/GmEn52g720xc
         OhHQ==
X-Gm-Message-State: APjAAAUsZAKSj44a99f9A05OhNesRA3gOW9LyiVHyA7j3v2oXNGTOtYi
        HbDQd4hFLu3yw1Qv7ZuNV5TkCA==
X-Google-Smtp-Source: APXvYqwcPd1+owiBQsig22wdHwFgkyKhegnZqrs9GrdyUORRBMXnX66BcFSnNmu5zWRGmST9mbxrtA==
X-Received: by 2002:a2e:208a:: with SMTP id g10mr9590103lji.135.1552061465963;
        Fri, 08 Mar 2019 08:11:05 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id q9sm600077lfk.40.2019.03.08.08.11.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 08:11:04 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Fri, 8 Mar 2019 17:11:03 +0100
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: Allow configuring of video standard
Message-ID: <20190308161103.GS9239@bigcity.dyn.berto.se>
References: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
 <47a6b6ce-e570-0ba3-f498-09ca83ce868d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47a6b6ce-e570-0ba3-f498-09ca83ce868d@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thanks for your feedback.

On 2019-03-08 15:12:15 +0100, Hans Verkuil wrote:
> On 2/16/19 11:57 PM, Niklas Söderlund wrote:
> > Allow the hardware to to do proper field detection for interlaced field
> > formats by implementing s_std() and g_std(). Depending on which video
> > standard is selected the driver needs to setup the hardware to correctly
> > identify fields.
> > 
> > Later versions of the datasheet have also been updated to make it clear
> > that FLD register should be set to 0 when dealing with none interlaced
> > field formats.
> 
> Nacked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The G/S_STD and QUERYSTD ioctls are specific for SDTV video receivers
> (composite, S-Video, analog tuner) and can't be used for CSI devices.
> 
> struct v4l2_mbus_framefmt already has a 'field' value that is explicit
> about the field ordering (TB vs BT) or the field ordering can be deduced
> from the frame height (FIELD_INTERLACED).

I will drop this patch and write a new one using field and height as 
suggested by you and Laurent. Thanks for the suggestion!

> 
> Regards,
> 
> 	Hans
> 
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
> > 
> 

-- 
Regards,
Niklas Söderlund
