Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E883C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BFE02075C
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="PuHQXWJx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfCNOpa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:45:30 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:57360 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726914AbfCNOpa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 10:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XO36dUqpemmQOl5cLg10KeAF5OwtzuVBXZk1o19UR/4=; b=PuHQXWJxwrpXvi6mye7gdDgJ8b
        a/t/CYDN6SLdKfjh9mejhrh1MFjWenBeGI7/TiOiWMH0fbo/B9gaEs6TR5U700V5PKBqLcC0CeYzJ
        F48wsvSzI99tQZx9iViZONG+mmUdhHBlcUckqKh0xd6J+B8CdWpLSzXwMOwcg7kc0KGg=;
Received: from [109.168.11.45] (port=50900 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h4Rbr-00HHHe-PO; Thu, 14 Mar 2019 15:45:27 +0100
Subject: Re: [PATCH v3 26/31] adv748x: csi2: add internal routing
 configuration
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-27-jacopo+renesas@jmondi.org>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <4f5b5763-be90-4040-7d55-986471168de1@lucaceresoli.net>
Date:   Thu, 14 Mar 2019 15:45:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190305185150.20776-27-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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

begging your pardon for the noob question below...

On 05/03/19 19:51, Jacopo Mondi wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Add support to get and set the internal routing between the adv748x
> CSI-2 transmitters sink pad and its multiplexed source pad. This routing
> includes which stream of the multiplexed pad to use, allowing the user
> to select which CSI-2 virtual channel to use when transmitting the
> stream.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 65 ++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index d8f7cbee86e7..13454af72c6e 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -14,6 +14,8 @@
>  
>  #include "adv748x.h"
>  
> +#define ADV748X_CSI2_ROUTES_MAX 4
> +
>  struct adv748x_csi2_format {
>  	unsigned int code;
>  	unsigned int datatype;
> @@ -253,10 +255,73 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
>  	return 0;
>  }
>  
> +static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_krouting *routing)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct v4l2_subdev_route *r = routing->routes;
> +	unsigned int vc;
> +
> +	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
> +		routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
> +		return -ENOSPC;
> +	}
> +
> +	routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
> +
> +	for (vc = 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
> +		r->sink_pad = ADV748X_CSI2_SINK;
> +		r->sink_stream = 0;
> +		r->source_pad = ADV748X_CSI2_SOURCE;
> +		r->source_stream = vc;
> +		r->flags = vc == tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
> +		r++;Begging your pardon for the noob question...

> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_krouting *routing)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct v4l2_subdev_route *r = routing->routes;
> +	unsigned int i;
> +	int vc = -1;
> +
> +	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
> +		return -ENOSPC;
> +
> +	for (i = 0; i < routing->num_routes; i++) {
> +		if (r->sink_pad != ADV748X_CSI2_SINK ||
> +		    r->sink_stream != 0 ||
> +		    r->source_pad != ADV748X_CSI2_SOURCE ||
> +		    r->source_stream >= ADV748X_CSI2_ROUTES_MAX)
> +			return -EINVAL;
> +
> +		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
> +			if (vc != -1)
> +				return -EMLINK;
> +
> +			vc = r->source_stream;
> +		}
> +		r++;
> +	}
> +
> +	if (vc != -1)
> +		tx->vc = vc;
> +
> +	adv748x_csi2_set_virtual_channel(tx, tx->vc);
> +
> +	return 0;
> +}

Not specific to this patch but rather to the set_routing idea as a
whole: can the set_routing ioctl be called while the stream is running?

If it cannot, I find it a limiting factor for nowadays use cases. I also
didn't find where the ioctl is rejected.

If it can, then shouldn't this function call s_stream(stop) through the
sink pad whose route becomes disabled, and a s_stream(start) through the
one that gets enabled?

Thanks,
-- 
Luca
