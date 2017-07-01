Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38885 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751868AbdGAMUw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Jul 2017 08:20:52 -0400
Date: Sat, 1 Jul 2017 13:20:50 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/2] rc-main: remove input events for repeat messages
Message-ID: <20170701122050.GA7091@gofer.mess.org>
References: <149815927618.22167.7035029052539207589.stgit@zeus.hardeman.nu>
 <149815944000.22167.2535987828056972392.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149815944000.22167.2535987828056972392.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 22, 2017 at 09:24:00PM +0200, David Härdeman wrote:
> Protocols like NEC generate around 10 repeat events per second.
> 
> The input events are not very useful for userspace but still waste power
> by waking up every listener. So let's remove them (MSC_SCAN events
> are still generated for the initial keypress).
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-main.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 7387bd4d75b0..9f490aa11bc4 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -616,16 +616,11 @@ void rc_repeat(struct rc_dev *dev)
>  
>  	spin_lock_irqsave(&dev->keylock, flags);
>  
> -	if (!dev->keypressed)
> -		goto out;
> -
> -	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
> -	input_sync(dev->input_dev);

I don't agree with this. It's good to see something in user space when
a repeat received. This is useful for debugging purposes.


Sean

> -
> -	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> -	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
> +	if (dev->keypressed) {
> +		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> +		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
> +	}
>  
> -out:
>  	spin_unlock_irqrestore(&dev->keylock, flags);
>  }
>  EXPORT_SYMBOL_GPL(rc_repeat);
