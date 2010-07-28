Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37948 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0G1Q3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 12:29:10 -0400
Subject: Re: [PATCH 4/9] IR: add helper functions for ir input devices that
 send ir timing data in small chunks, and alternation between pulses and
 spaces isn't guaranteed.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <4C505631.7020609@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
	 <1280330051-27732-5-git-send-email-maximlevitsky@gmail.com>
	 <4C505631.7020609@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 19:29:03 +0300
Message-ID: <1280334543.28785.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 13:09 -0300, Mauro Carvalho Chehab wrote:
> Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> 
> Please provide a smaller subject. Feel free to add a more detailed description, but
> subjects longer then 74 bytes end by causing some troubles when using git commands.
I didn't intend that, I just keep forgetting to add a newline between
subject and description..


> 
> It would be nice to have a good description on this patch, as it provides a method
> for working around troubles found on problematic devices.
> 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/media/IR/ir-core-priv.h |    1 +
> >  drivers/media/IR/ir-keytable.c  |    2 +-
> >  drivers/media/IR/ir-raw-event.c |   86 +++++++++++++++++++++++++++++++++++++++
> >  include/media/ir-core.h         |   24 +++++++++-
> >  4 files changed, 109 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
> > index 8ce80e4..3eafdb7 100644
> > --- a/drivers/media/IR/ir-core-priv.h
> > +++ b/drivers/media/IR/ir-core-priv.h
> > @@ -36,6 +36,7 @@ struct ir_raw_event_ctrl {
> >  	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
> >  	ktime_t				last_event;	/* when last event occurred */
> >  	enum raw_event_type		last_type;	/* last event type */
> > +	struct ir_raw_event		current_sample;	/* sample that is not yet pushed to fifo */
> >  	struct input_dev		*input_dev;	/* pointer to the parent input_dev */
> >  	u64				enabled_protocols; /* enabled raw protocol decoders */
> >  
> > diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
> > index 94a8577..34b9c07 100644
> > --- a/drivers/media/IR/ir-keytable.c
> > +++ b/drivers/media/IR/ir-keytable.c
> > @@ -428,7 +428,7 @@ static void ir_close(struct input_dev *input_dev)
> >   */
> >  int __ir_input_register(struct input_dev *input_dev,
> >  		      const struct ir_scancode_table *rc_tab,
> > -		      const struct ir_dev_props *props,
> > +		      struct ir_dev_props *props,
> >  		      const char *driver_name)
> >  {
> >  	struct ir_input_dev *ir_dev;
> 
> Hmm... why are you removing "const" from ir_dev_props? This change seems unrelated
> with the patch description.
Because I add new field 'timeout' I intend to change it in runtime by
the driver.


Best regards,
	Maxim Levitsky  


> 
> > diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> > index c6a80b3..bdf2ed8 100644
> > --- a/drivers/media/IR/ir-raw-event.c
> > +++ b/drivers/media/IR/ir-raw-event.c
> > @@ -129,6 +129,92 @@ int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type typ
> >  EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
> >  
> >  /**
> > + * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
> > + * @input_dev:	the struct input_dev device descriptor
> > + * @type:	the type of the event that has occurred
> > + *
> > + * This routine (which may be called from an interrupt context) is used to
> > + * store the beginning of an ir pulse or space (or the start/end of ir
> > + * reception) for the raw ir decoding state machines.\
> > + * This routine is intended for devices with limited internal buffer
> > + * It automerges samples of same type, and handles timeouts
> > + */
> > +int ir_raw_event_store_with_filter(struct input_dev *input_dev,
> > +						struct ir_raw_event *ev)
> > +{
> > +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
> > +	struct ir_raw_event_ctrl *raw = ir->raw;
> > +
> > +	if (!ir->raw || !ir->props)
> > +		return -EINVAL;
> > +
> > +	/* Ignore spaces in idle mode */
> > +	if (ir->idle && !ev->pulse)
> > +		return 0;
> > +	else if (ir->idle)
> > +		ir_raw_event_set_idle(input_dev, 0);
> > +
> > +	if (!raw->current_sample.duration) {
> > +		raw->current_sample = *ev;
> > +	} else if (ev->pulse == raw->current_sample.pulse) {
> > +		raw->current_sample.duration += ev->duration;
> > +	} else {
> > +		ir_raw_event_store(input_dev, &raw->current_sample);
> > +		raw->current_sample = *ev;
> > +	}
> > +
> > +	/* Enter idle mode if nessesary */
> > +	if (!ev->pulse && ir->props->timeout &&
> > +		raw->current_sample.duration >= ir->props->timeout)
> > +		ir_raw_event_set_idle(input_dev, 1);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
> > +
> > +
> > +void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
> > +{
> > +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
> > +	struct ir_raw_event_ctrl *raw = ir->raw;
> > +	ktime_t now;
> > +	u64 delta;
> > +
> > +	if (!ir->props)
> > +		return;
> > +
> > +	if (!ir->raw)
> > +		goto out;
> > +
> > +	if (idle) {
> > +		IR_dprintk(2, "enter idle mode\n");
> > +		raw->last_event = ktime_get();
> > +	} else {
> > +		IR_dprintk(2, "exit idle mode\n");
> > +
> > +		now = ktime_get();
> > +		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
> > +
> > +		WARN_ON(raw->current_sample.pulse);
> > +
> > +		raw->current_sample.duration =
> > +			min(raw->current_sample.duration + delta,
> > +						(u64)IR_MAX_DURATION);
> > +
> > +		ir_raw_event_store(input_dev, &raw->current_sample);
> > +
> > +		if (raw->current_sample.duration == IR_MAX_DURATION)
> > +			ir_raw_event_reset(input_dev);
> > +
> > +		raw->current_sample.duration = 0;
> > +	}
> > +out:
> > +	if (ir->props->s_idle)
> > +		ir->props->s_idle(ir->props->priv, idle);
> > +	ir->idle = idle;
> > +}
> > +EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
> > +
> > +/**
> >   * ir_raw_event_handle() - schedules the decoding of stored ir data
> >   * @input_dev:	the struct input_dev device descriptor
> >   *
> > diff --git a/include/media/ir-core.h b/include/media/ir-core.h
> > index 513e60d..53ce966 100644
> > --- a/include/media/ir-core.h
> > +++ b/include/media/ir-core.h
> > @@ -41,6 +41,9 @@ enum rc_driver_type {
> >   *	anything with it. Yet, as the same keycode table can be used with other
> >   *	devices, a mask is provided to allow its usage. Drivers should generally
> >   *	leave this field in blank
> > + * @timeout: optional time after which device stops sending data
> > + * @min_timeout: minimum timeout supported by device
> > + * @max_timeout: maximum timeout supported by device
> >   * @priv: driver-specific data, to be used on the callbacks
> >   * @change_protocol: allow changing the protocol used on hardware decoders
> >   * @open: callback to allow drivers to enable polling/irq when IR input device
> > @@ -50,11 +53,19 @@ enum rc_driver_type {
> >   * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
> >   * @s_tx_carrier: set transmit carrier frequency
> >   * @tx_ir: transmit IR
> > + * @s_idle: optional: enable/disable hardware idle mode, upon which,
> > +	device doesn't interrupt host untill it sees IR data
> >   */
> >  struct ir_dev_props {
> >  	enum rc_driver_type	driver_type;
> >  	unsigned long		allowed_protos;
> >  	u32			scanmask;
> > +
> > +	u64			timeout;
> > +	u64			min_timeout;
> > +	u64			max_timeout;
> > +
> > +
> >  	void			*priv;
> >  	int			(*change_protocol)(void *priv, u64 ir_type);
> >  	int			(*open)(void *priv);
> > @@ -62,6 +73,7 @@ struct ir_dev_props {
> >  	int			(*s_tx_mask)(void *priv, u32 mask);
> >  	int			(*s_tx_carrier)(void *priv, u32 carrier);
> >  	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
> > +	void			(*s_idle) (void *priv, int enable);
> >  };
> >  
> >  struct ir_input_dev {
> > @@ -69,9 +81,10 @@ struct ir_input_dev {
> >  	char				*driver_name;	/* Name of the driver module */
> >  	struct ir_scancode_table	rc_tab;		/* scan/key table */
> >  	unsigned long			devno;		/* device number */
> > -	const struct ir_dev_props	*props;		/* Device properties */
> > +	struct ir_dev_props		*props;		/* Device properties */
> >  	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
> >  	struct input_dev		*input_dev;	/* the input device associated with this device */
> > +	int				idle;
> >  
> >  	/* key info - needed by IR keycode handlers */
> >  	spinlock_t			keylock;	/* protects the below members */
> > @@ -95,12 +108,12 @@ enum raw_event_type {
> >  /* From ir-keytable.c */
> >  int __ir_input_register(struct input_dev *dev,
> >  		      const struct ir_scancode_table *ir_codes,
> > -		      const struct ir_dev_props *props,
> > +		      struct ir_dev_props *props,
> >  		      const char *driver_name);
> >  
> >  static inline int ir_input_register(struct input_dev *dev,
> >  		      const char *map_name,
> > -		      const struct ir_dev_props *props,
> > +		      struct ir_dev_props *props,
> >  		      const char *driver_name) {
> >  	struct ir_scancode_table *ir_codes;
> >  	struct ir_input_dev *ir_dev;
> > @@ -144,6 +157,11 @@ struct ir_raw_event {
> >  void ir_raw_event_handle(struct input_dev *input_dev);
> >  int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
> >  int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
> > +int ir_raw_event_store_with_filter(struct input_dev *input_dev,
> > +						struct ir_raw_event *ev);
> > +
> > +void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
> > +
> >  static inline void ir_raw_event_reset(struct input_dev *input_dev)
> >  {
> >  	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
> 


