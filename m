Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CBCC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 247242087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="LOCVvLL+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfCLSMN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:12:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37454 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727934AbfCLSMI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 14:12:08 -0400
Received: by mail-lj1-f195.google.com with SMTP id a17so3186720ljd.4
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=BEFAAliEV8zfpXpE49t1BnKYgkzZTC1nKbmHkqxWCL8=;
        b=LOCVvLL+Z17BayuxuHBFy5QS8XMVKTGBEPOUo1cGrdL28rWyvaIutwIeVcI3s1rLrn
         kRSrcIdjSaGLmUfIq7qUOOYOODqxXYW7Jk9za8Vv5BLaLMuWfu5lK3EPQUdnkDtErR7G
         gVdW9Dao2fZsiagnFuiWwlmPjWHphNR/+keGVQelhKMkdp4kvIZO8+2UPveRIyYng1Kj
         up4rCUd6rw3aC6VigPQpwqohygbSqns08apAIQbsmsp2EfHBajO6n7JicnhbTMOBAMH/
         jtLAO3OJSACR7r0HJ5y5fIk3n0tDEmgKiATDuP+yZBvij7Y1q/Pjh/9B91ENzIj9BI/H
         /4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=BEFAAliEV8zfpXpE49t1BnKYgkzZTC1nKbmHkqxWCL8=;
        b=RYT96hHOpyozr/UJza2dubAMWMYKLXcrvwT35h/Rv2+geN08p7/PnD0eycJY6YBocQ
         rr6jb1luGRXmLqergel1xj00KbaRu1oaWGufpp2O0ctSdWfboPJISTvtcQoaNw28eU1v
         eHgt0kDLvQzfoYFyyLEbU+PDwgsD8GdxZ7NR5gF9fm7PcI8tUGT0URbwNqZG3D9X+YQg
         H88AbfSrdLvE1xHQfp/styDaGlT5sb8CVievzqwlt0XKupM7PPBYT2mP9CtA4yryWONq
         zPl/Lmq7ZAw1u5xrp58ZbF0aAI1JrxJK0jUREzwhpcxOs9Itbvk3/0YaYDBNMyyfOBId
         EL0g==
X-Gm-Message-State: APjAAAUZuv2NTzJeBKsbKlPFnjRvZt2y0pJRgVpr7CPoNGuJfww4lVJN
        ekL9JZNCp8VdurdXf70MAaygRf2DJlM=
X-Google-Smtp-Source: APXvYqyLrlJN6JH6ThqNhn2ONVcnx3GWmtLsK5WSIrvOeVIAkpld8EbYptdsWntyFeNvogCNmEsi9Q==
X-Received: by 2002:a2e:8018:: with SMTP id j24mr19825439ljg.118.1552414208859;
        Tue, 12 Mar 2019 11:10:08 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id d5sm1689578lfi.95.2019.03.12.11.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 11:10:08 -0700 (PDT)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Tue, 12 Mar 2019 19:10:07 +0100
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] rcar-csi2: Use standby mode instead of resetting
Message-ID: <20190312181007.GB1776@bigcity.dyn.berto.se>
References: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308234722.25775-3-niklas.soderlund+renesas@ragnatech.se>
 <20190311095351.GL4775@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190311095351.GL4775@pendragon.ideasonboard.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for your feedback.

On 2019-03-11 11:53:51 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Sat, Mar 09, 2019 at 12:47:22AM +0100, Niklas Söderlund wrote:
> > Later versions of the datasheet updates the reset procedure to more
> > closely resemble the standby mode. Update the driver to enter and exit
> > the standby mode instead of resetting the hardware before and after
> > streaming is started and stopped.
> 
> I was mislead thinking this added support for module reset in addition
> to software reset (SRST_SRST-, but it actually removes the software
> reset completely. Should the commit message make this clear ?

Good point, will add a clarification in next version.

> 
> > While at it break out the full start and stop procedures from
> > rcsi2_s_stream() into the existing helper functions.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/Kconfig     |  1 +
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 69 +++++++++++++--------
> >  2 files changed, 43 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> > index e3eb8fee253658da..f26f47e3bcf44825 100644
> > --- a/drivers/media/platform/rcar-vin/Kconfig
> > +++ b/drivers/media/platform/rcar-vin/Kconfig
> > @@ -3,6 +3,7 @@ config VIDEO_RCAR_CSI2
> >  	tristate "R-Car MIPI CSI-2 Receiver"
> >  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> >  	depends on ARCH_RENESAS || COMPILE_TEST
> > +	select RESET_CONTROLLER
> >  	select V4L2_FWNODE
> >  	help
> >  	  Support for Renesas R-Car MIPI CSI-2 receiver.
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index f64528d2be3c95dd..7a1c9b549e0fffc6 100644
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
> > +static void rcsi2_enter_standby(struct rcar_csi2 *priv)
> >  {
> > -	rcsi2_write(priv, SRST_REG, SRST_SRST);
> > +	rcsi2_write(priv, PHYCNT_REG, 0);
> > +	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> > +	reset_control_assert(priv->rstc);
> >  	usleep_range(100, 150);
> > -	rcsi2_write(priv, SRST_REG, 0);
> > +	pm_runtime_put(priv->dev);
> > +}
> > +
> > +static void rcsi2_exit_standby(struct rcar_csi2 *priv)
> > +{
> > +	pm_runtime_get_sync(priv->dev);
> > +	reset_control_deassert(priv->rstc);
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
> > +	rcsi2_exit_standby(priv);
> > +
> > +	ret = rcsi2_start_receiver(priv);
> 
> The rcsi2_start_receiver() function should be split in two, with
> rcsi2_wait_phy_start() and below being performed after starting the
> source. Alternatively you could start the source first, but I think a
> split would be better.

I don't think that would work nor is correct. In Figure 25.16.1.1 data 
transfer should be started after confirmation of PHY start. If we call 
s_stream on the source before confirming PHY start we will never be able 
to detect LP-11.

I interpret the diagram as the CSI-2 transmitter should be powered on 
before conforming PHY start, something that should happen in s_power not 
s_stream. We handle s_power correctly today using the v4l2-mc link 
handling so I believe the current code is correct.

Would you agree with my reasoning?

> 
> > +	if (ret) {
> > +		rcsi2_enter_standby(priv);
> > +		return ret;
> > +	}
> > +
> > +	ret = v4l2_subdev_call(priv->remote, video, s_stream, 1);
> > +	if (ret) {
> > +		rcsi2_enter_standby(priv);
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
> > +	rcsi2_enter_standby(priv);
> 
> Shouldn't you enter standby before stopping the source ? Otherwise
> there's a risk of CSI errors being detected. Figures 25.23.1 and 25.23.2
> seem to agree with me.

I agree with you on this, it should enter standby before stopping the 
source. Will change this for next version.

> 
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
> >  	return 0;
> >  }
> >  
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Regards,
Niklas Söderlund
