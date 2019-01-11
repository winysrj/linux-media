Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C568C43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FFC2133F
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:50:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="fRwc7rHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbfAKMuy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 07:50:54 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:54702 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730166AbfAKMuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 07:50:54 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 27847513;
        Fri, 11 Jan 2019 13:50:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547211051;
        bh=jp28aC2OekCr7h4erfF6eTu0yPYzJhnWHrF48ghyfWA=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fRwc7rHBrEitWkj36KRZiUcw/NESbHevRJAbYldrBCUi0dBeIKY7worfFSeYyLozn
         OmmoMe3MvaGoKRLaCK6VdIAF0wfR3BpxxDYJMl4mH6Mbc3dAl40aqbQC7DHqPSU9V7
         PQl9WajTwZtP1bX4Z3InzuiqrgJcNsE/YvQ41aik=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 3/4] i2c: adv748x: store number of CSI-2 lanes
 described in device tree
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
References: <20181129020147.22115-1-niklas.soderlund+renesas@ragnatech.se>
 <20181129020147.22115-4-niklas.soderlund+renesas@ragnatech.se>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <ac405527-18fc-eb9b-f581-ec89b62d724d@ideasonboard.com>
Date:   Fri, 11 Jan 2019 12:50:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181129020147.22115-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 29/11/2018 02:01, Niklas Söderlund wrote:
> The adv748x CSI-2 transmitters TXA and TXB can use different number of
> lanes to transmit data. In order to be able to configure the device
> correctly this information need to be parsed from device tree and stored
> in each TX private data structure.
> 
> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> 

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

> 
> ---
> * Changes since v2
> - Rebase to latest media-tree requires the bus_type filed in struct
>   v4l2_fwnode_endpoint to be initialized, set it to V4L2_MBUS_CSI2_DPHY.
> 
> * Changes since v1
> - Use %u instead of %d to print unsigned int.
> - Fix spelling in commit message, thanks Laurent.
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 50 ++++++++++++++++++++++++
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  2 files changed, 51 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 2384f50dacb0ccff..9d80d7f3062b16bc 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-ioctl.h>
>  
>  #include "adv748x.h"
> @@ -521,12 +522,56 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
>  	sd->entity.ops = &adv748x_media_ops;
>  }
>  
> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> +				    unsigned int port,
> +				    struct device_node *ep)
> +{
> +	struct v4l2_fwnode_endpoint vep;
> +	unsigned int num_lanes;
> +	int ret;
> +
> +	if (port != ADV748X_PORT_TXA && port != ADV748X_PORT_TXB)
> +		return 0;
> +
> +	vep.bus_type = V4L2_MBUS_CSI2_DPHY;
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
> +	if (ret)
> +		return ret;
> +
> +	num_lanes = vep.bus.mipi_csi2.num_data_lanes;
> +
> +	if (vep.base.port == ADV748X_PORT_TXA) {
> +		if (num_lanes != 1 && num_lanes != 2 && num_lanes != 4) {
> +			adv_err(state, "TXA: Invalid number (%u) of lanes\n",
> +				num_lanes);
> +			return -EINVAL;
> +		}
> +
> +		state->txa.num_lanes = num_lanes;
> +		adv_dbg(state, "TXA: using %u lanes\n", state->txa.num_lanes);
> +	}
> +
> +	if (vep.base.port == ADV748X_PORT_TXB) {
> +		if (num_lanes != 1) {
> +			adv_err(state, "TXB: Invalid number (%u) of lanes\n",
> +				num_lanes);
> +			return -EINVAL;
> +		}
> +
> +		state->txb.num_lanes = num_lanes;
> +		adv_dbg(state, "TXB: using %u lanes\n", state->txb.num_lanes);
> +	}
> +
> +	return 0;
> +}
> +
>  static int adv748x_parse_dt(struct adv748x_state *state)
>  {
>  	struct device_node *ep_np = NULL;
>  	struct of_endpoint ep;
>  	bool out_found = false;
>  	bool in_found = false;
> +	int ret;
>  
>  	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
>  		of_graph_parse_endpoint(ep_np, &ep);
> @@ -557,6 +602,11 @@ static int adv748x_parse_dt(struct adv748x_state *state)
>  			in_found = true;
>  		else
>  			out_found = true;
> +
> +		/* Store number of CSI-2 lanes used for TXA and TXB. */
> +		ret = adv748x_parse_csi2_lanes(state, ep.port, ep_np);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	return in_found && out_found ? 0 : -ENODEV;
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 39c2fdc3b41667d8..b482c7fe6957eb85 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -79,6 +79,7 @@ struct adv748x_csi2 {
>  	struct v4l2_mbus_framefmt format;
>  	unsigned int page;
>  	unsigned int port;
> +	unsigned int num_lanes;
>  
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;
> 

-- 
Regards
--
Kieran
