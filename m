Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52459 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbdHGUZh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:25:37 -0400
Date: Mon, 7 Aug 2017 21:25:35 +0100
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] rc-main: support CEC protocol keypress timeout
Message-ID: <20170807202535.a54swjrlptgqoxbi@gofer.mess.org>
References: <20170807133124.30682-1-hverkuil@xs4all.nl>
 <20170807133124.30682-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807133124.30682-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 07, 2017 at 03:31:23PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The CEC protocol has a keypress timeout of 550ms. Add support for this.
> 
> Note: this really should be defined in a protocol struct.

That is a good point, the names of the protocol variants and scancode bits
can also go into such a struct. This can be done at some point in the
future.

Acked-by: Sean Young <sean@mess.org>

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/rc/rc-main.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index a9eba0013525..073407a78f70 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -33,6 +33,9 @@
>  /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
>  #define IR_KEYPRESS_TIMEOUT 250
>  
> +/* The CEC protocol needs a timeout of 550 */
> +#define IR_KEYPRESS_CEC_TIMEOUT 550
> +
>  /* Used to keep track of known keymaps */
>  static LIST_HEAD(rc_map_list);
>  static DEFINE_SPINLOCK(rc_map_lock);
> @@ -622,7 +625,12 @@ void rc_repeat(struct rc_dev *dev)
>  	if (!dev->keypressed)
>  		goto out;
>  
> -	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> +	if (dev->last_protocol == RC_TYPE_CEC)
> +		dev->keyup_jiffies = jiffies +
> +			msecs_to_jiffies(IR_KEYPRESS_CEC_TIMEOUT);
> +	else
> +		dev->keyup_jiffies = jiffies +
> +			msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
>  	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
>  
>  out:
> @@ -692,7 +700,12 @@ void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 togg
>  	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
>  
>  	if (dev->keypressed) {
> -		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> +		if (protocol == RC_TYPE_CEC)
> +			dev->keyup_jiffies = jiffies +
> +				msecs_to_jiffies(IR_KEYPRESS_CEC_TIMEOUT);
> +		else
> +			dev->keyup_jiffies = jiffies +
> +				msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
>  		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
>  	}
>  	spin_unlock_irqrestore(&dev->keylock, flags);
> -- 
> 2.13.2
