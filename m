Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF91C10F06
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 22:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEF152173C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 22:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="g5Ozr74A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfBQW1f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 17:27:35 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33572 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfBQW1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 17:27:34 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7AFDE49;
        Sun, 17 Feb 2019 23:27:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550442450;
        bh=WFVMi80p5kAihWj01Mc4b/F1/sCBjeAL/OTCz1TE0A0=;
        h=Subject:To:Cc:References:Reply-To:From:Date:In-Reply-To:From;
        b=g5Ozr74AfLw0k5uVxjtJ7COihNjmzWu9hJ5vDYXSLBk/5gWHFenYRj8K8ovnQSax5
         jnP5aS+W1QHXgfEe0/ueKTrWKHhmzl/d67uRJ6aD3pb6TieHenR7lTEt4E5KQLjZPJ
         adHtJZkFGyq4tL0mFgUIqAp8wxpxuZ8EhiN1pVaU=
Subject: Re: [PATCH] rcar-vin: Fix lockdep warning at stream on
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
References: <20190213220754.14664-1-niklas.soderlund+renesas@ragnatech.se>
Reply-To: kieran.bingham@ideasonboard.com
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <5a6c4b25-7639-b4b9-bcc8-0da9374e6697@ideasonboard.com>
Date:   Sun, 17 Feb 2019 22:27:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190213220754.14664-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 13/02/2019 22:07, Niklas Söderlund wrote:
> Changes to v4l2-fwnode in commit [1] triggered a lockdep warning in
> rcar-vin. The first attempt to solve this warning in the rcar-vin driver
> was incomplete and only pushed the warning to happen at at stream on
> time instead of at probe time.
> 
> This change reverts the incomplete fix and properly fix the warning by
> removing the need to hold the rcar-vin specific group lock when calling
> v4l2_async_notifier_parse_fwnode_endpoints_by_port(). And instead takes
> it in the callback where it's really needed.
> 

It might have been more readable to provide the revert and the fix
separately, as it's hard to know which parts of this are the revert, and
which are 'new', but don't worry about that as it is fortuanately a
fairly clear separation below..


> 1. commit eae2aed1eab9bf08 ("media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev")
> 
> Fixes: 6458afc8c49148f0 ("media: rcar-vin: remove unneeded locking in async callbacks")
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>


Only a couple of minorish comments below.

With those fixed:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>



> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 43 +++++++++++++++------
>  1 file changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 594d804340047511..abbb5820223965e3 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -546,7 +546,9 @@ static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
>  
>  	vin_dbg(vin, "unbind parallel subdev %s\n", subdev->name);
>  
> +	mutex_lock(&vin->lock);
>  	rvin_parallel_subdevice_detach(vin);
> +	mutex_unlock(&vin->lock);
>  }
>  
>  static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
> @@ -556,7 +558,9 @@ static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
>  	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
>  	int ret;
>  
> +	mutex_lock(&vin->lock);
>  	ret = rvin_parallel_subdevice_attach(vin, subdev);
> +	mutex_unlock(&vin->lock);
>  	if (ret)
>  		return ret;
>  
> @@ -664,6 +668,7 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
>  	}
>  
>  	/* Create all media device links between VINs and CSI-2's. */
> +	mutex_lock(&vin->group->lock);
>  	for (route = vin->info->routes; route->mask; route++) {
>  		struct media_pad *source_pad, *sink_pad;
>  		struct media_entity *source, *sink;
> @@ -699,6 +704,7 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
>  			break;
>  		}
>  	}
> +	mutex_unlock(&vin->group->lock);
>  
>  	return ret;
>  }
> @@ -714,6 +720,8 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
>  		if (vin->group->vin[i])
>  			rvin_v4l2_unregister(vin->group->vin[i]);
>  
> +	mutex_lock(&vin->group->lock);
> +
>  	for (i = 0; i < RVIN_CSI_MAX; i++) {
>  		if (vin->group->csi[i].fwnode != asd->match.fwnode)
>  			continue;
> @@ -721,6 +729,8 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
>  		vin_dbg(vin, "Unbind CSI-2 %s from slot %u\n", subdev->name, i);
>  		break;
>  	}
> +
> +	mutex_unlock(&vin->group->lock);
>  }
>  
>  static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
> @@ -730,6 +740,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
>  	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
>  	unsigned int i;
>  
> +	mutex_lock(&vin->group->lock);
> +
>  	for (i = 0; i < RVIN_CSI_MAX; i++) {
>  		if (vin->group->csi[i].fwnode != asd->match.fwnode)
>  			continue;
> @@ -738,6 +750,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
>  		break;
>  	}
>  
> +	mutex_unlock(&vin->group->lock);
> +
>  	return 0;
>  }

So if I'm not mistaken, everything above this is the 'revert' and the
below is the 'fix'




>  
> @@ -752,6 +766,7 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
>  				     struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = dev_get_drvdata(dev);
> +	int ret = 0;
>  
>  	if (vep->base.port != 1 || vep->base.id >= RVIN_CSI_MAX)
>  		return -EINVAL;
> @@ -762,38 +777,48 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
>  		return -ENOTCONN;
>  	}
>  
> +	mutex_lock(&vin->group->lock);
> +
>  	if (vin->group->csi[vep->base.id].fwnode) {
>  		vin_dbg(vin, "OF device %pOF already handled\n",
>  			to_of_node(asd->match.fwnode));
> -		return -ENOTCONN;
> +		ret = -ENOTCONN;
> +		goto out;
>  	}
>  
>  	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
>  
>  	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
>  		to_of_node(asd->match.fwnode), vep->base.id);
> +out:
> +	mutex_unlock(&vin->group->lock);

I think you could unlock before you print the debug... But perhaps
that's not a critical path.



>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  {
> -	unsigned int count = 0;
> +	unsigned int count = 0, vin_mask = 0;

Shouldn't vin_mask have it's own line?

>  	unsigned int i;
>  	int ret;
>  
>  	mutex_lock(&vin->group->lock);
>  
>  	/* If not all VIN's are registered don't register the notifier. */
> -	for (i = 0; i < RCAR_VIN_NUM; i++)
> -		if (vin->group->vin[i])
> +	for (i = 0; i < RCAR_VIN_NUM; i++) {
> +		if (vin->group->vin[i]) {
>  			count++;
> +			vin_mask |= BIT(i);
> +		}
> +	}
>  
>  	if (vin->group->count != count) {
>  		mutex_unlock(&vin->group->lock);
>  		return 0;
>  	}
>  
> +	mutex_unlock(&vin->group->lock);
> +
>  	v4l2_async_notifier_init(&vin->group->notifier);
>  
>  	/*
> @@ -802,21 +827,17 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  	 * will only be registered once with the group notifier.
>  	 */
>  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> -		if (!vin->group->vin[i])
> +		if (!(vin_mask & BIT(i)))
>  			continue;
>  
>  		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  				vin->group->vin[i]->dev, &vin->group->notifier,
>  				sizeof(struct v4l2_async_subdev), 1,
>  				rvin_mc_parse_of_endpoint);
> -		if (ret) {
> -			mutex_unlock(&vin->group->lock);
> +		if (ret)
>  			return ret;
> -		}
>  	}
>  
> -	mutex_unlock(&vin->group->lock);
> -
>  	if (list_empty(&vin->group->notifier.asd_list))
>  		return 0;
>  
> 


-- 
Regards
--
Kieran
