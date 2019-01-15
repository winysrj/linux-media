Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F2EC43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9167A208E4
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="F9DEJDUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbfAOW5p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:57:45 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49088 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730958AbfAOW5p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 17:57:45 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 496F7530;
        Tue, 15 Jan 2019 23:57:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547593062;
        bh=GX+Y9TF4MngHBS0o0YanLR7hWwVKqcOnbGBVD+Tf+F0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F9DEJDUAbNarHi2H2beRvC+egtzgKBdbtD7BrrVA4117SWmZ7ZKh6OLk6kSkUjHnU
         CzoQq/3cEa97rYhi6bJQBcj5J9fa7dsvpAkFzP4OR0E+T1MG5+ed03Foj4Kp26hdeu
         IKmbucUAzSJT6L6GAiE5kCjeec+Xe6KA+I7r6K4c=
Date:   Wed, 16 Jan 2019 00:57:43 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/30] media: entity: Swap pads if route is checked
 from source to sink
Message-ID: <20190115225743.GH28397@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:23AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> This way the pads are always passed to the has_route() op sink pad first.
> Makes sense.

Is there anything in the API that mandates one pad to be a sink and the
other pad to the a source ? I had designed the operation to allow
sink-sink and source-source connections to be checked too.

If your goal is to simplify the implementation of the .has_route()
operation in drivers, I would instead sort pad0 and pad1 by value.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>  	if (!entity->ops || !entity->ops->has_route)
>  		return true;
>  
> +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> +		swap(pad0, pad1);
> +
>  	return entity->ops->has_route(entity, pad0, pad1);
>  }
>  EXPORT_SYMBOL_GPL(media_entity_has_route);

-- 
Regards,

Laurent Pinchart
