Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab0G1RA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:00:28 -0400
Message-ID: <4C506231.5030203@redhat.com>
Date: Wed, 28 Jul 2010 14:00:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 5/9] IR: extend interfaces to support more device settings
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com> <1280330051-27732-6-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280330051-27732-6-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> Also reuse LIRC_SET_MEASURE_CARRIER_MODE as LIRC_SET_LEARN_MODE
> (LIRC_SET_LEARN_MODE will start carrier reports if possible, and
> tune receiver to wide band mode)
> 
> This IOCTL isn't yet used by lirc, so this won't break userspace.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ir-core-priv.h  |    2 +
>  drivers/media/IR/ir-lirc-codec.c |  100 ++++++++++++++++++++++++++++++++++----
>  include/media/ir-core.h          |   11 ++++
>  include/media/lirc.h             |    4 +-
>  4 files changed, 105 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
> index 3eafdb7..4ed170d 100644
> --- a/drivers/media/IR/ir-core-priv.h
> +++ b/drivers/media/IR/ir-core-priv.h
> @@ -77,6 +77,8 @@ struct ir_raw_event_ctrl {
>  	struct lirc_codec {
>  		struct ir_input_dev *ir_dev;
>  		struct lirc_driver *drv;
> +		int timeout_report;
> +		int carrier_low;
>  	} lirc;
>  };
>  
> diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
> index 8ca01fd..0f3969c 100644
> --- a/drivers/media/IR/ir-lirc-codec.c
> +++ b/drivers/media/IR/ir-lirc-codec.c
> @@ -96,13 +96,13 @@ out:
>  	return ret;
>  }
>  
> -static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long __user arg)
>  {
>  	struct lirc_codec *lirc;
>  	struct ir_input_dev *ir_dev;
>  	int ret = 0;
>  	void *drv_data;
> -	unsigned long val;
> +	unsigned long val = 0;
>  
>  	lirc = lirc_get_pdata(filep);
>  	if (!lirc)
> @@ -116,10 +116,21 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
>  
>  	switch (cmd) {
>  	case LIRC_SET_TRANSMITTER_MASK:
> +	case LIRC_SET_SEND_CARRIER:
> +	case LIRC_SET_SEND_MODE:
> +	case LIRC_SET_REC_TIMEOUT:
> +	case LIRC_SET_REC_TIMEOUT_REPORTS:
> +	case LIRC_SET_LEARN_MODE:
> +	case LIRC_SET_REC_CARRIER:
> +	case LIRC_SET_REC_CARRIER_RANGE:
> +	case LIRC_SET_SEND_DUTY_CYCLE:
>  		ret = get_user(val, (unsigned long *)arg);
>  		if (ret)
>  			return ret;
> +	}

	As, in all cases, the argument is an __u32, you can just use this, to get 
the arguments for all LIRC_SET_* cases:

	if (_IOC_DIR(cmd) & _IOC_WRITE) {
  		ret = get_user(val, (unsigned long *)arg);
  		if (ret)
  			return ret;
	}

 
> +	switch (cmd) {
> +	case LIRC_SET_TRANSMITTER_MASK:
>  		if (ir_dev->props && ir_dev->props->s_tx_mask)
>  			ret = ir_dev->props->s_tx_mask(drv_data, (u32)val);
>  		else
> @@ -127,10 +138,6 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
>  		break;
>  
>  	case LIRC_SET_SEND_CARRIER:
> -		ret = get_user(val, (unsigned long *)arg);
> -		if (ret)
> -			return ret;
> -
>  		if (ir_dev->props && ir_dev->props->s_tx_carrier)
>  			ir_dev->props->s_tx_carrier(drv_data, (u32)val);
>  		else
> @@ -143,14 +150,75 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
>  		break;
>  
>  	case LIRC_SET_SEND_MODE:
> -		ret = get_user(val, (unsigned long *)arg);
> -		if (ret)
> -			return ret;
> -
>  		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
>  			return -EINVAL;
>  		break;
>  
> +	case LIRC_GET_REC_RESOLUTION:
> +		val = ir_dev->props->rx_resolution;
> +		ret = put_user(val, (unsigned long *)arg);
> +		break;

	You can use something like this, to handle the LIRC_GET* cases:

	switch (cmd) {
	...
	case LIRC_GET_REC_RESOLUTION:
		val = ir_dev->props->rx_resolution;
		break;
	...
	}

	if (_IOC_DIR(cmd) & _IOC_READ) {
  		ret = put_user(val, (unsigned long *)arg);
  		if (ret)
  			return ret;
	}

> +
> +	case LIRC_SET_REC_TIMEOUT:
> +		if (val < ir_dev->props->min_timeout ||
> +			val > ir_dev->props->max_timeout)
> +			return -EINVAL;
> +
> +		ir_dev->props->timeout = val;
> +		break;
> +
> +	case LIRC_SET_REC_TIMEOUT_REPORTS:
> +		ir_dev->raw->lirc.timeout_report = !!val;
> +		return 0;
> +
> +	case LIRC_GET_MIN_TIMEOUT:
> +
> +		if (!ir_dev->props->max_timeout)
> +			return -ENOSYS;
> +
> +		ret = put_user(ir_dev->props->min_timeout, (unsigned long *)arg);
> +		break;
> +	case LIRC_GET_MAX_TIMEOUT:
> +		if (!ir_dev->props->max_timeout)
> +			return -ENOSYS;
> +
> +		ret = put_user(ir_dev->props->max_timeout, (unsigned long *)arg);
> +		break;
> +
> +	case LIRC_SET_LEARN_MODE:
> +		if (ir_dev->props->s_learning_mode)
> +			return ir_dev->props->s_learning_mode(
> +				ir_dev->props->priv, !!val);
> +		else
> +			return -ENOSYS;
> +
> +	case LIRC_SET_REC_CARRIER:
> +		if (ir_dev->props->s_rx_carrier_range)
> +			ret =  ir_dev->props->s_rx_carrier_range(
> +				ir_dev->props->priv,
> +					ir_dev->raw->lirc.carrier_low, val);
> +		else
> +			return -ENOSYS;
> +
> +		if (!ret)
> +			ir_dev->raw->lirc.carrier_low = 0;
> +		break;
> +
> +	case LIRC_SET_REC_CARRIER_RANGE:
> +		if (val >= 0)
> +			ir_dev->raw->lirc.carrier_low = val;
> +		break;
> +	case LIRC_SET_SEND_DUTY_CYCLE:
> +
> +		if (!ir_dev->props->s_tx_duty_cycle)
> +			return -ENOSYS;
> +
> +		if (val <= 0 || val >= 100)
> +			return -EINVAL;
> +
> +		ir_dev->props->s_tx_duty_cycle(ir_dev->props->priv, val);
> +		break;
> +
>  	default:
>  		return lirc_dev_fop_ioctl(filep, cmd, arg);
>  	}
> @@ -200,13 +268,25 @@ static int ir_lirc_register(struct input_dev *input_dev)
>  
>  	features = LIRC_CAN_REC_MODE2;
>  	if (ir_dev->props->tx_ir) {
> +
>  		features |= LIRC_CAN_SEND_PULSE;
>  		if (ir_dev->props->s_tx_mask)
>  			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
>  		if (ir_dev->props->s_tx_carrier)
>  			features |= LIRC_CAN_SET_SEND_CARRIER;
> +
> +		if (ir_dev->props->s_tx_duty_cycle)
> +			features |= LIRC_CAN_SET_REC_DUTY_CYCLE;
>  	}
>  
> +	if (ir_dev->props->s_rx_carrier_range)
> +		features |= LIRC_CAN_SET_REC_CARRIER |
> +			LIRC_CAN_SET_REC_CARRIER_RANGE;
> +
> +	if (ir_dev->props->s_learning_mode)
> +		features |= LIRC_CAN_LEARN_MODE;
> +
> +
>  	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
>  		 ir_dev->driver_name);
>  	drv->minor = -1;
> diff --git a/include/media/ir-core.h b/include/media/ir-core.h
> index 53ce966..46cc6c5 100644
> --- a/include/media/ir-core.h
> +++ b/include/media/ir-core.h
> @@ -44,6 +44,8 @@ enum rc_driver_type {
>   * @timeout: optional time after which device stops sending data
>   * @min_timeout: minimum timeout supported by device
>   * @max_timeout: maximum timeout supported by device
> + * @rx_resolution : resolution (in ns) of input sampler
> + * @tx_resolution: resolution (in ns) of output sampler
>   * @priv: driver-specific data, to be used on the callbacks
>   * @change_protocol: allow changing the protocol used on hardware decoders
>   * @open: callback to allow drivers to enable polling/irq when IR input device
> @@ -52,9 +54,12 @@ enum rc_driver_type {
>   *	is opened.
>   * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
>   * @s_tx_carrier: set transmit carrier frequency
> + * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
> + * @s_rx_carrier: inform driver about carrier it is expected to handle
>   * @tx_ir: transmit IR
>   * @s_idle: optional: enable/disable hardware idle mode, upon which,
>  	device doesn't interrupt host untill it sees IR data
> + * @s_learning_mode: enable learning mode
>   */
>  struct ir_dev_props {
>  	enum rc_driver_type	driver_type;
> @@ -65,6 +70,8 @@ struct ir_dev_props {
>  	u64			min_timeout;
>  	u64			max_timeout;
>  
> +	u32			rx_resolution;
> +	u32			tx_resolution;
>  
>  	void			*priv;
>  	int			(*change_protocol)(void *priv, u64 ir_type);
> @@ -72,8 +79,12 @@ struct ir_dev_props {
>  	void			(*close)(void *priv);
>  	int			(*s_tx_mask)(void *priv, u32 mask);
>  	int			(*s_tx_carrier)(void *priv, u32 carrier);
> +	int			(*s_tx_duty_cycle) (void *priv, u32 duty_cycle);
> +	int			(*s_rx_carrier_range) (void *priv, u32 min, u32 max);
>  	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
>  	void			(*s_idle) (void *priv, int enable);
> +	int			(*s_learning_mode) (void *priv, int enable);
> +
>  };
>  
>  struct ir_input_dev {
> diff --git a/include/media/lirc.h b/include/media/lirc.h
> index 42c467c..09a9753 100644
> --- a/include/media/lirc.h
> +++ b/include/media/lirc.h
> @@ -76,7 +76,7 @@
>  #define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
>  #define LIRC_CAN_SET_REC_FILTER           0x08000000
>  
> -#define LIRC_CAN_MEASURE_CARRIER          0x02000000
> +#define LIRC_CAN_LEARN_MODE		0x02000000
>  
>  #define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
>  #define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
> @@ -145,7 +145,7 @@
>   * if enabled from the next key press on the driver will send
>   * LIRC_MODE2_FREQUENCY packets
>   */
> -#define LIRC_SET_MEASURE_CARRIER_MODE  _IOW('i', 0x0000001d, __u32)
> +#define LIRC_SET_LEARN_MODE		_IOW('i', 0x0000001d, __u32)
>  
>  /*
>   * to set a range use

