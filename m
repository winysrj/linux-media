Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1E7C10F00
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F7120663
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="LPbJ+z6U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfCGAKM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:10:12 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33876 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfCGAKM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:10:12 -0500
Received: by mail-lj1-f193.google.com with SMTP id l5so12585435lje.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ImYAD5vO5I6OtzTM/fsWRqHNoXWnW3IZLCbX0OLHIw8=;
        b=LPbJ+z6UW6iShW8lFpNi09X0UM1RDqytCM5N19ZrHdLCGyLzU4/Cuu4BCHf+ootPEC
         CqSGBXa1J+3k4JaaA3a+hVb714LsY4nZaffhBO38+gJulDaX6Pvs6niMz2M0sijrGxKq
         KB+uSpGVsp5PCH/ECONRdkbKHGYR1ZSrqbz3tZaczWm9+31ZjWVG7Eovf9UiDMWBDtqD
         Ll0X2zR0KfclRRWlL6Oa6beTy1maisf+A+YOfZ2MhOvPDB64aV/do8cU5eG99GUwY/RT
         SZUpr7du7+y3CeMyftvu30KRe0dogHVnmYCKRJKYIJvffSVmMUoUIxTFyLVX2GSMIMBU
         hegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ImYAD5vO5I6OtzTM/fsWRqHNoXWnW3IZLCbX0OLHIw8=;
        b=seyR5IRfOH+wAKTqESgR4m0oAEDQElKQxdf3itEY8wbmURRpSDHwGH+rv+ApW2qgeK
         5HuO4HzGKHVb/0Tzb2zj97juwGWn1a0lIvdMbUtg5+wyros55rqCKcdbobBb07WIxXkZ
         1XgZfktx519nbrdHVtQMTj/8J/hY2i5B58apaCxe/Pky0aQZvnEQSFlkIY8O6YEzfu5e
         QSGKnu+P4TBxY+ueTfwJyqBZ/nvsxITlsmpAgZQPXFgMArQ74eaXpGHRRb9KodicfoGe
         INfMI4eYqmL1BP0wqFWfqP1xm7wwG+WB1FE0RD8H0FXQPU4I5uNKLyzvuemgLG1/fT3y
         BrZw==
X-Gm-Message-State: APjAAAUWx4EJ2KdrFsS+isUeSH5JmqK5gIXPnlfj9H3NsdO1cdA8CmM2
        skg+wO67sSnrZmtsFcu4Zy9+Uw==
X-Google-Smtp-Source: APXvYqxgqM2bKF9nCn7hOGbL4X3GL9dKTtatdrTqqAwL4zYWzwmaEdGH2BBDh2M3iJb7fxZ+ReUyfg==
X-Received: by 2002:a2e:2c11:: with SMTP id s17mr3923546ljs.147.1551917409146;
        Wed, 06 Mar 2019 16:10:09 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id f9sm563082ljc.56.2019.03.06.16.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:10:08 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:10:07 +0100
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: Allow configuring of video standard
Message-ID: <20190307001007.GG9239@bigcity.dyn.berto.se>
References: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
 <20190217184140.3duyiwjpgsswcgbx@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190217184140.3duyiwjpgsswcgbx@uno.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your feedback.

On 2019-02-17 19:41:40 +0100, Jacopo Mondi wrote:
> Hi Niklas,
>     where is this patch supposed to be applied on?
> 
> I tried master, media master, renesas-drivers and your rcar-csi2 and
> v4l2/mux branches, but it fails on all of them :(
> 
> What am I doing wrong?

You answered your own question in a later mail, thanks for that ;-)

> 
> On Sat, Feb 16, 2019 at 11:57:58PM +0100, Niklas Söderlund wrote:
> > Allow the hardware to to do proper field detection for interlaced field
> > formats by implementing s_std() and g_std(). Depending on which video
> > standard is selected the driver needs to setup the hardware to correctly
> > identify fields.
> >
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
> 
> Nit: (almost) all other functions in the file have an empty line
> before return...

Will fix.

> 
> > +}
> > +
> > +static int rcsi2_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
> > +{
> > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > +
> > +	*std = priv->std;
> 
> Should priv->std be initialized or STD_UNKNOWN is fine?

STD_UNKNOWN is fine as if the standard is not explicitly set by the user 
it is in fact unknown.

> 
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
> 
> I cannot tell where rcsi2_start_receiver() is called, as I don't have
> it in my local version, but I suppose it has been break out from
> rcsi2_start() has they set the same register. So this is called at
> s_stream() time and priv->mf at set_format() time, right?

Yes.

> 
> > +		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> > +
> > +		if (priv->std & V4L2_STD_525_60)
> > +			fld |= FLD_FLD_NUM(2);
> > +		else
> > +			fld |= FLD_FLD_NUM(1);
> 
> I haven't been able to find an explanation on why the field detection
> depends on this specific video standard... I guess it is defined in some
> standard I'm ignorant of, so I assume this is correct :)

It defines temporal order of field transmission (TOP or BOTTOM) is 
transmitted first. PAL and NTSC differs in this regard and the R-Car 
CSI-2 needs to be informed of what standard is received.

See: 
https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/field-order.html

> 
> Thanks
>    j
> 
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
> > --
> > 2.20.1
> >



-- 
Regards,
Niklas Söderlund
