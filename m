Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74276C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 19:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FA9A20652
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 19:39:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="OQVGfx9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfCETjV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:39:21 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:40844 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfCETjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 14:39:21 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B17D924A;
        Tue,  5 Mar 2019 20:39:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551814759;
        bh=qBysiG6x6mVtevRQyRTlOAjPgNFAz1LNM5q0bgORfCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQVGfx9WJOZJeWb3TT3uPRmNoJFYovbIyD1wdcd9rDN9r5HgsUeb3x8lLA5FhlsVT
         zOa7PZHgKouWZd4o77SUs4nxS6GtEli2ffHs5XcuLN6DUygSmKB/OVhn/XawdD2PgZ
         gLbxLNdDlfxx7Atlqpk4TjPyro7kz0MEKRZLGXoY=
Date:   Tue, 5 Mar 2019 21:39:13 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCHv2 4/9] media-entity: set ent_enum->bmap to NULL after
 freeing it
Message-ID: <20190305193913.GF14928@pendragon.ideasonboard.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-5-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305095847.21428-5-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Tue, Mar 05, 2019 at 10:58:42AM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Ensure that this pointer is set to NULL after it is freed.
> The vimc driver has a static media_entity and after
> unbinding and rebinding the vimc device the media code will
> try to free this pointer again since it wasn't set to NULL.

I still think the problem lies in the vimc driver. Reusing static
structures is really asking for trouble. I'm however not opposed to
merging this patch, as you mentioned the problem will be fixed in vimc
too. I still wonder, though, if merging this couldn't make it easier for
drivers to do the wrong thing.

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
