Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:55424 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbeG3U4r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 16:56:47 -0400
Date: Mon, 30 Jul 2018 21:20:18 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: read out of bounds if bpf reports high
 protocol number
Message-ID: <20180730192018.fadzkzfjudyxgy2t@lenny.lan>
References: <20180728091115.16971-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180728091115.16971-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Sat, Jul 28, 2018 at 10:11:15AM +0100, Sean Young wrote:
> The repeat period is read from a static array. If a keydown event is
> reported from bpf with a high protocol number, we read out of bounds. This
> is unlikely to end up with a reasonable repeat period at the best of times,
> in which case no timely key up event is generated.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/rc-main.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 2e222d9ee01f..a24850be1f4f 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -679,6 +679,14 @@ static void ir_timer_repeat(struct timer_list *t)
>  	spin_unlock_irqrestore(&dev->keylock, flags);
>  }
>  
> +unsigned int repeat_period(int protocol)
> +{
> +	if (protocol >= ARRAY_SIZE(protocols))
> +		return 100;

100 seems a bit arbitrarily chosen to me. Wouldn't it be better to
(re-)use eg protocols[RC_PROTO_UNKNOWN].repeat_period here?

so long,

Hias

> +
> +	return protocols[protocol].repeat_period;
> +}
> +
>  /**
>   * rc_repeat() - signals that a key is still pressed
>   * @dev:	the struct rc_dev descriptor of the device
> @@ -691,7 +699,7 @@ void rc_repeat(struct rc_dev *dev)
>  {
>  	unsigned long flags;
>  	unsigned int timeout = nsecs_to_jiffies(dev->timeout) +
> -		msecs_to_jiffies(protocols[dev->last_protocol].repeat_period);
> +		msecs_to_jiffies(repeat_period(dev->last_protocol));
>  	struct lirc_scancode sc = {
>  		.scancode = dev->last_scancode, .rc_proto = dev->last_protocol,
>  		.keycode = dev->keypressed ? dev->last_keycode : KEY_RESERVED,
> @@ -803,7 +811,7 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
>  
>  	if (dev->keypressed) {
>  		dev->keyup_jiffies = jiffies + nsecs_to_jiffies(dev->timeout) +
> -			msecs_to_jiffies(protocols[protocol].repeat_period);
> +			msecs_to_jiffies(repeat_period(protocol));
>  		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
>  	}
>  	spin_unlock_irqrestore(&dev->keylock, flags);
> -- 
> 2.17.1
> 
