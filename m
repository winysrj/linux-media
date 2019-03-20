Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E581C10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 19:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53AB120857
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 19:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="ejpGi9YV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfCTTuT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:50:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33869 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTTuT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 15:50:19 -0400
Received: by mail-lj1-f196.google.com with SMTP id j89so3388734ljb.1
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 12:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=hNJ9Y9OTTTRwl4uceU2b4fcwqd1xc2+fqL7kbthfXPY=;
        b=ejpGi9YVItJQyUTidqtA5r2vWSAbrW+DOExR43Ym1kH17HxeHg2P6h1A8fViQzAbnQ
         t/4Kpov6zFR+D3zjotzeLdHB7t5uDY6YFdct+b+nj9hFIAzn0bsR5/IjXEOawSbaDkWA
         0EuJAkxlFbtM7PDxhabxPJHW/FeSjZUQt2YbUKB4h5H0wVIazObyYSEN1O5G6/G2IesC
         JF9yYVmVBBT8Zqi7wdWla9fmI+UywBTean2zzl7y5i2Vw1fs/dFJ5jtbABCM21xO38uX
         l0S2krxmojuH3XZLbboQ1ReCBhN2UGmh9v0NJsZyh9WrkkmYMiemc6GdSaidyd4gu/p/
         TM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=hNJ9Y9OTTTRwl4uceU2b4fcwqd1xc2+fqL7kbthfXPY=;
        b=PD8Ky2NRZ/Gft4UDEA0/gXZVfY6m7y4itjftaEqyQ0KD394AED8sxz93j7VzzP/V5a
         nqBg/B/wVeg/83BGGfm9IxvbSNF3omsWeZdubv7iU9iyiM3rBiobfRp0mVc90HcQnLVX
         aWMjyp2in9PJmCmkwxzkL7r5wWj5O2SxPq5ApiBilefJBAcX3ZPQZQezaTRTsBtHnfEu
         GbgFl5Np8vpgGJe/DTjLoMZ8WeHiJpC6DkU9xhL2OguKsjKEOB7Ac/Y/PBTV4ma334cr
         bFiq15VnEOyAOeSl2jtlS05PyYn3xtRXjX932J2I4GD8ExDhEvM3XmbIE6/qiBXUHFdr
         r2aw==
X-Gm-Message-State: APjAAAXR6zHp/ryW5E7U1i+sS1uChfDHgGsQX6qhEl8RVL/2xp4gRTfr
        qHdUnTulpAFzfen/eYLPrJsmnw==
X-Google-Smtp-Source: APXvYqwCl1R15MqHVHcoVipJ4lUmHBfU+ApsodpP+XRoIam9Q+2ny6BKhw14jvrDywaDOhN2iAVBuA==
X-Received: by 2002:a2e:9a46:: with SMTP id k6mr139392ljj.119.1553111416530;
        Wed, 20 Mar 2019 12:50:16 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id e3sm536959lfn.80.2019.03.20.12.50.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 12:50:15 -0700 (PDT)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Wed, 20 Mar 2019 20:50:15 +0100
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, dave.stevenson@raspberrypi.org
Subject: Re: [RFC 5/5] media: rcar-csi2: Configure CSI-2 with frame desc
Message-ID: <20190320195015.GN26015@bigcity.dyn.berto.se>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-6-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190316154801.20460-6-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your patch.

On 2019-03-16 16:48:01 +0100, Jacopo Mondi wrote:
> Use the D-PHY configuration reported by the remote subdevice in its
> frame descriptor to configure the interface.
> 
> Store the number of lanes reported through the 'data-lanes' DT property
> as the number of phyisically available lanes, which might not correspond
> to the number of lanes actually in use.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 71 +++++++++++++--------
>  1 file changed, 43 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 6c46bcc0ee83..70b9a8165a6e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -375,8 +375,8 @@ struct rcar_csi2 {
>  	struct mutex lock;
>  	int stream_count;
>  
> -	unsigned short lanes;
> -	unsigned char lane_swap[4];
> +	unsigned short available_data_lanes;
> +	unsigned short num_data_lanes;

I don't like this, I'm sorry :-(

I think you should keep lanes and lane_swap and most code touching them 
intact. And drop num_data_lanes as it's only used when starting and only 
valid for one 'session' and should not be cached in the data structure 
unnecessary.

Furthermore I think involving lane swapping in the runtime configurable 
parameters is a bad idea. Or do you see a scenario where lanes could be 
swapped in runtime? In my view DT should describe which physical lanes 
are connected and how. And the runtime configuration part should only 
deal with how many lanes are used for the particular capture session.

>  };
>  
>  static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
> @@ -424,7 +424,7 @@ static int rcsi2_get_remote_frame_desc(struct rcar_csi2 *priv,
>  	if (ret)
>  		return -ENODEV;
>  
> -	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2) {
> +	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY) {
>  		dev_err(priv->dev, "Frame desc do not describe CSI-2 link");
>  		return -EINVAL;
>  	}
> @@ -438,7 +438,7 @@ static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
>  
>  	/* Wait for the clock and data lanes to enter LP-11 state. */
>  	for (timeout = 0; timeout <= 20; timeout++) {
> -		const u32 lane_mask = (1 << priv->lanes) - 1;
> +		const u32 lane_mask = (1 << priv->num_data_lanes) - 1;
>  
>  		if ((rcsi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATECKL)  &&
>  		    (rcsi2_read(priv, PHDLM_REG) & lane_mask) == lane_mask)
> @@ -511,14 +511,15 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv,
>  	 * bps = link_freq * 2
>  	 */
>  	mbps = v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> -	do_div(mbps, priv->lanes * 1000000);
> +	do_div(mbps, priv->num_data_lanes * 1000000);
>  
>  	return mbps;
>  }
>  
>  static int rcsi2_start(struct rcar_csi2 *priv)
>  {
> -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> +	struct v4l2_mbus_frame_desc_entry_csi2_dphy *dphy;
> +	u32 phycnt, vcdt = 0, vcdt2 = 0, lswap = 0;
>  	struct v4l2_mbus_frame_desc fd;
>  	unsigned int i;
>  	int mbps, ret;
> @@ -548,8 +549,26 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>  			entry->bus.csi2.channel, entry->bus.csi2.data_type);
>  	}
>  
> +	/* Get description of the D-PHY media bus configuration. */
> +	dphy = &fd.phy.csi2_dphy;
> +	if (dphy->clock_lane != 0) {
> +		dev_err(priv->dev,
> +			"CSI-2 configuration not supported: clock at index %u",
> +			dphy->clock_lane);
> +		return -EINVAL;
> +	}
> +
> +	if (dphy->num_data_lanes > priv->available_data_lanes ||
> +	    dphy->num_data_lanes == 3) {
> +		dev_err(priv->dev,
> +			"Number of CSI-2 data lanes not supported: %u",
> +			dphy->num_data_lanes);
> +		return -EINVAL;
> +	}
> +	priv->num_data_lanes = dphy->num_data_lanes;
> +
>  	phycnt = PHYCNT_ENABLECLK;
> -	phycnt |= (1 << priv->lanes) - 1;
> +	phycnt |= (1 << priv->num_data_lanes) - 1;
>  
>  	mbps = rcsi2_calc_mbps(priv, &fd);
>  	if (mbps < 0)
> @@ -566,12 +585,11 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>  	rcsi2_write(priv, VCDT_REG, vcdt);
>  	if (vcdt2)
>  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> +
>  	/* Lanes are zero indexed. */
> -	rcsi2_write(priv, LSWAP_REG,
> -		    LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> -		    LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> -		    LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> -		    LSWAP_L3SEL(priv->lane_swap[3] - 1));
> +	for (i = 0; i < priv->num_data_lanes; ++i)
> +		lswap |= (dphy->data_lanes[i] - 1) << (i * 2);
> +	rcsi2_write(priv, LSWAP_REG, lswap);
>  
>  	/* Start */
>  	if (priv->info->init_phtw) {
> @@ -822,7 +840,7 @@ static const struct v4l2_async_notifier_operations rcar_csi2_notify_ops = {
>  static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
>  			    struct v4l2_fwnode_endpoint *vep)
>  {
> -	unsigned int i;
> +	unsigned int num_data_lanes;
>  
>  	/* Only port 0 endpoint 0 is valid. */
>  	if (vep->base.port || vep->base.id)
> @@ -833,24 +851,21 @@ static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
>  		return -EINVAL;
>  	}
>  
> -	priv->lanes = vep->bus.mipi_csi2.num_data_lanes;
> -	if (priv->lanes != 1 && priv->lanes != 2 && priv->lanes != 4) {
> +	num_data_lanes = vep->bus.mipi_csi2.num_data_lanes;
> +	switch (num_data_lanes) {
> +	case 1:
> +		/* fallthrough */
> +	case 2:
> +		/* fallthrough */
> +	case 4:
> +		priv->available_data_lanes = num_data_lanes;
> +		break;
> +	default:

Nit pick, I don't like this switch statement and would prefer the 
original construct with an if.

>  		dev_err(priv->dev, "Unsupported number of data-lanes: %u\n",
> -			priv->lanes);
> +			num_data_lanes);
>  		return -EINVAL;
>  	}
>  
> -	for (i = 0; i < ARRAY_SIZE(priv->lane_swap); i++) {
> -		priv->lane_swap[i] = i < priv->lanes ?
> -			vep->bus.mipi_csi2.data_lanes[i] : i;
> -
> -		/* Check for valid lane number. */
> -		if (priv->lane_swap[i] < 1 || priv->lane_swap[i] > 4) {
> -			dev_err(priv->dev, "data-lanes must be in 1-4 range\n");
> -			return -EINVAL;
> -		}
> -	}
> -
>  	return 0;
>  }
>  
> @@ -1235,7 +1250,7 @@ static int rcsi2_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto error;
>  
> -	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
> +	dev_info(priv->dev, "%d lanes found\n", priv->available_data_lanes);
>  
>  	return 0;
>  
> -- 
> 2.21.0
> 

-- 
Regards,
Niklas Söderlund
