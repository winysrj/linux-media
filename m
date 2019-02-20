Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D6DC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A40620880
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfBTVV6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:21:58 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45900 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbfBTVV6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 16:21:58 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 27B6B634C7B;
        Wed, 20 Feb 2019 23:21:48 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gwZJM-0000UR-PN; Wed, 20 Feb 2019 23:21:48 +0200
Date:   Wed, 20 Feb 2019 23:21:48 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 4/7] Implement compound control set support
Message-ID: <20190220212148.latzmpdhojzeslxl@valkosipuli.retiisi.org.uk>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
 <20190220125123.9410-5-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220125123.9410-5-laurent.pinchart@ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Feb 20, 2019 at 02:51:20PM +0200, Laurent Pinchart wrote:
> Only arrays of integer types are supported.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  yavta.c | 228 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 172 insertions(+), 56 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 6428c22f88d7..d1bfd380c03b 100644
> --- a/yavta.c
> +++ b/yavta.c
...
> @@ -1338,17 +1318,157 @@ static int video_print_control(struct device *dev,
>  	return 1;
>  }
>  
> -static int __video_print_control(struct device *dev,
> -				 const struct v4l2_query_ext_ctrl *query)
> +static int __video_get_control(struct device *dev,
> +			       const struct v4l2_query_ext_ctrl *query)
>  {
> -	return video_print_control(dev, query, true);
> +	return video_get_control(dev, query, true);
> +}
> +
> +static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
> +				     struct v4l2_ext_control *ctrl,
> +				     const char *val)
> +{
> +	unsigned int i;
> +	char *endptr;
> +	__u32 value;
> +
> +	for ( ; isspace(*val); ++val) { };
> +	if (*val++ != '{')
> +		return -EINVAL;
> +
> +	for (i = 0; i < query->elems; ++i) {
> +		for ( ; isspace(*val); ++val) { };

Why braces?

Just wondering. :-)

You could use any number of semicolons, too.

There's more below.

-- 
Sakari Ailus
