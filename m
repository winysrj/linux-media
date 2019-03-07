Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ED1C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 597C820835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfCGKJ2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:09:28 -0500
Received: from mga18.intel.com ([134.134.136.126]:33721 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfCGKJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 05:09:28 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Mar 2019 02:09:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,451,1544515200"; 
   d="scan'208";a="129584438"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 07 Mar 2019 02:09:26 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 07442204CC; Thu,  7 Mar 2019 12:09:24 +0200 (EET)
Date:   Thu, 7 Mar 2019 12:09:24 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 12/31] media: entity: Add an iterator helper for
 connected pads
Message-ID: <20190307100924.4iuabzet67ttgk2p@paasikivi.fi.intel.com>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-13-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190305185150.20776-13-jacopo+renesas@jmondi.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Tue, Mar 05, 2019 at 07:51:31PM +0100, Jacopo Mondi wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Add a helper macro for iterating over pads that are connected through
> enabled routes. This can be used to find all the connected pads within an
> entity, for instance starting from the pad which has been obtained during
> the graph walk.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> - Make __media_entity_next_routed_pad() return NULL and adjust the
>   iterator to handle that
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  include/media/media-entity.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 205561545d7e..82f0bdf2a6d1 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
>  bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>  			    unsigned int pad1);
>  
> +static inline struct media_pad *__media_entity_next_routed_pad(
> +	struct media_pad *start, struct media_pad *iter)
> +{
> +	struct media_entity *entity = start->entity;
> +
> +	while (iter < &entity->pads[entity->num_pads] &&
> +	       !media_entity_has_route(entity, start->index, iter->index))
> +		iter++;
> +
> +	return iter == &entity->pads[entity->num_pads] ? NULL : iter;

Could you use iter <= ...?

It doesn't seem to matter here, but it'd seem safer to change the check.

> +}
> +
> +/**
> + * media_entity_for_each_routed_pad - Iterate over entity pads connected by routes
> + *
> + * @start: The stating pad
> + * @iter: The iterator pad
> + *
> + * Iterate over all pads connected through routes from a given pad
> + * within an entity. The iteration will include the starting pad itself.
> + */
> +#define media_entity_for_each_routed_pad(start, iter)			\
> +	for (iter = __media_entity_next_routed_pad(			\
> +		     start, (start)->entity->pads);			\
> +	     iter != NULL;						\
> +	     iter = __media_entity_next_routed_pad(start, iter + 1))
> +
>  /**
>   * media_graph_walk_cleanup - Release resources used by graph walk.
>   *

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
