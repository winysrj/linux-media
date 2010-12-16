Return-path: <mchehab@gaivota>
Received: from mail-bw0-f42.google.com ([209.85.214.42]:43806 "EHLO
	mail-bw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab0LPV27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 16:28:59 -0500
Received: by bwz13 with SMTP id 13so154704bwz.1
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 13:28:58 -0800 (PST)
Subject: Re: [PATCH 3/4] rc: conversion is to microseconds, not nanoseconds
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1292526037-21491-4-git-send-email-jarod@redhat.com>
References: <1292526037-21491-1-git-send-email-jarod@redhat.com>
	 <1292526037-21491-4-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 23:28:55 +0200
Message-ID: <1292534935.19587.5.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 2010-12-16 at 14:00 -0500, Jarod Wilson wrote:
> Fix a thinko, and move macro definition to a common header so it can be
> shared amongst all drivers, as ms to us conversion is something that
> multiple drivers need to do. We probably ought to have its inverse
> available as well.


Nope, at least ENE gets 'us' samples, that is 10^-6 seconds, and I
multiply that by 1000, and that gives nanoseconds (10^-9).
I have nothing against moving MS_TO_NS to common code of course.

Best regards,
	Maxim Levitsky



> 
> Reported-by: David Härdeman <david@hardeman.nu>
> CC: Maxim Levitsky <maximlevitsky@gmail.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/media/rc/ene_ir.c |   16 ++++++++--------
>  drivers/media/rc/ene_ir.h |    2 --
>  drivers/media/rc/mceusb.c |    7 +++----
>  include/media/rc-core.h   |    1 +
>  4 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
> index 80b3c31..1203d4f 100644
> --- a/drivers/media/rc/ene_ir.c
> +++ b/drivers/media/rc/ene_ir.c
> @@ -446,27 +446,27 @@ static void ene_rx_setup(struct ene_device *dev)
>  
>  select_timeout:
>  	if (dev->rx_fan_input_inuse) {
> -		dev->rdev->rx_resolution = MS_TO_NS(ENE_FW_SAMPLE_PERIOD_FAN);
> +		dev->rdev->rx_resolution = MS_TO_US(ENE_FW_SAMPLE_PERIOD_FAN);
>  
>  		/* Fan input doesn't support timeouts, it just ends the
>  			input with a maximum sample */
>  		dev->rdev->min_timeout = dev->rdev->max_timeout =
> -			MS_TO_NS(ENE_FW_SMPL_BUF_FAN_MSK *
> +			MS_TO_US(ENE_FW_SMPL_BUF_FAN_MSK *
>  				ENE_FW_SAMPLE_PERIOD_FAN);
>  	} else {
> -		dev->rdev->rx_resolution = MS_TO_NS(sample_period);
> +		dev->rdev->rx_resolution = MS_TO_US(sample_period);
>  
>  		/* Theoreticly timeout is unlimited, but we cap it
>  		 * because it was seen that on one device, it
>  		 * would stop sending spaces after around 250 msec.
>  		 * Besides, this is close to 2^32 anyway and timeout is u32.
>  		 */
> -		dev->rdev->min_timeout = MS_TO_NS(127 * sample_period);
> -		dev->rdev->max_timeout = MS_TO_NS(200000);
> +		dev->rdev->min_timeout = MS_TO_US(127 * sample_period);
> +		dev->rdev->max_timeout = MS_TO_US(200000);
>  	}
>  
>  	if (dev->hw_learning_and_tx_capable)
> -		dev->rdev->tx_resolution = MS_TO_NS(sample_period);
> +		dev->rdev->tx_resolution = MS_TO_US(sample_period);
>  
>  	if (dev->rdev->timeout > dev->rdev->max_timeout)
>  		dev->rdev->timeout = dev->rdev->max_timeout;
> @@ -801,7 +801,7 @@ static irqreturn_t ene_isr(int irq, void *data)
>  
>  		dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
>  
> -		ev.duration = MS_TO_NS(hw_sample);
> +		ev.duration = MS_TO_US(hw_sample);
>  		ev.pulse = pulse;
>  		ir_raw_event_store_with_filter(dev->rdev, &ev);
>  	}
> @@ -821,7 +821,7 @@ static void ene_setup_default_settings(struct ene_device *dev)
>  	dev->learning_mode_enabled = learning_mode_force;
>  
>  	/* Set reasonable default timeout */
> -	dev->rdev->timeout = MS_TO_NS(150000);
> +	dev->rdev->timeout = MS_TO_US(150000);
>  }
>  
>  /* Upload all hardware settings at once. Used at load and resume time */
> diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
> index c179baf..337a41d 100644
> --- a/drivers/media/rc/ene_ir.h
> +++ b/drivers/media/rc/ene_ir.h
> @@ -201,8 +201,6 @@
>  #define dbg_verbose(format, ...)	__dbg(2, format, ## __VA_ARGS__)
>  #define dbg_regs(format, ...)		__dbg(3, format, ## __VA_ARGS__)
>  
> -#define MS_TO_NS(msec) ((msec) * 1000)
> -
>  struct ene_device {
>  	struct pnp_dev *pnp_dev;
>  	struct rc_dev *rdev;
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 94b95d4..9c55e32 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -48,7 +48,6 @@
>  #define USB_BUFLEN		32 /* USB reception buffer length */
>  #define USB_CTRL_MSG_SZ		2  /* Size of usb ctrl msg on gen1 hw */
>  #define MCE_G1_INIT_MSGS	40 /* Init messages on gen1 hw to throw out */
> -#define MS_TO_NS(msec)		((msec) * 1000)
>  
>  /* MCE constants */
>  #define MCE_CMDBUF_SIZE		384  /* MCE Command buffer length */
> @@ -815,7 +814,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
>  	switch (ir->buf_in[index]) {
>  	/* 2-byte return value commands */
>  	case MCE_CMD_S_TIMEOUT:
> -		ir->rc->timeout = MS_TO_NS((hi << 8 | lo) / 2);
> +		ir->rc->timeout = MS_TO_US((hi << 8 | lo) / 2);
>  		break;
>  
>  	/* 1-byte return value commands */
> @@ -856,7 +855,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  			ir->rem--;
>  			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
>  			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
> -					 * MS_TO_NS(MCE_TIME_UNIT);
> +					 * MS_TO_US(MCE_TIME_UNIT);
>  
>  			dev_dbg(ir->dev, "Storing %s with duration %d\n",
>  				rawir.pulse ? "pulse" : "space",
> @@ -1059,7 +1058,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  	rc->priv = ir;
>  	rc->driver_type = RC_DRIVER_IR_RAW;
>  	rc->allowed_protos = RC_TYPE_ALL;
> -	rc->timeout = MS_TO_NS(1000);
> +	rc->timeout = MS_TO_US(1000);
>  	if (!ir->flags.no_tx) {
>  		rc->s_tx_mask = mceusb_set_tx_mask;
>  		rc->s_tx_carrier = mceusb_set_tx_carrier;
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index ffc93dd..830666d 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -185,6 +185,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
>  }
>  
>  #define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
> +#define MS_TO_US(msec)		((msec) * 1000)
>  
>  void ir_raw_event_handle(struct rc_dev *dev);
>  int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);


