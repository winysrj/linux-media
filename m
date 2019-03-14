Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E61C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 052AF2075C
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="li77Xd2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfCNOpD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:45:03 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:52316 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbfCNOpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 10:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Buyb2qH3FWsfb8gK2QY86URawQ3eEv/ckKI6qOz1RNI=; b=li77Xd2tO8lLsC8wHX/ULYpNgU
        kzi485EcgdNGZgFNjZYE/IIrRYhTB97Uu5X+orQLFN1VoTmUIcO7c7qaUQ7XpUV5JZRMGl+85kFi1
        byyb2VpIsNzdMb1dmec2Dbn8KqxaTqPQqoyOOsNOpe39ZokjYSQaEvfZUbYgbFy0/pQc=;
Received: from [109.168.11.45] (port=50894 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h4RbQ-00HH48-AA; Thu, 14 Mar 2019 15:45:00 +0100
Subject: Re: [PATCH v3 09/31] media: entity: Add media_has_route() function
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-10-jacopo+renesas@jmondi.org>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <d297c850-8af5-f435-861a-644fb64933e3@lucaceresoli.net>
Date:   Thu, 14 Mar 2019 15:45:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190305185150.20776-10-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

in the Subject line:
s/media_has_route/media_entity_has_route/

On 05/03/19 19:51, Jacopo Mondi wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This is a wrapper around the media entity has_route operation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/media-entity.c | 19 +++++++++++++++++++
>  include/media/media-entity.h | 17 +++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 6f5196d05894..8e0ca8b1cfa2 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -238,6 +238,25 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
>   * Graph traversal
>   */
>  
> +bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> +			    unsigned int pad1)
> +{
> +	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
> +		return false;
> +
> +	if (pad0 == pad1)
> +		return true;
> +
> +	if (!entity->ops || !entity->ops->has_route)
> +		return true;

Entities that implement has_route in following patches return false if
called with two sink pads or two source pads. This code behaves
differently. Which behavior is correct? IOW, how do you define "two
entity pads are connected internally"?

> +	if (entity->pads[pad1].index < entity->pads[pad0].index)
> +		swap(pad0, pad1);
> +
> +	return entity->ops->has_route(entity, pad0, pad1);
> +}
> +EXPORT_SYMBOL_GPL(media_entity_has_route);
> +
>  static struct media_pad *
>  media_pad_other(struct media_pad *pad, struct media_link *link)
>  {
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 675bc27b8b3c..205561545d7e 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -919,6 +919,23 @@ int media_entity_get_fwnode_pad(struct media_entity *entity,
>  __must_check int media_graph_walk_init(
>  	struct media_graph *graph, struct media_device *mdev);
>  
> +/**
> + * media_entity_has_route - Check if two entity pads are connected internally
> + *
> + * @entity: The entity
> + * @pad0: The first pad index
> + * @pad1: The second pad index
> + *
> + * This function can be used to check whether two pads of an entity are
> + * connected internally in the entity.
> + *
> + * The caller must hold entity->graph_obj.mdev->mutex.
> + *
> + * Return: true if the pads are connected internally and false otherwise.
> + */
> +bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> +			    unsigned int pad1);
> +
>  /**
>   * media_graph_walk_cleanup - Release resources used by graph walk.
>   *
> 

-- 
Luca
