Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F8DC10F00
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343E22087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="h317j10/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfCLS6T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:58:19 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43889 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfCLS6T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 14:58:19 -0400
Received: by mail-lf1-f66.google.com with SMTP id g7so2888300lfh.10
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 11:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=gUXKk4v3z/w6O3y/bAbmDLgMgw6R3rwXWJ2YFZUboac=;
        b=h317j10/4GRXkr0KCjl2KqwZTPyeSWZO152z5CCV+mwPVygZH0Nn4C6uwglhTqHDca
         FDYaQLA4krZtr+6foMjJbRURAT9qoGUsTVEmfkOdzOUObVcgICPuaieGajoYo7kvipMA
         ZHNV7RotDHU7wZ2iQwiZgBvadLJQEZmNoa2YDyMiv/4u3lvoWVo2GSHk0mB72k9qWIjb
         Iu/nYhrKmkSHYQYyPSK0NU1v8YiXznQLtQYwMACrNlh3us0HbTf1yLv+6SCn0C4avSc6
         OSs251ZSV+egPlarqYMR+lKe4YJv08HTaGFhR+ktL8jY2b8GqUEtAgtNiA/82thedN0h
         PIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gUXKk4v3z/w6O3y/bAbmDLgMgw6R3rwXWJ2YFZUboac=;
        b=BXhE2aLCHVkN1xPSOVGjTG85vR5S36F4aVLvrCzqszBinENKIEgp8CBsdmDqe1VHFa
         2X2YouF0QrZv2g0c8N55urKCB+uH5Va11GYxagmrjA39KFXHjuJYx0ZJdD/JaeZ3tjBv
         Xv36u0ng9nv60ZqR/LP31FGNTyRzZgoeafisc0TiTDL2pjh63zi9Vb581/NebhdAvaKM
         K+Nqr9eBsOoYGlj4cU7+0syi6UDI+wmIS9NCl8g2KF/bWuJTLcewVnXh2+J3e5DpO6Sy
         jupwXYK97juDPF+XOqngDFlYh4CCNedYT3U45P4O6JFI8k2p3R0gsUueWE5/DT3xJi1u
         zINw==
X-Gm-Message-State: APjAAAXCHTksoEZ701wnnmGLQJSioHYc9NGO1sLdKeGM5/v3GlVOq5q+
        afqLf5SkAoVHCfkb3fMmXYsqtA==
X-Google-Smtp-Source: APXvYqxhddKYdy527cSDReVAYsi8L1RZkCQaI8dGk9d3d3EXmGu7nqNhHxsn4eREy4W/yu4gKvqyrw==
X-Received: by 2002:a19:cfd1:: with SMTP id f200mr5680135lfg.81.1552417094717;
        Tue, 12 Mar 2019 11:58:14 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id w30sm1478451ljd.65.2019.03.12.11.58.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 11:58:13 -0700 (PDT)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Tue, 12 Mar 2019 19:58:13 +0100
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: restart CSI-2 link if error is detected
Message-ID: <20190312185813.GE1776@bigcity.dyn.berto.se>
References: <20190218101541.15819-1-niklas.soderlund+renesas@ragnatech.se>
 <0fb0337f-32f7-729b-c30b-1453c3b6e901@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0fb0337f-32f7-729b-c30b-1453c3b6e901@xs4all.nl>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thanks for your feedback.

On 2019-03-11 11:53:01 +0100, Hans Verkuil wrote:
> On 2/18/19 11:15 AM, Niklas Söderlund wrote:
> > Restart the CSI-2 link if the CSI-2 receiver detects an error during
> > reception. The driver did nothing when a link error happened and the
> > data flow simply stopped without the user knowing why.
> > 
> > Change the driver to try and recover from errors by restarting the link
> > and informing the user that something is not right. For obvious reasons
> > it's not possible to recover from all errors (video source disconnected
> > for example) but in such cases the user is at least informed of the
> > error and the same behavior of the stopped data flow is retained.
> 
> What you really would like to have is that when a CSI error is detected,
> the CSI driver can ask upstream whether or not a disconnect has taken place.
> 
> If that was the case, then there is no point in restarting the CSI.
> 
> While a disconnect is very uncommon for a sensor, it is of course perfectly
> normal if an HDMI-to-CSI bridge was connected to the CSI port.
> 
> Unfortunately, we don't have such functionality, but perhaps this is something
> to think about?

I think your idea sounds good and that such a functionality could be 
useful. I have a  feeling such a functionality could be related to 
notifications?

> 
> This does mean, however, that I don't like the dev_err since it doesn't have
> to be an error. I would suggest replacing the first dev_err by dev_info and
> the second by dev_warn.

With the background you provides I agree that they should not be 
dev_err. I will update as you suggest for the next version, thanks.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 52 ++++++++++++++++++++-
> >  1 file changed, 51 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index f90b380478775015..0506fe4106d5c012 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -84,6 +84,9 @@ struct rcar_csi2;
> >  
> >  /* Interrupt Enable */
> >  #define INTEN_REG			0x30
> > +#define INTEN_INT_AFIFO_OF		BIT(27)
> > +#define INTEN_INT_ERRSOTHS		BIT(4)
> > +#define INTEN_INT_ERRSOTSYNCHS		BIT(3)
> >  
> >  /* Interrupt Source Mask */
> >  #define INTCLOSE_REG			0x34
> > @@ -540,6 +543,10 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  	if (mbps < 0)
> >  		return mbps;
> >  
> > +	/* Enable interrupts. */
> > +	rcsi2_write(priv, INTEN_REG, INTEN_INT_AFIFO_OF | INTEN_INT_ERRSOTHS
> > +		    | INTEN_INT_ERRSOTSYNCHS);
> > +
> >  	/* Init */
> >  	rcsi2_write(priv, TREF_REG, TREF_TREF);
> >  	rcsi2_write(priv, PHTC_REG, 0);
> > @@ -702,6 +709,43 @@ static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
> >  	.pad	= &rcar_csi2_pad_ops,
> >  };
> >  
> > +static irqreturn_t rcsi2_irq(int irq, void *data)
> > +{
> > +	struct rcar_csi2 *priv = data;
> > +	u32 status, err_status;
> > +
> > +	status = rcsi2_read(priv, INTSTATE_REG);
> > +	err_status = rcsi2_read(priv, INTERRSTATE_REG);
> > +
> > +	if (!status)
> > +		return IRQ_HANDLED;
> > +
> > +	rcsi2_write(priv, INTSTATE_REG, status);
> > +
> > +	if (!err_status)
> > +		return IRQ_HANDLED;
> > +
> > +	rcsi2_write(priv, INTERRSTATE_REG, err_status);
> > +
> > +	dev_err(priv->dev, "Transfer error, restarting CSI-2 receiver\n");
> > +
> > +	return IRQ_WAKE_THREAD;
> > +}
> > +
> > +static irqreturn_t rcsi2_irq_thread(int irq, void *data)
> > +{
> > +	struct rcar_csi2 *priv = data;
> > +
> > +	mutex_lock(&priv->lock);
> > +	rcsi2_stop(priv);
> > +	usleep_range(1000, 2000);
> > +	if (rcsi2_start(priv))
> > +		dev_err(priv->dev, "Failed to restart CSI-2 receiver\n");
> > +	mutex_unlock(&priv->lock);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> >  /* -----------------------------------------------------------------------------
> >   * Async handling and registration of subdevices and links.
> >   */
> > @@ -982,7 +1026,7 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
> >  				 struct platform_device *pdev)
> >  {
> >  	struct resource *res;
> > -	int irq;
> > +	int irq, ret;
> >  
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	priv->base = devm_ioremap_resource(&pdev->dev, res);
> > @@ -993,6 +1037,12 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
> >  	if (irq < 0)
> >  		return irq;
> >  
> > +	ret = devm_request_threaded_irq(&pdev->dev, irq, rcsi2_irq,
> > +					rcsi2_irq_thread, IRQF_SHARED,
> > +					KBUILD_MODNAME, priv);
> > +	if (ret)
> > +		return ret;
> > +
> >  	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> >  	if (IS_ERR(priv->rstc))
> >  		return PTR_ERR(priv->rstc);
> > 
> 

-- 
Regards,
Niklas Söderlund
