Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09D3C10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 12:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AB902081B
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 12:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfCGMtf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 07:49:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:29495 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfCGMtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 07:49:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Mar 2019 04:49:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,451,1544515200"; 
   d="scan'208";a="132335390"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 07 Mar 2019 04:49:33 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id ED0ED204CC; Thu,  7 Mar 2019 14:49:32 +0200 (EET)
Date:   Thu, 7 Mar 2019 14:49:32 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 28/31] adv748x: afe: Implement has_route()
Message-ID: <20190307124932.pbi6lox5o5rr5ucg@paasikivi.fi.intel.com>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-29-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305185150.20776-29-jacopo+renesas@jmondi.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 05, 2019 at 07:51:47PM +0100, Jacopo Mondi wrote:
> Now that the adv748x subdevice supports internal routing, add an
> has_route() operation used during media graph traversal.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c | 26 +++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index 3f770f71413f..39ac55f0adbb 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -463,6 +463,30 @@ static const struct v4l2_subdev_ops adv748x_afe_ops = {
>  	.pad = &adv748x_afe_pad_ops,
>  };
>  
> +/* -----------------------------------------------------------------------------
> + * media_entity_operations
> + */
> +
> +static bool adv748x_afe_has_route(struct media_entity *entity,
> +				  unsigned int pad0, unsigned int pad1)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +
> +	/* Only consider direct sink->source routes. */
> +	if (pad0 > ADV748X_AFE_SINK_AIN7 ||
> +	    pad1 != ADV748X_AFE_SOURCE)

Fits on a single line.

> +		return false;
> +
> +	if (pad0 != afe->input)
> +		return false;
> +
> +	return true;
> +}
> +
> +static const struct media_entity_operations adv748x_afe_entity_ops = {
> +	.has_route = adv748x_afe_has_route,
> +};
>  /* -----------------------------------------------------------------------------
>   * Controls
>   */
> @@ -595,6 +619,8 @@ int adv748x_afe_init(struct adv748x_afe *afe)
>  
>  	afe->pads[ADV748X_AFE_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>  
> +	afe->sd.entity.ops = &adv748x_afe_entity_ops;
> +
>  	ret = media_entity_pads_init(&afe->sd.entity, ADV748X_AFE_NR_PADS,
>  			afe->pads);
>  	if (ret)
> -- 
> 2.20.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
