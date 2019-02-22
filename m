Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB9CC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2BE20700
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HyYm/yA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfBVLRp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:17:45 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33844 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfBVLRp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:17:45 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 829622D2;
        Fri, 22 Feb 2019 12:17:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550834263;
        bh=/P4lhD0h3vskod55YaxCPsRq3IyXOZuySGFoIRdemhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HyYm/yA90Dlb4a6EFFRtj98cHfKIo98AkzvgW4pfRdD1OcTZ4jOwRcJfzXRGDozCL
         J2ng0q2mhFmLO7DcQCw3F1IQC8mrixbMyYjvAvWzQNSI6Y39Gy1RQGxdUNqJW9IJBp
         HBonAg61A11LyslOLnWbpXShO8rtclUI9qy/ivjM=
Date:   Fri, 22 Feb 2019 13:17:39 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 4/7] media-entity: set ent_enum->bmap to NULL after
 freeing it
Message-ID: <20190222111739.GM3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-5-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-5-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:45PM +0100, Hans Verkuil wrote:
> Ensure that this pointer is set to NULL after it is freed.
> The vimc driver has a static media_entity and after
> unbinding and rebinding the vimc device the media code will
> try to free this pointer again since it wasn't set to NULL.

As this fixes a problem in vimc, should you add a Fixes: tag ? To avoid
other similar problems, I think the vimc driver should allocate the
media_device and other device data dynamically at probe time. Bundling
them with the platform_device in struct vimc_device isn't a good idea.

> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/media-entity.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 0b1cb3559140..7b2a2cc95530 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -88,6 +88,7 @@ EXPORT_SYMBOL_GPL(__media_entity_enum_init);
>  void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
>  {
>  	kfree(ent_enum->bmap);
> +	ent_enum->bmap = NULL;
>  }
>  EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
>  

-- 
Regards,

Laurent Pinchart
