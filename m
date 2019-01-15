Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F53BC43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506CB20883
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="YkFVkk1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387940AbfAOXfP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:35:15 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49320 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOXfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:35:15 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4DBA9530;
        Wed, 16 Jan 2019 00:35:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547595313;
        bh=pN1eZ5FXKZjvxJC43q9BaOr20cq8WFXG/WYazdkVon8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YkFVkk1KWInJVzZByaoIhXG8gZA3qlHpgJD7rOCEP1KWQzuL4ZGGDX0ZlJ9YjfvnI
         08uD4dbrIc0HGmx7N4DuO0X68UOExaRwWon0As4jVWSKdikVN3Z6LObQmYdE44D6Wq
         znbMXQ4rwE90Pu3Z4oAvzxJJh3LykgK/HLtyEy0M=
Date:   Wed, 16 Jan 2019 01:35:14 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 14/30] media: entity: Add debug information in graph
 walk route check
Message-ID: <20190115233514.GD31088@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-15-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-15-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:28AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index a5bb257d5a68f755..42977634d7102852 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -360,6 +360,9 @@ static void media_graph_walk_iter(struct media_graph *graph)
>  	 */
>  	if (!media_entity_has_route(pad->entity, pad->index, local->index)) {
>  		link_top(graph) = link_top(graph)->next;
> +		dev_dbg(pad->graph_obj.mdev->dev,
> +			"walk: skipping \"%s\":%u -> %u (no route)\n",
> +			pad->entity->name, pad->index, local->index);

Maybe "%s: skipping...", __func__, ?

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  		return;
>  	}
>  

-- 
Regards,

Laurent Pinchart
