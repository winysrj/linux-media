Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29313C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A6C20675
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="SP+TC3Qv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393162AbfAPNdN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:33:13 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46838 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732780AbfAPNdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 08:33:13 -0500
Received: by mail-lf1-f66.google.com with SMTP id y14so4855393lfg.13
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 05:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dkVRjPzDyeIj1c4QcPgMS7rIVBwKEFcEdWyYnJMVhwM=;
        b=SP+TC3Qvx2rdw0iRPhwVvtg7TaZWTnI454ZiV0j52MOoSXP+uK7O+p6yL0vSDMFUJt
         SYi9QXYHsoRCYCtnXB5VFzlpEpIQ6YbiOIoxyIDmFuJf1gEXE4bfPo2eIFSuiU88Z64P
         ruGV4fo8ZGxrQMLmBzQvQGgptTXZ3msy0NToNWb3obaS3fxJ0lj78G9mLMOlgiH5UOXH
         YcnpMVA+6ShZhJkVLfQLCbVdlHMqQsgz84qTczfGMqwOL9pP9ZXe+yxIMIObQmYN7Q7B
         YY+LPx1eJCw4U7xQL6AlflA54rYOup2GQNwhnCAxAq/kZZzPpV++DJgOkoy1NE3OTZZE
         1/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dkVRjPzDyeIj1c4QcPgMS7rIVBwKEFcEdWyYnJMVhwM=;
        b=E2mpkzrgjAUThjX/eq6YwsW3D8MDSVMfRLSnvMsajxtosBwnfekqRJNs6EWOjZDRFh
         kr7jBlSWbIMrV7IsgStPup8lmkbhfEUdCX673eLq2YOZPru8OKeWNimr4ySp67/sI7ba
         sb5KF3itd0m4Hfn8UC+qokEA5y1+pR+iUHnaK3e37RLPUoK8blQOKemtTU94L9fvqdam
         noQpoQyUK2FO12Lah47yA6IMW8IEM0HehJNKzjaklQQbltI4dGn6JBsnn/CNS24yH6qj
         jWLitWq+F/9RGT3k1I/BtUq5AIzoGv4PelDUokBwc7T/QBVjAruD18JGBhkP8Hth1Wgk
         9Yow==
X-Gm-Message-State: AJcUuke6eCkWMxaoY3tMh1dKDXUjgfFriA+gCBgYPwcQuwxuJF762qb+
        fgSidKJdtVC2YsRiT8ZgEP3Rxw==
X-Google-Smtp-Source: ALg8bN5N75H1UMcMs0USfDl3H4GJ7efdoHTdpnEFJ94PWWg7KZz49O6Dqne2s/ZEBWEJXtyq3e9zHw==
X-Received: by 2002:a19:645b:: with SMTP id b27mr6916058lfj.14.1547645590814;
        Wed, 16 Jan 2019 05:33:10 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id v19sm1158341lfe.69.2019.01.16.05.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 05:33:09 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Wed, 16 Jan 2019 14:33:09 +0100
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 4/6] media: adv748x: Store the source subdevice in TX
Message-ID: <20190116133309.GO7393@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-5-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190110140213.5198-5-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your patch.

On 2019-01-10 15:02:11 +0100, Jacopo Mondi wrote:
> The power_up_tx() procedure needs to set a few registers conditionally to
> the selected video source, but it currently checks for the provided tx to
> be either TXA or TXB.
> 
> With the introduction of dynamic routing between HDMI and AFE entities to
> TXA, checking which TX the function is operating on is not meaningful anymore.
> 
> To fix this, store the subdevice of the source providing video data to the
> CSI-2 TX in the 'struct adv748x_csi2' representing the TX and check on it.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c |  2 +-
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 13 ++++++++++---
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index ad4e6424753a..200e00f93546 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -254,7 +254,7 @@ static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
>  	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
>  
>  	/* ADI Required Write */
> -	if (is_txa(tx)) {
> +	if (tx->src == &state->hdmi.sd) {
>  		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
>  		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
>  	} else {
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 8c3714495e11..353b6b9bf6a7 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -46,9 +46,16 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
>  			return ret;
>  	}
>  
> -	return media_create_pad_link(&src->entity, src_pad,
> -				     &tx->sd.entity, ADV748X_CSI2_SINK,
> -				     enable ? MEDIA_LNK_FL_ENABLED : 0);
> +	ret = media_create_pad_link(&src->entity, src_pad,
> +				    &tx->sd.entity, ADV748X_CSI2_SINK,
> +				    enable ? MEDIA_LNK_FL_ENABLED : 0);
> +	if (ret)
> +		return ret;
> +
> +	if (enable)
> +		tx->src = src;
> +
> +	return 0;
>  }
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index ab0c84adbea9..d22270f5e2c1 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -84,6 +84,7 @@ struct adv748x_csi2 {
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;
>  	struct v4l2_ctrl *pixel_rate;
> +	struct v4l2_subdev *src;
>  	struct v4l2_subdev sd;
>  };
>  
> -- 
> 2.20.1
> 

-- 
Regards,
Niklas Söderlund
