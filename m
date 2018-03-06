Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54744 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754052AbeCFWsJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 17:48:09 -0500
Subject: Re: [PATCHv2 5/7] cec-pin: add error injection support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
 <20180305135139.95652-6-hverkuil@xs4all.nl>
Message-ID: <526d0a58-b032-2b8b-1c47-8168918b4330@xs4all.nl>
Date: Tue, 6 Mar 2018 23:48:05 +0100
MIME-Version: 1.0
In-Reply-To: <20180305135139.95652-6-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/18 14:51, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Implement all the error injection commands.
> 
> The state machine gets new states for the various error situations,
> helper functions are added to detect whether an error injection is
> active and the actual error injections are implemented.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/cec/cec-pin-priv.h |  38 ++-
>  drivers/media/cec/cec-pin.c      | 542 +++++++++++++++++++++++++++++++++++----
>  2 files changed, 521 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-pin-priv.h b/drivers/media/cec/cec-pin-priv.h
> index 779384f18689..c9349f68e554 100644
> --- a/drivers/media/cec/cec-pin-priv.h
> +++ b/drivers/media/cec/cec-pin-priv.h

<snip>

> +static bool tx_error_inj(struct cec_pin *pin, unsigned int mode_offset,
> +			 int arg_idx, u8 *arg)
> +{
> +#ifdef CONFIG_CEC_PIN_ERROR_INJ
> +	u16 cmd = cec_pin_tx_error_inj(pin);
> +	u64 e = pin->error_inj[cmd];
> +	unsigned int mode = (e >> mode_offset) & CEC_ERROR_INJ_MODE_MASK;
> +
> +	if (arg_idx) {

Oops, this should be arg_idx >= 0. It's -1 if there is no argument associated
with the error injection command.

> +		u8 pos = pin->error_inj_args[cmd][arg_idx];
> +
> +		if (arg)
> +			*arg = pos;
> +		else if (pos != pin->tx_bit)
> +			return false;
> +	}
> +
> +	switch (mode) {
> +	case CEC_ERROR_INJ_MODE_ONCE:
> +		pin->error_inj[cmd] &= ~(CEC_ERROR_INJ_MODE_MASK << mode_offset);
> +		return true;
> +	case CEC_ERROR_INJ_MODE_ALWAYS:
> +		return true;
> +	case CEC_ERROR_INJ_MODE_TOGGLE:
> +		return pin->tx_toggle;
> +	default:
> +		return false;
> +	}
> +#else
> +	return false;
> +#endif
> +}

<snip>

> +		case EOM_BIT:
> +			v = pin->tx_bit / 10 ==
> +				pin->tx_msg.len + pin->tx_extra_bytes - 1;
> +			if (pin->tx_msg.len > 1 && tx_early_eom(pin)) {

tx_early_eom should only be called for the second-to-last byte.

> +				/* Error injection: set EOM one byte early */
> +				v = pin->tx_bit / 10 ==
> +					pin->tx_msg.len + pin->tx_extra_bytes - 2;
> +				pin->tx_post_eom = true;
> +			}
> +			if (tx_no_eom(pin)) {

Ditto for tx_no_eom: only call for the last byte.

Otherwise for mode 'once' this error injection command will be cleared
before the end of the message is reached.

> +				/* Error injection: no EOM */
> +				v = false;
> +			}
>  			pin->state = v ? CEC_ST_TX_DATA_BIT_1_LOW :
> -				CEC_ST_TX_DATA_BIT_0_LOW;
> +					 CEC_ST_TX_DATA_BIT_0_LOW;
>  			break;

Regards,

	Hans
