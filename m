Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C5EC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C3A20848
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="PQpEhgso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfCENkj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:40:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33562 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfCENkj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 08:40:39 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 074FB24A;
        Tue,  5 Mar 2019 14:40:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551793237;
        bh=1/FCzakrrR2GjUUJvPnCv9Yff8xT/HsBZhsCMvBGp6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PQpEhgso1OvGMBN6n0owLfpCNUDRUEmoNVKWe/pRrwmkp2ipwZ/uNrCK81wtxzJeh
         25bGSOFCL58+l4B0x3N+IlPf1/PaYEk+l97tpktC7aiODSoE35KnAPTuYRjWPgMpPu
         Dcq6sAy/SavzVZxc3fnYQ+6IOnSGPu49mC56lLvc=
Date:   Tue, 5 Mar 2019 15:40:31 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: adv748x: select V4L2_FWNODE
Message-ID: <20190305134031.GD4949@pendragon.ideasonboard.com>
References: <20190305132332.3788205-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305132332.3788205-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Arnd,

Thank you for the patch.

On Tue, Mar 05, 2019 at 02:23:13PM +0100, Arnd Bergmann wrote:
> Building adv748x fails now unless V4L2_FWNODE is selected:
> 
> drivers/media/i2c/adv748x/adv748x-core.o: In function `adv748x_probe':
> adv748x-core.c:(.text+0x1b2c): undefined reference to `v4l2_fwnode_endpoint_parse'
> 
> Fixes: 6a18865da8e3 ("media: i2c: adv748x: store number of CSI-2 lanes described in device tree")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

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

-- 
Regards,

Laurent Pinchart
