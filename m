Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:57960 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755072AbdLOOGr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:06:47 -0500
Subject: Re: [PATCH] v4l: rcar-csi2: Don't bail out from probe on no ep
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
References: <1512506508-17418-1-git-send-email-jacopo+renesas@jmondi.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d022e2a8-2343-42ef-4075-d81375a490e6@xs4all.nl>
Date: Fri, 15 Dec 2017 15:06:44 +0100
MIME-Version: 1.0
In-Reply-To: <1512506508-17418-1-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Niklas,

Did you look at this? If I should take it, can you Ack it? If you are
going to squash or add it to our of your own patch series, then let me
know and I can remove it from my todo queue.

Regards,

	Hans

On 05/12/17 21:41, Jacopo Mondi wrote:
> When rcar-csi interface is not connected to any endpoint, it fails and
> bails out from probe before registering its own video subdevice.
> This prevents rcar-vin registered notifier from completing and no
> subdevice is ever registered, also for other properly connected csi
> interfaces.
> 
> Fix this not returning an error when no endpoint is connected to a csi
> interface and let the driver complete its probe function and register its
> own video subdevice.
> 
> ---
> Niklas,
>    please squash this patch in your next rcar-csi2 series (if you like it ;)
> 
> As we have discussed this is particularly useful for gmsl setup, where adv748x
> is connected to CSI20 and max9286 to CSI40/CSI41. If we disable adv748x from DTS
> we need CSI20 probe to complete anyhow otherwise no subdevice gets registered
> for the two deserializers.
> 
> Please note we cannot disable CSI20 entirely otherwise VIN's graph parsing
> breaks.
> 
> Thanks
>    j
> 
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 2793efb..90c4062 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -928,8 +928,8 @@ static int rcar_csi2_parse_dt(struct rcar_csi2 *priv)
> 
>  	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
>  	if (!ep) {
> -		dev_err(priv->dev, "Not connected to subdevice\n");
> -		return -EINVAL;
> +		dev_dbg(priv->dev, "Not connected to subdevice\n");
> +		return 0;
>  	}
> 
>  	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> --
> 2.7.4
> 
