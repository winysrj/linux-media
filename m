Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57433 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752005AbdK1OC3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 09:02:29 -0500
Subject: Re: [PATCH] media: i2c: adv748x: Restore full DT paths in kernel
 messages
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1511874084-5068-1-git-send-email-geert+renesas@glider.be>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <60496d91-446a-435e-41a4-3e579c6fe08b@ideasonboard.com>
Date: Tue, 28 Nov 2017 14:02:25 +0000
MIME-Version: 1.0
In-Reply-To: <1511874084-5068-1-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for the patch.

On 28/11/17 13:01, Geert Uytterhoeven wrote:
> As of_node_full_name() now returns only the basename, the endpoint
> information printed became useless:
> 
>     adv748x 4-0070: Endpoint endpoint on port 7
>     adv748x 4-0070: Endpoint endpoint on port 8
>     adv748x 4-0070: Endpoint endpoint on port 10
>     adv748x 4-0070: Endpoint endpoint on port 11
> 
> Restore the old behavior by using "%pOF" instead:
> 
>     adv748x 4-0070: Endpoint /soc/i2c@e66d8000/video-receiver@70/port@7/endpoint on port 7
>     adv748x 4-0070: Endpoint /soc/i2c@e66d8000/video-receiver@70/port@8/endpoint on port 8
>     adv748x 4-0070: Endpoint /soc/i2c@e66d8000/video-receiver@70/port@10/endpoint on port 10
>     adv748x 4-0070: Endpoint /soc/i2c@e66d8000/video-receiver@70/port@11/endpoint on port 11
> 
> Fixes: a7e4cfb0a7ca4773 ("of/fdt: only store the device node basename in full_name")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 5ee14f2c27478e3a..c1001db6a172e256 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -646,14 +646,12 @@ static int adv748x_parse_dt(struct adv748x_state *state)
>  
>  	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
>  		of_graph_parse_endpoint(ep_np, &ep);
> -		adv_info(state, "Endpoint %s on port %d",
> -				of_node_full_name(ep.local_node),
> -				ep.port);
> +		adv_info(state, "Endpoint %pOF on port %d", ep.local_node,
> +			 ep.port);
>  
>  		if (ep.port >= ADV748X_PORT_MAX) {
> -			adv_err(state, "Invalid endpoint %s on port %d",
> -				of_node_full_name(ep.local_node),
> -				ep.port);
> +			adv_err(state, "Invalid endpoint %pOF on port %d",
> +				ep.local_node, ep.port);
>  
>  			continue;
>  		}
> 
