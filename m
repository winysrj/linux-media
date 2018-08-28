Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44974 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeH1TS6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 15:18:58 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Support probing a single output
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1535369285-26032-1-git-send-email-jacopo+renesas@jmondi.org>
 <1535369285-26032-2-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <f9923f8e-4644-81bd-9ee6-1ffbf44551f3@ideasonboard.com>
Date: Tue, 28 Aug 2018 16:26:43 +0100
MIME-Version: 1.0
In-Reply-To: <1535369285-26032-2-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch,


On 27/08/18 12:28, Jacopo Mondi wrote:
> Currently the adv748x driver refuses to probe if both its output endpoints
> (TXA and TXB) are not connected.
> 
> Make the driver support probing with (at least) one output endpoint connected
> and protect the cleanup function from accessing un-initialized fields.
> 
> Following patches will fix other user of un-initialized TXs in the driver,
> such as power management functions.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 38 +++++++++++++++++++++++++-------
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 17 ++++----------
>  drivers/media/i2c/adv748x/adv748x.h      |  2 ++
>  3 files changed, 36 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 6ca88daa..78d5996 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -654,6 +654,24 @@ static int adv748x_probe(struct i2c_client *client,
>  		goto err_cleanup_clients;
>  	}
>  
> +	/*
> +	 * We can not use container_of to get back to the state with two TXs;
> +	 * Initialize the TXs's fields unconditionally on the endpoint
> +	 * presence to access them later.
> +	 */
> +	state->txa.state = state->txb.state = state;
> +	state->txa.page = ADV748X_PAGE_TXA;
> +	state->txb.page = ADV748X_PAGE_TXB;
> +	state->txa.port = ADV748X_PORT_TXA;
> +	state->txb.port = ADV748X_PORT_TXB;
> +

Initialising this data here feels a bit hacky...


> +	if (!is_tx_enabled(&state->txa) &&
> +	    !is_tx_enabled(&state->txb)) {

Could we make is_tx_enabled() based on the information it needs?

	is_tx_enabled(ADV748X_PORT_TXA);

Or perhaps:
	is_port_enabled(ADV748X_PORT_TXA)
	


> +		ret = -ENODEV;
> +		adv_err(state, "No output endpoint defined\n");
> +		goto err_cleanup_clients;
> +	}
> +

I approached this slightly differently at [0], by allowing the CSI
object to initialise, but if they return -ENODEV, then it's fine.

The only thing missing from [0] is a check to see if at least one of the
CSI devices probed.



You might be interested in [1], from my old 'adv748x/dev' branch [2] for
looking at the link creation too.

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=adv748x/for-next&id=ee53e0f7e6e0f3dacc79dcf157ce3c403b17ec14

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=adv748x/dev&id=e0e975d73a70a5b73ad674e206103cd7df983a04


[2]
https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/log/?h=adv748x/dev


>  	/* SW reset ADV748X to its default values */
>  	ret = adv748x_reset(state);
>  	if (ret) {
> @@ -676,17 +694,21 @@ static int adv748x_probe(struct i2c_client *client,
>  	}
>  
>  	/* Initialise TXA */
> -	ret = adv748x_csi2_init(state, &state->txa);
> -	if (ret) {
> -		adv_err(state, "Failed to probe TXA");
> -		goto err_cleanup_afe;
> +	if (is_tx_enabled(&state->txa)) {
> +		ret = adv748x_csi2_init(state, &state->txa);
> +		if (ret) {
> +			adv_err(state, "Failed to probe TXA");
> +			goto err_cleanup_afe;
> +		}
>  	}
>  
>  	/* Initialise TXB */
> -	ret = adv748x_csi2_init(state, &state->txb);
> -	if (ret) {
> -		adv_err(state, "Failed to probe TXB");
> -		goto err_cleanup_txa;
> +	if (is_tx_enabled(&state->txb)) {
> +		ret = adv748x_csi2_init(state, &state->txb);
> +		if (ret) {
> +			adv_err(state, "Failed to probe TXB");
> +			goto err_cleanup_txa;
> +		}
>  	}
>  
>  	return 0;
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 469be87..709cdea 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -266,20 +266,8 @@ static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
>  
>  int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
>  {
> -	struct device_node *ep;
>  	int ret;
>  
> -	/* We can not use container_of to get back to the state with two TXs */
> -	tx->state = state;
> -	tx->page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> -
> -	ep = state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA : ADV748X_PORT_TXB];
> -	if (!ep) {
> -		adv_err(state, "No endpoint found for %s\n",
> -				is_txa(tx) ? "txa" : "txb");

If you used the -ENODEV approach, this adv_err should be removed.

> -		return -ENODEV;
> -	}
> -
>  	/* Initialise the virtual channel */
>  	adv748x_csi2_set_virtual_channel(tx, 0);
>  
> @@ -288,7 +276,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
>  			    is_txa(tx) ? "txa" : "txb");
>  
>  	/* Ensure that matching is based upon the endpoint fwnodes */
> -	tx->sd.fwnode = of_fwnode_handle(ep);
> +	tx->sd.fwnode = of_fwnode_handle(state->endpoints[tx->port]);
>  
>  	/* Register internal ops for incremental subdev registration */
>  	tx->sd.internal_ops = &adv748x_csi2_internal_ops;
> @@ -321,6 +309,9 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
>  
>  void adv748x_csi2_cleanup(struct adv748x_csi2 *tx)
>  {
> +	if (!is_tx_enabled(tx))
> +		return;
> +
>  	v4l2_async_unregister_subdev(&tx->sd);
>  	media_entity_cleanup(&tx->sd.entity);
>  	v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 65f8374..1cf46c40 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -82,6 +82,7 @@ struct adv748x_csi2 {
>  	struct adv748x_state *state;
>  	struct v4l2_mbus_framefmt format;
>  	unsigned int page;
> +	unsigned int port;
>  
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;
> @@ -91,6 +92,7 @@ struct adv748x_csi2 {
>  
>  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
>  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
> +#define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)

>  
>  enum adv748x_hdmi_pads {
>  	ADV748X_HDMI_SINK,
> 
