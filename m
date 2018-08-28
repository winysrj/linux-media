Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45160 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbeH1TjZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 15:39:25 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 2/2] media: i2c: adv748x: Handle TX[A|B] power management
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1535369285-26032-1-git-send-email-jacopo+renesas@jmondi.org>
 <1535369285-26032-3-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <33085517-c771-05c8-c053-6e6abbe83e53@ideasonboard.com>
Date: Tue, 28 Aug 2018 16:47:05 +0100
MIME-Version: 1.0
In-Reply-To: <1535369285-26032-3-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch,

On 27/08/18 12:28, Jacopo Mondi wrote:
> As the driver is now allowed to probe with a single output endpoint,
> power management routines shall now take into account the case a CSI-2 TX
> is not enabled.
> 
> Unify the adv748x_tx_power() routine to handle transparently TXA and TXB,
> and enable the CSI-2 outputs conditionally.

Great - I definitely want to see this code refactored. Ideally with a
full removal of the register lists ... but we can get there in stages :D

> 
> The AFE and HDMI backends have fixed output routes, so enable the designated
> CSI-2 output according to that.

Ah ... but what happens when the links can be changed dynamically ?
I guess we handle that then ...

> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
>  drivers/media/i2c/adv748x/adv748x-core.c | 52 +++++++++++++-------------------
>  drivers/media/i2c/adv748x/adv748x-csi2.c |  5 ---
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
>  drivers/media/i2c/adv748x/adv748x.h      |  4 +--
>  5 files changed, 25 insertions(+), 40 deletions(-)
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
> index 78d5996..0adbcb6 100644
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

I was going to query if this was dropped, but the check is identical in
the other function.

The original BSP driver had this condition as a 'fatal' error from what
I recall, which is why I kept it as a warning check.

I've only seen it fire once, when I had an incorrect power-on-off sequence.

I think the bit actually likely only gets set from one of the reglists
in the driver.

The bit is undocumented, and I didn't get any further detail from
querying analog devices. At somepoint I'd like to drop the WARN_ON with
an equivalent change which removes all references to this bit (whichever
entry in the register lists sets the bit).

But that's not an issue for this patch.



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

I think we can remove txa_read(), txb_read() now  ?




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

As discussed, I believe this refers to the 8-bit TTL I/O port.

Ideally - this functionality should be broken out to a separate port (or
pair of ports) - but that's not for here.

Keeping this here maintains the existing behaviour of the driver so
that's fine, but perhaps if you re-spin - could you add a comment to
state that the ADV748X_IO_10_PIX_OUT_EN refers to the non-supported TTL
IO port ?

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
> +	/* Conditionally enable 4-lane CSI Tx & Pixel Port */
> +	if (is_tx_enabled(&state->txa))
> +		regval |= ADV748X_IO_10_CSI4_EN;
> +	if (is_tx_enabled(&state->txb))
> +		regval |= ADV748X_IO_10_CSI1_EN;
> +	io_write(state, ADV748X_IO_10, regval);

Could be a bit of powersaving here :) Great.



>  	/* Use vid_std and v_freq as freerun resolution for CP */
>  	cp_clrset(state, ADV748X_CP_CLMP_POS, ADV748X_CP_CLMP_POS_DIS_AUTO,
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 709cdea..36bc786 100644
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
> index 1cf46c40..2e8d37a 100644
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
> @@ -400,8 +401,7 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
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
