Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A69C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 17:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7298620652
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 17:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="zBfDqpB/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfCERFi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:05:38 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39909 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfCERFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 12:05:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id g80so8248918ljg.6
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2019 09:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=qHJMNVcMs+xsVplhG30B/1P6IVaUubM0ykSVg1P0wD8=;
        b=zBfDqpB/+zbwM7OTTTsch/52dM/Mgf/K/fw3vfLcIy5So+V4PxcfglurN8prwUiq4r
         l9d2/+UE/FRRD9SSp4tiMhd1+PhS31vMFIeswZCrnWMPuXBsuyjrckhT+izoahtSHMZj
         oabR8JUDKs3Jg71N96IsMbE0HzboxzcGTh4pHZHTZSCPYUOiPllD6uzBPpsFRFwRr0Jp
         JP7gOQCzez8ZVnBRuCiUQtZ6oMrot1WruvmOG/vtYOt4XOOiypn+bx23V716/K5UOsar
         cgD67wyRKtUJnvs39q1ITaUy6GcaYre1C7feTpeZcKoINC58/7Evb32yKm0DFLSNuftC
         +yJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=qHJMNVcMs+xsVplhG30B/1P6IVaUubM0ykSVg1P0wD8=;
        b=b2uv6XwKQYNjvchl55Xkdp3eB5FSTJz17JYatMnzlynm3YwSGzeDXcM2bJ/MFe2WgR
         pC54nqIIMBsrszxFuQPXRS3QbZGmbnsBW9q0df6NfjdU5QmsIpQsGq38DiCSDnMoCQU7
         rcIUDItK9NRsahHSFI+w6hK/ubuWJFW5sKy2CEx5v11/D7eGnuEQESDzKwSk5uH7JzPV
         542+qyK/4/VD8dHIeJlbW4ukhrFCqCL0/+qaAEiyUgaiF4oi3UXIt18mR19mQ2+Z3vzZ
         l5A02lwcxs7yCIv6tHLsQ01YUGvRGpzguqYC4zsTAh9nOm2buuFMv8kvnIRE6TIpZtz6
         vj/Q==
X-Gm-Message-State: APjAAAWUfE8q61u6meSFWBYvXqcyv9DiiQIoE/As33BFOIKiju31r2S/
        giUyxQBPjj+ADvgODuhEZ7Ze0w==
X-Google-Smtp-Source: APXvYqx/zwSQS45StrREoB8OlluOlCDLUWaqu1Y2XESegWHg106KQUwmC8buPpoL92VW7fffOWRJeQ==
X-Received: by 2002:a2e:9150:: with SMTP id q16mr530686ljg.18.1551805536016;
        Tue, 05 Mar 2019 09:05:36 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id u15sm2249119lja.73.2019.03.05.09.05.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Mar 2019 09:05:35 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Tue, 5 Mar 2019 18:05:34 +0100
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: adv748x: select V4L2_FWNODE
Message-ID: <20190305170534.GD9239@bigcity.dyn.berto.se>
References: <20190305132332.3788205-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190305132332.3788205-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Arnd,

Thanks for your work.

On 2019-03-05 14:23:13 +0100, Arnd Bergmann wrote:
> Building adv748x fails now unless V4L2_FWNODE is selected:
> 
> drivers/media/i2c/adv748x/adv748x-core.o: In function `adv748x_probe':
> adv748x-core.c:(.text+0x1b2c): undefined reference to `v4l2_fwnode_endpoint_parse'
> 
> Fixes: 6a18865da8e3 ("media: i2c: adv748x: store number of CSI-2 lanes described in device tree")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 6d32f8dcf83b..3f5dd80e14f8 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -221,6 +221,7 @@ config VIDEO_ADV748X
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	depends on OF
>  	select REGMAP_I2C
> +	select V4L2_FWNODE
>  	---help---
>  	  V4L2 subdevice driver for the Analog Devices
>  	  ADV7481 and ADV7482 HDMI/Analog video decoders.
> -- 
> 2.20.0
> 

-- 
Regards,
Niklas Söderlund
