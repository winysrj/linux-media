Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:42570 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbeIPTc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Sep 2018 15:32:26 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v2 2/5] media: i2c: adv748x: Handle TX[A|B] power
 management
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
 <1536161231-25221-3-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <78b78183-3962-fc1a-6eba-596dd3076a30@ideasonboard.com>
Date: Sun, 16 Sep 2018 15:09:15 +0100
MIME-Version: 1.0
In-Reply-To: <1536161231-25221-3-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for addressing my comments on V1.
This looks good to me here.

On 05/09/18 16:27, Jacopo Mondi wrote:
> As the driver is now allowed to probe with a single output endpoint,
> power management routines shall now take into account the case a CSI-2 TX
> is not enabled.
> 
> Unify the adv748x_tx_power() routine to handle transparently TXA and TXB,
> and enable the CSI-2 outputs conditionally.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
>  drivers/media/i2c/adv748x/adv748x-core.c | 52 +++++++++++++-------------------
>  drivers/media/i2c/adv748x/adv748x-csi2.c |  5 ---
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
>  drivers/media/i2c/adv748x/adv748x.h      |  7 ++---
>  5 files changed, 25 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index edd25e8..6d78105 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -286,7 +286,7 @@ static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
>  			goto unlock;
>  	}
>  
> -	ret = adv748x_txb_power(state, enable);
> +	ret = adv748x_tx_power(&state->txb, enable);
>  	if (ret)
>  		goto unlock;
>  
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 65c3024..72a6692 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -292,33 +292,16 @@ static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>  
> -int adv748x_txa_power(struct adv748x_state *state, bool on)
> +int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
>  {
> +	struct adv748x_state *state = tx->state;
> +	const struct adv748x_reg_value *reglist;
>  	int val;
>  
> -	val = txa_read(state, ADV748X_CSI_FS_AS_LS);
> -	if (val < 0)
> -		return val;
> -
> -	/*
> -	 * This test against BIT(6) is not documented by the datasheet, but was
> -	 * specified in the downstream driver.
> -	 * Track with a WARN_ONCE to determine if it is ever set by HW.
> -	 */
> -	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
> -			"Enabling with unknown bit set");
> -
> -	if (on)
> -		return adv748x_write_regs(state, adv748x_power_up_txa_4lane);
> -
> -	return adv748x_write_regs(state, adv748x_power_down_txa_4lane);
> -}
> -
> -int adv748x_txb_power(struct adv748x_state *state, bool on)
> -{
> -	int val;
> +	if (!is_tx_enabled(tx))
> +		return 0;
>  
> -	val = txb_read(state, ADV748X_CSI_FS_AS_LS);
> +	val = tx_read(tx, ADV748X_CSI_FS_AS_LS);
>  	if (val < 0)
>  		return val;
>  
> @@ -331,9 +314,13 @@ int adv748x_txb_power(struct adv748x_state *state, bool on)
>  			"Enabling with unknown bit set");
>  
>  	if (on)
> -		return adv748x_write_regs(state, adv748x_power_up_txb_1lane);
> +		reglist = is_txa(tx) ? adv748x_power_up_txa_4lane :
> +				       adv748x_power_up_txb_1lane;
> +	else
> +		reglist = is_txa(tx) ? adv748x_power_down_txa_4lane :
> +				       adv748x_power_down_txb_1lane;
>  
> -	return adv748x_write_regs(state, adv748x_power_down_txb_1lane);
> +	return adv748x_write_regs(state, reglist);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -482,6 +469,7 @@ static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
>  static int adv748x_reset(struct adv748x_state *state)
>  {
>  	int ret;
> +	u8 regval = ADV748X_IO_10_PIX_OUT_EN;
>  
>  	ret = adv748x_write_regs(state, adv748x_sw_reset);
>  	if (ret < 0)
> @@ -496,22 +484,24 @@ static int adv748x_reset(struct adv748x_state *state)
>  	if (ret)
>  		return ret;
>  
> -	adv748x_txa_power(state, 0);
> +	adv748x_tx_power(&state->txa, 0);
>  
>  	/* Init and power down TXB */
>  	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
>  	if (ret)
>  		return ret;
>  
> -	adv748x_txb_power(state, 0);
> +	adv748x_tx_power(&state->txb, 0);
>  
>  	/* Disable chip powerdown & Enable HDMI Rx block */
>  	io_write(state, ADV748X_IO_PD, ADV748X_IO_PD_RX_EN);
>  
> -	/* Enable 4-lane CSI Tx & Pixel Port */
> -	io_write(state, ADV748X_IO_10, ADV748X_IO_10_CSI4_EN |
> -				       ADV748X_IO_10_CSI1_EN |
> -				       ADV748X_IO_10_PIX_OUT_EN);
> +	/* Conditionally enable TXa and TXb. */
> +	if (is_tx_enabled(&state->txa))
> +		regval |= ADV748X_IO_10_CSI4_EN;
> +	if (is_tx_enabled(&state->txb))
> +		regval |= ADV748X_IO_10_CSI1_EN;
> +	io_write(state, ADV748X_IO_10, regval);
>  
>  	/* Use vid_std and v_freq as freerun resolution for CP */
>  	cp_clrset(state, ADV748X_CP_CLMP_POS, ADV748X_CP_CLMP_POS_DIS_AUTO,
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 556e13c..034fd93 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -18,11 +18,6 @@
>  
>  #include "adv748x.h"
>  
> -static bool is_txa(struct adv748x_csi2 *tx)
> -{
> -	return tx == &tx->state->txa;
> -}
> -
>  static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
>  					    unsigned int vc)
>  {
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> index aecc2a8..abb6568 100644
> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -362,7 +362,7 @@ static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)
>  
>  	mutex_lock(&state->mutex);
>  
> -	ret = adv748x_txa_power(state, enable);
> +	ret = adv748x_tx_power(&state->txa, enable);
>  	if (ret)
>  		goto done;
>  
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 1cf46c40..eeadf05 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -93,6 +93,7 @@ struct adv748x_csi2 {
>  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
>  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
>  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
> +#define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
>  
>  enum adv748x_hdmi_pads {
>  	ADV748X_HDMI_SINK,
> @@ -378,9 +379,6 @@ int adv748x_write_block(struct adv748x_state *state, int client_page,
>  #define cp_write(s, r, v) adv748x_write(s, ADV748X_PAGE_CP, r, v)
>  #define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~m) | v)
>  
> -#define txa_read(s, r) adv748x_read(s, ADV748X_PAGE_TXA, r)
> -#define txb_read(s, r) adv748x_read(s, ADV748X_PAGE_TXB, r)
> -
>  #define tx_read(t, r) adv748x_read(t->state, t->page, r)
>  #define tx_write(t, r, v) adv748x_write(t->state, t->page, r, v)
>  
> @@ -400,8 +398,7 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
>  int adv748x_register_subdevs(struct adv748x_state *state,
>  			     struct v4l2_device *v4l2_dev);
>  
> -int adv748x_txa_power(struct adv748x_state *state, bool on);
> -int adv748x_txb_power(struct adv748x_state *state, bool on);
> +int adv748x_tx_power(struct adv748x_csi2 *tx, bool on);
>  
>  int adv748x_afe_init(struct adv748x_afe *afe);
>  void adv748x_afe_cleanup(struct adv748x_afe *afe);
> 
