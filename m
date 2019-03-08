Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA811C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4B822085A
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="mctDlnQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfCHOJS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:09:18 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:54296 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfCHOJS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 09:09:18 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AFB31309;
        Fri,  8 Mar 2019 15:09:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552054155;
        bh=6Y6MpQ2Nml4Tz+W5wck3Z07KDPNkk047EcGsGPtKfYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mctDlnQKewqQpuyLnUNboFAmQ2zmTgDFbc7z5FDnix7Kaef9hJ6CnhdEwp8ho56E6
         91dtqL2dISkmMeKdLR2Rh6cf+XB2wFfuU978pDhImxCWr5teOWgeBOX4j4t//K5eoh
         1adYnkuB4X6nSC3NZ7GYnLew9PKNkGmLqv+IiXog=
Date:   Fri, 8 Mar 2019 16:09:09 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCHv4 7/9] vimc: zero the media_device on probe
Message-ID: <20190308140909.GL4802@pendragon.ideasonboard.com>
References: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
 <20190308135625.11278-8-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190308135625.11278-8-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Fri, Mar 08, 2019 at 02:56:23PM +0100, Hans Verkuil wrote:
> The media_device is part of a static global vimc_device struct.
> The media framework expects this to be zeroed before it is
> used, however, since this is a global this is not the case if
> vimc is unbound and then bound again.
> 
> So call memset to ensure any left-over values are cleared.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Do I recall correctly that you mentioned there's work in progress that
will allocate this dynamically ? If so feel free to mention it in the
commit message if you want.

> ---
>  drivers/media/platform/vimc/vimc-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> index 0fbb7914098f..3aa62d7e3d0e 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -304,6 +304,8 @@ static int vimc_probe(struct platform_device *pdev)
>  
>  	dev_dbg(&pdev->dev, "probe");
>  
> +	memset(&vimc->mdev, 0, sizeof(vimc->mdev));
> +
>  	/* Create platform_device for each entity in the topology*/
>  	vimc->subdevs = devm_kcalloc(&vimc->pdev.dev, vimc->pipe_cfg->num_ents,
>  				     sizeof(*vimc->subdevs), GFP_KERNEL);

-- 
Regards,

Laurent Pinchart
