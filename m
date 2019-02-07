Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92592C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A22F2190A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="PMpC9esG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfBGP5b (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:57:31 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37143 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfBGP5b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 10:57:31 -0500
Received: by mail-lj1-f196.google.com with SMTP id r10-v6so309333ljj.4
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2019 07:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=u5jKTaUzhIul4RD7gT5c2lAWF8HuxyRGZOAze/aQgXU=;
        b=PMpC9esGPefEiT8k4fJmgz8r587uP11en2tiQQ6t/lxZxk2HTruNML4QkUnLOQte9U
         cBJPUYtHeIoY1EbCA38STGBBXSiwqTmFao6CpodtQzbmxSynd4e0IirCv66FBg3kuiFs
         4JswXfzbvqLCSTlE8LcpkTe5eN5MYjbu8UiY+KCFFX+xi77SUtQB661M/jR+tsk4Fhy6
         hxpArjo5GdgrwROb6mxjPN9+YY91KQjQFi4M+zlcME55dtXJdEkjI8oR3ZmoHutGgwQf
         nMBcv2de/1+S6YwiwYnlUwR69OkrGUiK1Ain0nUt/xPovtG+vK8f/nKDhrPQ+pJvldAR
         gY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=u5jKTaUzhIul4RD7gT5c2lAWF8HuxyRGZOAze/aQgXU=;
        b=EujvbGE4MnQIh5xD52zvPvW/YhEyEPwkVjMy0oKLDewXXCRRC3xvSiNx3WAppBZGFY
         eonA+j4al0O/IZJFjoPKfsQpPNg+Tm+wS6x6WNumAR6UvcBWRimWpeZUas3VtyXdEfyd
         VHddE/Il+iwHijhfa/hoe1siiGgH0NonV57QMULCdqVQX/o8ElJmrXOK43Ju2rhOdi/x
         4TCE6MG7YOvWF3h0rnOfTZFicFb7kxumcNJdya/tNilBCmC4JZtG+TPpV1BnhycYbhFz
         D0XR1Lppj9JoXcd+BCCbJ4QFgp1ybNL4DZMopt1/J8Vk2D8VTXZxRIDDnCf6Nq+UniqQ
         luvw==
X-Gm-Message-State: AHQUAubrRLEQFkhqRjl/agfsx2DSZZb7eoAktqfx5UJeBtK6YouVtUTF
        QvndlRziNmai34fUQ94vWYs3Gw==
X-Google-Smtp-Source: AHgI3IYBXgGCsB4ZJ7UbyXjQkNaMjBzU9yy5wJwroG8SWgQoAT1EO87ofBkxUUKybnSu2EFa0o9K+A==
X-Received: by 2002:a2e:9189:: with SMTP id f9-v6mr7417468ljg.70.1549555048986;
        Thu, 07 Feb 2019 07:57:28 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id s27-v6sm408369ljd.64.2019.02.07.07.57.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Feb 2019 07:57:28 -0800 (PST)
Date:   Thu, 7 Feb 2019 16:57:27 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Message-ID: <20190207155727.GG32622@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-4-jacopo+renesas@jmondi.org>
 <20190114145533.GK30160@bigcity.dyn.berto.se>
 <20190116134424.GP7393@bigcity.dyn.berto.se>
 <20190128144736.7hulivpepab2mp7z@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190128144736.7hulivpepab2mp7z@uno.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2019-01-28 15:47:37 +0100, Jacopo Mondi wrote:
> Hi Niklas,
>    sorry for replying late
> 
> On Wed, Jan 16, 2019 at 02:44:25PM +0100, Niklas Söderlund wrote:
> > Hi (again) Jacopo,
> >
> > I found something else in this patch unfortunately :-(
> >
> > On 2019-01-14 15:55:33 +0100, Niklas Söderlund wrote:
> > > Hi Jacopo,
> > >
> > > Thanks for your patch.
> > >
> > > On 2019-01-10 15:02:10 +0100, Jacopo Mondi wrote:
> > > > The ADV748x chip supports routing AFE output to either TXA or TXB.
> > > > In order to support run-time configuration of video stream path, create an
> > > > additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
> > > > from existing ones.
> > > >
> > > > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > > ---
> > > >  drivers/media/i2c/adv748x/adv748x-csi2.c | 44 +++++++++++++-----------
> > > >  1 file changed, 23 insertions(+), 21 deletions(-)
> > > >
> > > > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > > index b6b5d8c7ea7c..8c3714495e11 100644
> > > > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > > @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> > > >   * @v4l2_dev: Video registration device
> > > >   * @src: Source subdevice to establish link
> > > >   * @src_pad: Pad number of source to link to this @tx
> > > > + * @enable: Link enabled flag
> > > >   *
> > > >   * Ensure that the subdevice is registered against the v4l2_device, and link the
> > > >   * source pad to the sink pad of the CSI2 bus entity.
> > > > @@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> > > >  static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> > > >  				      struct v4l2_device *v4l2_dev,
> > > >  				      struct v4l2_subdev *src,
> > > > -				      unsigned int src_pad)
> > > > +				      unsigned int src_pad,
> > > > +				      bool enable)
> > > >  {
> > > > -	int enabled = MEDIA_LNK_FL_ENABLED;
> > > >  	int ret;
> > > >
> > > > -	/*
> > > > -	 * Dynamic linking of the AFE is not supported.
> > > > -	 * Register the links as immutable.
> > > > -	 */
> > > > -	enabled |= MEDIA_LNK_FL_IMMUTABLE;
> > > > -
> > > >  	if (!src->v4l2_dev) {
> > > >  		ret = v4l2_device_register_subdev(v4l2_dev, src);
> > > >  		if (ret)
> > > > @@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> > > >
> > > >  	return media_create_pad_link(&src->entity, src_pad,
> > > >  				     &tx->sd.entity, ADV748X_CSI2_SINK,
> > > > -				     enabled);
> > > > +				     enable ? MEDIA_LNK_FL_ENABLED : 0);
> > > >  }
> > > >
> > > >  /* -----------------------------------------------------------------------------
> > > > @@ -68,25 +63,32 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> > > >  {
> > > >  	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> > > >  	struct adv748x_state *state = tx->state;
> > > > +	int ret;
> > > >
> > > >  	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> > > >  			sd->name);
> > > >
> > > >  	/*
> > > > -	 * The adv748x hardware allows the AFE to route through the TXA, however
> > > > -	 * this is not currently supported in this driver.
> > > > +	 * Link TXA to AFE and HDMI, and TXB to AFE only as TXB cannot output
> > > > +	 * HDMI.
> > > >  	 *
> > > > -	 * Link HDMI->TXA, and AFE->TXB directly.
> > > > +	 * The HDMI->TXA link is enabled by default, as is the AFE->TXB one.
> > > >  	 */
> > > > -	if (is_txa(tx) && is_hdmi_enabled(state))
> > > > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > > > -						  &state->hdmi.sd,
> > > > -						  ADV748X_HDMI_SOURCE);
> > > > -	if (is_txb(tx) && is_afe_enabled(state))
> > > > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > > > -						  &state->afe.sd,
> > > > -						  ADV748X_AFE_SOURCE);
> > > > -	return 0;
> > > > +	if (is_afe_enabled(state)) {
> > > > +		ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > > > +						 &state->afe.sd,
> > > > +						 ADV748X_AFE_SOURCE,
> > > > +						 is_txb(tx));
> > > > +		if (ret)
> > > > +			return ret;
> > > > +	}
> > > > +
> > > > +	/* Register link to HDMI for TXA only. */
> > > > +	if (is_txb(tx) || !is_hdmi_enabled(state))
> > >
> > > Small nit, I would s/is_txb(tx)/!is_txa(tx)/ here as to me it becomes
> > > easier to read. With or without this change,
> > >
> > > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > >
> > > > +		return 0;
> > > > +
> > > > +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> > > > +					  ADV748X_HDMI_SOURCE, true);
> >
> > If the call to adv748x_csi2_register_link() fails should not the
> > (possible) link to the AFE be removed?
> >
> 
> The .register() callback is called from v4l2-device.c in
> v4l2_device_register_subdev(). If the callback returns an error, the
> subdev gets not registered at all and the media entity cleaned up, so it
> won't appear in the media graph.
> 
> I think we're safe and the patch series is good to go. What's your
> opinion?

As long as no stray links are left in the graph I'm happy :-)

> 
> Thanks
>   j
> 
> 
> > > >  }
> > > >
> > > >  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> > > > --
> > > > 2.20.1
> > > >
> > >
> > > --
> > > Regards,
> > > Niklas Söderlund
> >
> > --
> > Regards,
> > Niklas Söderlund



-- 
Regards,
Niklas Söderlund
