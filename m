Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38031C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED53A20663
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="BxFgzvUl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfCGADn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:03:43 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35707 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfCGADn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:03:43 -0500
Received: by mail-lj1-f195.google.com with SMTP id t13so12580572lji.2
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MJKxXR05caq5wY43O2yof2CA1nBtk36x9PwvrlYFfwo=;
        b=BxFgzvUljjpCV8dhdxC0fwFzxaz86IcFC6mYOxKCcD9pXGLqdDsHDgv0XJwAM8MnHP
         7GpjGPjJUWk8ISt+Xk3C6WYMZidBDMsPIarawwFV7eSy6R/4JTb2dbHaD+6OZtRP7Lu/
         8oFyk1cEEoBN/f+f70mFxqdXIUlZgIR8HLAUlOl2fEgpiYlG7P0NHmtKSECGy3dcFOVc
         tTsaKZGZRJft0Pj7p587TIKMR/2J9muLtPHDN1L/Lbu1R/54JK5Y0rn9MZUIMIpHkgC7
         4UcPE0z8rYfjXxiJKGwzJ19joQY0yWXu8kRtH4v+GcPEjZnQmQtsQQ23H5sdHjZpfnw1
         ci4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MJKxXR05caq5wY43O2yof2CA1nBtk36x9PwvrlYFfwo=;
        b=epSqNfJ3snLa+NcTf5zCM5NcSRyUzdGadE4EBZ+JKhONTR+VRTGtk7q5z4kpv6sLpq
         QsyUswnu48fmgO5SWx6loTbwBqsq8UOccl2QfwHrt2zhrSYC+xoH27BG2nk+B2am4yn+
         oDQDhpLF3cVRL6cF4GNL1W+bLyiZtpKOQn3vkwuJsdnTfRyvVUS9gG7yASubvUbVqN1K
         8OD3wpO1oMk4Ds+08fYwiD8fwy3lP2JF/JYL6Hwuv1bav9YjESQ8RcYOpjzRJzPqjvaM
         ClMIHfSKW1uZFilVh46ho0P0UVPK6BuYwuswCDpHlQJGkaA83s3uMUkZ0o1Ld88XEOWQ
         pS6Q==
X-Gm-Message-State: APjAAAV15vZ2Z2LqkyzlVgiYy6tRWNy1MWxb+2wLXRfRerPGLQT4Ob3s
        SVd/J1enpab9GnW6U3jZwMXD9ciIxTU=
X-Google-Smtp-Source: APXvYqyRW2gM5ULLEKEAxttWr0u/IEIgrJcZFoKdLkLzleIl33LIyeJD6P1QtSklys8c1ZXBTsknDQ==
X-Received: by 2002:a2e:2202:: with SMTP id i2mr1414184lji.170.1551917019676;
        Wed, 06 Mar 2019 16:03:39 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id h23sm618794ljk.36.2019.03.06.16.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:03:38 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:03:38 +0100
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: Use standby mode instead of resetting
Message-ID: <20190307000338.GA10014@bigcity.dyn.berto.se>
References: <20190216225638.7159-1-niklas.soderlund+renesas@ragnatech.se>
 <20190217194124.fziv3yfr2xlvvcib@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190217194124.fziv3yfr2xlvvcib@uno.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your feedback.

On 2019-02-17 20:41:24 +0100, Jacopo Mondi wrote:
> Hi Niklas,
>    ah, ups, this was maybe the patch the other one I just reviewed was
>    based on... sorry, I missed this one :)

:-)

> 
> On Sat, Feb 16, 2019 at 11:56:38PM +0100, Niklas Söderlund wrote:
> > Later versions of the datasheet updates the reset procedure to more
> > closely resemble the standby mode. Update the driver to enter and exit
> > the standby mode instead of resetting the hardware before and after
> > streaming is started and stopped.
> >
> > While at it break out the full start and stop procedures from
> > rcsi2_s_stream() into the existing helper functions.
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 69 +++++++++++++--------
> >  1 file changed, 42 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index f64528d2be3c95dd..f3099f3e536d808a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/of_graph.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/pm_runtime.h>
> > +#include <linux/reset.h>
> >  #include <linux/sys_soc.h>
> >
> >  #include <media/v4l2-ctrls.h>
> > @@ -350,6 +351,7 @@ struct rcar_csi2 {
> >  	struct device *dev;
> >  	void __iomem *base;
> >  	const struct rcar_csi2_info *info;
> > +	struct reset_control *rstc;
> >
> >  	struct v4l2_subdev subdev;
> >  	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> > @@ -387,11 +389,19 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
> >  	iowrite32(data, priv->base + reg);
> >  }
> >
> > -static void rcsi2_reset(struct rcar_csi2 *priv)
> > +static void rcsi2_standby_mode(struct rcar_csi2 *priv, int on)
> >  {
> > -	rcsi2_write(priv, SRST_REG, SRST_SRST);
> > +	if (!on) {
> 
> minor thing: if (!on) { "wakeup"; } is confusing. What if you call the
> variable "standby" or just "off" ?

I agree this was a bad design, I will split this function in two.

    rcsi2_enter_standby()
    rcsi2_exit_standby()

> 
> > +		pm_runtime_get_sync(priv->dev);
> > +		reset_control_deassert(priv->rstc);
> > +		return;
> > +	}
> > +
> > +	rcsi2_write(priv, PHYCNT_REG, 0);
> > +	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> > +	reset_control_assert(priv->rstc);
> >  	usleep_range(100, 150);
> > -	rcsi2_write(priv, SRST_REG, 0);
> > +	pm_runtime_put(priv->dev);
> >  }
> >
> >  static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
> > @@ -462,7 +472,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> >  	return mbps;
> >  }
> >
> > -static int rcsi2_start(struct rcar_csi2 *priv)
> > +static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  {
> >  	const struct rcar_csi2_format *format;
> >  	u32 phycnt, vcdt = 0, vcdt2 = 0;
> > @@ -506,7 +516,6 @@ static int rcsi2_start(struct rcar_csi2 *priv)
> >
> >  	/* Init */
> >  	rcsi2_write(priv, TREF_REG, TREF_TREF);
> > -	rcsi2_reset(priv);
> >  	rcsi2_write(priv, PHTC_REG, 0);
> >
> >  	/* Configure */
> > @@ -564,19 +573,36 @@ static int rcsi2_start(struct rcar_csi2 *priv)
> >  	return 0;
> >  }
> >
> > +static int rcsi2_start(struct rcar_csi2 *priv)
> > +{
> > +	int ret;
> > +
> > +	rcsi2_standby_mode(priv, 0);
> > +
> > +	ret = rcsi2_start_receiver(priv);
> > +	if (ret) {
> > +		rcsi2_standby_mode(priv, 1);
> > +		return ret;
> > +	}
> > +
> > +	ret = v4l2_subdev_call(priv->remote, video, s_stream, 1);
> 
> minor thing as well, but I feel this one was better where it was, so
> that "rcsi2_start()" only handles the hardware, while s_stream handles
> the pipeline. But then _start() and _stop() becomes very short... so
> yeah, feel free to keep it the way it is.

Do not agree, I like this :-)

> 
> > +	if (ret) {
> > +		rcsi2_standby_mode(priv, 1);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static void rcsi2_stop(struct rcar_csi2 *priv)
> >  {
> > -	rcsi2_write(priv, PHYCNT_REG, 0);
> > -
> > -	rcsi2_reset(priv);
> > -
> > -	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> > +	v4l2_subdev_call(priv->remote, video, s_stream, 0);
> > +	rcsi2_standby_mode(priv, 1);
> >  }
> >
> >  static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >  	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > -	struct v4l2_subdev *nextsd;
> >  	int ret = 0;
> >
> >  	mutex_lock(&priv->lock);
> > @@ -586,27 +612,12 @@ static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
> >  		goto out;
> >  	}
> >
> > -	nextsd = priv->remote;
> > -
> >  	if (enable && priv->stream_count == 0) {
> > -		pm_runtime_get_sync(priv->dev);
> > -
> >  		ret = rcsi2_start(priv);
> > -		if (ret) {
> > -			pm_runtime_put(priv->dev);
> > +		if (ret)
> >  			goto out;
> > -		}
> > -
> > -		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
> > -		if (ret) {
> > -			rcsi2_stop(priv);
> > -			pm_runtime_put(priv->dev);
> > -			goto out;
> > -		}
> >  	} else if (!enable && priv->stream_count == 1) {
> >  		rcsi2_stop(priv);
> > -		v4l2_subdev_call(nextsd, video, s_stream, 0);
> > -		pm_runtime_put(priv->dev);
> >  	}
> >
> >  	priv->stream_count += enable ? 1 : -1;
> > @@ -936,6 +947,10 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
> >  	if (irq < 0)
> >  		return irq;
> >
> > +	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> > +	if (IS_ERR(priv->rstc))
> > +		return PTR_ERR(priv->rstc);
> > +
> 
> I don't see 'resets' listed as a mandatory property of the rcar-csi2
> bindings, shouldn't you fallback to software reset if not 'reset'
> is specified? True that all mainline users have a reset property specified,
> so you could also add 'resets' among the mandatory properties, could
> that break out of tree implementations in your opinion?

Nice catch! I will add a patch to this series listing it as mandatory.  
It's a good thing the resets property always have been part of the dts 
sources so it will not create any regressions.

> 
> Thanks
>    j
> 
> >  	return 0;
> >  }
> >
> > --
> > 2.20.1
> >



-- 
Regards,
Niklas Söderlund
