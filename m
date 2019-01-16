Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFDBC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04EE1206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="w28MHBH/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393270AbfAPNoe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:44:34 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42896 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393261AbfAPNoe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 08:44:34 -0500
Received: by mail-lf1-f68.google.com with SMTP id l10so4899393lfh.9
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 05:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=kJSfVfzKhoHaYIr23U4bZuc4Mw2UX1QBGLtJxKg3D8o=;
        b=w28MHBH/yB4Xd7VHGuOBmTTOlaCttCKuwnvZ09X+gCzpmbq3xSeVNPDpAJ/HjI5QNv
         p3+4duD885stnUhhrffyN5gKT7QXnupyDeV6OnKlLWvAj7Yvr5vM7T/wVhmIU/jMfZwd
         MUnkHjtox18MQ2L73cGCkRfXtdZkvGbudRkgmVZuOi5LsDudOKEAtnyPuySnVqrlD0+m
         DOTgtulP6E4Ji/ZjQZ5cnHiqNImC3SDGkN4lK2FyaGX7pdBRA7zTbzLj2CT4lwFXzHV8
         v1NlvkBxwVKvBGBC3i57hePy3xDw2yaiJXMtRb9D4FlrjnSwjuJGWjXUQ+2fCIfBjRJx
         0pHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=kJSfVfzKhoHaYIr23U4bZuc4Mw2UX1QBGLtJxKg3D8o=;
        b=J+TiwtiVXVuG3P0vYtYZ37ZR7zSbZHE00oVzw7yXR2Q4FScOkrHZVClhR2bGcBS28Y
         TahmSbIlXwyVuSWYwBmzpiK51T8U4omVQziu/Z00BFSTHtbNGsGpXbYqcsVHQx8wV3WW
         FvW1uqNYbnV41GDJ3cOT9mU3MvKbQqdGUvocVudPySsBk/aN/biRfgFX8ZVy+Cf+cQvA
         tPTcZmq9BYnVmLKg8Y8r/s9lK4o2S2n9zrO9n+laFyo3/M1gAiJ+SKNp5j6oFimnV7U7
         vVy+NLKK71NntVlqc+fGmpSDLqhwospUblOkdkp6hlkvke56+tXyh6pTbr4HxvtWwVGo
         gCSA==
X-Gm-Message-State: AJcUukcWJi0p04vkmTvIVYO/Z0enRIWPGHl0EhXA5DTlLzF9y8hZOrLz
        SQOlwwHu1fW3poSGpvzUoAITW7sloxc=
X-Google-Smtp-Source: ALg8bN6Anks9MmnFEbemw5zV+t5q8BfBtdhpbjPOuFYK9g8bqO3TBH8RGI0PDfNH94a+utqPgRg6Lg==
X-Received: by 2002:a19:26ce:: with SMTP id m197mr6847680lfm.23.1547646271560;
        Wed, 16 Jan 2019 05:44:31 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id j18-v6sm1027442ljc.52.2019.01.16.05.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 05:44:25 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Wed, 16 Jan 2019 14:44:25 +0100
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Message-ID: <20190116134424.GP7393@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-4-jacopo+renesas@jmondi.org>
 <20190114145533.GK30160@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190114145533.GK30160@bigcity.dyn.berto.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi (again) Jacopo,

I found something else in this patch unfortunately :-(

On 2019-01-14 15:55:33 +0100, Niklas Söderlund wrote:
> Hi Jacopo,
> 
> Thanks for your patch.
> 
> On 2019-01-10 15:02:10 +0100, Jacopo Mondi wrote:
> > The ADV748x chip supports routing AFE output to either TXA or TXB.
> > In order to support run-time configuration of video stream path, create an
> > additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
> > from existing ones.
> > 
> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 44 +++++++++++++-----------
> >  1 file changed, 23 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index b6b5d8c7ea7c..8c3714495e11 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> >   * @v4l2_dev: Video registration device
> >   * @src: Source subdevice to establish link
> >   * @src_pad: Pad number of source to link to this @tx
> > + * @enable: Link enabled flag
> >   *
> >   * Ensure that the subdevice is registered against the v4l2_device, and link the
> >   * source pad to the sink pad of the CSI2 bus entity.
> > @@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> >  static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> >  				      struct v4l2_device *v4l2_dev,
> >  				      struct v4l2_subdev *src,
> > -				      unsigned int src_pad)
> > +				      unsigned int src_pad,
> > +				      bool enable)
> >  {
> > -	int enabled = MEDIA_LNK_FL_ENABLED;
> >  	int ret;
> >  
> > -	/*
> > -	 * Dynamic linking of the AFE is not supported.
> > -	 * Register the links as immutable.
> > -	 */
> > -	enabled |= MEDIA_LNK_FL_IMMUTABLE;
> > -
> >  	if (!src->v4l2_dev) {
> >  		ret = v4l2_device_register_subdev(v4l2_dev, src);
> >  		if (ret)
> > @@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> >  
> >  	return media_create_pad_link(&src->entity, src_pad,
> >  				     &tx->sd.entity, ADV748X_CSI2_SINK,
> > -				     enabled);
> > +				     enable ? MEDIA_LNK_FL_ENABLED : 0);
> >  }
> >  
> >  /* -----------------------------------------------------------------------------
> > @@ -68,25 +63,32 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> >  {
> >  	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >  	struct adv748x_state *state = tx->state;
> > +	int ret;
> >  
> >  	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> >  			sd->name);
> >  
> >  	/*
> > -	 * The adv748x hardware allows the AFE to route through the TXA, however
> > -	 * this is not currently supported in this driver.
> > +	 * Link TXA to AFE and HDMI, and TXB to AFE only as TXB cannot output
> > +	 * HDMI.
> >  	 *
> > -	 * Link HDMI->TXA, and AFE->TXB directly.
> > +	 * The HDMI->TXA link is enabled by default, as is the AFE->TXB one.
> >  	 */
> > -	if (is_txa(tx) && is_hdmi_enabled(state))
> > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > -						  &state->hdmi.sd,
> > -						  ADV748X_HDMI_SOURCE);
> > -	if (is_txb(tx) && is_afe_enabled(state))
> > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > -						  &state->afe.sd,
> > -						  ADV748X_AFE_SOURCE);
> > -	return 0;
> > +	if (is_afe_enabled(state)) {
> > +		ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > +						 &state->afe.sd,
> > +						 ADV748X_AFE_SOURCE,
> > +						 is_txb(tx));
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	/* Register link to HDMI for TXA only. */
> > +	if (is_txb(tx) || !is_hdmi_enabled(state))
> 
> Small nit, I would s/is_txb(tx)/!is_txa(tx)/ here as to me it becomes 
> easier to read. With or without this change,
> 
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> > +		return 0;
> > +
> > +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> > +					  ADV748X_HDMI_SOURCE, true);

If the call to adv748x_csi2_register_link() fails should not the 
(possible) link to the AFE be removed?

> >  }
> >  
> >  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> > -- 
> > 2.20.1
> > 
> 
> -- 
> Regards,
> Niklas Söderlund

-- 
Regards,
Niklas Söderlund
