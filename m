Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:42620 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbeIPTnM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Sep 2018 15:43:12 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v2 4/5] media: i2c: adv748x: Register only enabled inputs
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
 <1536161231-25221-5-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <efd35177-86c9-f03a-32e5-24a9923f4aa3@ideasonboard.com>
Date: Sun, 16 Sep 2018 15:19:59 +0100
MIME-Version: 1.0
In-Reply-To: <1536161231-25221-5-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thankyou for the patch,

On 05/09/18 16:27, Jacopo Mondi wrote:
> The adv748x assumes input endpoints are always enabled, and registers
> a subdevice for each of them everytime the corresponding output subdevice
> is registered.
> 

s/everytime/every time/

Although this sounds like something that happens repeatedly in the
lifetime of the driver when it only actually happens once I believe?

In which case perhaps:

s/everytime/when/

> Fix this by conditionally register the input subdevice only if it is

s/register/registering/

> actually described in device tree.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Otherwise,

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c |  6 +++---
>  drivers/media/i2c/adv748x/adv748x.h      | 10 ++++++++++
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 034fd93..9e9df51 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -82,15 +82,15 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
>  	 *
>  	 * Link HDMI->TXA, and AFE->TXB directly.
>  	 */
> -	if (is_txa(tx)) {
> +	if (is_txa(tx) && is_hdmi_enabled(state))
>  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
>  						  &state->hdmi.sd,
>  						  ADV748X_HDMI_SOURCE);
> -	} else {
> +	if (!is_txa(tx) && is_afe_enabled(state))
>  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
>  						  &state->afe.sd,
>  						  ADV748X_AFE_SOURCE);
> -	}
> +	return 0;
>  }
>  
>  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index eeadf05..a34004e 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -94,6 +94,16 @@ struct adv748x_csi2 {
>  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
>  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
>  #define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
> +#define is_afe_enabled(_state)					\
> +	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN1] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN2] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN3] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN4] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN5] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN6] != NULL ||	\
> +	 (_state)->endpoints[ADV748X_PORT_AIN7] != NULL)
> +#define is_hdmi_enabled(_state) ((_state)->endpoints[ADV748X_PORT_HDMI] != NULL)

Wow that's quite some conditionals on the AFE :)

We could introduce a flag instead... but it's just implementation
detail. I'll leave that up to you, if you prefer this then that's fine.
We're not on a hot-path here so it's not a big deal.


>  
>  enum adv748x_hdmi_pads {
>  	ADV748X_HDMI_SINK,
> 
