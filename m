Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49778 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab0HBCKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 22:10:55 -0400
Subject: Re: [PATCH 09/13] IR: add helper function for hardware with small
 o/b buffer.
From: Andy Walls <awalls@md.metrocast.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1280588366-26101-10-git-send-email-maximlevitsky@gmail.com>
References: <1280588366-26101-1-git-send-email-maximlevitsky@gmail.com>
	 <1280588366-26101-10-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 22:11:01 -0400
Message-ID: <1280715061.19666.47.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-07-31 at 17:59 +0300, Maxim Levitsky wrote:
> Some ir input devices have small buffer, and interrupt the host
> each time it is full (or half full)
> 
> Add a helper that automaticly handles timeouts, and also
> automaticly merges samples of same time (space-space)
> Such samples might be placed by hardware because size of
> sample in the buffer is small (a byte for example).
> 
> Also remove constness from ir_dev_props, because it now contains timeout
> settings that driver might want to change
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Acked-by: Jarod Wilson <jarod@redhat.com>

Hi Maxim and Jarod,

I've started looking at this patch, and patch 10/13, to work with them
and build upon them.  I have some comments, below:


> ---
>  drivers/media/IR/ir-core-priv.h |    1 +
>  drivers/media/IR/ir-keytable.c  |    2 +-
>  drivers/media/IR/ir-raw-event.c |   84 +++++++++++++++++++++++++++++++++++++++
>  include/media/ir-core.h         |   23 +++++++++-
>  4 files changed, 106 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
> index be68172..8053e3b 100644
> --- a/drivers/media/IR/ir-core-priv.h
> +++ b/drivers/media/IR/ir-core-priv.h
> @@ -41,6 +41,7 @@ struct ir_raw_event_ctrl {
>  
>  	/* raw decoder state follows */
>  	struct ir_raw_event prev_ev;
> +	struct ir_raw_event this_ev;
>  	struct nec_dec {
>  		int state;
>  		unsigned count;
> diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
> index 94a8577..34b9c07 100644
> --- a/drivers/media/IR/ir-keytable.c
> +++ b/drivers/media/IR/ir-keytable.c
> @@ -428,7 +428,7 @@ static void ir_close(struct input_dev *input_dev)
>   */
>  int __ir_input_register(struct input_dev *input_dev,
>  		      const struct ir_scancode_table *rc_tab,
> -		      const struct ir_dev_props *props,
> +		      struct ir_dev_props *props,
>  		      const char *driver_name)
>  {
>  	struct ir_input_dev *ir_dev;
> diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> index d0c18db..43094e7 100644
> --- a/drivers/media/IR/ir-raw-event.c
> +++ b/drivers/media/IR/ir-raw-event.c
> @@ -140,6 +140,90 @@ int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type typ
>  EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
>  
>  /**
> + * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
> + * @input_dev:	the struct input_dev device descriptor
> + * @type:	the type of the event that has occurred
> + *
> + * This routine (which may be called from an interrupt context) works
> + * in similiar manner to ir_raw_event_store_edge.
> + * This routine is intended for devices with limited internal buffer
> + * It automerges samples of same type, and handles timeouts
> + */

I think this comment might need to explain the filtering being performed
a little more explicitly, because "handles timeouts" wasn't enough to go
on.

>From what I can tell, it performs

	a. space aggrregation
	b. auto "idle" of the receiver and some state
	c. gap measurment and gap space event generation
	d, decoder reset at the end of the gap

(For my needs, c. is very useful, and a. & d. don't hurt.)

What is idle supposed to do for hardware that provides interrupts?

Aside from asking the hardware driver to do something, idle otherwise
appears to be used to keep track of being in a gap or not.
Did I get that all right?

> +int ir_raw_event_store_with_filter(struct input_dev *input_dev,
> +						struct ir_raw_event *ev)
> +{
> +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
> +	struct ir_raw_event_ctrl *raw = ir->raw;
> +
> +	if (!raw || !ir->props)
> +		return -EINVAL;
> +
> +	/* Ignore spaces in idle mode */
> +	if (ir->idle && !ev->pulse)
> +		return 0;
> +	else if (ir->idle)
> +		ir_raw_event_set_idle(input_dev, 0);
> +
> +	if (!raw->this_ev.duration) {
> +		raw->this_ev = *ev;
> +	} else if (ev->pulse == raw->this_ev.pulse) {
> +		raw->this_ev.duration += ev->duration;
> +	} else {
> +		ir_raw_event_store(input_dev, &raw->this_ev);
> +		raw->this_ev = *ev;
> +	}
> +
> +	/* Enter idle mode if nessesary */
> +	if (!ev->pulse && ir->props->timeout &&
> +		raw->this_ev.duration >= ir->props->timeout)
> +		ir_raw_event_set_idle(input_dev, 1);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
> +
> +void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
> +{
> +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
> +	struct ir_raw_event_ctrl *raw = ir->raw;
> +	ktime_t now;
> +	u64 delta;
> +
> +	if (!ir->props)
> +		return;
> +
> +	if (!ir->raw)
> +		goto out;
> +
> +	if (idle) {
> +		IR_dprintk(2, "enter idle mode\n");
> +		raw->last_event = ktime_get();
> +	} else {
> +		IR_dprintk(2, "exit idle mode\n");
> +
> +		now = ktime_get();
> +		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
> +
> +		WARN_ON(raw->this_ev.pulse);
> +
> +		raw->this_ev.duration =
> +			min(raw->this_ev.duration + delta,
> +						(u64)IR_MAX_DURATION);
> +
> +		ir_raw_event_store(input_dev, &raw->this_ev);
> +
> +		if (raw->this_ev.duration == IR_MAX_DURATION)
> +			ir_raw_event_reset(input_dev);
> +
> +		raw->this_ev.duration = 0;
> +	}
> +out:
> +	if (ir->props->s_idle)
> +		ir->props->s_idle(ir->props->priv, idle);
> +	ir->idle = idle;
> +}
> +EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
> +
> +/**
>   * ir_raw_event_handle() - schedules the decoding of stored ir data
>   * @input_dev:	the struct input_dev device descriptor
>   *
> diff --git a/include/media/ir-core.h b/include/media/ir-core.h
> index 197d05a..a781045 100644
> --- a/include/media/ir-core.h
> +++ b/include/media/ir-core.h
> @@ -41,6 +41,9 @@ enum rc_driver_type {
>   *	anything with it. Yet, as the same keycode table can be used with other
>   *	devices, a mask is provided to allow its usage. Drivers should generally
>   *	leave this field in blank
> + * @timeout: optional time after which device stops sending data
> + * @min_timeout: minimum timeout supported by device
> + * @max_timeout: maximum timeout supported by device
>   * @priv: driver-specific data, to be used on the callbacks
>   * @change_protocol: allow changing the protocol used on hardware decoders
>   * @open: callback to allow drivers to enable polling/irq when IR input device
> @@ -50,11 +53,19 @@ enum rc_driver_type {
>   * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
>   * @s_tx_carrier: set transmit carrier frequency
>   * @tx_ir: transmit IR
> + * @s_idle: optional: enable/disable hardware idle mode, upon which,
> + *	device doesn't interrupt host untill it sees IR data
>   */
>  struct ir_dev_props {
>  	enum rc_driver_type	driver_type;
>  	unsigned long		allowed_protos;
>  	u32			scanmask;
> +
> +	u32			timeout;
> +	u32			min_timeout;
> +	u32			max_timeout;
> +
> +
>  	void			*priv;
>  	int			(*change_protocol)(void *priv, u64 ir_type);
>  	int			(*open)(void *priv);
> @@ -62,6 +73,7 @@ struct ir_dev_props {
>  	int			(*s_tx_mask)(void *priv, u32 mask);
>  	int			(*s_tx_carrier)(void *priv, u32 carrier);
>  	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
> +	void			(*s_idle)(void *priv, int enable);
>  };

As I begin to look at using these changes for setting parameters and
storing them, I realize I've been down this road before with the struct
v4l2_subdev_ir_ops found here:

http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=include/media/v4l2-subdev.h;h=08880dd15d2fe6582865633f297a5e0293becf82;hb=wilson-levitsky#l391
http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=include/media/v4l2-subdev.h;h=08880dd15d2fe6582865633f297a5e0293becf82;hb=wilson-levitsky#l339

and struct v4l2_subdev_ir_params found here:

http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=include/media/v4l2-subdev.h;h=08880dd15d2fe6582865633f297a5e0293becf82;hb=wilson-levitsky#l366

I had originally started with an approach of adding a specialized
callback for everything.  However, besides being large and clumsy, Hans
and Mauro shot it down.  

In retrospect I'm glad they did - the final implementation was 7 simple
callbacks (3 for Rx, 3 for Tx and 1 for IRQ handling) and one parameter
form.

Example parameter setting can be found here:

http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=drivers/media/video/cx23885/cx23885-input.c;h=bb61870b8d6ed39d25c11aa676b55bd0a94dc235;hb=wilson-levitsky#l105
http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=drivers/media/video/cx23885/cx23885-input.c;h=bb61870b8d6ed39d25c11aa676b55bd0a94dc235;hb=wilson-levitsky#l135

The parameter form can also be used to hold the state of the transmitter
and receiver internal to the driver:

http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=drivers/media/video/cx23885/cx23888-ir.c;h=2502a0a6709783b8c01d5de639d759d097f0f1cd;hb=wilson-levitsky#l130

 
>  struct ir_input_dev {
> @@ -69,9 +81,10 @@ struct ir_input_dev {
>  	char				*driver_name;	/* Name of the driver module */
>  	struct ir_scancode_table	rc_tab;		/* scan/key table */
>  	unsigned long			devno;		/* device number */
> -	const struct ir_dev_props	*props;		/* Device properties */
> +	struct ir_dev_props		*props;		/* Device properties */

So I don't think the struct ir_dev_props structure is the right place to
be storing current operating parameters. IMO, operating parameters
stored in the ir_dev_props are "too far" from the lower level driver,
and are essentially mirroring what the low level driver should be
tracking internally as it's own state anyway.


So in summary, I think we need to keep the opertions in struct
ir_dev_props simple using ,get_parameters() and .set_parameters() to
contol the lower level driver and to fetch, retrieve, and store
parameters.


Regards,
Andy


>  	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
>  	struct input_dev		*input_dev;	/* the input device associated with this device */
> +	bool				idle;
>  
>  	/* key info - needed by IR keycode handlers */
>  	spinlock_t			keylock;	/* protects the below members */
> @@ -95,12 +108,12 @@ enum raw_event_type {
>  /* From ir-keytable.c */
>  int __ir_input_register(struct input_dev *dev,
>  		      const struct ir_scancode_table *ir_codes,
> -		      const struct ir_dev_props *props,
> +		      struct ir_dev_props *props,
>  		      const char *driver_name);
>  
>  static inline int ir_input_register(struct input_dev *dev,
>  		      const char *map_name,
> -		      const struct ir_dev_props *props,
> +		      struct ir_dev_props *props,
>  		      const char *driver_name) {
>  	struct ir_scancode_table *ir_codes;
>  	struct ir_input_dev *ir_dev;
> @@ -148,6 +161,10 @@ struct ir_raw_event {
>  void ir_raw_event_handle(struct input_dev *input_dev);
>  int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
>  int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
> +int ir_raw_event_store_with_filter(struct input_dev *input_dev,
> +				struct ir_raw_event *ev);
> +void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
> +
>  static inline void ir_raw_event_reset(struct input_dev *input_dev)
>  {
>  	struct ir_raw_event ev = { .pulse = false, .duration = 0 };


