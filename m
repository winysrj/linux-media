Return-path: <linux-media-owner@vger.kernel.org>
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53114 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdGWLWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 07:22:51 -0400
Date: Sun, 23 Jul 2017 12:22:42 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] i2c: add helpers to ease DMA handling
Message-ID: <20170723122242.7fd0edf4@jic23.retrosnub.co.uk>
In-Reply-To: <20170718102339.28726-2-wsa+renesas@sang-engineering.com>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
        <20170718102339.28726-2-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Jul 2017 12:23:36 +0200
Wolfram Sang <wsa+renesas@sang-engineering.com> wrote:

> One helper checks if DMA is suitable and optionally creates a bounce
> buffer, if not. The other function returns the bounce buffer and makes
> sure the data is properly copied back to the message.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
My knowledge of the exact requirements for dma on all platforms isn't
all that good.  Mostly it's based around the assumption that if one
forces a heap allocation and makes sure nothing else is in the
cacheline all is good.

I like the basic idea of this patch set a lot btw!

Jonathan
> ---
> Changes since v2:
> 
> * rebased to v4.13-rc1
> * helper functions are not inlined anymore but moved to i2c core
> * __must_check has been added to the buffer check helper
> * the release function has been renamed to contain 'dma' as well
> 
>  drivers/i2c/i2c-core-base.c | 68 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c.h         |  5 ++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index c89dac7fd2e7b7..7326a9d2e4eb69 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -34,6 +34,7 @@
>  #include <linux/irqflags.h>
>  #include <linux/jump_label.h>
>  #include <linux/kernel.h>
> +#include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/of_device.h>
> @@ -44,6 +45,7 @@
>  #include <linux/pm_wakeirq.h>
>  #include <linux/property.h>
>  #include <linux/rwsem.h>
> +#include <linux/sched/task_stack.h>
>  #include <linux/slab.h>
>  
>  #include "i2c-core.h"
> @@ -2240,6 +2242,72 @@ void i2c_put_adapter(struct i2c_adapter *adap)
>  }
>  EXPORT_SYMBOL(i2c_put_adapter);
>  
> +/**
> + * i2c_check_msg_for_dma() - check if a message is suitable for DMA
> + * @msg: the message to be checked
> + * @threshold: the amount of byte from which using DMA makes sense
> + * @ptr_for_bounce_buf: if not NULL, a bounce buffer will be attached to this
> + *			ptr, if needed. The bounce buffer must be freed by the
> + *			caller using i2c_release_dma_bounce_buf().
> + *
> + * Return: -ERANGE if message is smaller than threshold
> + *	   -EFAULT if message buffer is not DMA capable and no bounce buffer
> + *		   was requested
> + *	   -ENOMEM if a bounce buffer could not be created
> + *	   0 if message is suitable for DMA
> + *
> + * The return value must be checked.
> + *
> + * Note: This function should only be called from process context! It uses
> + * helper functions which work on the 'current' task.
> + */
> +int i2c_check_msg_for_dma(struct i2c_msg *msg, unsigned int threshold,
> +					u8 **ptr_for_bounce_buf)
> +{
> +	if (ptr_for_bounce_buf)
> +		*ptr_for_bounce_buf = NULL;
> +
> +	if (msg->len < threshold)
> +		return -ERANGE;
> +
> +	if (!virt_addr_valid(msg->buf) || object_is_on_stack(msg->buf)) {
> +		pr_debug("msg buffer to 0x%04x is not DMA safe%s\n", msg->addr,
> +			 ptr_for_bounce_buf ? ", trying bounce buffer" : "");
> +		if (ptr_for_bounce_buf) {
> +			if (msg->flags & I2C_M_RD)
> +				*ptr_for_bounce_buf = kzalloc(msg->len, GFP_KERNEL);
> +			else
> +				*ptr_for_bounce_buf = kmemdup(msg->buf, msg->len,
> +							      GFP_KERNEL);
> +			if (!*ptr_for_bounce_buf)
> +				return -ENOMEM;
> +		} else {
> +			return -EFAULT;
> +		}
> +	}
I'm trying to get my head around whether this is a sufficient set of conditions
for a dma safe buffer and I'm not sure it is.

We go to a lot of effort with SPI buffers to ensure they are in their own cache
lines.  Do we not need to do the same here?  The issue would be the
classic case of embedding a buffer inside a larger structure which is on
the stack.  Need the magic of __cacheline_aligned to force it into it's
own line for devices with dma-incoherent caches.
DMA-API-HOWTO.txt (not read that for a while at it is a rather good
at describing this stuff these days!)

So that one is easy enough to check by checking if it is cache line aligned,
but what do you do to know there is nothing much after it?

Not sure there is a way around this short of auditing i2c drivers to
change any that do this.
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(i2c_check_msg_for_dma);
> +
> +/**
> + * i2c_release_bounce_buf - copy data back from bounce buffer and release it
> + * @msg: the message to be copied back to
> + * @bounce_buf: the bounce buffer obtained from i2c_check_msg_for_dma().
> + *		May be NULL.
> + */
> +void i2c_release_dma_bounce_buf(struct i2c_msg *msg, u8 *bounce_buf)
> +{
> +	if (!bounce_buf)
> +		return;
> +
> +	if (msg->flags & I2C_M_RD)
> +		memcpy(msg->buf, bounce_buf, msg->len);
> +
> +	kfree(bounce_buf);
> +}
> +EXPORT_SYMBOL_GPL(i2c_release_bounce_buf);
> +
>  MODULE_AUTHOR("Simon G. Vogl <simon@tk.uni-linz.ac.at>");
>  MODULE_DESCRIPTION("I2C-Bus main module");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 00ca5b86a753f8..ac02287b6c0d8f 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -766,6 +766,11 @@ static inline u8 i2c_8bit_addr_from_msg(const struct i2c_msg *msg)
>  	return (msg->addr << 1) | (msg->flags & I2C_M_RD ? 1 : 0);
>  }
>  
> +int __must_check i2c_check_msg_for_dma(struct i2c_msg *msg, unsigned int threshold,
> +					u8 **ptr_for_bounce_buf);
> +
> +void i2c_release_dma_bounce_buf(struct i2c_msg *msg, u8 *bounce_buf);
> +
>  int i2c_handle_smbus_host_notify(struct i2c_adapter *adap, unsigned short addr);
>  /**
>   * module_i2c_driver() - Helper macro for registering a modular I2C driver
