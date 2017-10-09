Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43555 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751715AbdJIJUz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 05:20:55 -0400
Subject: Re: [PATCH v2 10/25] media: lirc: validate scancode for transmit
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
 <46af0b140d94a0e4f192120e4e9c68e5bc18ff23.1507192752.git.sean@mess.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1eb71761-53ce-0418-5311-782c3c220164@xs4all.nl>
Date: Mon, 9 Oct 2017 11:20:52 +0200
MIME-Version: 1.0
In-Reply-To: <46af0b140d94a0e4f192120e4e9c68e5bc18ff23.1507192752.git.sean@mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/10/17 10:45, Sean Young wrote:
> Ensure we reject an attempt to transmit invalid scancodes.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/ir-lirc-codec.c |  3 +++
>  drivers/media/rc/rc-core-priv.h  |  1 +
>  drivers/media/rc/rc-main.c       | 53 +++++++++++++++++++++++++---------------
>  3 files changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 94561d8b0c0b..863d975d40fb 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -122,6 +122,9 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  		    scan.timestamp)
>  			return -EINVAL;
>  
> +		if (!rc_validate_scancode(scan.rc_proto, scan.scancode))
> +			return -EINVAL;
> +
>  		if (dev->tx_scancode) {
>  			ret = dev->tx_scancode(dev, &scan);
>  			return ret < 0 ? ret : n;
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 21e515d34f64..a064c401fa38 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -160,6 +160,7 @@ static inline bool is_timing_event(struct ir_raw_event ev)
>  #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
>  
>  /* functions for IR encoders */
> +bool rc_validate_scancode(enum rc_proto proto, u32 scancode);
>  
>  static inline void init_ir_raw_event_duration(struct ir_raw_event *ev,
>  					      unsigned int pulse,
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 758c14b90a87..38393f13822f 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -776,6 +776,37 @@ void rc_keydown_notimeout(struct rc_dev *dev, enum rc_proto protocol,
>  EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
>  
>  /**
> + * rc_validate_scancode() - checks that a scancode is valid for a protocol
> + * @proto:	protocol
> + * @scancode:	scancode
> + */
> +bool rc_validate_scancode(enum rc_proto proto, u32 scancode)

The scancode in struct lirc_scancode is a u64. Shouldn't this be a u64 as well?

> +{
> +	switch (proto) {
> +	case RC_PROTO_NECX:
> +		if ((((scancode >> 16) ^ ~(scancode >> 8)) & 0xff) == 0)
> +			return false;
> +		break;
> +	case RC_PROTO_NEC32:
> +		if ((((scancode >> 24) ^ ~(scancode >> 16)) & 0xff) == 0)
> +			return false;
> +		break;
> +	case RC_PROTO_RC6_MCE:
> +		if ((scancode & 0xffff0000) != 0x800f0000)
> +			return false;
> +		break;
> +	case RC_PROTO_RC6_6A_32:
> +		if ((scancode & 0xffff0000) == 0x800f0000)
> +			return false;

I think that some comments explaining what is tested here would be useful.

This can be done in a separate patch, or done here.

Regards,

	Hans

> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return true;
> +}
> +
> +/**
>   * rc_validate_filter() - checks that the scancode and mask are valid and
>   *			  provides sensible defaults
>   * @dev:	the struct rc_dev descriptor of the device
> @@ -793,26 +824,8 @@ static int rc_validate_filter(struct rc_dev *dev,
>  
>  	mask = protocols[protocol].scancode_bits;
>  
> -	switch (protocol) {
> -	case RC_PROTO_NECX:
> -		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
> -			return -EINVAL;
> -		break;
> -	case RC_PROTO_NEC32:
> -		if ((((s >> 24) ^ ~(s >> 16)) & 0xff) == 0)
> -			return -EINVAL;
> -		break;
> -	case RC_PROTO_RC6_MCE:
> -		if ((s & 0xffff0000) != 0x800f0000)
> -			return -EINVAL;
> -		break;
> -	case RC_PROTO_RC6_6A_32:
> -		if ((s & 0xffff0000) == 0x800f0000)
> -			return -EINVAL;
> -		break;
> -	default:
> -		break;
> -	}
> +	if (!rc_validate_scancode(protocol, s))
> +		return -EINVAL;
>  
>  	filter->data &= mask;
>  	filter->mask &= mask;
> 
